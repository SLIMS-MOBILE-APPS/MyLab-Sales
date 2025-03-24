import 'dart:async';
import 'dart:convert';
import 'allbottomnavigationbar.dart';
import 'globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:http/http.dart' as http;

List<Map<String, dynamic>> dataList = [];

class FlagDataPage extends StatefulWidget {
  @override
  _FlagDataPageState createState() => _FlagDataPageState();
}

class _FlagDataPageState extends State<FlagDataPage> {
  // Map to store data against each flag
  @override
  void initState() {
    super.initState();
    handleButtonClick(globals.Glb_SelectedDate);
  }

  Future<void> Business_Hourls_Data(BuildContext context) async {
    Map<String, dynamic> data = {
      "employee_id":
          globals.new_selectedEmpid == "" || globals.new_selectedEmpid == "null"
              ? globals.loginEmpid
              : globals.new_selectedEmpid,
      "session_id": globals.Glb_Method == "Payments"
          ? globals.glb_session_id
          : globals.Glb_Hours_session_id,
      "from_dt": globals.Glb_SelectedDate,
      "to_dt": globals.Glb_SelectedDate,
      "connection": globals.Connection_Flag,
    };

    print("Request data: $data");

    final response = await http.post(
      Uri.parse(globals.API_url + '/MobileSales/ManagerEmpDetails'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: data,
      encoding: Encoding.getByName("utf-8"),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);
      if (resposne["message"] == "sucess") {
        for (var item in resposne["Data"]) {
          dataList.add({
            "BILL_AMOUNT": item["BILL_AMOUNT"] ?? 0,
            "BILL_DT": item["BILL_DT"] ?? "",
            "CNT": int.tryParse(item["CNT"].toString()) ?? 0,
            "HOURSE": item["HOURSE"] ?? 0,
          });
        }
        print("Data added to list: $dataList");
      } else {
        print("Failed to retrieve data: ${resposne["message"]}");
      }
    } else {
      print("Request failed with status: ${response.statusCode}");
    }
    handleButtonClick(globals.Glb_SelectedDate);
  }

  @override
  void handleButtonClick(String flag) async {
    // Iterate over the list to find if any map contains the flag
    var matchingItem = dataList
        .where((item) =>
            item['BILL_DT'] != null &&
            item['BILL_DT']!.toLowerCase().contains(flag.toLowerCase()))
        .toList();

    if (matchingItem.isNotEmpty) {
      // If a matching item is found, use it
      setState(() {
        _currentData = matchingItem;
      });
    } else {
      Business_Hourls_Data(context);
      print("No match found for flag: $flag");
    }
  }

  dynamic _currentData;

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text('Flag Data Example')),
      body: Column(
        children: [
          globals.new_selectedEmpid == "" || globals.new_selectedEmpid == "null"
              ? Container(
                  height: screenHeight * 0.15,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 8.0, bottom: 8.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 30,
                              child: Icon(
                                Icons.account_box,
                                size: 25,
                                color: Color.fromARGB(255, 107, 114,
                                    151), // Replace Colors.blue with any color you prefer
                              ),
                            ),
                            Text(
                              globals.glb_EMPLOYEE_NAME,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Text(
                              globals.Glb_DESIGNATION_NAME,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 10)
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Container(
                  height: screenHeight * 0.15,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 8.0, bottom: 8.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 30,
                              child: Icon(
                                Icons.account_box,
                                size: 25,
                                color: Color.fromARGB(255, 107, 114,
                                    151), // Replace Colors.blue with any color you prefer
                              ),
                            ),
                            Text(
                              globals.Glb_empname,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Text(
                              globals.Employee_Code,
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                height: screenHeight * 0.04,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 3,
                    ),
                    Text(globals.Glb_SelectedDate,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 41, 11, 209),
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0)),
                    Spacer(),
                    Text(globals.Glb_BILL_AMOUNT,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 41, 11, 209),
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0)),
                    SizedBox(
                      width: 3,
                    ),
                  ],
                )),
          ),
          _currentData != "null"
              ? Expanded(
                  // Wrap ListView.builder with Expanded
                  child: ListView.builder(
                    itemCount: _currentData?.length ?? 0,
                    itemBuilder: (context, index) {
                      final item = _currentData[index];
                      final BILL_AMOUNT = item['BILL_AMOUNT'];
                      final BILL_DT = item['BILL_DT'];
                      final CNT = item['CNT'];
                      final HOURSE = item['HOURSE'];

                      return InkWell(
                          onTap: () {
                            // Define onTap action here if needed
                          },
                          child: Container(
                            padding: EdgeInsets.all(
                                12), // Add padding for better spacing
                            decoration: BoxDecoration(
                              color: Colors.white, // Background color
                              borderRadius:
                                  BorderRadius.circular(10), // Rounded corners
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.watch_later_outlined, // Date icon
                                        color: Colors.blueAccent, // Icon color
                                      ),
                                      SizedBox(
                                          width:
                                              8), // Space between icon and text
                                      Text(
                                        HOURSE.toString(), // Format the date
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Spacer(), // Push the amount to the right
                                      Text(
                                        BILL_AMOUNT
                                            .toString(), // Format the amount with 2 decimal places
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: CNT.toString() == "0"
                                                ? Colors.red
                                                : CNT.toString() == "1"
                                                    ? Colors.green
                                                    : Color.fromARGB(
                                                        255, 10, 10, 129)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ));
                    },
                  ),
                )
              : Center(
                  child:
                      CircularProgressIndicator(), // Show loader if the list is empty
                )
        ],
      ),
      bottomNavigationBar: const AllbottomNavigation(),
    );
  }
}
