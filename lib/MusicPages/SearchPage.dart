import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/colors.dart' as AppColors;
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final OnAudioQuery audioQuery = OnAudioQuery();

  late final AudioPlayer player;
  List<SongModel> _foundUsers = [];
  List<SongModel> Tracks = [];

  var songTitle;
  var songId;
  var songLocation;

  void getTracks() async {
    Tracks = await audioQuery.querySongs();
    setState(() {
      Tracks = Tracks;
    });
  }

  void initState() {
    super.initState();
    player = AudioPlayer();
    _foundUsers = Tracks;
    getTracks();
  }

  void _runFilter(String enteredKeyword) {
    List<SongModel> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = Tracks;
    } else {
      results = Tracks.where((user) =>
              user.title.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double Heights = MediaQuery.of(context).size.height;
    final double Weights = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.back,
        appBar: AppBar(
          backgroundColor: AppColors.back,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: TextFormField(
              onChanged: (value) => _runFilter(value),
              style: TextStyle(color: Colors.white, fontSize: 20),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.yellow),
                  ),
                  hintText: "Search",
                  hintStyle: TextStyle(fontSize: 20, color: Colors.grey))),
        ),
        body: Padding(
          padding: const EdgeInsets.all(6),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: _foundUsers.isNotEmpty
                    ? ListView.builder(
                        itemCount: _foundUsers.length,
                        itemBuilder: (context, index) => Column(
                          children: [
                            ListTile(
                              onTap: () {
                                player.setUrl(Tracks[index].data);
                                player.play();
                              },
                              leading: QueryArtworkWidget(
                                artworkBorder: BorderRadius.circular(8),
                                nullArtworkWidget: Container(
                                    width: Weights / 8,
                                    height: Heights / 14,
                                    decoration: BoxDecoration(
                                        color: AppColors.shade,
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Icon(
                                      Icons.music_note_outlined,
                                      color: Colors.grey,
                                      size: 45,
                                    )),
                                id: Tracks[index].id,
                                type: ArtworkType.AUDIO,
                                artworkFit: BoxFit.contain,
                              ),
                              title: Text(
                                _foundUsers[index].title,
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                '${_foundUsers[index].title.toString()} album',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Divider(
                              height: 0,
                              indent: 85,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ) : Center(
                        child: const Text(
                          'No results found',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
