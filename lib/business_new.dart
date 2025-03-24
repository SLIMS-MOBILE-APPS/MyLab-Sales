import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'Sales_Dashboard.dart';
import 'allbottomnavigationbar.dart';
import 'business_paymentsByHours.dart';
import 'dummy_screen.dart';
import 'globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:http/http.dart' as http;

List<Map<String, String>> Dip_Pay_filteredItems = [];
List<Map<String, String>> Dip_Pay_allItems = [];
List<Map<String, String>> Dip_Pay_selectedItems = [];

class businesss extends StatefulWidget {
  int selectedIndex;

  businesss({super.key, required this.selectedIndex});

  @override
  _businesssState createState() => _businesssState();
}

class _businesssState extends State<businesss> {
  var selecteFromdt = '';
  var selecteTodt = '';

  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    final DateFormat formatter1 = DateFormat('dd-MMM-yyyy');
    DateTime today = DateTime.now();
    DateTime last30Days = today.subtract(Duration(days: 30));

    var now = DateTime.now();
    if (globals.fromDate != "") {
      selecteFromdt = globals.fromDate;
      selecteTodt = globals.ToDate;
    } else if (selecteTodt == '') {
      selecteFromdt = formatter1.format(last30Days);
      selecteTodt = formatter1.format(today);
    }
    var Variable_Date = "$selecteFromdt To $selecteTodt";
    // globals.Glb_Deposit_Last_Month_DB_Avble == "true" + globals.Glb_Method
    //     ?
    Dip_Pay_filterSearchResults(Variable_Date + '-' + globals.Glb_Method);
    //     : Business_Data(context);
    // globals.Glb_Deposit_Last_Month_DB_Avble = "true" + globals.Glb_Method;
  }

  void Dip_Pay_filterSearchResults(String query) {
    List<Map<String, String>> Dip_Pay_dummyList = [];

    if (query.isNotEmpty) {
      // Filter items by checking if 'PRODUCT_NAME' contains the query
      Dip_Pay_dummyList = Dip_Pay_allItems.where((item) =>
          item['SELECTED_FLAG'] != null &&
          item['SELECTED_FLAG']!
              .toLowerCase()
              .contains(query.toLowerCase())).toList();

      setState(() {
        // Clear the filteredItems list and update it with filtered results
        Dip_Pay_filteredItems.clear();
        Dip_Pay_dummyList.forEach((item) {
          Dip_Pay_filteredItems.add({
            'BILL_AMOUNT': item['BILL_AMOUNT'].toString(),
            'BILL_DT': item['BILL_DT'].toString(),
            'CNT': item['CNT'].toString(),
            'SELECTED_FLAG': item['SELECTED_FLAG'].toString(),
          });
        });

        if (Dip_Pay_filteredItems.isNotEmpty) {
          // If a matching item is found, use it
          setState(() {
            Dip_Pay_filteredItems;
          });
        } else {
          Business_Data(context);
        }
      });
    } else {
      setState(() {
        Dip_Pay_filteredItems.clear();
      });
    }
  }

  void selectItem(Map<String, String> selectedItem) {
    setState(() {
      // Check if the selected item is not already in the list
      if (!Dip_Pay_selectedItems.contains(selectedItem)) {
        Dip_Pay_selectedItems.add(
            selectedItem); // Add the map directly to the list
      }
      Dip_Pay_filteredItems
          .clear(); // Clear the filtered list after selection (if that's what you intend)
    });
  }

  Business_Data(BuildContext context) async {
    var Variable_Date = "$selecteFromdt To $selecteTodt";
    Map data = {
      "employee_id":
          globals.new_selectedEmpid == "" || globals.new_selectedEmpid == "null"
              ? globals.loginEmpid
              : globals.new_selectedEmpid,
      "session_id": globals.glb_session_id,
      "from_dt": selecteFromdt == ""
          ? "${selectedDate.toLocal()}".split(' ')[0]
          : selecteFromdt,
      "to_dt": selecteTodt == ""
          ? "${selectedDate.toLocal()}".split(' ')[0]
          : selecteTodt,
      "connection": globals.Connection_Flag
    };
    print(data.toString());
    final response = await http.post(
        Uri.parse(globals.API_url + '/MobileSales/ManagerEmpDetails'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);
      if (resposne["message"] == "sucess") {
        List<dynamic> results = resposne["Data"];
        // allItems.clear();
        results.forEach((item) {
          Dip_Pay_allItems.add({
            'BILL_AMOUNT': (item['BILL_AMOUNT'] ?? "0").toString(),
            'BILL_DT': (item['BILL_DT'] ?? "0").toString(),
            'CNT': (item['CNT'] ?? "0").toString(),
            'SELECTED_FLAG': item['SELECTED_FLAG'].toString() +
                '-' +
                globals.Glb_Method.toString(),
          });
        });

        Dip_Pay_filterSearchResults(Variable_Date + '-' + globals.Glb_Method);
      }
    }
  }

  @override
