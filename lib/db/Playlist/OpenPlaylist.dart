import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/MusicPages/Cnplaylist.dart';
import 'package:musicplayer/colors.dart' as AppColors;
import 'package:musicplayer/db/Playlist/SelectInside.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'db_helperPla.dart';
import 'helperPlay.dart';

class OpenPlaylist extends StatefulWidget {
 final int id;

  OpenPlaylist(this.id, {Key? key}) : super(key: key);

  @override
  _OpenPlaylistState createState() => _OpenPlaylistState();
}

class _OpenPlaylistState extends State<OpenPlaylist> {
  final GlobalKey<MusicControllsState> key = GlobalKey<MusicControllsState>();
  final OnAudioQuery audioQuery = OnAudioQuery();
  late PlaylistDatabaseHandler songsHandler;
  int playlistFolderId = 0;
  int currentIndex = 0;
  List tracks = [];
  List<SongModel> tracksQuery = [];
  late PlaylistDatabaseHandler playlistHandler;
  late final AudioPlayer player;

  @override
  void initState() {
    setState(() {});
    super.initState();
    getTracks();
    player = AudioPlayer();
    playlistHandler = PlaylistDatabaseHandler();
    songsHandler = PlaylistDatabaseHandler();
  }

  void getTracks() async {
    tracksQuery = await audioQuery.querySongs();
    setState(() {
      tracksQuery = tracksQuery;
    });
  }

  void changeTrack(bool isNext) {
    if (isNext) {
      if (currentIndex != tracksQuery.length - 1) {
        currentIndex++;
      }
    } else {
      if (currentIndex != 0) {
        currentIndex--;
      }
    }
    key.currentState!.setSong(tracksQuery[currentIndex]);
  }

  @override
  Widget build(BuildContext context) {
    final double heights = MediaQuery.of(context).size.height;
    final double weights = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.back,
        appBar: AppBar(
          actions: [
            IconButton(
              padding: EdgeInsets.only(right: 20, top: 10),
              icon: Icon(
                Icons.add,
                size: 30,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectInside(
                        playlistId: widget.id,
                      ),
                    ));
              },
            ),
          ],
          leadingWidth: 50,
          leading: IconButton(
            padding: EdgeInsets.only(
              left: 25,
              top: 16,
            ),
            color: Colors.white,
            alignment: Alignment.topLeft,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: Text(
            'Add Songs',
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontFamily: 'Titil'),
          ),
          backgroundColor: AppColors.back,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Positioned(
                top: 20,
                child: Container(
                  width: weights,
                  child: Center(
                      child: Icon(
                    Icons.music_note_outlined,
                    color: Colors.white,
                    size: 90,
                  )),
                  color: AppColors.back,
                )),
            Positioned(
              child: DraggableScrollableSheet(
                initialChildSize: 0.7,
                minChildSize: 0.7,
                maxChildSize: 1.0,
                builder: (BuildContext context, myscrollController) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25)),
                      color: AppColors.shade,
                    ),
                    child: FutureBuilder(
                      future: this.songsHandler.retrieveSingleSong(widget.id),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<PlayListSong>> snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  ListTile(
                                    leading: QueryArtworkWidget(
                                      artworkBorder: BorderRadius.circular(8),
                                      nullArtworkWidget: Container(
                                          width: weights / 8,
                                          height: heights / 14,
                                          decoration: BoxDecoration(
                                              color: AppColors.back,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Icon(
                                            Icons.music_note_outlined,
                                            color: Colors.grey,
                                            size: 45,
                                          )),
                                      id: snapshot.data![index].songID,
                                      type: ArtworkType.AUDIO,
                                      artworkFit: BoxFit.contain,
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () async {
                                        await this.songsHandler.deleteSongs(
                                            snapshot.data![index].id!);
                                        setState(() {
                                          snapshot.data!
                                              .remove(snapshot.data![index]);
                                        });
                                      },
                                    ),
                                    onTap: () {
                                      for (int i = 0;
                                          i <= tracksQuery.length;
                                          i++) {
                                        if (tracksQuery[i].id ==
                                            snapshot.data![index].songID) {
                                          currentIndex = i;
                                          break;
                                        }
                                      }
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MusicControlls(
                                                    changeTrack: changeTrack,
                                                    songInfo: tracksQuery[
                                                        currentIndex],
                                                    key: key,
                                                  )));
                                    },
                                    title: Text(
                                      snapshot.data![index].songName,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 17),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    subtitle: Text(
                                      snapshot.data![index].songName,
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  Divider(
                                    height: 0,
                                    indent: 85,
                                    color: Colors.grey,
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          return Center(
                              child: Text(
                            "No song added",
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ));
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
