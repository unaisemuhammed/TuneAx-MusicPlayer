import 'package:musicplayer/colors.dart' as app_colors;
import 'package:flutter/material.dart';
import 'package:musicplayer/db/Playlist/open_playlist.dart';
import 'package:musicplayer/db/Playlist/select_song.dart';
import 'package:musicplayer/db/Playlist/db_helper_pla.dart';
import 'package:musicplayer/db/Playlist/helper_play.dart';

class Playlist extends StatefulWidget {
  const Playlist({Key? key}) : super(key: key);

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
    final PlaylistModel firstUser = PlaylistModel(playListName: folderName);
    final List<PlaylistModel> listOfUsers = [firstUser];
    debugPrint('addPlaylistName:$folderName');
    return await playlistHandler.insertPlaylist(listOfUsers);
  }

  Future<void> _showMyDialog(playlistFolderId) async {
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
                      });
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 20, fontFamily: 'Title',
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
                      }
                    },
                    child: const Text(
                      'Create',
                      style: TextStyle(fontSize: 20, fontFamily: 'Title',
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
        backgroundColor: app_colors.shade,
        body: Container(
          padding: const EdgeInsets.only(bottom: 0, top: 10),
          child: Stack(
            children: [
              Positioned(
                child: FutureBuilder(
                  future: playlistHandler.retrievePlaylist(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<PlaylistModel>> snapshot) {
                    if (snapshot.hasData) {
                      return GridView.builder(
                          itemCount: snapshot.data?.length,
                          gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 180,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 0,
                          ),
                          itemBuilder: (context, index) {
                            playlistFolderId = snapshot.data![index].id!;
                            return Container(
                              padding: const EdgeInsets.all(6),
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => OpenPlaylist(
                                            snapshot.data![index].id!),));
                                    },
                                    onLongPress: () {
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: false,
                                        // user must tap button!
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: app_colors.back,
                                            title: const Text(
                                              'Are you sure to delete this '
                                                  'folder?',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Title'),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text('Yes',
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontFamily: 'Title')),
                                                onPressed: () async {
                                                  await playlistHandler
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
                                                child: const Text(
                                                  'No',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: 'Title'),
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
                                          padding: const EdgeInsets.all(5),
                                          child: const Icon(
                                            Icons.music_note_outlined,
                                            size: 70,
                                            color: Colors.grey,
                                          ),
                                          decoration: BoxDecoration(
                                            color: app_colors.back,
                                            borderRadius:
                                            BorderRadius.circular(10),),
                                        ),
                                        Text(
                                          '${snapshot.data![index].playListName
                                          }',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontFamily: 'Title'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              Positioned(
                bottom: height / 35,
                right: 30,
                child: Ink(
                  child: IconButton(
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 50,
                    ),
                    onPressed: () {
                      _showMyDialog(playlistFolderId);
                    },
                  ),
                  decoration: const ShapeDecoration(
                      color: app_colors.back, shape: CircleBorder()),
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
