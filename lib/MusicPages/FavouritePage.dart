import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/colors.dart' as AppColors;
import 'package:musicplayer/db/Favourite/db_helper.dart';
import 'package:musicplayer/db/Favourite/helper.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'Cnplaylist.dart';

class Favourite extends StatefulWidget {
  const Favourite({Key? key}) : super(key: key);

  @override
  FavouriteState createState() => FavouriteState();
}

class FavouriteState extends State<Favourite> {
  dynamic favTracks = [];
  List<SongModel> tracks = [];
  List <dynamic> dbTracks=[];
  final GlobalKey<MusicControllsState> key = GlobalKey<MusicControllsState>();
  final OnAudioQuery audioQuery = OnAudioQuery();
  late final AudioPlayer player;
  int currentIndex = 0;
  int isFav = 0;
  dynamic songTitle;
  dynamic songId;
  dynamic songLocation;
  int favourite = 0;
  late  DatabaseHandler handler= DatabaseHandler();

  @override
  void initState() {
    super.initState();
    handler= DatabaseHandler();
    getTracks();
    getFavSong();
    player = AudioPlayer();
  }

  void getTracks() async {
    tracks = await audioQuery.querySongs();
    setState(() {
      tracks = tracks;
    });
  }
  void getDbTrac() async {
    dbTracks = await this.handler.retrieveFavSongs();
    setState(() {
      dbTracks = dbTracks;
    });
  }
  void getFavSong() async {
    favTracks = await this.handler.retrieveFavSongs();
    setState(() {
      favTracks =favTracks;
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

  @override
  Widget build(BuildContext context) {
    final double heights = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.shade,
        body: Container(
          padding: EdgeInsets.only(bottom: 0, top: 10),
          child: FutureBuilder(
            future: this.handler.retrieveFavSongs(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Songs>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        ListTile(
                          onTap: () {
                            for(int i=0;i<=tracks.length;i++){
                              if(tracks[i].id==snapshot.data![index].num){
                                currentIndex=i;
                                break;
                              }
                            }
                              favTracks = snapshot.data![index].location;
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MusicControlls(
                                      changeTrack: changeTrack,
                                      songInfo: tracks[currentIndex],
                                      key: key,
                                    )));
                          },
                          leading: QueryArtworkWidget(
                            artworkBorder: BorderRadius.circular(8),
                            nullArtworkWidget: Container(
                                width: width / 8,
                                height: heights / 14,
                                decoration: BoxDecoration(
                                    color: AppColors.back,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Icon(
                                  Icons.music_note_outlined,
                                  color: Colors.grey,
                                  size: 45,
                                )),
                            id: snapshot.data![index].num,
                            type: ArtworkType.AUDIO,
                            artworkFit: BoxFit.contain,
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.grey,
                            ),
                            onPressed: () async {
                              showToast();
                              await this.handler.deleteFavSongs(snapshot.data![index].num);
                              setState(() {
                                snapshot.data!.remove(snapshot.data![index].num);
                              });
                            },
                          ),
                          title: Text(
                            snapshot.data![index].name,
                            style: TextStyle(color: Colors.white, fontSize: 17),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          subtitle: Text(
                            "ariana Grande",
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
        ),
      ),
    );
  }
  void showToast()=>Fluttertoast.showToast(msg: "Deleted From Favourite",fontSize: 18,backgroundColor: AppColors.shade);

}
