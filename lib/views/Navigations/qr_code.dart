import 'package:MyPharmacie/controllers/UserController.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class MyQrCode extends StatefulWidget {
  const MyQrCode({super.key});

  @override
  State<MyQrCode> createState() => _MyQrCodeState();
}

class _MyQrCodeState extends State<MyQrCode> {
  String token = "nope kim";

  @override
  void initState() {
    showToken();
    super.initState();
  }

  Usercontroller _usercontroller = Usercontroller();
  void showToken() async {
    var vtoken = await _usercontroller.getToken();
    setState(() {
      token = vtoken.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Code"),
      ),
      body: Container(
        margin: EdgeInsets.all(40),
        child: PrettyQrView.data(
          data: token,
        ),
      ),
    );
  }
}
