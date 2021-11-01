import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:musicplayer/colors.dart' as AppColors;

import 'OpenPlaylist.dart';
import 'db_helperPla.dart';
import 'helperPlay.dart';

class CreateOrSelect extends StatefulWidget {
 final String songData;
  final int songId;
  final String songTitle;
   CreateOrSelect(this.songData, this.songId, this.songTitle, {Key? key}) : super(key: key);

  @override
  _CreateOrSelectState createState() => _CreateOrSelectState();
}

class _CreateOrSelectState extends State<CreateOrSelect> {
  final folderController = TextEditingController();
  late String playlistName;
  dynamic folderName;
  int playlistFolderId = 0;
  int   playlistFolderId1=0;
  late PlaylistDatabaseHandler playlistHandler;
  List<OpenContainer> playlistPages = [];
  late PlaylistDatabaseHandler songAddHandler;
  initState() {
    super.initState();
    songAddHandler = PlaylistDatabaseHandler();
    playlistHandler = PlaylistDatabaseHandler();
    addSongToPlaylist(widget.songId, playlistFolderId1, widget.songTitle, widget.songData);
    addUsers(folderName);
  }

  Future<int> addSongToPlaylist(var songID,var playlistID,var songName,var path) async {
    PlayListSong firstUser = PlayListSong(
        songID: songID, playlistID: playlistID, songName: songName, path: path);
    List<PlayListSong> listOfUsers = [firstUser];
    debugPrint("addSongToPlaylist:$songID,$playlistID,$songName,$path");
    return await songAddHandler.insertSongs(listOfUsers);
  }

  Future<int> addUsers(folderName) async {
    PlaylistModel firstUser = PlaylistModel(playListName: folderName);
    List<PlaylistModel> listOfUsers = [firstUser];
    debugPrint("ADNAN:$folderName");
    return await playlistHandler.insertPlaylist(listOfUsers);
  }

  Future<void> _showMyDialog(var songData, var songTitle, var songId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Create a playlist',
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.white, fontFamily: 'Titil'),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return TextField(
                maxLength: 12,
                style: TextStyle(color: Colors.white),
                controller: folderController,
                autofocus: true,
                decoration: InputDecoration(
                    hintText: 'Enter folder name',
                    hintStyle: TextStyle(color: Colors.grey)),
                onChanged: (val) {
                  setState(() {
                    playlistName = folderController.text;
                  });
                },
              );
            },
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  alignment: Alignment.bottomLeft,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        // playlistFolderId=(snapshot.data![index].id!);
                        print(playlistFolderId);
                      });
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Titil",
                          color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        folderName = playlistName;
                        addUsers(folderName);
                        addSongToPlaylist(widget.songId, playlistFolderId, widget.songTitle, widget.songData);
                      });
                      Navigator.pop(context);
                    
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) =>
                        //           OpenPlaylist(playlistFolderId),
                        //     ));
                    },
                    child: Text(
                      "Create",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Titil",
                          color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: AppColors.back,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double heights = MediaQuery.of(context).size.height;
    final double widths = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.shade,
        appBar: AppBar(
          leadingWidth: 30,
          leading: IconButton(
            padding: EdgeInsets.only(left: 20, top: 16),
            color: Colors.white,
            alignment: Alignment.topLeft,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: Text(
            'Add to',
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontFamily: 'Titil'),
          ),
          backgroundColor: AppColors.back,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: 50),
              child: FutureBuilder(
                future: this.playlistHandler.retrievePlaylist(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<PlaylistModel>> snapshot) {
                  if (snapshot.hasData) {
                    debugPrint(
                        "GGGGGGGGGGGGGGGGGGGGGGGGGGGGGG:::$snapshot");
                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            ListTile(
                              onTap: () {
                                showToast();
                                setState(() {
                                  playlistFolderId1=snapshot.data![index].id!;
                                });
                                addSongToPlaylist(widget.songId, playlistFolderId1, widget.songTitle, widget.songData);
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OpenPlaylist(snapshot.data![index].id!),));
                              },
                              leading: Icon(Icons.folder_open,size: 55,color: Colors.grey,),
                              title: Text(
                                snapshot.data![index].playListName,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              subtitle: Text(
                                snapshot.data![index].playListName,
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
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
              width: widths,
              decoration: BoxDecoration(color: AppColors.shade),
            ),

            /// shadedHolllow///
            Positioned(
              top: heights / 2000,
              right: 0,
              left: 0,
              height: heights / 12,
              child: Container(
                child: ColorFiltered(
                  colorFilter:
                      ColorFilter.mode(AppColors.back, BlendMode.srcOut),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: AppColors.shade,
                            backgroundBlendMode: BlendMode
                                .dstOut), // This one will handle background + difference out
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 40),
                        height: heights,
                        width: widths,
                        decoration: BoxDecoration(
                          color: AppColors.shade,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            topLeft: Radius.circular(30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: heights / 35,
              right: 25,
              child: CircleAvatar(
                backgroundColor: AppColors.back,
                radius: 30,
                child: IconButton(
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 35,
                  ),
                  onPressed: () {
                    _showMyDialog(widget.songData,widget.songTitle,widget.songId);
                    print('playlistFolderIdu=$playlistFolderId');
                  },
                ),
                // decoration: ShapeDecoration(
                //     color: AppColors.back, shape: CircleBorder()),
                // height: 65,
                // width: 65,
              ),
            ),
          ],
        ),
      ),
    );
  }
  void showToast()=>Fluttertoast.showToast(msg: "Songs Added",fontSize: 18,backgroundColor: AppColors.shade);

}
