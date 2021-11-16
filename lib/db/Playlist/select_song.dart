import 'package:fluttertoast/fluttertoast.dart';
import 'package:musicplayer/colors.dart' as app_colors;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:musicplayer/db/Playlist/open_playlist.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'db_helper_pla.dart';
import 'helper_play.dart';

class SelectTrack extends StatefulWidget {
  final int playlistId;
  SelectTrack({Key? key, required this.playlistId}) : super(key: key);

  @override
  SelectTrackState createState() => SelectTrackState();
}

class SelectTrackState extends State<SelectTrack> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  var songID;
  var playlistID;
  var songName;
  var path;
  int select=0;
  List<SongModel> tracks = [];

  late PlaylistDatabaseHandler songAddHandler;

  @override
  void initState() {
    super.initState();
    getTracks();
    songAddHandler = PlaylistDatabaseHandler();
  }

  Future<int> addSongToPlaylist(var songID,var playlistID,var songName,var path)
  async {final PlayListSong firstUser = PlayListSong(
        songID: songID, playlistID: playlistID, songName: songName, path: path);
    final List<PlayListSong> listOfUsers = [firstUser];
    return await songAddHandler.insertSongs(listOfUsers);
  }


  void getTracks() async {
    tracks = await audioQuery.querySongs();
    setState(() {
      tracks = tracks;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double heights = MediaQuery.of(context).size.height;
    final double widths = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: app_colors.back,
        title: const Text(
          'Add song to playlist',
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_outlined),
            onPressed: () {
              if(select==1){
                Navigator.pushReplacement(context, MaterialPageRoute(builder:
                    (context) => OpenPlaylist(playlistID),));
                showToast();
                setState(() {
                  select=0;
                });
              }else{
                showToast2();
              }


            },
          ),
        ],
      ),
      backgroundColor: app_colors.shade,
      body: Container(
        padding: const EdgeInsets.only(bottom: 0, top: 10),
        color: Colors.transparent,
        child: ListView.builder(
            itemCount: tracks.length,
            itemBuilder: (BuildContext context, int index) {
              if (tracks[index].data.contains('mp3'))
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: QueryArtworkWidget(
                        artworkBorder: BorderRadius.circular(8),
                        nullArtworkWidget: Container(
                            width: widths / 8,
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
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.add,
                        ),
                        color: Colors.white,
                        onPressed: () {
                          if(select==0){
                            setState(() {
                              select=1;
                            });}
                            songID = tracks[index].id;
                            playlistID = widget.playlistId+1;
                            songName = tracks[index].title;
                            path = tracks[index].data;
                            addSongToPlaylist(songID, playlistID, songName,
                                path);
                        },
                      ),
                      title: Text(
                        tracks[index].title,
                        style: const TextStyle(color: Colors.white,
                            fontSize: 17),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      subtitle: Text(
                        tracks[index].displayNameWOExt,
                        style: const TextStyle(color: Colors.grey),
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
    );
  }
  void showToast()=>Fluttertoast.showToast(msg: 'Playlist created',fontSize: 18,
      backgroundColor: app_colors.back);
  void showToast2()=>Fluttertoast.showToast(msg: 'Select song',fontSize: 18,
      backgroundColor: app_colors.back);

}
