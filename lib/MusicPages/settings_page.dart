import 'package:flutter/material.dart';
import 'package:musicplayer/colors.dart' as app_colors;
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'about.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    final double heights = MediaQuery
        .of(context)
        .size
        .height;
    final double width = MediaQuery
        .of(context)
        .size
        .width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: app_colors.back,
        appBar: AppBar(
          leading: IconButton(
            padding: const EdgeInsets.only(left: 20, top: 20),
            color: Colors.white,
            alignment: Alignment.topLeft,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          backgroundColor: app_colors.back,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: heights,
              height: heights,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                height: heights,
                width: width,
              ),
            ),
            ListView(
              scrollDirection: Axis.vertical,
              children: [
                Container(
                  color: app_colors.back,
                  padding: const EdgeInsets.only(top: 100),
                  child: const Center(
                    child: Text(
                      '''TUNE '''
                          '''Ax''',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          letterSpacing: 5,
                          fontFamily: 'Geman',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  height: 150,
                ),
                Container(
                  color: app_colors.back,
                  padding: const EdgeInsets.only(bottom: 50),
                  child: const Center(
                    child: Text(
                      'settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontFamily: 'Babas',
                      ),
                    ),
                  ),
                  height: 100,
                ),
                // Container(
                //   // padding: EdgeInsets.only(left: 15),
                //   color:AppColors.back,
                //   height: 100,
                //   child: IconButton(color: Colors.white,
                //     alignment: Alignment.topLeft,
                //       onPressed: (){Navigator.pop(context);},
                //       icon: Icon(Icons.arrow_back_ios),),
                // ),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  height: 30,
                  child: const Text(
                    'Privacy',
                    style: TextStyle(
                        color: app_colors.subtitle,
                        fontSize: 18,
                        fontFamily: 'Title',
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          launch(
                              'https://github.com/unaisemuhammed/Privacy-and-Policy/blob/main/privacy-policy.md');
                        },
                        // dense: true,
                        title: const Text(
                          'Privacy and Security',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        subtitle: const Text(
                          'Read and listen our privacy and policy',
                          style: TextStyle(color: Colors.grey),
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.lock,
                            color: Colors.white,
                            size: 25,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      const Divider(
                        height: 10,
                        color: Colors.grey,
                      ),
                      ListTile(
                        // dense: true,
                        title: const Text(
                          'Help and Support',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        subtitle: const Text(
                          'Let us know your problems',
                          style: TextStyle(color: Colors.grey),
                        ),
                        trailing: IconButton(
                          padding: const EdgeInsets.only(right: 20),
                          icon: const Icon(
                            Icons.headset_mic_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {},
                        ),
                        onTap: () {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: true, // user must tap button!
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                  'Contact us:',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.white, fontFamily: 'Title'),
                                ),
                                content: GestureDetector(
                                  onTap: () =>
                                      launch(
                                          'https://mail.google.com/mail/u/0/#inbox?compose=unys313@gmail.com'),
                                  child: Row(
                                    children: const [
                                      Text(
                                        'Email:',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text(
                                        ' unys313@gmail.com',
                                        style: TextStyle(color: Colors.blueAccent),
                                      ),
                                    ],
                                  ),),
                                actions: const [],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                backgroundColor: app_colors.back,
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  height: 180,
                  width: heights,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: app_colors.shade),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10, left: 20),
                  height: 40,
                  child: const Text(
                    'Information',
                    style: TextStyle(
                        color: app_colors.subtitle,
                        fontSize: 18,
                        fontFamily: 'Title',
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  height: 180,
                  width: heights,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: app_colors.shade),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                            Share.share('https://play.google.com/store/apps/details?id=com.unys.AxTune', subject: 'Try out TuneAx music player!');
                        },
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.share,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                        title: const Text(
                          'Share Tune Ax',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        subtitle: const Text(
                          'Share this app to your friends.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      const Divider(
                        height: 10,
                        color: Colors.grey,
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const About(),
                              ));
                        },
                        trailing: const Icon(
                          Icons.info_rounded,
                          color: Colors.white,
                        ),
                        title: const Text(
                          'About Tune Ax',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        subtitle: const Text(
                          'Everything about Tune Ax you can'
                              ' read terms and conditions.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                    padding: const EdgeInsets.all(20),
                    alignment: Alignment.center,
                    child: const Text(
                      'Powered by Tune Ax',
                      style: TextStyle(color: Colors.white30),
                    ))
              ],
            ),

            /// shadedHollow///
            Positioned(
              top: heights / 2000,
              right: 0,
              left: 0,
              height: heights / 8,
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
                        width: width,
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
          ],
        ),
      ),
    );
  }
}
