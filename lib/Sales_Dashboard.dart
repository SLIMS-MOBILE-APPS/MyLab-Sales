import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:salesapp/report.dart';
// import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'ReportsPopupWidgets.dart';
import 'add_company.dart';
import 'allbottomnavigationbar.dart';
import 'dart:convert';
import 'allinone.dart';
import 'business_new.dart';
import 'clients_search.dart';
import 'dummy_screen.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'total_business.dart';

class SalesManagerDashboard extends StatefulWidget {
  @override
  _SalesManagerDashboardState createState() => _SalesManagerDashboardState();
}

final TextEditingController _searchController = TextEditingController();
TextEditingController _Mobile_NoController = TextEditingController();
TextEditingController _billnoController = TextEditingController();

class _SalesManagerDashboardState extends State<SalesManagerDashboard> {
  // Sample list of dashboard items with colors similar to PhonePe

  List<Map<String, String>> filteredItems = [];
  List<Map<String, String>> allItems = [];
  List<Map<String, String>> selectedItems = [];
  List<Map<String, String>> Expension_allItems = [];
  List<Map<String, String>> Expension_allItems_outstanding = [];
  List<Map<String, String>> Expension_allItems_expanded_Sample_Count = [];

  String refresh = "";
  DateTime selectedDate = DateTime.now();
  String formattedDate = '';
  DateTimeRange _selectedDateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  ); // Variable to store selected date range
  @override
  void initState() {
    super.initState();
    globals.fromDate = "";
    globals.ToDate = "";
    formattedDate = formattedDate = DateFormat('dd-MMM-yyyy')
        .format(selectedDate); // Format as "10 Oct 2024"

    String session_id_flag = "";
    globals.Class_refresh == "clicked"
        ? session_id_flag = "10"
        : session_id_flag = "9";
    Sales_Data(context, session_id_flag);
  }

  Expension_Sales_Data(BuildContext context, expension_session_id) async {
    Map data = {
      "employee_id": globals.loginEmpid,
      "session_id":
          globals.Glb_Client_Need != "HEALMAX" ? "2" : expension_session_id,
      "from_dt": selecteFromdt == "" ? formattedDate : selecteFromdt,
      "to_dt": selecteTodt == "" ? formattedDate : selecteTodt,
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
        Expension_allItems.clear;
        results.forEach((item2) {
          Expension_allItems.add({
            'BALANCE': (item2['BALANCE'] ?? "0").toString(),
            'COMPANY_CDS': (item2['COMPANY_CDS'] ?? "0").toString(),
            'CMP_AMOUNTS': (item2['CMP_AMOUNTS'] ?? "0").toString(),
          });
        });

        print("All items: $allItems");
        setState(() {
          Expension_allItems;
        });
      }
    }
  }

  Expension_Sales_Data_Outstanding(
      BuildContext context, expension_session_id) async {
    Map data = {
      "employee_id": globals.loginEmpid,
      "session_id":
          globals.Glb_Client_Need != "HEALMAX" ? "2" : expension_session_id,
      "from_dt": selecteFromdt == "" ? formattedDate : selecteFromdt,
      "to_dt": selecteTodt == "" ? formattedDate : selecteTodt,
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
      Expension_allItems_outstanding = [];
      Map<String, dynamic> resposne = jsonDecode(response.body);
      if (resposne["message"] == "sucess") {
        List<dynamic> results = resposne["Data"];
        Expension_allItems_outstanding.clear;
        results.forEach((item1) {
          Expension_allItems_outstanding.add({
            'BALANCE': (item1['BALANCE'] ?? "0").toString(),
            'COMPANY_CDS': (item1['COMPANY_CDS'] ?? "0").toString(),
            'CMP_AMOUNTS': (item1['CMP_AMOUNTS'] ?? "0").toString(),
          });
        });

        print("All items: $allItems");
        setState(() {
          Expension_allItems_outstanding;
        });
      }
    }
  }

  Expension_Sales_Data__Sample_Count(
      BuildContext context, expension_session_id) async {
    Map data = {
      "employee_id": globals.loginEmpid,
      "session_id":
          globals.Glb_Client_Need != "HEALMAX" ? "2" : expension_session_id,
      "from_dt": selecteFromdt == "" ? formattedDate : selecteFromdt,
      "to_dt": selecteTodt == "" ? formattedDate : selecteTodt,
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
      Expension_allItems_expanded_Sample_Count = [];
      Map<String, dynamic> resposne = jsonDecode(response.body);
      if (resposne["message"] == "sucess") {
        List<dynamic> results = resposne["Data"];
        Expension_allItems_expanded_Sample_Count.clear;
        results.forEach((item2) {
          Expension_allItems_expanded_Sample_Count.add({
            'SAMPLE_CNT': (item2['SAMPLE_CNT'] ?? "0").toString(),
          });
        });

        print("All items: $allItems");
        setState(() {
          Expension_allItems_expanded_Sample_Count;
        });
      }
    }
  }

  Sales_Data(BuildContext context, session_id_flag_parameter) async {
    // ProgressDialog progressDialog = ProgressDialog(context);
    // progressDialog.style(message: 'Loading...'); // Customize the loader message
    // progressDialog.show(); // Show the loader
    EasyLoading.show(status: 'Loading...');
    Map data = {
      "employee_id": globals.loginEmpid,
      "session_id": globals.Glb_Client_Need != "HEALMAX"
          ? "1"
          : session_id_flag_parameter.toString(),
      "from_dt": globals.fromDate.toString() == ""
          ? selecteFromdt == ""
              ? formattedDate
              : selecteFromdt
          : globals.fromDate.toString(),
      "to_dt": globals.ToDate.toString() == ""
          ? selecteTodt == ""
              ? formattedDate
              : selecteTodt
          : globals.ToDate.toString(),
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
        // progressDialog.hide(); // Hide the loader
        EasyLoading.dismiss();
        allItems.clear();
        results.forEach((item) {
          allItems.add({
            'AVG_DEPOSITS': (item['AVG_DEPOSITS'] ?? "0").toString(),
            'AVG_BUSINESS': (item['AVG_BUSINESS'] ?? "0").toString(),
            'BUSINESS': (item['BUSINESS'] ?? "0").toString(),
            'FLAG_NEW': (item['FLAG_NEW'] ?? "0").toString(),
            'MNGR_CNT': (item['MNGR_CNT'] ?? "0").toString(),
            'DEPOSITS': (item['DEPOSITS'] ?? "0").toString(),
            'INVENTORY_PURCHASE':
                (item['INVENTORY_PURCHASE'] ?? "0").toString(),
            'INVENTORY_CONSUMPTION':
                (item['INVENTORY_CONSUMPTION'] ?? "0").toString(),
            'TOTAL': (item['TOTAL'] ?? "0").toString(),
            'EMPLOYEE_NAME': (item['EMPLOYEE_NAME'] ?? "0").toString(),
            'EMPLOYEE_ID': (item['EMPLOYEE_ID'] ?? "0").toString(),
            'EMAIL_ID': (item['EMAIL_ID'] ?? "0").toString(),
            'MOBILE_PHONE': (item['MOBILE_PHONE'] ?? "0").toString(),
            'BALANCE': (item['BALANCE'] ?? "0").toString(),
            'ACTIVE': (item['ACTIVE'] ?? "0").toString(),
            'IN_ACTIVE': (item['IN_ACTIVE'] ?? "0").toString(),
            'IS_LOCK_REQ': (item['IS_LOCK_REQ'] ?? "0").toString(),
            'LAST_REFRESH_DT': (item['LAST_REFRESH_DT'] ?? "0").toString(),
          });
        });

        globals.Glb_Client_Need == "HEALMAX"
            ? globals.fromDate == ""
                ? filterSearchResults("TODAY")
                : filterSearchResults_NonHealmax()
            : filterSearchResults_NonHealmax();
        print("All items: $allItems");
      }
    }
  }

  void filterSearchResults(String query) {
    List<Map<String, String>> dummyList = [];

    if (query.isNotEmpty) {
      // Filter items by checking if 'PRODUCT_NAME' contains the query
      dummyList = allItems
          .where((item) =>
              item['FLAG_NEW'] != null &&
              item['FLAG_NEW']!.toLowerCase().contains(query.toLowerCase()))
          .toList();

      setState(() {
        // Clear the filteredItems list and update it with filtered results
        filteredItems.clear();
        dummyList.forEach((item) {
          filteredItems.add({
            'AVG_DEPOSITS': item['AVG_DEPOSITS'].toString(),
            'AVG_BUSINESS': item['AVG_BUSINESS'].toString(),
            'BUSINESS': item['BUSINESS'].toString(),
            'FLAG_NEW': item['FLAG_NEW'].toString(),
            'MNGR_CNT': item['MNGR_CNT'].toString(),
            'DEPOSITS': item['DEPOSITS'].toString(),
            'INVENTORY_PURCHASE': item['INVENTORY_PURCHASE'].toString(),
            'INVENTORY_CONSUMPTION': item['INVENTORY_CONSUMPTION'].toString(),
            'TOTAL': item['TOTAL'].toString(),
            'EMPLOYEE_NAME': item['EMPLOYEE_NAME'].toString(),
            'EMPLOYEE_ID': item['EMPLOYEE_ID'].toString(),
            'EMAIL_ID': item['EMAIL_ID'].toString(),
            'MOBILE_PHONE': item['MOBILE_PHONE'].toString(),
            'BALANCE': item['BALANCE'].toString(),
            'ACTIVE': item['ACTIVE'].toString(),
            'IN_ACTIVE': item['IN_ACTIVE'].toString(),
            'IS_LOCK_REQ': item['IS_LOCK_REQ'].toString(),
            'LAST_REFRESH_DT': item['LAST_REFRESH_DT'].toString(),
          });
        });
      });
    } else {
      setState(() {
        filteredItems.clear();
      });
    }
  }

  void filterSearchResults_NonHealmax() {
    List<Map<String, String>> dummyList = [];

    // Filter items by checking if 'PRODUCT_NAME' contains the query
    dummyList = allItems.toList();

    setState(() {
      // Clear the filteredItems list and update it with filtered results
      filteredItems.clear();
      dummyList.forEach((item) {
        filteredItems.add({
          'AVG_DEPOSITS': item['AVG_DEPOSITS'].toString(),
          'AVG_BUSINESS': item['AVG_BUSINESS'].toString(),
          'BUSINESS': item['BUSINESS'].toString(),
          'FLAG_NEW': item['FLAG_NEW'].toString(),
          'MNGR_CNT': item['MNGR_CNT'].toString(),
          'DEPOSITS': item['DEPOSITS'].toString(),
          'INVENTORY_PURCHASE': item['INVENTORY_PURCHASE'].toString(),
          'INVENTORY_CONSUMPTION': item['INVENTORY_CONSUMPTION'].toString(),
          'TOTAL': item['TOTAL'].toString(),
          'EMPLOYEE_NAME': item['EMPLOYEE_NAME'].toString(),
          'EMPLOYEE_ID': item['EMPLOYEE_ID'].toString(),
          'EMAIL_ID': item['EMAIL_ID'].toString(),
          'MOBILE_PHONE': item['MOBILE_PHONE'].toString(),
          'BALANCE': item['BALANCE'].toString(),
          'ACTIVE': item['ACTIVE'].toString(),
          'IN_ACTIVE': item['IN_ACTIVE'].toString(),
          'IS_LOCK_REQ': item['IS_LOCK_REQ'].toString(),
          'LAST_REFRESH_DT': item['LAST_REFRESH_DT'].toString(),
        });
      });
    });
  }

  void selectItem(Map<String, String> selectedItem) {
    setState(() {
      // Check if the selected item is not already in the list
      if (!selectedItems.contains(selectedItem)) {
        selectedItems.add(selectedItem); // Add the map directly to the list
      }
      filteredItems
          .clear(); // Clear the filtered list after selection (if that's what you intend)
    });
  }

  var selecteFromdt = '';
  var selecteTodt = '';
  int selectedDateIndex = 0;
  Accept_Permission() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        contentPadding: EdgeInsets.only(top: 15, left: 10.0, right: 10.0),
        content: Center(
          heightFactor: 1,
          child: Container(
            height: 70,
            child: Column(
              children: [
                MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: Center(
                      child: Text(
                        'Please click Yes to refresh the screen',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(textScaleFactor: 1.0),
                            child: Text("No"))),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          globals.Class_refresh = "";
                          globals.Glb_Refresh_need = "";
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SalesManagerDashboard()));
                        },
                        child: MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(textScaleFactor: 1.0),
                            child: Text("Yes"))),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatesCard(data, index) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0, right: 5, top: 2),
        child: SizedBox(
          width: screenWidth * 0.17,
          child: TextButton(
            child: Text(
              data["Frequency"],
              style: const TextStyle(fontSize: 8.0),
            ),
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                )),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                overlayColor:
                    MaterialStateColor.resolveWith((states) => Colors.red),
                backgroundColor: selectedDateIndex == index &&
                        globals.fromDate == '' &&
                        refresh != "clicked"
                    ? MaterialStateColor.resolveWith((states) => Colors.pink)
                    : MaterialStateColor.resolveWith(
                        (states) => Colors.blueGrey),
                shadowColor:
                    MaterialStateColor.resolveWith((states) => Colors.blueGrey),
                foregroundColor:
                    MaterialStateColor.resolveWith((states) => Colors.white)),
            onPressed: () {
              print(index.toString());
              setState(() {
                globals.fromDate = '';
                globals.ToDate = '';
                selectedDateIndex = index;
                final DateFormat formatter = DateFormat('dd-MMM-yyyy');
                var now = DateTime.now();
                var yesterday = now.subtract(const Duration(days: 1));
                var thisweek = now.subtract(Duration(days: now.weekday - 1));
                var lastWeek1stDay =
                    thisweek.subtract(Duration(days: thisweek.weekday + 6));
                var lastWeekLastDay =
                    thisweek.subtract(Duration(days: thisweek.weekday - 0));
                var thismonth = DateTime(now.year, now.month, 1);

                var prevMonth1stday = DateTime.utc(
                    DateTime.now().year, DateTime.now().month - 1, 1);
                var prevMonthLastday = DateTime.utc(
                  DateTime.now().year,
                  DateTime.now().month - 0,
                ).subtract(Duration(days: 1));

                if (selectedDateIndex == 0) {
                  // filterSearchResults("TODAY");

                  selecteFromdt = formatter.format(now);
                  selecteTodt = formatter.format(now);

                  globals.Glb_Client_Need == "HEALMAX"
                      ? globals.Glb_Refresh_need == "Refresh"
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SalesManagerDashboard()))
                          : filterSearchResults("TODAY")
                      : Sales_Data(context, 1);
                  globals.Glb_Refresh_need = "";
                } else if (selectedDateIndex == 1) {
                  // filterSearchResults("YESTERDAY");

                  selecteFromdt = formatter.format(yesterday);
                  selecteTodt = formatter.format(yesterday);
                  globals.Glb_Client_Need == "HEALMAX"
                      ? globals.Glb_Refresh_need == "Refresh"
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SalesManagerDashboard()))
                          : filterSearchResults("YESTERDAY")
                      : Sales_Data(context, 1);
                  globals.Glb_Refresh_need = "";
                } else if (selectedDateIndex == 2) {
                  // filterSearchResults("PREVIOUS MONTH");

                  selecteFromdt = formatter.format(prevMonth1stday);
                  selecteTodt = formatter.format(prevMonthLastday);
                  globals.Glb_Client_Need == "HEALMAX"
                      ? globals.Glb_Refresh_need == "Refresh"
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SalesManagerDashboard()))
                          : filterSearchResults("PREVIOUS MONTH")
                      : Sales_Data(context, 1);
                  globals.Glb_Refresh_need = "";
                } else if (selectedDateIndex == 3) {
                  // filterSearchResults("THIS MONTH");

                  selecteFromdt = formatter.format(thismonth);
                  selecteTodt = formatter.format(now);
                  globals.Glb_Client_Need == "HEALMAX"
                      ? globals.Glb_Refresh_need == "Refresh"
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SalesManagerDashboard()))
                          : filterSearchResults("THIS MONTH")
                      : Sales_Data(context, 1);
                  globals.Glb_Refresh_need = "";
                }

                print("From Date " + selecteFromdt);
                print("To Date " + selecteTodt);
                print(selectedDateIndex);
                refresh = "";
                globals.Class_refresh = "";
              });
            },
            onLongPress: () {
              print('Long press');
            },
          ),
        ),
      ),
    );
  }

  ListView datesListView() {
    var myData = [
      {
        "FrequencyId": "0",
        "Frequency": "Today(T)",
      },
      {
        "FrequencyId": "1",
        "Frequency": "T-1",
      },
      {
        "FrequencyId": "2",
        "Frequency": "L M",
      },
      {
        "FrequencyId": "3",
        "Frequency": "Month(MTD)",
      },
    ];

    return ListView.builder(
        itemCount: myData.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildDatesCard(myData[index], index),
            ],
          );
        });
  }

  Widget DateSelection() {
    return Container(child: datesListView());
  }

  bool isExpanded = false;

  void _handleExpansion(bool expanded) {
    setState(() {
      isExpanded = expanded;
    });
    if (expanded) {
      Expension_allItems = [];
      var session_id = "2";
      Expension_Sales_Data(
          context, session_id); // Call the function only when expanded
    }
  }

  bool isExpanded_Outstanding = false;
  // Function to handle date range selection
  Future<void> _centerWiseBusinessDate(BuildContext context) async {
    // Calculate the date 10 years ago
    DateTime fiveYearsAgo = DateTime.now().subtract(Duration(days: 10 * 365));

    // Calculate the date 30 days ago for the initial view
    DateTime pastMonth = DateTime.now().subtract(Duration(days: 30));

    final DateTimeRange? selected = await showDateRangePicker(
      context: context,
      // Allow dates from 5 years ago
      firstDate: fiveYearsAgo,
      // Allow dates up to one year in the future
      lastDate: DateTime(DateTime.now().year + 1),
      // Initially display past 30 days
      initialDateRange: DateTimeRange(
        start: pastMonth,
        end: DateTime.now(),
      ),
      saveText: 'Done',
    );

    if (selected != null) {
      final int daysDifference = selected.end.difference(selected.start).inDays;

      if (daysDifference > 30) {
        // Show an error message if the date range exceeds 30 days
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Invalid Date Range'),
              content: const Text('Please select a date range within 30 days.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        setState(() {
          // Reset and format selected dates
          selecteFromdt = "";
          globals.fromDate = "";
          globals.fromDate = DateFormat('dd-MMM-yyyy').format(selected.start);
          globals.ToDate = DateFormat('dd-MMM-yyyy').format(selected.end);

          _selectedDateRange = selected;

          var session_id_flag = "1";
          Sales_Data(context, session_id_flag);

          globals.Glb_Refresh_need = "Refresh";
        });
      }
    }
  }

  void _handleExpansion_Outstanding(bool expanded_Outstanding) {
    setState(() {
      isExpanded = expanded_Outstanding;
    });
    if (expanded_Outstanding) {
      Expension_allItems_outstanding = [];

      var session_id = "2";
      Expension_Sales_Data_Outstanding(
          context, session_id); // Call the function only when expanded
    }
  }

  void _handleExpansion_Sample_Count(bool expanded_Sample_Count) {
    setState(() {
      isExpanded = expanded_Sample_Count;
    });
    if (expanded_Sample_Count) {
      Expension_allItems_expanded_Sample_Count = [];

      var session_id = "2";
      Expension_Sales_Data__Sample_Count(
          context, session_id); // Call the function only when expanded
    }
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () async {
          // Returning false prevents the back button action.
          return false;
        },
        child: Scaffold(
          backgroundColor:
              Colors.grey[200], // Set screen background to light grey
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xff123456),
            title: Container(
              color: const Color(0xff123456),
              height: 80,
              child: ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (context, index) {
                  final item = filteredItems[index];
                  // Extract all necessary fields as before
                  final EMPLOYEE_NAME = item['EMPLOYEE_NAME'];
                  final MNGR_CNT = item['MNGR_CNT'];

                  return InkWell(
                    onTap: () {
                      globals.fromDate = "";
                      globals.ToDate = "";
                      // Handle tap action
                      globals.Navigate_mngrcnt = MNGR_CNT.toString();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllinOne(selectedDateIndex: 0),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.account_box,
                              color: Colors.white,
                              size: 32, // Larger icon size for visibility
                            ),
                            SizedBox(width: 12),
                            SizedBox(
                              width: MediaQuery.of(context).size.width *
                                  0.4, // Dynamic width
                              child: Text(
                                EMPLOYEE_NAME.toString(),
                                style: TextStyle(
                                  fontSize:
                                      18, // Increased font size for better readability
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              MNGR_CNT.toString(),
                              style: TextStyle(
                                fontSize: 16, // Increased text size
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.double_arrow,
                              color: Colors.red,
                              size: 28, // Larger arrow icon
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              final item = filteredItems[0];
              setState() {
                globals.Glb_LAST_REFRESH_DT =
                    item['LAST_REFRESH_DT'].toString();
                // globals.refresh_data == "false";
              }

              allItems.clear();
              filteredItems.clear();
              String session_id_flag = "10";
              // Sales_Data(context, session_id_flag);
              refresh = "clicked";

              globals.Class_refresh = "clicked";
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SalesManagerDashboard()),
              );

              selecteFromdt = "";
              int selectedDateIndex = 0;
            },
            child: filteredItems.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                  width: screenWidth * 0.8,
                                  height: screenHeight * 0.04,
                                  child: DateSelection()),
                              IconButton(
                                icon: const Icon(Icons.date_range_outlined),
                                onPressed: () async {
                                  await _centerWiseBusinessDate(context);
                                },
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Container(
                                height: screenHeight * 0.015,
                                child: selecteFromdt == "" &&
                                        globals.fromDate == ""
                                    ? Text(
                                        formattedDate +
                                            '  To   ' +
                                            formattedDate,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.0))
                                    : selecteFromdt != ""
                                        ? Text(
                                            selecteFromdt +
                                                '  To   ' +
                                                selecteTodt,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.0))
                                        : Text(
                                            globals.fromDate +
                                                '  To   ' +
                                                globals.ToDate,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.0))),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Card(
                              elevation: 4,
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: screenWidth * 0.75,
                                    height: screenHeight * 0.08,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: TextField(
                                        controller: _searchController,
                                        decoration: InputDecoration(
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                            borderSide: const BorderSide(
                                                color: Colors.grey),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                            borderSide: const BorderSide(
                                                color: Colors.grey),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                            borderSide: const BorderSide(
                                                color: Color(0xFF2262AB)),
                                          ),
                                          hintText: 'Search Client Code',
                                          hintStyle: const TextStyle(
                                              color: Colors.grey),
                                          prefixIcon: const Icon(
                                              Icons.person_search_outlined,
                                              color: Color(0xFF1E429A)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.005,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.search),
                                    onPressed: () {
                                      globals.Glb_Client_Code =
                                          _searchController.text;
                                      _searchController.text = "";
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Client_Search(
                                                selectedDateIndex: 0)),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 3,
                            child: ListView.builder(
                              itemCount: filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = filteredItems[index];

                                final IN_ACTIVE = item['IN_ACTIVE'];
                                final ACTIVE = item['ACTIVE'];
                                final BALANCE = item['BALANCE'];
                                final AVG_DEPOSITS = item['AVG_DEPOSITS'];
                                final AVG_BUSINESS = item['AVG_BUSINESS'];
                                final BUSINESS = item['BUSINESS'];
                                final FLAG_NEW = item['FLAG_NEW'];
                                final MNGR_CNT = item['MNGR_CNT'];
                                final DEPOSITS = item['DEPOSITS'];
                                final INVENTORY_PURCHASE =
                                    item['INVENTORY_PURCHASE'] == ""
                                        ? "0"
                                        : item['INVENTORY_PURCHASE'];
                                final INVENTORY_CONSUMPTION =
                                    item['INVENTORY_CONSUMPTION'] == ""
                                        ? "0"
                                        : item['INVENTORY_CONSUMPTION'];

                                final TOTAL = item['TOTAL'];
                                final EMPLOYEE_NAME = item['EMPLOYEE_NAME'];
                                final EMPLOYEE_ID = item['EMPLOYEE_ID'];
                                final EMAIL_ID = item['EMAIL_ID'];
                                final MOBILE_PHONE = item['MOBILE_PHONE'];
                                final IS_LOCK_REQ = item['IS_LOCK_REQ'];
                                final LAST_REFRESH_DT = item['LAST_REFRESH_DT'];
                                globals.new_selectedEmpid =
                                    item['EMPLOYEE_ID'].toString();
                                globals.Glb_LAST_REFRESH_DT =
                                    item['LAST_REFRESH_DT'].toString();
                                globals.Glb_IS_LOCK_REQ =
                                    item['IS_LOCK_REQ'].toString();
                                globals.glb_EMPLOYEE_NAME =
                                    item['EMPLOYEE_NAME'].toString();
                                globals.glb_EMPLOYEE_ID =
                                    item['EMPLOYEE_ID'].toString();
                                globals.glb_EMAIL_ID =
                                    item['EMAIL_ID'].toString();
                                globals.glb_MOBILE_PHONE_NEW =
                                    item['MOBILE_PHONE'].toString();

                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            globals.fromDate = "";
                                            globals.ToDate = "";
                                            globals.Glb_Method = "Business";
                                            globals.new_selectedEmpid = "";
                                            globals.glb_session_id = "3";
                                            globals.Navigate_mngrcnt =
                                                MNGR_CNT.toString();
                                            globals.Glb_empname = "";
                                            globals.Employee_Code = "";
                                            // globals.Glb_IS_LOCK_REQ =
                                            //     managerDetails.IS_LOCK_REQ.toString();

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      businesss(
                                                        selectedIndex: 0,
                                                      )),
                                            );
                                          },
                                          child: SizedBox(
                                            // width: 90, // Slightly increased width
                                            // height: 100, // Slightly increased height

                                            width: screenWidth * 0.27,
                                            height: screenHeight * 0.14,

                                            child: Card(
                                              // Added gradient background for better look
                                              color: Colors.white,
                                              elevation:
                                                  6, // Slightly higher elevation for a shadow effect
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    15), // More rounded corners
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical:
                                                        12), // Added padding
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.business,
                                                      size: screenHeight *
                                                          0.04, // Larger icon size

                                                      color: Colors
                                                          .deepPurpleAccent,
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            6), // Added space between icon and text
                                                    Text(
                                                      "Business",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize:
                                                            10, // Slightly larger font
                                                        fontWeight: FontWeight
                                                            .bold, // Bold for emphasis
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    if (item['BUSINESS'] !=
                                                            null &&
                                                        item['BUSINESS']
                                                            .toString()
                                                            .isNotEmpty)
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            top:
                                                                2), // Small padding above text
                                                        child: Text(
                                                          item['BUSINESS'] ??
                                                              '',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize:
                                                                12, // Slightly smaller secondary font
                                                            color: Colors
                                                                .grey[700],
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            globals.fromDate = "";
                                            globals.ToDate = "";
                                            globals.new_selectedEmpid = "";
                                            globals.glb_session_id = "4";
                                            globals.Glb_Method = "Payments";
                                            globals.Glb_empname = "";
                                            globals.Employee_Code = "";
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        businesss(
                                                          selectedIndex: 0,
                                                        )));
                                          },
                                          child: SizedBox(
                                            width: screenWidth * 0.27,
                                            height: screenHeight * 0.14,
                                            child: Card(
                                              color: Colors.white,
                                              elevation: 4,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    12), // Slightly rounded corners
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical:
                                                        8), // Adjusted padding
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.account_balance,
                                                      size: screenHeight * 0.04,
                                                      color:
                                                          Colors.orangeAccent,
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            6), // Reduced space between icon and text
                                                    Text(
                                                      "Deposits",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize:
                                                            10, // Reduced font size
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    if (item['DEPOSITS'] !=
                                                            null &&
                                                        item['DEPOSITS']
                                                            .toString()
                                                            .isNotEmpty)
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            top:
                                                                2), // Reduced padding above text
                                                        child: Text(
                                                          item['DEPOSITS'] ??
                                                              '',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize:
                                                                12, // Reduced secondary font size
                                                            color: Colors
                                                                .grey[700],
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {},
                                          child: SizedBox(
                                            width: screenWidth * 0.27,
                                            height: screenHeight * 0.14,
                                            child: Card(
                                              color: Colors.white,
                                              elevation: 4,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    12), // Slightly rounded corners
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical:
                                                        8), // Adjusted padding
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.show_chart,
                                                      size: screenHeight * 0.04,
                                                      color: Colors.teal,
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            6), // Reduced space between icon and text
                                                    Text(
                                                      "Avg. Business",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize:
                                                            10, // Reduced font size
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    if (item['AVG_BUSINESS'] !=
                                                            null &&
                                                        item['AVG_BUSINESS']
                                                            .toString()
                                                            .isNotEmpty)
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            top:
                                                                2), // Reduced padding above text
                                                        child: Text(
                                                          item['AVG_BUSINESS'] ??
                                                              '',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize:
                                                                12, // Reduced secondary font size
                                                            color: Colors
                                                                .grey[700],
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: screenHeight * 0.01,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {},
                                          child: SizedBox(
                                            width: screenWidth * 0.27,
                                            height: screenHeight * 0.14,
                                            child: Card(
                                              color: Colors.white,
                                              elevation: 4,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    12), // Slightly rounded corners
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical:
                                                        8), // Adjusted padding
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.insert_chart,
                                                      size: screenHeight * 0.04,
                                                      color: Colors.pinkAccent,
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            6), // Reduced space between icon and text
                                                    Text(
                                                      "Avg. Deposits",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize:
                                                            10, // Reduced font size
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    if (item['AVG_DEPOSITS'] !=
                                                            null &&
                                                        item['AVG_DEPOSITS']
                                                            .toString()
                                                            .isNotEmpty)
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            top:
                                                                2), // Reduced padding above text
                                                        child: Text(
                                                          item['AVG_DEPOSITS'] ??
                                                              '',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize:
                                                                12, // Reduced secondary font size
                                                            color: Colors
                                                                .grey[700],
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            globals.new_selectedEmpid = "";
                                            globals.glb_session_id = "5";
                                            globals.Glb_Method =
                                                "Inventory Purchase";
                                            globals.Glb_empname = "";
                                            globals.Employee_Code = "";
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        businesss(
                                                          selectedIndex: 0,
                                                        )));
                                          },
                                          child: SizedBox(
                                            width: screenWidth * 0.27,
                                            height: screenHeight * 0.14,
                                            child: Card(
                                              color: Colors.white,
                                              elevation: 4,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    12), // Slightly rounded corners
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical:
                                                        8), // Adjusted padding
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.inventory,
                                                      size: screenHeight * 0.04,
                                                      color: Colors.blueAccent,
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            6), // Reduced space between icon and text
                                                    Text(
                                                      "Intry Purchase",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize:
                                                            10, // Reduced font size
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    if (item['INVENTORY_PURCHASE'] !=
                                                            null &&
                                                        item['INVENTORY_PURCHASE']
                                                            .toString()
                                                            .isNotEmpty)
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            top:
                                                                2), // Reduced padding above text
                                                        child: Text(
                                                          item['INVENTORY_PURCHASE'] ??
                                                              '',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize:
                                                                12, // Reduced secondary font size
                                                            color: Colors
                                                                .grey[700],
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            globals.new_selectedEmpid = "";
                                            globals.glb_session_id = "6";
                                            globals.Glb_Method =
                                                "Inventory Consumption";
                                            globals.Glb_empname = "";
                                            globals.Employee_Code = "";
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        businesss(
                                                          selectedIndex: 0,
                                                        )));
                                          },
                                          child: SizedBox(
                                            width: screenWidth * 0.27,
                                            height: screenHeight * 0.14,
                                            child: Card(
                                              color: Colors.white,
                                              elevation: 4,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    12), // Slightly rounded corners
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical:
                                                        8), // Adjusted padding
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.construction,
                                                      size: screenHeight * 0.04,
                                                      color: Colors.lightGreen,
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            6), // Reduced space between icon and text
                                                    Text(
                                                      "Intry Consumption",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize:
                                                            10, // Reduced font size
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    if (item['INVENTORY_CONSUMPTION'] !=
                                                            null &&
                                                        item['INVENTORY_CONSUMPTION']
                                                            .toString()
                                                            .isNotEmpty)
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            top:
                                                                2), // Reduced padding above text
                                                        child: Text(
                                                          item['INVENTORY_CONSUMPTION'] ??
                                                              '',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize:
                                                                9, // Reduced secondary font size
                                                            color: Colors
                                                                .grey[700],
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: screenHeight * 0.01,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             FlagDataPage()));
                                          },
                                          child: SizedBox(
                                            width: screenWidth * 0.27,
                                            height: screenHeight * 0.14,
                                            child: Card(
                                              // Added gradient background for better look
                                              color: Colors.white,
                                              elevation:
                                                  6, // Slightly higher elevation for a shadow effect
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    15), // More rounded corners
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical:
                                                        12), // Added padding
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.people,
                                                      size: screenHeight * 0.04,
                                                      color: Colors.redAccent,
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            6), // Added space between icon and text
                                                    Text(
                                                      "Clients Count",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize:
                                                            10, // Slightly larger font
                                                        fontWeight: FontWeight
                                                            .bold, // Bold for emphasis
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                    if (item['TOTAL'] != null &&
                                                        item['TOTAL']
                                                            .toString()
                                                            .isNotEmpty)
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            top:
                                                                2), // Small padding above text
                                                        child: Text(
                                                          item['TOTAL'] ?? '',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize:
                                                                12, // Slightly smaller secondary font
                                                            color: Colors
                                                                .grey[700],
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        globals.Glb_Client_Need_Add_Franchise_Client ==
                                                "Accepted"
                                            ? GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              CompanyAddScreen()));
                                                },
                                                child: SizedBox(
                                                  width: screenWidth * 0.27,
                                                  height: screenHeight * 0.14,
                                                  child: Card(
                                                    // Added gradient background for better look
                                                    color: Colors.white,
                                                    elevation:
                                                        6, // Slightly higher elevation for a shadow effect
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15), // More rounded corners
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal: 8,
                                                          vertical:
                                                              12), // Added padding
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.add_business,
                                                            size: screenHeight *
                                                                0.04,
                                                            color:
                                                                Colors.indigo,
                                                          ),
                                                          SizedBox(
                                                              height:
                                                                  6), // Added space between icon and text
                                                          Text(
                                                            "Add Franchise",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontSize:
                                                                  10, // Slightly larger font
                                                              fontWeight: FontWeight
                                                                  .bold, // Bold for emphasis
                                                              color: Colors
                                                                  .black87,
                                                            ),
                                                          ),
                                                          // if (item['BUSINESS'] != null &&
                                                          //     item['BUSINESS']
                                                          //         .toString()
                                                          //         .isNotEmpty)
                                                          //   Padding(
                                                          //     padding: EdgeInsets.only(
                                                          //         top:
                                                          //             2), // Small padding above text
                                                          //     child: Text(
                                                          //       item['BUSINESS'] ?? '',
                                                          //       textAlign: TextAlign.center,
                                                          //       style: TextStyle(
                                                          //         fontSize:
                                                          //             12, // Slightly smaller secondary font
                                                          //         color: Colors.grey[700],
                                                          //       ),
                                                          //     ),
                                                          //   ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : globals.Glb_Client_Need_Location_Wise_Business ==
                                                    "Accepted"
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          Total_Business()));
                                                        },
                                                        child: SizedBox(
                                                          width: screenWidth *
                                                              0.27,
                                                          height: screenHeight *
                                                              0.14,
                                                          child: Card(
                                                            // Added gradient background for better look
                                                            color: Colors.white,
                                                            elevation:
                                                                6, // Slightly higher elevation for a shadow effect
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15), // More rounded corners
                                                            ),
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8,
                                                                      vertical:
                                                                          12), // Added padding
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .location_on,
                                                                    size:
                                                                        screenHeight *
                                                                            0.04,
                                                                    color: Colors
                                                                        .redAccent,
                                                                  ),
                                                                  SizedBox(
                                                                      height:
                                                                          6), // Added space between icon and text
                                                                  Text(
                                                                    "Location Wise Business",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          10, // Slightly larger font
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold, // Bold for emphasis
                                                                      color: Colors
                                                                          .black87,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Container(),
                                        GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return CustomPopupDialog(
                                                  mobileNoController:
                                                      _Mobile_NoController,
                                                  billNoController:
                                                      _billnoController,
                                                  onSubmit: () {
                                                    if (_billnoController
                                                                .text ==
                                                            "" &&
                                                        _Mobile_NoController
                                                                .text ==
                                                            "") {
                                                      Fluttertoast.showToast(
                                                        msg:
                                                            "Enter Valid Number",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.CENTER,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor:
                                                            const Color
                                                                    .fromARGB(
                                                                255,
                                                                180,
                                                                17,
                                                                17),
                                                        textColor: Colors.white,
                                                        fontSize: 16.0,
                                                      );
                                                    }

                                                    if (_billnoController
                                                                .text !=
                                                            "" ||
                                                        _Mobile_NoController
                                                                .text !=
                                                            "") {
                                                      globals.mobile_no =
                                                          _Mobile_NoController
                                                              .text;
                                                      globals.bill_no =
                                                          _billnoController
                                                              .text;
                                                      ReportData(5, 0);
                                                      Navigator.pop(context);
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ReportData(0, 0),
                                                        ),
                                                      );
                                                    }
                                                    _billnoController.text = '';
                                                    _Mobile_NoController.text =
                                                        '';
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          child: SizedBox(
                                            width: screenWidth * 0.27,
                                            height: screenHeight * 0.14,
                                            child: Card(
                                              // Added gradient background for better look
                                              color: Colors.white,
                                              elevation:
                                                  6, // Slightly higher elevation for a shadow effect
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    15), // More rounded corners
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical:
                                                        12), // Added padding
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.assessment,
                                                      size:
                                                          36, // Larger icon size
                                                      color: Colors.cyan,
                                                    ),
                                                    SizedBox(
                                                        height:
                                                            6), // Added space between icon and text
                                                    Text(
                                                      "Report",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize:
                                                            10, // Slightly larger font
                                                        fontWeight: FontWeight
                                                            .bold, // Bold for emphasis
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: screenHeight * 0.01,
                                    ),
                                    globals.Glb_Client_Need == "HEALMAX"
                                        ? Padding(
                                            padding:
                                                const EdgeInsets.only(top: 2.0),
                                            child: SizedBox(
                                              height: screenHeight * 0.05,
                                              child: Card(
                                                child: Center(
                                                  child: Container(
                                                    color: Colors.white,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          top:
                                                              2), // Small padding above text
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "Last Refresh:   ",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontSize:
                                                                  12, // Slightly smaller secondary font
                                                              color: Colors
                                                                  .grey[700],
                                                            ),
                                                          ),
                                                          Text(
                                                            item['LAST_REFRESH_DT'] ??
                                                                '',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontSize:
                                                                  12, // Slightly smaller secondary font
                                                              color: Colors
                                                                  .grey[700],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    // Text(
                                                    //   "Last Refresh: " +
                                                    //       globals.Glb_LAST_REFRESH_DT,
                                                    //   style: TextStyle(
                                                    //     fontWeight: FontWeight.w500,
                                                    //     fontSize: 15,
                                                    //     color: Colors.grey,
                                                    //   ),
                                                    // ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 4),
                          Outstanding_buildExpansionTile(
                            context,
                            title: 'Outstanding',
                            icon: Icons.monetization_on,
                            color: Colors.green,
                            children: [
                              ListTile(
                                title: Text("Outstanding Amount: \$5000"),
                              ),
                              ListTile(
                                title: Text("Due Date: 15 Oct"),
                              ),
                            ],
                          ),
                          Sample_Count_buildExpansionTile(
                            context,
                            title: 'Sample Count',
                            icon: Icons.plus_one,
                            color: Color.fromARGB(255, 20, 18, 129),
                            children: [
                              ListTile(
                                title: Text("Outstanding Amount: \$5000"),
                              ),
                              ListTile(
                                title: Text("Due Date: 15 Oct"),
                              ),
                            ],
                          ),
                          Recent_Payments_buildExpansionTile(
                            context,
                            title: 'Recent Payments',
                            icon: Icons.payment,
                            color: Colors.amber,
                            children: [
                              ListTile(
                                title: Text("Payment 1: \$150"),
                                subtitle: Text("Date: 10 Oct"),
                              ),
                              ListTile(
                                title: Text("Payment 2: \$200"),
                                subtitle: Text("Date: 12 Oct"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                : Center(
                    child:
                        CircularProgressIndicator(), // Show loader if the list is empty
                  ),
          ),
          bottomNavigationBar: const AllbottomNavigation(),
        ),
      ),
    );
  }

  Widget _buildDashboardItem(BuildContext context, Map<String, dynamic> item) {
    return GestureDetector(
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.business, // Assuming 'icon' exists in the map
              size: 40,
              color:
                  Colors.deepPurpleAccent, // Assuming 'color' exists in the map
            ),
            SizedBox(height: 8),
            Text(
              item['title'] ?? '', // Assuming 'title' exists in the map
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            if (item['BUSINESS'] != null &&
                item['BUSINESS'].toString().isNotEmpty)
              Text(
                item['BUSINESS'] ?? '', // Assuming 'value' exists in the map
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
          ],
        ),
      ),
    );
  }

  Widget Outstanding_buildExpansionTile(BuildContext context,
      {required String title,
      required IconData icon,
      required Color color,
      required List<Widget> children}) {
    return Container(
      width: double.infinity,
      child: Card(
        color: Colors.white, // Set expansion tile background to white
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ExpansionTile(
          leading: Icon(icon, color: color),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          onExpansionChanged: _handleExpansion_Outstanding,
          children: Expension_allItems_outstanding.isEmpty
              ? [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        CircularProgressIndicator(), // Show loading indicator when expanding
                  )
                ]
              : Expension_allItems_outstanding.map((item) {
                  return ListTile(
                    title: Text('Balance: ${item['BALANCE']}'),
                  );
                }).toList(),
        ),
      ),
    );
  }

  Widget Recent_Payments_buildExpansionTile(BuildContext context,
      {required String title,
      required IconData icon,
      required Color color,
      required List<Widget> children}) {
    return Container(
      width: double.infinity,
      child: Card(
        color: Colors.white, // Set expansion tile background to white
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ExpansionTile(
          leading: Icon(icon, color: color),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          onExpansionChanged: _handleExpansion,
          children: Expension_allItems.isEmpty
              ? [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        CircularProgressIndicator(), // Show loading indicator
                  )
                ]
              : [
                  // Wrap children in a SingleChildScrollView with limited height
                  Container(
                    constraints: BoxConstraints(maxHeight: 140), // Limit height
                    child: SingleChildScrollView(
                      child: Column(
                        children: Expension_allItems.expand((item) {
                          List<String> amounts =
                              item['CMP_AMOUNTS']?.split(',') ?? [];
                          List<String> companyCds =
                              item['COMPANY_CDS']?.split(',') ?? [];

                          int length = amounts.length < companyCds.length
                              ? amounts.length
                              : companyCds.length;

                          return List.generate(length, (index) {
                            return ListTile(
                              title: Row(
                                children: [
                                  Text('${companyCds[index]}'), // COMPANY_CDS
                                  Spacer(),
                                  Text('${amounts[index]}'), // CMP_AMOUNTS
                                ],
                              ),
                            );
                          });
                        }).toList(),
                      ),
                    ),
                  ),
                ],
        ),
      ),
    );
  }

  Widget Sample_Count_buildExpansionTile(BuildContext context,
      {required String title,
      required IconData icon,
      required Color color,
      required List<Widget> children}) {
    return Container(
      width: double.infinity,
      child: Card(
        color: Colors.white, // Set expansion tile background to white
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: ExpansionTile(
          leading: Icon(icon, color: color),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          onExpansionChanged: _handleExpansion_Sample_Count,
          children: Expension_allItems_expanded_Sample_Count.isEmpty
              ? [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        CircularProgressIndicator(), // Show loading indicator when expanding
                  )
                ]
              : Expension_allItems_expanded_Sample_Count.map((item) {
                  return ListTile(
                    title: Text('Sample Count: ${item['SAMPLE_CNT']}'),
                  );
                }).toList(),
        ),
      ),
    );
  }
}
