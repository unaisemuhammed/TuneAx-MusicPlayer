import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:musicplayer/colors.dart' as app_colors;

import 'open_playlist.dart';
import 'db_helper_pla.dart';
import 'helper_play.dart';

class CreateOrSelect extends StatefulWidget {
  final String songData;
  final int songId;
  final String songTitle;

  CreateOrSelect(this.songData, this.songId, this.songTitle, {Key? key})
      : super(key: key);

  @override
  _CreateOrSelectState createState() => _CreateOrSelectState();
}

class _CreateOrSelectState extends State<CreateOrSelect> {
  final folderController = TextEditingController();
  late String playlistName;
  dynamic folderName;
  int playlistFolderId = 0;
  int playlistFolderId1 = 0;
  late PlaylistDatabaseHandler playlistHandler;
  List<OpenContainer> playlistPages = [];
  late PlaylistDatabaseHandler songAddHandler;

  @override
  void initState() {
    super.initState();
    songAddHandler = PlaylistDatabaseHandler();
    playlistHandler = PlaylistDatabaseHandler();
    addSongToPlaylist(
        widget.songId, playlistFolderId1, widget.songTitle, widget.songData);
    addUsers(folderName);
  }

  Future<int> addSongToPlaylist(
      var songID, var playlistID, var songName, var path) async {
    final PlayListSong firstUser = PlayListSong(
        songID: songID, playlistID: playlistID, songName: songName, path: path);
    final List<PlayListSong> listOfUsers = [firstUser];
    return await songAddHandler.insertSongs(listOfUsers);
  }

  Future<int> addUsers(folderName) async {
    final PlaylistModel firstUser = PlaylistModel(playListName: folderName);
    final List<PlaylistModel> listOfUsers = [firstUser];
    return await playlistHandler.insertPlaylist(listOfUsers);
  }

  Future<void> _showMyDialog(var songData, var songTitle, var songId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Create a playlist',
            textAlign: TextAlign.left,
            style: TextStyle(color: Colors.white, fontFamily: 'Title'),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return TextField(
                maxLength: 12,
                style: const TextStyle(color: Colors.white),
                controller: folderController,
                autofocus: true,
                decoration: const InputDecoration(
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
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Title',
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
                        addSongToPlaylist(widget.songId, playlistFolderId,
                            widget.songTitle, widget.songData);
                      });
                      Navigator.pop(context);

                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) =>
                      //           OpenPlaylist(playlistFolderId),
                      //     ));
                    },
                    child: const Text(
                      'Create',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Title',
                          color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: app_colors.back,
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
        backgroundColor: app_colors.shade,
        appBar: AppBar(
          leadingWidth: 30,
          leading: IconButton(
            padding: const EdgeInsets.only(left: 20, top: 16),
            color: Colors.white,
            alignment: Alignment.topLeft,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: const Text(
            'Add to',
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontFamily: 'Title'),
          ),
          backgroundColor: app_colors.back,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 50),
              child: FutureBuilder(
                future: playlistHandler.retrievePlaylist(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<PlaylistModel>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            ListTile(
                              onTap: () {
                                showToast();
                                setState(() {
                                  playlistFolderId1 = snapshot.data![index].id!;
                                });
                                addSongToPlaylist(
                                    widget.songId,
                                    playlistFolderId1,
                                    widget.songTitle,
                                    widget.songData);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OpenPlaylist(
                                          snapshot.data![index].id!),
                                    ));
                              },
                              leading: const Icon(
                                Icons.folder_open,
                                size: 55,
                                color: Colors.grey,
                              ),
                              title: Text(
                                snapshot.data![index].playListName,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 17),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              subtitle: Text(
                                snapshot.data![index].playListName,
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
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              width: widths,
              decoration: const BoxDecoration(color: app_colors.shade),
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
                      const ColorFilter.mode(app_colors.back, BlendMode.srcOut),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                            color: app_colors.shade,
                            backgroundBlendMode: BlendMode
                                .dstOut), // This one will handle background +
                        // difference out
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 40),
                        height: heights,
                        width: widths,
                        decoration: const BoxDecoration(
                          color: app_colors.shade,
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
                backgroundColor: app_colors.back,
                radius: 30,
                child: IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 35,
                  ),
                  onPressed: () {
                    _showMyDialog(
                        widget.songData, widget.songTitle, widget.songId);
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

  void showToast() => Fluttertoast.showToast(
      msg: 'Songs Added', fontSize: 18, backgroundColor: app_colors.shade);
}
