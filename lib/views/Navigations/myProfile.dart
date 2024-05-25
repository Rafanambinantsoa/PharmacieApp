import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:MyPharmacie/controllers/UserController.dart';
import 'package:MyPharmacie/model/components/CustomTextField.dart';
import 'package:MyPharmacie/model/components/constant.dart';
import 'package:MyPharmacie/model/pointRes.dart';
import 'package:MyPharmacie/model/registrationRes.dart';
import 'package:MyPharmacie/model/user.dart';
import 'package:MyPharmacie/views/login.dart';
import 'package:MyPharmacie/views/tabv1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Myprofile extends StatefulWidget {
  const Myprofile({super.key});

  @override
  State<Myprofile> createState() => _MyprofileState();
}

class _MyprofileState extends State<Myprofile> {
  File? _image;
  String mesPoints = "";

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

  @override
  void initState() {
    getUserDetails();
    getMypoints();
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

  void getMypoints() async {
    var res = await _usercontroller.getPoint();
    if (res == null) return;
    var caster = PointRes.fromJson(jsonDecode(res));
    setState(() {
      mesPoints = caster.points.toString();
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

  void logOut() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print("FIrstrn ${pref.getString("token")}");

    pref.clear();

    print("asdsadad ${pref.getString("token")}");

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false);
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
      appBar: AppBar(
          title: const Text(
            'Mon Profile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                getUser();
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(0.0)),
                  ),
                  builder: (context) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 35, left: 10, right: 10),
                        child: Container(
                            height: MediaQuery.of(context).size.height * 1.2,
                            width: double.infinity,
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 20),
                                Text(
                                  "Modifier les informations".toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
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
                                  labelText: "Telephone",
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
                      ),
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 85,
                    child: CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage("$uriImg${kim.image}"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 1),
                    child: Text(
                      'Mes points  : $mesPoints'.toUpperCase(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                    // color: Colors.grey.shade200,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 8, right: 8, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.person,
                                size: 18,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Nom :  ".toUpperCase(),
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                kim.firstname,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 8, right: 8, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.person,
                                size: 18,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Prenom :  ".toUpperCase(),
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                kim.lastname,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 8, right: 8, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.email,
                                size: 18,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Email :  ".toUpperCase(),
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                kim.email,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 20, left: 8, right: 8, bottom: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.phone,
                                size: 18,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Telephone :  ".toUpperCase(),
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                kim.phone,
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // const SizedBox(height: 10),
              // Container(
              //   margin: const EdgeInsets.all(14),
              //   child: Row(
              //     crossAxisAlignment: CrossAxisAlignment.center,
              //     children: [
              //       Container(
              //         child: Text("Button vers l'events"),
              //       ),
              //       SizedBox(width: 16),
              //       Container(
              //         child: Text("Button vers le QR code"),
              //       )
              //     ],
              //   ),
              // ),
              // const SizedBox(height: 170),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            logOut();
          },
          child: Container(
            child: Icon(Icons.logout),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
