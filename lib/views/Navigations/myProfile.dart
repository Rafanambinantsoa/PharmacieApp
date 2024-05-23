import 'dart:convert';
import 'dart:io';

import 'package:MyPharmacie/controllers/UserController.dart';
import 'package:MyPharmacie/model/components/CustomTextField.dart';
import 'package:MyPharmacie/model/components/constant.dart';
import 'package:MyPharmacie/model/registrationRes.dart';
import 'package:MyPharmacie/model/user.dart';
import 'package:MyPharmacie/views/tabv1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class Myprofile extends StatefulWidget {
  const Myprofile({super.key});

  @override
  State<Myprofile> createState() => _MyprofileState();
}

class _MyprofileState extends State<Myprofile> {
  File? _image;

  late User kim = User(
      id: 0,
      firstname: "",
      lastname: "",
      email: "",
      phone: "",
      emailVerifiedAt: "",
      role: "",
      badgeToken: "",
      passwordResetToken: "",
      image: "");
  final TextEditingController _firstcontroller = TextEditingController();
  final TextEditingController _lastcontroller = TextEditingController();
  final TextEditingController _phonecontroller = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final String labelText = "Modifier les informations";

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

  void getUser() async {
    var res = await _usercontroller.getUserInfos();
    if (res == null) return;
    kim = User.fromJson(jsonDecode(res));
    setState(() {
      _emailcontroller.text = kim.email;
      _firstcontroller.text = kim.firstname;
      _lastcontroller.text = kim.lastname;
      _phonecontroller.text = kim.phone;
    });
  }

  Future<void> _getImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    // (source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void UpdateUser() async {
    var res = await _usercontroller.updateUser(
        _firstcontroller.text,
        _lastcontroller.text,
        _phonecontroller.text,
        _emailcontroller.text,
        _image);
    if (res != null) {
      var caster = RegistrationRes.fromJson(jsonDecode(res));

      if (caster.message == "success") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Compte mise a jour success "),
          ),
        );

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const NavigationRailPage()),
            (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(caster.message),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon Profil'), actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            getUser();
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(0.0)),
              ),
              builder: (context) {
                return SingleChildScrollView(
                  child: Container(
                      height: MediaQuery.of(context).size.height * 1.2,
                      width: double.infinity,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 20),
                          const Text(
                            "Modifier les informations",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          // CircleAvatar(
                          //   key: UniqueKey(), // Ajoutez cette ligne
                          //   radius: 50,
                          //   backgroundImage:
                          //       _image == null ? null : FileImage(_image!),
                          // ),
                          SizedBox(height: 20),
                          CustomTextField(
                            controller: _firstcontroller,
                            labelText: "Nom",
                          ),
                          SizedBox(height: 20),
                          CustomTextField(
                            controller: _lastcontroller,
                            labelText: "Prenom",
                          ),
                          SizedBox(height: 20),
                          CustomTextField(
                            controller: _emailcontroller,
                            labelText: "Email",
                          ),
                          SizedBox(height: 20),
                          CustomTextField(
                            controller: _phonecontroller,
                            labelText: "Phone",
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              _getImage();
                            },
                            child: Text('Sélectionner une image'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              UpdateUser();
                            },
                            child: const Text("Modifier"),
                          )
                        ],
                      )),
                );
              },
            );
          },
        )
      ]),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage("$uriImg${kim.image}"),
              ),
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
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.normal),
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
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.normal),
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
