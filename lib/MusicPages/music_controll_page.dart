import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/colors.dart' as app_colors;
import 'package:musicplayer/db/Favourite/db_helper.dart';
import 'package:musicplayer/db/Favourite/helper.dart';
import 'package:musicplayer/db/Playlist/select_playlist.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:rxdart/rxdart.dart';
import '../just_audio_background.dart';

class MusicController extends StatefulWidget {
  SongModel songInfo;

  MusicController({
    required this.songInfo,
    required this.changeTrack,
    required this.key,
  }) : super(key: key);
  Function changeTrack;
  @override
  final GlobalKey<MusicControllerState> key;

  @override
  MusicControllerState createState() => MusicControllerState();
}

class MusicControllerState extends State<MusicController> {
  final OnAudioQuery audioQuery = OnAudioQuery();

  double minimumValue = 0.0, maximumValue = 0.0, currentValue = 0.0;
  String currentTime = '', endTime = '';
  bool isPlaying = false;
  final AudioPlayer player = AudioPlayer();
  dynamic songTitle;
  dynamic songId;
  dynamic songLocation;
  DatabaseHandler? handler;
  int fav = 0;

  @override
  void initState() {
// TODO: implement initState
    super.initState();
    handler = DatabaseHandler();
    setSong(widget.songInfo);
    player.play();
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
          (position, bufferedPosition, duration) =>
              PositionData(position, duration ?? Duration.zero));

  Future<int> addUsers(songTitle, songId, songLocation) async {
    final Songs firstUser =
        Songs(name: songTitle, num: songId, location: songLocation);
    final List<Songs> listOfUsers = [firstUser];
    debugPrint('ADNAN:$songTitle');
    debugPrint('ADNAN: $songId');
    debugPrint('ADNAN: $songLocation');
    return await handler!.insertFavSongs(listOfUsers);
  }

  void setSong(SongModel songInfo) async {
    widget.songInfo = songInfo;
    await player.setUrl(widget.songInfo.data);
    currentValue = minimumValue;
    maximumValue = player.duration!.inMilliseconds.toDouble();
    if (currentValue == maximumValue) {
      widget.changeTrack(true);
    }
    setState(() {
      currentTime = getDuration(currentValue);
      endTime = getDuration(maximumValue);
    });
    isPlaying = false;
    changeStatus();
    player.positionStream.listen((duration) {
      currentValue = duration.inMilliseconds.toDouble();
      setState(() {
        currentTime = getDuration(currentValue);
        if (currentValue == maximumValue) {
          widget.changeTrack(true);
        }
      });
    });
  }

  void changeStatus() {
    setState(() {
      isPlaying = !isPlaying;
    });
    if (isPlaying) {
      player.play();
    } else {
      player.pause();
    }
  }

  void nextSong() {
    setState(() {
      if (currentValue >= maximumValue) {
        widget.changeTrack(true);
      }
    });
  }

