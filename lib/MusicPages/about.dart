import 'package:flutter/material.dart';
import 'package:musicplayer/colors.dart' as app_colors;

class About extends StatefulWidget {
  const About({Key? key}) : super(key: key);

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  int screen = 0;
  int controllMusic = 0;

  @override
  Widget build(BuildContext context) {
    // final double Heights = MediaQuery.of(context).size.height;
    // final double Weights = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: app_colors.back,
        appBar: AppBar(
          actions: [
            Container(
                padding: const EdgeInsets.only(right: 20, top: 0),
                child: const Icon(
                  Icons.info,
                  color: Colors.white,
                ))
          ],
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
            Container(
              color: app_colors.back,
              padding: const EdgeInsets.only(top: 100),
              child: const Center(
                child: Text(
                  '''About TUNE '''
                  '''Ax''',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      letterSpacing: 5,
                      fontFamily: 'Geman',
                      fontWeight: FontWeight.bold),
                ),
              ),
              height: 190,
            ),
            Positioned(
              bottom: 120,
              right: 60,
              left: 60,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AboutSection(),
                      ));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: app_colors.shade,
                      borderRadius: BorderRadius.circular(30)),
                  width: 300,
                  height: 60,
                  child: const Center(
                    child: Text(
                      'Terms and Condition',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Title',
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ),
            // Positioned(
            //   bottom: 50,
            //   right: 60,
            //   left: 60,
            //   child: GestureDetector(
            //     onTap: () {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //             builder: (context) => AboutSection(),
            //           ));
            //     },
            //     child: Container(
            //       decoration: BoxDecoration(
            //           color: AppColors.back,
            //           borderRadius: BorderRadius.circular(30)),
            //       width: 300,
            //       height: 60,
            //       child: Center(
            //         child: Text(
            //           "Open Source Licences",
            //           style: TextStyle(
            //               color: Colors.white,
            //               fontSize: 20,
            //               fontFamily: 'Titil',
            //               fontWeight: FontWeight.w700),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Positioned(
              child: Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  child: const Text('',
                    style: TextStyle(color: Colors.white30),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutSection extends StatefulWidget {
  const AboutSection({Key? key}) : super(key: key);

  @override
  _AboutSectionState createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Terms and Conditions',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            fontFamily: 'Geman',
          ),
        ),
        backgroundColor: app_colors.back,
        elevation: 0,
      ),
      backgroundColor: app_colors.back,
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: const [
                Text(
                  'Tune Ax TERMS OF SERVICE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontFamily: 'Title',
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'IMPORTANT – READ CAREFULLY. THESE TERMS OF SERVICE (“TOS”) '
                      'ARE A LEGAL AGREEMENT BETWEEN YOU AND TuneAx ELECTRONICS'
                      'CO.,'
                  ' LTD. AND ITS AFFILIATES (COLLECTIVELY, “TuneAx”) FOR THE '
                      'SAMSUNG MUSIC APPLICATION AND ANY RELEVANT SOFTWARE OR '
                  'DOCUMENTATION THEREOF (COLLECTIVELY, THE “SERVICE”) PROVIDED'
                      ' BY SAMSUNG OR ITS THIRD PARTY SUPPLIERS OR LICENSORS.'
                  ' BY AGREEING TO THESE TOS OR BY INSTALLING OR OTHERWISE'
                      ' USING THE SERVICE, YOU AGREE TO BE BOUND BY THESE TOS.'
                      ' IF YOU DO NOT AGREE TO THESE TOS, THEN DO NOT INSTALL'
                      ' OR USE THE SERVICE.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Title',
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'TuneAx Music is a music player application that allows a '
                      'seamless and easy playlist management.'
                  ' With TuneAx Music, you can play your music according to '
                      'various categories, such as genre, artist and etc.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Title',
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  '1. Grant of License'
                  'Subject to the terms of these TOS, you are granted a limited'
                      'non-exclusive, and revocable license to install,'
                  'access and use the SERVICE. The services and features '
                      'provided'
                      ' by the SERVICE or Update (defined below) thereto '
                  'may vary or be limited depending on certain factors, '
                      'including,'
                      ' without limitation, your country, device, operating '
                      'system,'
                  'or network operator. If you are 13 or older but under the '
                      'age'
                      ' of 18, you represent that you have reviewed these TOS '
                      'with your '
                  'parent or legal guardian and that you and your parent or '
                      'guardian'
                      ' understands and consents to the terms and conditions of'
                      ' these TOS.'
                  'If you are a parent or guardian permitting a person under'
                      ' the'
                      " age of 18 ('Minor') to use the SERVICE, you agree to:"
                      ' (i) supervise'
                  "the Minor's use of the SERVICE; (ii) assume all risks "
                      'associated with the Minor’s use of the SERVICE, (iii)'
                      'assume any liability resulting '
                  'from the Minor’s use of the SERVICE; (iv) ensure the'
                      ' accuracy'
                      ' and truthfulness of all information submitted by'
                      ' the Minor; and '
                  '(v) assume responsibility and are bound by this Agreement '
                      'for '
                      'the Minor’s access and use of the SERVICE.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Titil',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
