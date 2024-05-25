import 'package:MyPharmacie/views/login.dart';
import 'package:MyPharmacie/views/tabv1.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String token = "";

  void checking() async {
    SharedPreferences kim = await SharedPreferences.getInstance();
    setState(() {
      token = kim.getString("token").toString();
    });
    print("token est $token");
  }

  @override
  void initState() {
    checking();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: token == ""
            ? Center(child: CircularProgressIndicator())
            : token == "null"
                ? LoginScreen()
                : NavigationRailPage());
  }
}

// http://localhost:8000/api/user/sumpoint/1