//Date Selection...........................................
  Widget _buildDatesCard(data, index) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextButton(
        child: Text(
          data["Frequency"],
          style: const TextStyle(fontSize: 12.0),
        ),
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              // side: BorderSide(color: Colors.red)
            )),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            overlayColor:
                MaterialStateColor.resolveWith((states) => Colors.red),
            backgroundColor: widget.selectedIndex == index &&
                    globals.fromDate == ''
                ? MaterialStateColor.resolveWith((states) => Colors.pink)
                : MaterialStateColor.resolveWith((states) => Colors.blueGrey),
            shadowColor:
                MaterialStateColor.resolveWith((states) => Colors.blueGrey),
            foregroundColor:
                MaterialStateColor.resolveWith((states) => Colors.white)),
        onPressed: () {
          print(index.toString());
          setState(() {
            // globals.selectDate = '';
            globals.fromDate = '';
            globals.ToDate = '';
            widget.selectedIndex = index;
            final DateFormat formatter = DateFormat('dd-MMM-yyyy');
            var now = DateTime.now();
            var yesterday = now.subtract(const Duration(days: 1));
            //   var lastweek = now.subtract(const Duration(days: 7));

            var thisweek = now.subtract(Duration(days: now.weekday - 1));
            var lastWeek1stDay =
                thisweek.subtract(Duration(days: thisweek.weekday + 6));
            var lastWeekLastDay =
                thisweek.subtract(Duration(days: thisweek.weekday - 0));
            var thismonth = DateTime(now.year, now.month, 1);

            var Last30days = DateTime.now().subtract(Duration(days: 30));
            var prevMonthLastday = DateTime.utc(
              DateTime.now().year,
              DateTime.now().month - 0,
            ).subtract(Duration(days: 1));

            if (widget.selectedIndex == 0) {
              final DateFormat formatter1 = DateFormat('dd-MMM-yyyy');
              DateTime today = DateTime.now();
              DateTime last30Days = today.subtract(Duration(days: 30));
              selecteFromdt = formatter1.format(last30Days);
              selecteTodt = formatter1.format(today);
              var Variable_Date = "$selecteFromdt To $selecteTodt";
              // globals.Glb_Deposit_Last_Month_DB_Avble ==
              //         "true" + globals.Glb_Method
              //     ?

              Dip_Pay_filterSearchResults(
                  Variable_Date + '-' + globals.Glb_Method);
              //     : Business_Data(context);
              // globals.Glb_Deposit_Last_Month_DB_Avble =
              //     "true" + globals.Glb_Method;
            } else if (widget.selectedIndex == 1) {
              selecteFromdt = formatter.format(now);
              selecteTodt = formatter.format(now);

              var Variable_Date = "$selecteFromdt To $selecteTodt";
              // globals.Glb_Deposit_Today_DB_Avble == "true" + globals.Glb_Method
              //     ?
              Dip_Pay_filterSearchResults(
                  Variable_Date + '-' + globals.Glb_Method);
              //     : Business_Data(context);
              // globals.Glb_Deposit_Today_DB_Avble = "true" + globals.Glb_Method;
            } else if (widget.selectedIndex == 2) {
              selecteFromdt = formatter.format(thismonth);
              selecteTodt = formatter.format(now);

              var Variable_Date = "$selecteFromdt To $selecteTodt";
              // globals.Glb_Deposit_This_Month_DB_Avble ==
              //         "true" + globals.Glb_Method
              //     ?
              Dip_Pay_filterSearchResults(
                  Variable_Date + '-' + globals.Glb_Method);
              //     : Business_Data(context);
              // globals.Glb_Deposit_This_Month_DB_Avble =
              //     "true" + globals.Glb_Method;
            }

            print("From Date " + selecteFromdt);
            print("To Date " + selecteTodt);
            print(widget.selectedIndex);
          });
        },
        onLongPress: () {
          print('Long press');
        },
      ),
    );
  }

  ListView datesListView() {
    var myData = [
      {
        "FrequencyId": "1",
        "Frequency": "Last 30 Days",
      },
      {
        "FrequencyId": "2",
        "Frequency": "Today",
      },
      {
        "FrequencyId": "3",
        "Frequency": "This Month",
      },
    ];

    return ListView.builder(
        itemCount: myData.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          // return  Text(myData[index]["Frequency"].toString());
          return _buildDatesCard(myData[index], index);
        });
  }

  Widget DateSelection() {
    return Container(child: datesListView());
  }

  DateTime pastMonth = DateTime.now().subtract(Duration(days: 30));
  _CenterWiseBusinessDate(BuildContext context) async {
    final DateTimeRange? selected = await showDateRangePicker(
      context: context,
      // initialDate: selectedDate,
      firstDate: pastMonth,
      lastDate: DateTime(DateTime.now().year + 1),
      saveText: 'Done',
    );
    // if (selected != null && selected != selectedDate) {
    setState(() {
      globals.fromDate = selected!.start.toString().split(' ')[0];
      globals.ToDate = selected.end.toString().split(' ')[0];
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

//Date Selection...........................................

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter1 = DateFormat('dd-MMM-yyyy');
    DateTime today = DateTime.now();
    DateTime last30Days = today.subtract(Duration(days: 30));
    var now = DateTime.now();
    if (globals.fromDate != "") {
      selecteFromdt = globals.fromDate;
      selecteTodt = globals.ToDate;
    } else if (selecteTodt == '') {
      selecteFromdt = formatter1.format(last30Days);
      selecteTodt = formatter1.format(today);
    }

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
                        builder: (context) => SalesManagerDashboard()),
                  );
                },
              ),
              Text(globals.Glb_Method)
            ],
          ),
        ),
        body: RefreshIndicator(
            onRefresh: () async {
              Dip_Pay_filteredItems = [];
              Dip_Pay_allItems = [];
              Dip_Pay_selectedItems = [];

              globals.Glb_Deposit_Today_DB_Avble = "";
              globals.Glb_Deposit_Last_Month_DB_Avble = "";
              globals.Glb_Deposit_This_Month_DB_Avble = "";
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => businesss(
                          selectedIndex: 0,
                        )),
              );

              // final DateFormat formatter1 = DateFormat('dd-MMM-yyyy');
              // DateTime today = DateTime.now();
              // DateTime last30Days = today.subtract(Duration(days: 30));

              // var now = DateTime.now();
              // if (globals.fromDate != "") {
              //   selecteFromdt = globals.fromDate;
              //   selecteTodt = globals.ToDate;
              // } else if (selecteTodt == '') {
              //   selecteFromdt = formatter1.format(last30Days);
              //   selecteTodt = formatter1.format(today);
              // }
              // Business_Data(context);
            },
            child: Center(
                child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 25.0,
                  ),
                  child: SizedBox(
                      height: screenHeight * 0.07, child: DateSelection()),
                ),
                SizedBox(
                    height: screenHeight * 0.02,
                    child: Text(selecteFromdt + '  To   ' + selecteTodt,
                        style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0))),
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
                                      color: Color.fromARGB(255, 107, 114,
                                          151), // Replace Colors.blue with any color you prefer
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
                                      color: Color.fromARGB(255, 107, 114,
                                          151), // Replace Colors.blue with any color you prefer
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
                Dip_Pay_filteredItems.isNotEmpty
                    ? Container(
                        height: screenHeight * 0.58,
                        child: ListView.builder(
                            itemCount: Dip_Pay_filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = Dip_Pay_filteredItems[index];
                              // Extract all necessary fields as before
                              final BILL_AMOUNT = item['BILL_AMOUNT'];
                              final BILL_DT = item['BILL_DT'];
                              final CNT = item['CNT'];
                              final SELECTED_FLAG = item['SELECTED_FLAG'];

                              return Container(
                                padding: EdgeInsets.all(
                                    12), // Add padding for better spacing
                                decoration: BoxDecoration(
                                  color: Colors.white, // Background color
                                  borderRadius: BorderRadius.circular(
                                      10), // Rounded corners
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
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8.0),
                                  child: InkWell(
                                    onTap: () {
                                      globals.Glb_BILL_AMOUNT =
                                          BILL_AMOUNT.toString();
                                      globals.Glb_SelectedDate =
                                          BILL_DT.toString();
                                      globals.Glb_Method == "Business"
                                          ? globals.Glb_Hours_session_id = "7"
                                          : globals.Glb_Method == "Payments"
                                              ? globals.glb_session_id = "8"
                                              : null;
                                      globals.Glb_Method == "Business" ||
                                              globals.Glb_Method == "Payments"
                                          ? Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      business_paymentsByHours(
                                                        selectedIndex: 1,
                                                      )),
                                            )

                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (context) =>
                                          //             FlagDataPage()),
                                          //   )
                                          : null;
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.calendar_today, // Date icon
                                          color:
                                              Colors.blueAccent, // Icon color
                                        ),
                                        SizedBox(
                                            width:
                                                8), // Space between icon and text
                                        Text(
                                          BILL_DT.toString(), // Format the date
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
                                                          255,
                                                          10,
                                                          10,
                                                          129) // Color for the amount
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 150.0),
                        child: Center(
                          child:
                              CircularProgressIndicator(), // Show loader if the list is empty
                        ),
                      ),
              ],
            ))),
        bottomNavigationBar: const AllbottomNavigation(),
      ),
    );
  }
}

class ManagerDetails {
  final BILL_AMOUNT;
  final BILL_DT;
  final CNT;
  final SELECTED_FLAG;
  ManagerDetails({
    required this.BILL_AMOUNT,
    required this.BILL_DT,
    required this.CNT,
    required this.SELECTED_FLAG,
  });
  factory ManagerDetails.fromJson(Map<String, dynamic> json) {
    return ManagerDetails(
      BILL_AMOUNT: json['BILL_AMOUNT'].toString(),
      BILL_DT: json['BILL_DT'].toString(),
      CNT: json['CNT'].toString(),
      SELECTED_FLAG: json['SELECTED_FLAG'].toString(),
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
