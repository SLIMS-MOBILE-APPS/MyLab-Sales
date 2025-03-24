import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/RevenueModels.dart';
import '../../globals.dart' as globals;

class RevenueDataController {
  static Future<RevenueData> fetchRevenueData(DateTime fromDate,
      DateTime toDate, int? selectedLocationId, String flag) async {
    final jobsListAPIUrl =
        Uri.parse(globals.API_url + '/MobileSales/GET_REVENUE_DATA_MOBILE');

    final Map<String, String> data = {
      "IP_LOCATION_ID": selectedLocationId.toString(),
      "IP_USER_ID": globals.USER_ID,
      "IP_FROM_DT": "${fromDate.year}-${fromDate.month}-${fromDate.day}",
      "IP_TO_DT": "${toDate.year}-${toDate.month}-${toDate.day}",
      "IP_SESSION_ID": "1",
      "IP_FLAG": flag, // Pass the flag parameter here
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

        // Ensure that "Data" is a list
        if (jsonData["Data"] is List) {
          // Assuming you want the first item from the list
          final dynamic data = jsonData["Data"][0];
          return RevenueData.fromJson(data);
        } else {
          throw Exception('Failed to fetch data: "Data" is not a list');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<List<ChannelDepartmentData>> fetchChannelDepartmentWiseData(
      DateTime fromDate,
      DateTime toDate,
      int? selectedLocationId,
      String flag) async {
    final jobsListAPIUrl =
        Uri.parse(globals.API_url + '/MobileSales/GET_REVENUE_DATA_MOBILE');

    final Map<String, String> data = {
      "IP_LOCATION_ID": selectedLocationId.toString(),
      "IP_USER_ID": globals.USER_ID,
      "IP_FROM_DT": "${fromDate.year}-${fromDate.month}-${fromDate.day}",
      "IP_TO_DT": "${toDate.year}-${toDate.month}-${toDate.day}",
      "IP_SESSION_ID": "1",
      "IP_FLAG": flag, // Pass the flag parameter here
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
        List<dynamic> dataList = jsonData['Data'];
        List<ChannelDepartmentData> ChannelDepartment = dataList
            .map((json) => ChannelDepartmentData.fromJson(json))
            .toList();
        return ChannelDepartment;
      } else {
        throw Exception('Failed to fetch data: "Data" is not a list');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
