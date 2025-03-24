import 'dart:convert';

import 'package:http/http.dart' as http;

import '../Models/LocatioDropdownModels.dart';
import 'package:salesapp/globals.dart' as globals;

class DropdownController {
  static Future<List<LocationDropdownOption>>
      fetchLocationDropdownOptions() async {
    final jobsListAPIUrl =
        Uri.parse(globals.API_url + '/PatinetMobileApp/Location_list');

    final Map<String, String> data = {
      "IP_SESSION_ID": "1",
      "connection": globals.Connection_Flag,
    };

    try {
      final response = await http.post(
        jobsListAPIUrl,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: data,
        encoding: Encoding.getByName("utf-8"),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        List<LocationDropdownOption> locations = (jsonData['Data'] as List)
            .map((item) => LocationDropdownOption.fromJson(item))
            .toList();
        return locations;
      } else {
        throw Exception('Failed to load state dropdown options');
      }
    } catch (e) {
      throw Exception('Failed to load state dropdown options: $e');
    }
  }
}
