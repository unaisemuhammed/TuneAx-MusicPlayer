import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/MusicPages/settings_page.dart';
import 'favourite_page.dart';
import 'playlist_page.dart';
import 'search_page.dart';
import 'track_page.dart';
import 'package:musicplayer/colors.dart' as app_colors;

var _pages = [Track(), const Favourite(), const Playlist()];
List title = ['Playlist', 'Track', 'Favourite', 'Folder'];

class SlidePage extends StatefulWidget {
  const SlidePage({Key? key}) : super(key: key);

  @override
  _SlidePageState createState() => _SlidePageState();
}

class _SlidePageState extends State<SlidePage> {

  @override
  void initState() {
    super.initState();
  }

  int play = 0;
  int favourite = 0;
  TextEditingController playlistController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double heights = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: app_colors.back,
          appBar: AppBar(
            bottom: const TabBar(
              dragStartBehavior: DragStartBehavior.down,
              tabs: [
                Tab(
                  text: 'Track',
                ),
                Tab(
                  text: 'Favourite',
                ),
                Tab(
                  text: 'Playlist',
                ),
              ],
              indicatorColor: Colors.white70,
              unselectedLabelColor: Colors.white60,
              unselectedLabelStyle:
              TextStyle(fontSize: 16, fontFamily: 'Title'),
              labelStyle: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Title',
                  fontWeight: FontWeight.w500),
            ),
            toolbarHeight: 70,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Search(),
                      ));
                },
                icon: const Icon(Icons.search),
                iconSize: 30,
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Settings(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.settings),
                  iconSize: 25),
            ],
            title: const Text(
              'TUNE ' 'Ax',
              style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Geman',
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: app_colors.back,
          ),

          ///PageView///
          body: Stack(
            children: [
              TabBarView(
                children: _pages,
              ),

              /// ///////MusicBottomBar/////// ///
              // Positioned(
              //     bottom: Heights / 100,
              //     right: 7,
              //     left: 7,
              //     height: Heights / 13,
              //     child: BottomBar()),
              //

              ///ShadedPart///
              Positioned(
                top: heights / 2000,
                right: 0,
                left: 0,
                height: heights / 25,
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
                              backgroundBlendMode: BlendMode.dstOut),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          height: heights,
                          width: width,
                          decoration: const BoxDecoration(
                            color: app_colors.shade,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(50),
                              topLeft: Radius.circular(50),
                            ),
                          ),
                        ),
                      ],
                    ),
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
