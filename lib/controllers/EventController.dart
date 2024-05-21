import 'dart:convert';

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
        print("HEY HEY");
        //clear the list before adding new items
        events.value.clear();
        isLoading.value = false;
        final content = json.decode(response.body);

        for (var items in content) {
          events.value.add(Events.fromJson(items));
        }
        print(content);
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
