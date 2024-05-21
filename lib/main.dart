import 'package:MyPharmacie/views/login.dart';
import 'package:MyPharmacie/views/profile.dart';
import 'package:MyPharmacie/views/tab_bar.dart';
import 'package:MyPharmacie/views/tabv1.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
