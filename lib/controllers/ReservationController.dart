import 'dart:async';
import 'dart:convert';

import 'package:MyPharmacie/controllers/UserController.dart';
import 'package:MyPharmacie/model/listReservation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = 'http://192.168.43.220:8000/api';

class ReservationController extends GetxController {
  Rx<List<ListReservation>> listRes = Rx<List<ListReservation>>([]);
  final isLoading = true.obs;

  Future getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('token') ?? '';
  }

  //get user email
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

  //annuler ma reservation
  Future<dynamic> cancelRes(String eventId) async {
    String userId = await getUserId();
    String token = await getToken();
    var url = Uri.parse("$baseUrl/mobile/events/$eventId/annuler/$userId");
    var _headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    var response = await client.delete(url,
        headers: _headers); //send request to the server
    if (response.statusCode == 200) {
      return response.body;
    }
    if (response.statusCode == 403) {
      return response.body;
    } else {
      return response.body;
    }
  }

  Future getMyRes() async {
    try {
      String id = await getUserId();
      String token = await getToken();
      isLoading.value = true;
      var response = await http.get(Uri.parse('$baseUrl/reservation/user/$id'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });

      if (response.statusCode == 200) {
        print("HEY HEY");
        //clear the list before adding new items
        listRes.value.clear();
        isLoading.value = false;
        final content = json.decode(response.body);

        for (var items in content) {
          listRes.value.add(ListReservation.fromJson(items));
        }
        print(content);
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
