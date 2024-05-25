import 'dart:convert';
import 'dart:io';

import 'package:MyPharmacie/model/components/constant.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';

var client = http.Client();

class Usercontroller {
//get points

  Future getUserId() async {
    var url = Uri.parse("$baseUrl/user");
    String token = await getToken();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var response = await client.get(
      url,
      headers: headers,
    );
    if (response.statusCode == 200) {
      var content = json.decode(response.body);
      return content['id'].toString();
    }
  }

  Future getBadgeToken() async {
    var url = Uri.parse("$baseUrl/user");
    String token = await getToken();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var response = await client.get(
      url,
      headers: headers,
    );
    if (response.statusCode == 200) {
      var content = json.decode(response.body);
      return content['badgeToken'].toString();
    }
  }

  //Get user details
  Future<dynamic> getPoint() async {
    var id = await getUserId();
    var url = Uri.parse("$baseUrl/user/sumpoint/$id");
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
      return response.body;
      //throw exception and catch it in UI
    }
  }

  Future<dynamic> updateUser(String firstname, String lastname, String phone,
      String email, File? image) async {
    var userId = await getUserId();
    var token = await getToken();
    var url = Uri.parse('$baseUrl/mobile/user/update/$userId');
    // Création de la requête multipart
    var request = http.MultipartRequest('POST', url);

    request.headers['Authorization'] = 'Bearer $token';

    // Ajout des champs de texte
    request.fields['firstname'] = firstname;
    request.fields['lastname'] = lastname;
    request.fields['phone'] = phone;
    request.fields['email'] = email;

    if (image != null) {
      // Déterminer le type MIME de l'image
      final mimeTypeData =
          lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])?.split('/');

      // Ajouter le fichier image à la requête
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        image.path,
        contentType: mimeTypeData != null && mimeTypeData.length == 2
            ? MediaType(mimeTypeData[0], mimeTypeData[1])
            : null,
      ));
      // Envoi de la requête
      try {
        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          return response.body; // ou autre traitement de réponse réussi
        } else {
          return response.body; // ou autre traitement de réponse réussi
        }
      } catch (e) {
        return {
          'error': true,
          'message': 'Une erreur est survenue. Veuillez réessayer plus tard.'
        };
      }
    } else {
      var headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };

      var response = await client.post(url,
          headers: headers,
          body: jsonEncode({
            'firstname': firstname,
            'lastname': lastname,
            'phone': phone,
            'email': email,
          }));
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return response.body;
      }
    }
  }

  Future<dynamic> register(String firstname, String lastname, String phone,
      String email, String pass, File? image) async {
    var url = Uri.parse('$baseUrl/registration');
    // Création de la requête multipart
    var request = http.MultipartRequest('POST', url);

    // Ajout des champs de texte
    request.fields['firstname'] = firstname;
    request.fields['lastname'] = lastname;
    request.fields['phone'] = phone;
    request.fields['email'] = email;
    request.fields['password'] = pass;

    if (image != null) {
      // Déterminer le type MIME de l'image
      final mimeTypeData =
          lookupMimeType(image.path, headerBytes: [0xFF, 0xD8])?.split('/');

      // Ajouter le fichier image à la requête
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        image.path,
        contentType: mimeTypeData != null && mimeTypeData.length == 2
            ? MediaType(mimeTypeData[0], mimeTypeData[1])
            : null,
      ));
    }

    // Envoi de la requête
    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return response.body; // ou autre traitement de réponse réussi
      } else {
        return response.body; // ou autre traitement de réponse réussi
      }
    } catch (e) {
      return {
        'error': true,
        'message': 'Une erreur est survenue. Veuillez réessayer plus tard.'
      };
    }
  }

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
      return response.body;
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
