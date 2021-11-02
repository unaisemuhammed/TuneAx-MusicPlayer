import 'dart:async';
import 'package:flutter/material.dart';
import 'package:musicplayer/MusicPages/slide_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) =>
      const SlidePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          body: Container(
            child: Image.asset('assets/Welcome To.png',fit: BoxFit.fill,),
          )
        ),
      ],
    );
  }
}