  String getDuration(double value) {
    final Duration duration = Duration(milliseconds: value.round());
    return [duration.inMinutes, duration.inSeconds]
        .map((element) => element.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }

  @override
  Widget build(context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              'TUNE ' 'Ax',
              style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Gemunu',
                  fontWeight: FontWeight.bold),
            ),
          ),
          elevation: 0,
          backgroundColor: app_colors.back,
          leading: IconButton(
            padding: const EdgeInsets.only(top: 5, left: 10),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 40,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                app_colors.back,
                app_colors.shade,
              ])),
          child: Stack(
            children: [
              ///Play $ Pause///
              ///Play $ Pause///
              Positioned(
                top: height - 170,
                child: Container(
                  width: width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StreamBuilder<bool>(
                        stream: player.shuffleModeEnabledStream,
                        builder: (context, snapshot) {
                          final shuffleModeEnabled = snapshot.data ?? false;
                          return IconButton(
                            icon: shuffleModeEnabled
                                ? const Icon(Icons.shuffle,
                                    color: Colors.lightBlueAccent)
                                : const Icon(Icons.shuffle,
                                    color: Colors.white),
                            onPressed: () async {
                              final enable = !shuffleModeEnabled;
                              if (enable) {
                                await player.shuffle();
                              }
                              await player.setShuffleModeEnabled(enable);
                            },
                          );
                        },
                      ),
                      GestureDetector(
                        child: StreamBuilder<SequenceState?>(
                          stream: player.sequenceStateStream,
                          builder: (context, snapshot) => IconButton(
                              icon: const Icon(
                                Icons.skip_previous,
                                size: 30,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                widget.changeTrack(false);
                              }),
                        ),
                      ),
                      StreamBuilder<PlayerState>(
                        stream: player.playerStateStream,
                        builder: (context, snapshot) {
                          final playerState = snapshot.data;
                          final processingState = playerState?.processingState;
                          final playing = playerState?.playing;
                          if (playing != true) {
                            return IconButton(
                              icon: const Icon(Icons.play_arrow,
                                  color: Colors.white),
                              iconSize: 64.0,
                              onPressed: player.play,
                            );
                          } else if (processingState !=
                              ProcessingState.completed) {
                            return IconButton(
                              icon:
                                  const Icon(Icons.pause, color: Colors.white),
                              iconSize: 64.0,
                              onPressed: player.pause,
                            );
                          } else {
                            return widget.changeTrack(true);
                          }
                        },
                      ),
                      StreamBuilder<SequenceState?>(
                        stream: player.sequenceStateStream,
                        builder: (context, snapshot) => IconButton(
                            icon: const Icon(Icons.skip_next,
                                size: 30, color: Colors.white),
                            onPressed: () {
                              widget.changeTrack(true);
                            }),
                      ),
                      StreamBuilder<LoopMode>(
                        stream: player.loopModeStream,
                        builder: (context, snapshot) {
                          final loopMode = snapshot.data ?? LoopMode.off;
                          const icons = [
                            Icon(Icons.repeat, color: Colors.white),
                            Icon(Icons.repeat_one,
                                color: Colors.lightBlueAccent),
                          ];
                          const cycleModes = [
                            LoopMode.off,
                            LoopMode.one,
                          ];
                          final index = cycleModes.indexOf(loopMode);
                          return IconButton(
                            icon: icons[index],
                            onPressed: () {
                              player.setLoopMode(cycleModes[
                                  (cycleModes.indexOf(loopMode) + 1) %
                                      cycleModes.length]);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 0,
                left: 0,
                top: height - 270,
                child: StreamBuilder<double>(
                  stream: player.speedStream,
                  builder: (context, snapshot) => IconButton(
                    icon: Text('${snapshot.data?.toStringAsFixed(1)}x',

                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                    onPressed: () {
                      showSliderDialog(
                        context: context,
                        title: 'Adjust speed',
                        divisions: 10,
                        min: 0.5,
                        max: 1.5,
                        stream: player.speedStream,
                        onChanged: player.setSpeed,
                        value: player.speed,
                      );
                    },
                  ),
                ),
              ),

              ///Slider///
              ///Slider///
              ///Slider///
              ///Slider///
              Positioned(
                right: 0,
                left: 0,
                top: height - 240,
                child: SizedBox(
                  height: 50,
                  child: StreamBuilder<PositionData>(
                    stream: _positionDataStream,
                    builder: (context, snapshot) {
                      final positionData = snapshot.data;
                      return SeekBar(
                        duration: positionData?.duration ?? Duration.zero,
                        position: positionData?.position ?? Duration.zero,
                        onChangeEnd: (newPosition) {
                          player.seek(newPosition);
                        },
                      );
                    },
                  ),
                ),
              ),

              ///Favourite Container///
              ///Favourite Container///
              ///Favourite Container///
              Positioned(
                top: height - 320,
                child: Container(
                  width: width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        iconSize: 30,
                        color: Colors.white,
                        icon: const Icon(Icons.volume_up),
                        onPressed: () {
                          showSliderDialog(
                            context: context,
                            title: 'Adjust volume',
                            divisions: 10,
                            min: 0.0,
                            max: 1.0,
                            value: player.volume,
                            stream: player.volumeStream,
                            onChanged: player.setVolume,
                          );
                        },
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      IconButton(
                        iconSize: 25,
                        color: Colors.white,
                        onPressed: () {
                          showToast();
                          setState(() {
                            fav = 1;
                          });

                          songTitle = widget.songInfo.title;
                          songId = widget.songInfo.id;
                          songLocation = widget.songInfo.data;
                          addUsers(songTitle, songId, songLocation);
                        },
                        icon: fav == 1
                            ? const Icon(Icons.favorite)
                            : const Icon(Icons.favorite_border),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      IconButton(
                        iconSize: 30,
                        color: Colors.white,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateOrSelect(
                                    widget.songInfo.data,
                                    widget.songInfo.id,
                                    widget.songInfo.title),
                              ));
                        },
                        icon: const Icon(Icons.add_outlined),
                      ),
                    ],
                  ),
                ),
              ),

              ///subtitle///
              ///subtitle///
              ///subtitle///
              Positioned(
                right: 5,
                left: 5,
                top: height / 3,
                child: Container(
                  child: Center(
                    child: StreamBuilder<SequenceState?>(
                      stream: player.sequenceStateStream,
                      builder: (context, snapshot) {
                        return Text(
                          widget.songInfo.artist.toString(),
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                              fontFamily: 'Title'),
                        );
                      },
                    ),
                  ),
                  height: 100,
                  width: width,
                ),
              ),

              ///Song Title///
              ///Song Title///
              ///Song Title///
              Positioned(
                right: 20,
                left: 20,
                top: height / 3,
                child: Center(
                  child: StreamBuilder<SequenceState?>(
                    stream: player.sequenceStateStream,
                    builder: (context, snapshot) {
                      return Text(
                        widget.songInfo.title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Titil'),
                      );
                    },
                  ),
                ),
              ),

              ///Icon $ Images///
              ///Icon $ Images///
              ///Icon $ Images///
              Positioned(
                top: height / 25,
                child: Container(
                  width: width,
                  child: Center(
                    child: StreamBuilder<SequenceState?>(
                      stream: player.sequenceStateStream,
                      builder: (context, snapshot) {
                        return QueryArtworkWidget(
                          artworkFit: BoxFit.fill,
                          artworkHeight: 180,
                          artworkWidth: 180,
                          type: ArtworkType.AUDIO,
                          id: widget.songInfo.id,
                          nullArtworkWidget: Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                  color: app_colors.back,
                                  borderRadius: BorderRadius.circular(40)),
                              child: const Icon(
                                Icons.music_note_outlined,
                                color: Colors.white70,
                                size: 90,
                              )),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showToast() => Fluttertoast.showToast(
      msg: 'Added to Favourite',
      fontSize: 18,
      backgroundColor: app_colors.back);
}

void showSliderDialog({
  required BuildContext context,
  required String title,
  required int divisions,
  required double min,
  required double max,
  String valueSuffix = '',
  required double value,
  required Stream<double> stream,
  required ValueChanged<double> onChanged,
}) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: app_colors.back,
      title: Text(title,
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Gemunu',
              fontWeight: FontWeight.bold,
              fontSize: 24.0)),
      content: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) => Container(
          height: 100.0,
          child: Column(
            children: [
              Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                  style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Gemunu',
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0)),
              Slider(
                inactiveColor: Colors.grey,
                activeColor: Colors.white,
                divisions: divisions,
                min: min,
                max: max,
                value: snapshot.data ?? value,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

//
// class BottomBar extends StatefulWidget {
//
//  const BottomBar({Key? key}) : super(key: key);
//
//   @override
//   BottomBarState createState() => BottomBarState();
// }
//
// class BottomBarState extends State<BottomBar> {
//   double minimumValue = 0.0, maximumValue = 0.0, currentValue = 0.0;
//   String currentTime = '', endTime = '';
//   bool isPlaying = false;
//   final AudioPlayer player = AudioPlayer();
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//
//
//
//   String getDuration(double value) {
//     Duration duration = Duration(milliseconds: value.round());
//
//     return [duration.inMinutes, duration.inSeconds]
//         .map((element) => element.remainder(60).toString().padLeft(2, '0'))
//         .join(':');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final double Heights = MediaQuery.of(context).size.height;
//     final double Weights = MediaQuery.of(context).size.width;
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: Container(
//         decoration: BoxDecoration(
//           color: AppColors.back,
//           borderRadius: BorderRadius.circular(30)
//         ),
//         height: 90,
//         width: Weights,
//         child: Row(
//           // mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             SizedBox(
//               width: 5,
//             ),
//             Container(
//               decoration: BoxDecoration(
//                   color: AppColors.shade,
//                   borderRadius: BorderRadius.circular(50)),
//               child: IconButton(
//                 iconSize: 30,
//                 alignment: Alignment.centerLeft,
//                 color: Colors.black,
//                 onPressed: () {},
//                 icon: Icon(
//                   Icons.music_note_outlined,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             SizedBox(
//               width: 5,
//             ),
//             Expanded(
//               child: Marquee(
//                 blankSpace: 100,
//                 text:
//                 'Selena Gomez - The Heart Wants What It Wants
//                 (Official Video)',
//                 style: TextStyle(
//                     color: Colors.white, fontSize: 18, fontFamily: "Title"),
//               ),
//             ),
//             // SizedBox(
//             //   width: 5,
//             // ),
//             IconButton(
//               iconSize: 30,
//               alignment: Alignment.centerRight,
//               color: Colors.white,
//               onPressed: () {},
//               icon: Icon(Icons.skip_previous_sharp),
//             ),
//             StreamBuilder<PlayerState>(
//               stream: player.playerStateStream,
//               builder: (context, snapshot) {
//                 final playerState = snapshot.data;
//                 final processingState = playerState?.processingState;
//                 final playing = playerState?.playing;
//                 if (playing != true) {
//                   return IconButton(
//                     icon: const Icon(Icons.play_arrow,
//                         color: Colors.white),
//                     iconSize: 40.0,
//                     onPressed: player.play,
//                   );
//                 } else if (processingState !=
//                     ProcessingState.completed) {
//                   return IconButton(
//                     icon:
//                     const Icon(Icons.pause, color: Colors.white),
//                     iconSize: 40.0,
//                     onPressed: player.pause,
//                   );
//                 } else {
//                   return IconButton(onPressed: (){},
//                   icon:Icon(Icons.play_arrow));
//                 }
//               },
//             ),
//             IconButton(
//               iconSize: 30,
//               alignment: Alignment.centerRight,
//               color: Colors.white,
//               onPressed: () {},
//               icon: Icon(Icons.skip_next),
//             ),
//             IconButton(
//               iconSize: 25,
//               alignment: Alignment.centerRight,
//               color: Colors.white,
//               onPressed: () {},
//               icon: Icon(Icons.favorite),
//             ),
//             SizedBox(
//               width: 5,
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
//
//
//
//
