import 'dart:convert';

import 'package:MyPharmacie/controllers/UserController.dart';
import 'package:MyPharmacie/model/event.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = 'http://192.168.43.220:8000/api';

class EventController extends GetxController {
  Rx<List<Events>> events = Rx<List<Events>>([]);

  final isLoading = true.obs;

  //get token
  Future<String> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('token') ?? '';
  }

  //get userEmail
  Future<String> getUserEmail() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('email') ?? '';
  }

  Future reservation(String eventId) async {
    var url = Uri.parse("$baseUrl/reservation/add/$eventId");
    var _headers = {
      'Content-Type': 'application/json',
    };

    String email = await getUserEmail();
    var response = await client.post(url,
        headers: _headers,
        body: jsonEncode({
          'email': email,
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

//get events
  Future getEvents() async {
    try {
      String token = await getToken();
      isLoading.value = true;
      var response = await http.get(Uri.parse(baseUrl + '/mobile/events'),
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'
          });

      if (response.statusCode == 200) {
        //clear the list before adding new items
        events.value.clear();
        isLoading.value = false;
        final content = json.decode(response.body);

        for (var items in content) {
          events.value.add(Events.fromJson(items));
        }
        // print(content);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
