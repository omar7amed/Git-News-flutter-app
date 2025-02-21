import 'package:flutter/material.dart';
import 'package:git_news/screens/welcome_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Git-NEWS'.toString(),
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}
