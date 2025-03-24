import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';

// import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'allbottomnavigationbar.dart';
import 'business_new.dart';
import 'globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:http/http.dart' as http;

List<Map<String, dynamic>> dataList = [];

class business_paymentsByHours extends StatefulWidget {
  int selectedIndex;

  business_paymentsByHours({super.key, required this.selectedIndex});

  @override
  _business_paymentsByHoursState createState() =>
      _business_paymentsByHoursState();
}

class _business_paymentsByHoursState extends State<business_paymentsByHours> {
  var selecteTodayDt = '';

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    handleButtonClick(globals.Glb_SelectedDate + '-' + globals.Glb_Method);
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
            "FLAG": item["BILL_DT"].split(' ')[0].toString() +
                '-' +
                globals.Glb_Method.toString(),
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
    handleButtonClick(globals.Glb_SelectedDate + '-' + globals.Glb_Method);
  }

  void handleButtonClick(String flag) async {
    // Iterate over the list to find if any map contains the flag
    var matchingItem = dataList
        .where((item) =>
            item['FLAG'] != null &&
            item['FLAG']!.toLowerCase().contains(flag.toLowerCase()))
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

    return WillPopScope(
      onWillPop: () async {
        // Returning false prevents the back button action.
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xff123456),
          title: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_sharp),
                onPressed: () {
                  globals.Class_refresh == "";
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => businesss(
                              selectedIndex: 0,
                            )),
                  );
                },
              ),
              Text(globals.Glb_Method),
              Spacer(),
            ],
          ),
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            dataList.clear();
            _currentData.clear();

            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => business_paymentsByHours(
                        selectedIndex: 0,
                      )),
            );
          },
          child: Column(
            children: [
              globals.new_selectedEmpid == "" ||
                      globals.new_selectedEmpid == "null"
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
                                    color: Color.fromARGB(255, 107, 114, 151),
                                  ),
                                ),
                                Text(
                                  globals.glb_EMPLOYEE_NAME,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                Text(
                                  globals.Glb_DESIGNATION_NAME,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
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
                                    color: Color.fromARGB(255, 107, 114, 151),
                                  ),
                                ),
                                Text(
                                  globals.Glb_empname,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                                Text(
                                  globals.Employee_Code,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
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
                        SizedBox(width: 3),
                        Text(
                          globals.Glb_SelectedDate,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 41, 11, 209),
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                        Spacer(),
                        Text(
                          globals.Glb_BILL_AMOUNT,
                          style: const TextStyle(
                              color: Color.fromARGB(255, 41, 11, 209),
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        ),
                        SizedBox(width: 3),
                      ],
                    )),
              ),
              _currentData != null && _currentData != "0"
                  ? Column(
                      children: [
                        Container(
                          height: screenHeight * 0.6,
                          child: ListView.builder(
                            shrinkWrap:
                                true, // Allow ListView to take only as much space as needed

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
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.3),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.watch_later_outlined,
                                              color: Colors.blueAccent,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              HOURSE.toString(),
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Spacer(),
                                            Text(
                                              BILL_AMOUNT.toString(),
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: CNT.toString() == "0"
                                                    ? Colors.red
                                                    : CNT.toString() == "1"
                                                        ? Colors.green
                                                        : Color.fromARGB(
                                                            255, 10, 10, 129),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 200.0),
                      child: Center(
                        child:
                            CircularProgressIndicator(), // Show loader if the list is empty
                      ),
                    ),
            ],
          ),
        ),
        bottomNavigationBar: const AllbottomNavigation(),
      ),
    );
  }
}

class ManagerDetails {
  final BILL_AMOUNT;
  final BILL_DT;
  final CNT;
  final HOURSE;
  ManagerDetails({
    required this.BILL_AMOUNT,
    required this.BILL_DT,
    required this.CNT,
    required this.HOURSE,
  });
  factory ManagerDetails.fromJson(Map<String, dynamic> json) {
    return ManagerDetails(
      BILL_AMOUNT: json['BILL_AMOUNT'].toString(),
      BILL_DT: json['BILL_DT'].toString(),
      CNT: json['CNT'].toString(),
      HOURSE: json['HOURSE'].toString(),
    );
  }
}

class NoContent extends StatelessWidget {
  const NoContent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.verified_rounded,
              color: Colors.red,
              size: 50,
            ),
            const Text('No Data Found'),
          ],
        ),
      ),
    );
  }
}
