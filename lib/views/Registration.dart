import 'dart:convert';
import 'dart:io';

import 'package:MyPharmacie/controllers/UserController.dart';
import 'package:MyPharmacie/model/components/CustomTextField.dart';
import 'package:MyPharmacie/model/loginRes.dart';
import 'package:MyPharmacie/model/registrationRes.dart';
import 'package:MyPharmacie/views/login.dart';
import 'package:MyPharmacie/views/tabv1.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
//Initialise  le variable de l'image
  File? _image;

  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _lastController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

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

  void handleRegistration() async {
    Usercontroller _usercontroller = Usercontroller();
    if (_emailController.text != "" &&
        _passController.text != "" &&
        _firstController.text != "" &&
        _lastController.text != "" &&
        _phoneController.text != "" &&
        _image != null) {
      var response = await _usercontroller
          .register(
              _firstController.text,
              _lastController.text,
              _phoneController.text,
              _emailController.text,
              _passController.text,
              _image)
          .catchError((err) {});

      if (response == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verifie ta connexion Internet'),
          ),
        );
      } else {
        print(response);
        var caster = RegistrationRes.fromJson(jsonDecode(response));
        if (caster.message == "success") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Compte créé avec succès"),
            ),
          );

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(caster.message),
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Complete all the champs '),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                textDirection: TextDirection.ltr,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Registration',
                    style: TextStyle(
                      color: Color(0xFF755DC1),
                      fontSize: 27,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                      controller: _firstController, labelText: "First Name"),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomTextField(
                      controller: _lastController, labelText: "Last Name"),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomTextField(
                      controller: _phoneController, labelText: "Phone"),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomTextField(
                      controller: _emailController, labelText: "Email"),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomTextField(
                      controller: _passController, labelText: "Password"),
                  const SizedBox(
                    height: 25,
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _image == null
                            ? Text('Pas d\'image sélectionnée')
                            : Image.file(_image!, height: 200.0),
                        ElevatedButton(
                          onPressed: _getImage,
                          child: Text('Sélectionner une image'),
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: SizedBox(
                      width: 329,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          handleRegistration();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9F7BFF),
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      const Text(
                        'Don’t have an account?',
                        style: TextStyle(
                          color: Color(0xFF837E93),
                          fontSize: 13,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        width: 2.5,
                      ),
                      InkWell(
                        onTap: () {
                          handleRegistration();
                        },
                        child: const Text(
                          'Se connecter',
                          style: TextStyle(
                            color: Color(0xFF755DC1),
                            fontSize: 13,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Forget Password?',
                    style: TextStyle(
                      color: Color(0xFF755DC1),
                      fontSize: 13,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
