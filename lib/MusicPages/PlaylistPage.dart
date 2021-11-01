import 'package:musicplayer/colors.dart' as AppColors;
import 'package:flutter/material.dart';
import 'package:musicplayer/db/Playlist/OpenPlaylist.dart';
import 'package:musicplayer/db/Playlist/SelectSong.dart';
import 'package:musicplayer/db/Playlist/db_helperPla.dart';
import 'package:musicplayer/db/Playlist/helperPlay.dart';

class Playlist extends StatefulWidget {
  const Playlist(playlistFolderId, {Key? key}) : super(key: key);

  @override
  PlaylistState createState() => PlaylistState();
}

class PlaylistState extends State<Playlist> {
  final folderController = TextEditingController();
  late String playlistName;
  var folderName;
  int playlistFolderId = 0;
  late PlaylistDatabaseHandler playlistHandler;

  Future<int> addPlaylist(String folderName) async {
    PlaylistModel firstUser = PlaylistModel(playListName: folderName);
    List<PlaylistModel> listOfUsers = [firstUser];
    debugPrint("addPlaylistName:$folderName");
    return await playlistHandler.insertPlaylist(listOfUsers);
  }

  Future<void> _showMyDialog(playlistFolderId) async {
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
                      style: TextStyle(fontSize: 20, fontFamily: "Titil",color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        folderName = playlistName;
                        addPlaylist(folderName);
                      });
                      if (playlistName != null) {
                        setState(() {
                          folderController.clear();
                          playlistName = '';
                        });
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SelectTrack(playlistId: playlistFolderId),
                            ));
                        print('   playlistFolderIdr=$playlistFolderId');
                      }
                    },
                    child: Text(
                      "Create",
                      style: TextStyle(fontSize: 20, fontFamily: "Titil",color: Colors.white),
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
  void initState() {
    // TODO: implement initState
    super.initState();
    // addPlaylist(folderName);
    playlistHandler = PlaylistDatabaseHandler();
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    folderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final double height = MediaQuery.of(context).size.height;
    // final double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.shade,
        body: Container(
          padding: EdgeInsets.only(bottom: 0, top: 10),
          child: Stack(
            children: [
              Positioned(
                child: FutureBuilder(
                  future: this.playlistHandler.retrievePlaylist(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<PlaylistModel>> snapshot) {
                    if (snapshot.hasData) {
                      return GridView.builder(
                          itemCount: snapshot.data?.length,
                          gridDelegate:
                          SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 180,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 0,
                          ),
                          itemBuilder: (context, index) {
                            playlistFolderId = snapshot.data![index].id!;
                            return Container(
                              padding: EdgeInsets.all(6),
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => OpenPlaylist(snapshot.data![index].id!),));
                                    },
                                    onLongPress: () {
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: false,
                                        // user must tap button!
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: AppColors.back,
                                            title: Text(
                                              'Are you sure to delete this folder?',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Titil'),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: Text('Yes',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontFamily: 'Titil')),
                                                onPressed: () async {
                                                  await this
                                                      .playlistHandler
                                                      .deletePlaylist(snapshot
                                                      .data![index].id!);
                                                  setState(() {
                                                    snapshot.data!.remove(
                                                        snapshot.data![index]);
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: Text(
                                                  'No',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: 'Titil'),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(5),
                                          child: Icon(
                                            Icons.folder_open,
                                            size: 80,
                                            color: Colors.grey,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.back,
                                            borderRadius:
                                            BorderRadius.circular(10),),
                                        ),
                                        Text(
                                          '${snapshot.data![index].playListName}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontFamily: 'Titil'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              Positioned(
                bottom: height / 35,
                right: 30,
                child: Ink(
                  child: IconButton(
                    icon: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 50,
                    ),
                    onPressed: () {
                      _showMyDialog(playlistFolderId);
                      print('playlistFolderIdu=$playlistFolderId');
                    },
                  ),
                  decoration: ShapeDecoration(
                      color: AppColors.back, shape: CircleBorder()),
                  height: 65,
                  width: 65,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
