import 'package:fluttertoast/fluttertoast.dart';
import 'package:musicplayer/colors.dart' as AppColors;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:musicplayer/db/Playlist/OpenPlaylist.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'db_helperPla.dart';
import 'helperPlay.dart';

class SelectInside extends StatefulWidget {
 final int playlistId;

  SelectInside({Key? key, required this.playlistId}) : super(key: key);

  @override
  SelectInsideState createState() => SelectInsideState();
}

class SelectInsideState extends State<SelectInside> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  var songID;
  var playlistID;
  var songName;
  var path;
  List<SongModel> tracks = [];

  late PlaylistDatabaseHandler songAddHandler;

  void initState() {
    super.initState();
    getTracks();
    songAddHandler = PlaylistDatabaseHandler();
    // requestPermission();
    // addSongsToPlaylist(songID, playlistID, songName, path);
  }
  void showToast()=>Fluttertoast.showToast(msg: "Songs Added",fontSize: 18,backgroundColor: AppColors.shade);


  Future<int> addSongsToPlaylist( var songID, var playlistID,var songName,var path) async {
    PlayListSong firstUser = PlayListSong(
        songID: songID, playlistID: playlistID, songName: songName, path: path);
    List<PlayListSong> listOfUsers = [firstUser];
    debugPrint("SELECTED SONG INSIDE PLAYLIST:$songID,$playlistID,$songName,$path");
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
        backgroundColor: AppColors.back,
        title: Text(
          "Add song to playlist",
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save_outlined),
            onPressed: () {
              showToast();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OpenPlaylist(playlistID),));
            },
          ),
        ],
      ),
      backgroundColor: AppColors.shade,
      body: Container(
        padding: EdgeInsets.only(bottom: 0, top: 10),
        color: Colors.transparent,
        child: ListView.builder(
            itemCount: tracks.length,
            itemBuilder: (BuildContext context, int index) {
              if (tracks[index].data.contains("mp3"))
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
                                color: AppColors.back,
                                borderRadius: BorderRadius.circular(8)),
                            child: Icon(
                              Icons.music_note_outlined,
                              color: Colors.grey,
                              size: 45,
                            )),
                        id: tracks[index].id,
                        type: ArtworkType.AUDIO,
                        artworkFit: BoxFit.contain,
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.add,
                        ),
                        color: Colors.white,
                        onPressed: () {
                            songID = tracks[index].id;
                            playlistID = widget.playlistId;
                            songName = tracks[index].title;
                            path = tracks[index].data;
                            addSongsToPlaylist(songID, playlistID, songName, path);
                        },
                      ),
                      title: Text(
                        tracks[index].title,
                        style: TextStyle(color: Colors.white, fontSize: 17),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      subtitle: Text(
                        tracks[index].displayNameWOExt,
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
              return Container(
                height: 0,
              );
            }),
      ),
    );
  }
}
