import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/colors.dart' as app_colors;
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
  List<SongModel> tracks = [];

  var songTitle;
  var songId;
  var songLocation;

  void getTracks() async {
    tracks = await audioQuery.querySongs();
    setState(() {
      tracks = tracks;
    });
  }

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    _foundUsers = tracks;
    getTracks();
  }

  void _runFilter(String enteredKeyword) {
    List<SongModel> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space,
      // we'll display all users
      results = tracks;
    } else {
      results = tracks.where((user) =>
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
    final double heights = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: app_colors.back,
        appBar: AppBar(
          backgroundColor: app_colors.back,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: TextFormField(
              onChanged: (value) => _runFilter(value),
              style: const TextStyle(color: Colors.white, fontSize: 20),
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
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
                  hintText: 'Search',
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
                                player.setUrl(tracks[index].data);
                                player.play();
                              },
                              leading: QueryArtworkWidget(
                                artworkBorder: BorderRadius.circular(8),
                                nullArtworkWidget: Container(
                                    width: width / 8,
                                    height: heights / 14,
                                    decoration: BoxDecoration(
                                        color: app_colors.shade,
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
                                _foundUsers[index].title,
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                '${_foundUsers[index].title.toString()} album',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                            const Divider(
                              height: 0,
                              indent: 85,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ) : const Center(
                        child: Text(
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
