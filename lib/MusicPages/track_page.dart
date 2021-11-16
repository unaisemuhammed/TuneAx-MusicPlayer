import 'package:audio_service/audio_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/MusicPages/music_controll_page.dart';
import 'package:musicplayer/colors.dart' as app_colors;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:musicplayer/db/Favourite/db_helper.dart';
import 'package:musicplayer/db/Favourite/helper.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Track extends StatefulWidget {
  @override
  TrackState createState() => TrackState();
}

class TrackState extends State<Track> {
  List<SongModel> tracks = [];
  final GlobalKey<MusicControllerState> key = GlobalKey<MusicControllerState>();
  final OnAudioQuery audioQuery = OnAudioQuery();
  late final AudioPlayer player;
  int currentIndex = 0;
  int isFav = 0;
  var songTitle;
  var songId;
  var songLocation;

  DatabaseHandler? handler;

  @override
  void initState() {
    super.initState();
    requestPermission();
    getTracks();
    player = AudioPlayer();
    handler = DatabaseHandler();
    setState(() {});
    // addSongsToFavourite(songTitle, songId, songLocation);
  }

  Future<int> addSongsToFavourite(
      String songTitle, int songId, String songLocation) async {
    final Songs firstUser =
        Songs(name: songTitle, num: songId, location: songLocation);
    final List<Songs> listOfUsers = [firstUser];
    debugPrint('addSongsToFavourite:$songTitle');
    debugPrint('addSongsToFavourite: $songId');
    debugPrint('addSongsToFavourite: $songLocation');
    return await handler!.insertFavSongs(listOfUsers);
  }

  void requestPermission() async {
    // Web platform don't support permissions methods.
    if (!kIsWeb) {
      final bool permissionStatus = await audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await audioQuery.permissionsRequest();
      }
      setState(() {});
    }
  }

  void getTracks() async {
    tracks = await audioQuery.querySongs();
    setState(() {
      tracks = tracks;
    });
  }

  void changeTrack(bool isNext) {
    if (isNext) {
      if (currentIndex != tracks.length - 1) {
        currentIndex++;
      }
    } else {
      if (currentIndex != 0) {
        currentIndex--;
      }
    }
    key.currentState!.setSong(tracks[currentIndex]);
  }
  final TextEditingController _textEditingController = TextEditingController();
  String searchingTerm = "";
  @override
  Widget build(BuildContext context) {
    final double heights = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: app_colors.shade,
      body: Stack(
        children: [
          Positioned(
            child: Container(
              padding: const EdgeInsets.only(bottom: 0, top: 10),
              child: ListView.builder(
                  itemCount: tracks.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (tracks[index].data.contains('mp3'))
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              currentIndex = index;
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MusicController(
                                        changeTrack: changeTrack,
                                        songInfo: tracks[currentIndex],
                                        key: key,
                                      )));
                            },
                            child: ListTile(
                              leading: QueryArtworkWidget(
                                artworkBorder: BorderRadius.circular(8),
                                nullArtworkWidget: Container(
                                    width: width / 8,
                                    height: heights / 14,
                                    decoration: BoxDecoration(
                                        color: app_colors.back,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: const Icon(
                                      Icons.music_note_outlined,
                                      color: Colors.grey,
                                      size: 45,
                                    )),
                                id: tracks[index].id,
                                type: ArtworkType.AUDIO,
                                artworkFit: BoxFit.contain,
                              ),
                              title: Text(
                                tracks[index].title,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 17),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              subtitle: Text(
                                tracks[index].displayNameWOExt,
                                style: const TextStyle(color: Colors.grey),
                              ),
                              trailing: PopupMenuButton(
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: Colors.grey,
                                  ),
                                  color: app_colors.back,
                                  itemBuilder: (context) => [
                                        // PopupMenuItem(
                                        //   child: Text(
                                        //     "Delete",
                                        //     style:
                                        //  TextStyle(color: Colors.white)
                                        //   ),
                                        //   value: 1,
                                        // ),
                                        PopupMenuItem(
                                          child: const Text(
                                            'Add to Favourite',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          onTap: () {
                                            songTitle = tracks[index].title;
                                            songId = tracks[index].id;
                                            songLocation = tracks[index].data;
                                            addSongsToFavourite(songTitle,
                                                songId, songLocation);
                                            showToast();
                                          },
                                          value: 2,
                                        ),
                                      ]),
                            ),
                          ),
                          const Divider(
                            height: 0,
                            indent: 85,
                            color: Colors.grey,
                          ),
                        ],
                      );
                    return Container(
                      height: 0,
                    );
                  }),
            ),
          ),
          // Positioned(
          //     bottom: heights / 100,
          //     right: 7,
          //     left: 7,
          //     height: heights / 13,
          //     child: MusicController(
          //         songInfo: tracks[currentIndex],
          //         changeTrack: changeTrack,
          //         key: key)),
        ],
      ),
    );
  }

  void showToast() => Fluttertoast.showToast(
      msg: 'Added to Favourite',
      fontSize: 18,
      backgroundColor: app_colors.back);
}
