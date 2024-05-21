import 'dart:convert';

import 'package:MyPharmacie/controllers/UserController.dart';
import 'package:MyPharmacie/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Myprofile extends StatefulWidget {
  const Myprofile({super.key});

  @override
  State<Myprofile> createState() => _MyprofileState();
}

class _MyprofileState extends State<Myprofile> {
  late User kim = User(
      id: 0,
      firstname: "",
      lastname: "",
      email: "",
      phone: "",
      emailVerifiedAt: "",
      role: "",
      badgeToken: "",
      passwordResetToken: "");
  @override
  void initState() {
    getUserDetails();
    super.initState();
  }

  Usercontroller _usercontroller = Usercontroller();
  void getUserDetails() async {
    var res = await _usercontroller.getUserInfos();
    if (res == null) return;
    setState(() {
      kim = User.fromJson(jsonDecode(res));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Profil'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // const CircleAvatar(
              //   radius: 50,
              //   backgroundColor: Colors.black38,
              // ),
              const SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Nom :  ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    kim.firstname,
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Prenom :  ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    kim.lastname,
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Email :  ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    kim.email,
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Phone  :  ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    kim.phone,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.normal),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Container(
                margin: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Text("Button vers l'events"),
                    ),
                    SizedBox(width: 16),
                    Container(
                      child: Text("Button vers le QR code"),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 170),
            ],
          ),
        ),
      ),
    );
  }
}
