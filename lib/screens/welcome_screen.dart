// ignore_for_file: avoid_unnecessary_containers

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:git_news/screens/home_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 6), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      
      appBar: AppBar(
      
        title: Text('Git-news-app', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/news.jpg',
              fit: BoxFit.cover,
              height: height * 0.57,
              width: width * 1.5,
            ),
            Text(
              "Top Headlines for United Status News",
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17),
            ),
            SizedBox(height: 100, width: 5),

            SpinKitWave(color: Colors.black),
            Text("Loading...", style: GoogleFonts.sigmar(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
