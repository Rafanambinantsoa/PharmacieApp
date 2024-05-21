import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = 'http://192.168.43.220:8000/api';
var client = http.Client();

class Usercontroller {
//Login
  Future<dynamic> login(String api, String email, String pass) async {
    var url = Uri.parse(baseUrl + api);
    var _headers = {
      'Content-Type': 'application/json',
    };

    var response = await client.post(url,
        headers: _headers,
        body: jsonEncode({
          'email': email,
          'password': pass,
        }));
    if (response.statusCode == 200) {
      return response.body;
    }
    if (response.statusCode == 403) {
      return response.body;
    } else {
      //throw exception and catch it in UI
    }
  }

//get token
  Future<String> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('token') ?? '';
  }

//Get user details
  Future<dynamic> getUserInfos() async {
    var url = Uri.parse("$baseUrl/user");
    String token = await getToken();
    var _headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var response = await client.get(
      url,
      headers: _headers,
    );
    if (response.statusCode == 200) {
      return response.body;
    }
    if (response.statusCode == 403) {
      return response.body;
    } else {
      //throw exception and catch it in UI
    }
  }
}
