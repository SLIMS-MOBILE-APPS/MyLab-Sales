import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'ManagerEmployees.dart';
import 'Sales_Dashboard.dart';

import 'allbottomnavigationbar.dart';
import 'business_new.dart';
import 'clients_search.dart';
import 'globals.dart' as globals;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

//import 'SalesClientsList.dart';

class AllinOne extends StatefulWidget {
  int selectedDateIndex;

  AllinOne({super.key, required this.selectedDateIndex});

  // AllinOne(String iEmpid) {
  //   this.empID = iEmpid;

  // }

  @override
  _AllinOneState createState() => _AllinOneState();
}

class _AllinOneState extends State<AllinOne> {
  final TextEditingController _searchController = TextEditingController();
  Map<int, bool> _isExpanded = {}; // Keep track of expanded tiles
  late Future<List<SalesManagers>> _futureManagers;
  int _expandedTileIndex = -1;
  bool _isLoading = false;

  String empID = "0";
  DateTime pastMonth = DateTime.now().subtract(Duration(days: 30));
  _CenterWiseBusinessDate(BuildContext context) async {
    final DateTimeRange? selected = await showDateRangePicker(
      context: context,
      firstDate: pastMonth,
      lastDate: DateTime(DateTime.now().year + 1),
      saveText: 'Done',
    );

    if (selected != null) {
      final int daysDifference = selected.end.difference(selected.start).inDays;

      if (daysDifference > 30) {
        // Show an error message or handle accordingly
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Invalid Date Range'),
              content: Text('Please select a date range within 30 days.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
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
          // globals.fromDate = selected.start.toString().split(' ')[0];
          // globals.ToDate = selected.end.toString().split(' ')[0];
          globals.fromDate = DateFormat('dd-MMM-yyyy').format(selected.start);

          globals.ToDate = DateFormat('dd-MMM-yyyy').format(selected.end);
        });
      }
    }
  }
  // String empID = "0";

  var selecteFromdt = '';
  var selecteTodt = '';
  DateTime selectedDate = DateTime.now();
  String formattedDate = '';
  @override
  void initState() {
    super.initState();
    formattedDate = formattedDate = DateFormat('dd-MMM-yyyy')
        .format(selectedDate); // Format as "10 Oct 2024"
    globals.Glb_Flag = "A_B";
    _futureManagers = _fetchSalespersons();
  }

  Future<List<SalesManagers>> _fetchSalespersons() async {
    Map data = {
      "emp_id": globals.loginEmpid,
      "session_id": "1",
      "IP_SALES_EMP_CD": "",
      "IP_FLAG": globals.Glb_Flag,
      "IP_FROM_DATE": selecteFromdt == ""
          ? "${selectedDate.toLocal()}".split(' ')[0]
          : selecteFromdt,
      "IP_TO_DATE": selecteTodt == ""
          ? "${selectedDate.toLocal()}".split(' ')[0]
          : selecteTodt,
      "connection": globals.Connection_Flag
      //"Server_Flag":""
    };
    final jobsListAPIUrl =
        Uri.parse(globals.API_url + '/MobileSales/MgnrEmpDtls');
    var response = await http.post(jobsListAPIUrl,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);
      List jsonResponse = resposne["Data"];

      return jsonResponse
          .map((managers) => SalesManagers.fromJson(managers))
          .toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    void showClientCodePopup(BuildContext context) {
      TextEditingController clientCodeController = TextEditingController();

      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text(
              "Enter Client Code",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            content: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Card(
                elevation: 4,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: screenWidth * 0.55,
                      height: screenHeight * 0.08,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextField(
                          controller: clientCodeController,
                          decoration: InputDecoration(
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide:
                                  const BorderSide(color: Color(0xFF2262AB)),
                            ),
                            hintText: 'Search Client Code',
                            hintStyle: const TextStyle(color: Colors.grey),
                            prefixIcon: const Icon(Icons.person_search_outlined,
                                color: Color(0xFF1E429A)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  String clientCode = clientCodeController.text.trim();
                  if (clientCode.isNotEmpty) {
                    Navigator.pop(context);
                    globals.Glb_Client_Code = clientCodeController.text;
                    _searchController.text = "";
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Client_Search(selectedDateIndex: 0)),
                    );
                  }
                },
                child: Text("Submit"),
              ),
            ],
          );
        },
      );
    }

    final topAppBar = AppBar(
      elevation: 0.1,
      backgroundColor: Color(0xff123456),
      automaticallyImplyLeading: false,
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
          Text("Sales Managers"),
          Spacer(),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // globals.Glb_Client_Code = _searchController.text;
              // _searchController.text = "";
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => Client_Search(selectedDateIndex: 0)),
              // );

              showClientCodePopup(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.date_range_outlined),
            onPressed: () {
              _CenterWiseBusinessDate(context);
            },
          ),
        ],
      ),
    );

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
              backgroundColor: widget.selectedDateIndex == index &&
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
              widget.selectedDateIndex = index;
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

              var prevMonth1stday = DateTime.utc(
                  DateTime.now().year, DateTime.now().month - 1, 1);
              var prevMonthLastday = DateTime.utc(
                DateTime.now().year,
                DateTime.now().month - 0,
              ).subtract(Duration(days: 1));

              if (widget.selectedDateIndex == 0) {
                // Today
                // total_amouont = "";
                selecteFromdt = formatter.format(now);
                selecteTodt = formatter.format(now);
              } else if (widget.selectedDateIndex == 1) {
                // yesterday
                //  total_amouont = "";
                selecteFromdt = formatter.format(yesterday);
                selecteTodt = formatter.format(yesterday);
              } else if (widget.selectedDateIndex == 2) {
                // LastWeek
                // total_amouont = "";
                selecteFromdt = formatter.format(lastWeek1stDay);
                selecteTodt = formatter.format(lastWeekLastDay);
              } else if (widget.selectedDateIndex == 3) {
                //  total_amouont = "";
                selecteFromdt = formatter.format(thisweek);
                selecteTodt = formatter.format(now);
              } else if (widget.selectedDateIndex == 4) {
                // Last Month
                // total_amouont = "";
                selecteFromdt = formatter.format(prevMonth1stday);
                selecteTodt = formatter.format(prevMonthLastday);
              } else if (widget.selectedDateIndex == 5) {
                // total_amouont = "";
                selecteFromdt = formatter.format(thismonth);
                selecteTodt = formatter.format(now);
                // _fetchSalespersons();
              }
              _futureManagers = _fetchSalespersons();
              print("From Date " + selecteFromdt);
              print("To Date " + selecteTodt);
              print(widget.selectedDateIndex);
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
          "FrequencyId": "0",
          "Frequency": "Today",
        },
        {
          "FrequencyId": "1",
          "Frequency": "Yesterday",
        },
        {
          "FrequencyId": "2",
          "Frequency": "Last Week",
        },
        {
          "FrequencyId": "3",
          "Frequency": "This Week",
        },
        {
          "FrequencyId": "4",
          "Frequency": "Last Month",
        },
        {
          "FrequencyId": "6",
          "Frequency": "This Month",
        },
      ];

      return ListView.builder(
          itemCount: myData.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return _buildDatesCard(myData[index], index);
          });
    }

    Widget DateSelection() {
      return Container(child: datesListView());
    }

    final DateFormat formatter1 = DateFormat('dd-MMM-yyyy');
    var now = DateTime.now();
    if (globals.fromDate != "") {
      setState(() {
        selecteFromdt = globals.fromDate;
        selecteTodt = globals.ToDate;
        _futureManagers = _fetchSalespersons();
      });
    } else if (selecteTodt == '') {
      setState(() {
        selecteFromdt = formatter1.format(now);
        selecteTodt = formatter1.format(now);
        _futureManagers = _fetchSalespersons();
      });
    }

    Future<List<ManagerEMPDetails>> _fetchManagerDetails(
        String newSelectedempid, BuildContext context) async {
      Map data = {
        "emp_id": newSelectedempid,
        "session_id": "1",
        "IP_SALES_EMP_CD": "",
        "IP_FLAG": "B",
        "IP_FROM_DATE": selecteFromdt.isEmpty
            ? "${selectedDate.toLocal()}".split(' ')[0]
            : selecteFromdt,
        "IP_TO_DATE": selecteTodt.isEmpty
            ? "${selectedDate.toLocal()}".split(' ')[0]
            : selecteTodt,
        "connection": globals.Connection_Flag,
      };

      print("Request Data: $data");

      final response = await http.post(
        Uri.parse(globals.API_url + '/MobileSales/MgnrEmpDtls'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: data,
        encoding: Encoding.getByName("utf-8"),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody["message"] == "success") {
          List<dynamic> dataList = responseBody['Data'];
          return dataList
              .map((data) => ManagerEMPDetails.fromJson(data))
              .toList();
        } else {
          throw Exception('Failed to load data: ${responseBody["message"]}');
        }
      } else {
        throw Exception(
            'Failed to fetch data from the server. Status code: ${response.statusCode}');
      }
    }

    Widget _buildSalesCard(var data, BuildContext context, int index) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(12, 2, 12, 2),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ExpansionTile(
            initiallyExpanded: true,
            trailing: SizedBox.shrink(),
            title: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    globals.selectedEmpid = data.empid.toString();
                    globals.new_selectedEmpid = data.empid.toString();

                    globals.Glb_second_new_selectedEmpid =
                        data.empid.toString();
                    globals.Employee_Code = data.EMPLOYEE_CD.toString();
                    globals.glb_deposits = data.deposits;
                    globals.Glb_empname = data.empname;
                    globals.Glb_business = data.business;
                    globals.Glb_balance = data.balance;
                    globals.Glb_mobileno = data.mobileno;
                    globals.glb_deposits = data.deposits;
                    globals.Glb_emailid = data.emailid;
                    globals.Glb_ACTIVE = data.acount.toString();
                    globals.Glb_IN_ACTIVE = data.icount.toString();
                    globals.Glb_TOTAL = data.total.toString();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManagerEmployees(
                          selectedDateIndex: 0,
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.account_box,
                      size: 25,
                      color: Color.fromARGB(255, 107, 114, 151),
                    ),
                    title: Text(
                      data.empname,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 19, 18, 18),
                      ),
                    ),
                    trailing: Text(
                      data.EMPLOYEE_CD,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 116, 111, 111),
                      ),
                    ),
                  ),
                ),
                Divider()
              ],
            ),
            children: [
              FutureBuilder<List<ManagerEMPDetails>>(
                future: _fetchManagerDetails(data.empid.toString(), context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SizedBox(
                        height: 60,
                        width: 60,
                        child: Center(
                          child: LoadingIndicator(
                            indicatorType: Indicator.ballClipRotateMultiple,
                            colors: Colors.primaries,
                            strokeWidth: 4.0,
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData) {
                    final salesManagerDetailsList = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: salesManagerDetailsList.map((managerDetail) {
                        return ListTile(
                          subtitle: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 2, 0, 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 8, 0, 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          globals.glb_session_id = "3";
                                          globals.new_selectedEmpid =
                                              data.empid.toString();
                                          globals.Glb_mobileno = data.mobileno;
                                          globals.Glb_Method = "Business";
                                          globals.Glb_emailid = data.emailid;
                                          globals.Glb_empname = data.empname;

                                          globals.Employee_Code =
                                              data.EMPLOYEE_CD.toString();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => businesss(
                                                      selectedIndex: 0,
                                                    )),
                                          );
                                        },
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets
                                              .zero, // Remove default padding
                                          minimumSize: Size(0,
                                              0), // Set minimum size to remove extra space
                                          tapTargetSize: MaterialTapTargetSize
                                              .shrinkWrap, // Shrink the tap target size
                                        ),
                                        child: Text(
                                          "(B)${managerDetail.business.toString()}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          globals.glb_session_id = "4";
                                          globals.Glb_Method = "Payments";
                                          globals.new_selectedEmpid =
                                              data.empid.toString();
                                          globals.Glb_empname = data.empname;

                                          globals.Employee_Code =
                                              data.EMPLOYEE_CD.toString();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => businesss(
                                                      selectedIndex: 0,
                                                    )),
                                          );
                                        },
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets
                                              .zero, // Remove default padding
                                          minimumSize: Size(0,
                                              0), // Set minimum size to remove extra space
                                          tapTargetSize: MaterialTapTargetSize
                                              .shrinkWrap, // Shrink the tap target size
                                        ),
                                        child: Text(
                                          "(P)" +
                                              managerDetail.deposits.toString(),
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                      Text(
                                          "(O)" +
                                              managerDetail.balance.toString(),
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.red)),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 6, 0, 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          'Active (' +
                                              managerDetail.active.toString() +
                                              ')',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromARGB(
                                                  255, 31, 190, 52))),
                                      Text(
                                          'Locked (' +
                                              managerDetail.inactive
                                                  .toString() +
                                              ')',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromARGB(
                                                  255, 202, 24, 24))),
                                      Text(
                                          'Total (' +
                                              managerDetail.total.toString() +
                                              ')',
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromARGB(
                                                  255, 64, 17, 190))),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 6, 0, 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      data.mobileno.toString() == "null"
                                          ? Text("",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey))
                                          : Text(data.mobileno.toString(),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey)),
                                      Spacer(),
                                      Text(data.emailid.toString(),
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: NoContent(),
                    );
                  }
                },
              ),
            ],
            onExpansionChanged: (bool expanded) {
              // Optional: Handle expansion state changes if needed
            },
          ),
        ),
      );
    }

    ListView salesDashboardListView(data, BuildContext context) {
      return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return _buildSalesCard(data[index], context, index);
          });
    }

    Widget All_Test_Widget(var data, BuildContext context) {
      return SingleChildScrollView(
        child: Column(
          children: [
            if (data.length > 0)
              Container(
                width: double.infinity,
                child: Card(
                  elevation: 7,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, top: 4, bottom: 4, right: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
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
                              data[0]['EMPLOYEE_NAME'],
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            SizedBox(
                              width: 30,
                            ),
                            SizedBox(
                              width: 80,
                              child: Text('Designation:',
                                  style: TextStyle(fontSize: 12)),
                            ),
                            Text(globals.Glb_DESIGNATION_NAME,
                                style: TextStyle(fontSize: 12)),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 30,
                            ),
                            SizedBox(
                              width: 80,
                              child: Text('Emp cd:',
                                  style: TextStyle(fontSize: 12)),
                            ),
                            Text(data[0]['EMPLOYEE_CD'],
                                style: TextStyle(fontSize: 12)),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 30,
                            ),
                            SizedBox(
                              width: 80,
                              child: Text('Email:',
                                  style: TextStyle(fontSize: 12)),
                            ),
                            Text(data[0]['EMAIL_ID'],
                                style: TextStyle(fontSize: 12)),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 30,
                            ),
                            SizedBox(
                              width: 80,
                              child: Text('Phone:',
                                  style: TextStyle(fontSize: 12)),
                            ),
                            Text(data[0]['MOBILE_PHONE'],
                                style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    function_widet() {
      return All_Test_Widget(globals.Glb_ManagerDetailsList, context);
    }

    return WillPopScope(
      onWillPop: () async {
        // Returning false prevents the back button action.
        return false;
      },
      child: Scaffold(
        appBar: topAppBar,
        body: Column(
          children: [
            SizedBox(height: 48, child: DateSelection()),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                  height: 15,
                  child: selecteFromdt == ""
                      ? Text(
                          "${selectedDate.toLocal()}".split(' ')[0] +
                              '  To   ' +
                              "${selectedDate.toLocal()}".split(' ')[0],
                          style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0))
                      : Text(selecteFromdt + '  To   ' + selecteTodt,
                          style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0))),
            ),

            // Padding(
            //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            //   child: Container(height: 100, child: function_widet()),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 4.0),
            //   child: Card(
            //     elevation: 4,
            //     color: Colors.white,
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Container(
            //           width: screenWidth * 0.75,
            //           height: screenHeight * 0.08,
            //           child: Padding(
            //             padding: const EdgeInsets.all(4.0),
            //             child: TextField(
            //               controller: _searchController,
            //               decoration: InputDecoration(
            //                 errorBorder: OutlineInputBorder(
            //                   borderRadius: BorderRadius.circular(16.0),
            //                   borderSide: const BorderSide(color: Colors.grey),
            //                 ),
            //                 enabledBorder: OutlineInputBorder(
            //                   borderRadius: BorderRadius.circular(16.0),
            //                   borderSide: const BorderSide(color: Colors.grey),
            //                 ),
            //                 focusedBorder: OutlineInputBorder(
            //                   borderRadius: BorderRadius.circular(16.0),
            //                   borderSide:
            //                       const BorderSide(color: Color(0xFF2262AB)),
            //                 ),
            //                 hintText: 'Search Client Code',
            //                 hintStyle: const TextStyle(color: Colors.grey),
            //                 prefixIcon: const Icon(Icons.person_search_outlined,
            //                     color: Color(0xFF1E429A)),
            //               ),
            //             ),
            //           ),
            //         ),
            //         SizedBox(
            //           width: screenWidth * 0.005,
            //         ),
            //         IconButton(
            //           icon: const Icon(Icons.search),
            //           onPressed: () {
            //             globals.Glb_Client_Code = _searchController.text;
            //             _searchController.text = "";
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) =>
            //                       Client_Search(selectedDateIndex: 0)),
            //             );
            //           },
            //         ),
            //       ],
            //     ),
            //   ),
            // ),

            Padding(
              padding: EdgeInsets.all(4.0),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {
                    // No need for logic here, just rebuilding the FutureBuilder
                  });
                },
                decoration: InputDecoration(
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 149, 149, 149),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 149, 149, 149),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 34, 98, 171),
                    ),
                  ),
                  // focusedErrorBorder: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(16.0),
                  //   borderSide: const BorderSide(
                  //     color: Color.fromARGB(255, 149, 149, 149),
                  //   ),
                  // ),
                  // You can customize other properties like fillColor, filled, hintText, etc.
                  hintText: 'Search Employee Code & Name',
                  hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 194, 193, 193)),
                  prefixIcon: const Icon(
                    Icons.person_search_outlined,
                    color: Color.fromARGB(255, 30, 66, 138),
                  ),
                ),
              ),
            ),
            globals.Glb_FILTER_BUSINESS_PAYMENTS == "Yes"
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Sort By:",
                        style: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 17, 17, 17),
                            fontWeight: FontWeight.bold),
                      ),
                      ToggleButtonRow(
                        onButtonPressed: (String selected) {
                          setState(() {
                            _futureManagers = _fetchSalespersons();
                          });
                        },
                      ),
                    ],
                  )
                : Container(),

            Expanded(
              child: FutureBuilder<List<SalesManagers>>(
                future: _futureManagers,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else if (!snapshot.hasData) {
                    return Center(
                      child: Text("No data found."),
                    );
                  } else {
                    var data = snapshot.data!;
                    // Filter data based on search query
                    if (_searchController.text.isNotEmpty) {
                      data = data
                          .where((client) =>
                              client.EMPLOYEE_CD.toLowerCase().contains(
                                  _searchController.text.toLowerCase()) ||
                              client.empname.toLowerCase().contains(
                                  _searchController.text.toLowerCase()))
                          .toList();
                    }
                    return salesDashboardListView(data, context);
                  }
                },
              ),
            ),

            // Container(

            //   child: verticalList,
            // ),
          ],
        ),
        bottomNavigationBar: const AllbottomNavigation(),
      ),
    );
  }
}

class ManagerEMPDetails {
  final String business;
  final String deposits;
  final String balance;
  final String active;
  final String inactive;
  final String total;

  ManagerEMPDetails({
    required this.business,
    required this.deposits,
    required this.balance,
    required this.active,
    required this.inactive,
    required this.total,
  });

  // Factory constructor to create a ManagerDetails instance from JSON
  factory ManagerEMPDetails.fromJson(Map<String, dynamic> json) {
    return ManagerEMPDetails(
      business: json['BUSINESS'] ?? '',
      deposits: json['DEPOSITS'] ?? '',
      balance: json['BALANCE'] ?? '',
      active: json['ACTIVE'].toString(),
      inactive: json['IN_ACTIVE'].toString(),
      total: json['TOTAL'].toString(),
    );
  }
}

class SalesManagers {
  final empid;
  final empname;
  final reportmgrid;
  final reportmgrname;
  final deposits;
  final business;
  final balance;
  final acount;
  final icount;
  final total;
  final mobileno;
  final emailid;
  final dayWiseTargetAmt;
  final dayWiseAchieveAmt;
  final EMPLOYEE_CD;

  SalesManagers({
    required this.empid,
    required this.empname,
    required this.reportmgrid,
    required this.reportmgrname,
    required this.deposits,
    required this.business,
    required this.balance,
    required this.acount,
    required this.icount,
    required this.total,
    required this.mobileno,
    required this.emailid,
    required this.dayWiseTargetAmt,
    required this.dayWiseAchieveAmt,
    required this.EMPLOYEE_CD,
  });
  factory SalesManagers.fromJson(Map<String, dynamic> json) {
    if (json['EMAIL_ID'] == "") {
      json['EMAIL_ID'] = 'Not Specified.';
    }
    return SalesManagers(
      empid: json['EMPLOYEE_ID'],
      empname: json['EMPLOYEE_NAME'],
      reportmgrid: json['REPORTING_MNGR_ID'],
      reportmgrname: json['REPORTING_MNGR_NAME'],
      deposits: json['DEPOSITS'],
      business: json['BUSINESS'],
      balance: json['BALANCE'],
      acount: json['ACTIVE'],
      icount: json['IN_ACTIVE'],
      total: json['TOTAL'],
      mobileno: json['MOBILE_PHONE'],
      emailid: json['EMAIL_ID'],
      dayWiseTargetAmt: json['DAY_WISE_TARGET_AMOUNT'],
      dayWiseAchieveAmt: json['DAY_WISE_ACHIEVED_AMOUNT'],
      EMPLOYEE_CD: json['EMPLOYEE_CD'],
    );
  }
}
// ExpansionTile(
//   title: Padding(
//     padding: const EdgeInsets.fromLTRB(23, 0, 0, 0),
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         data.mobileno.toString() == "null"
//             ? Text(
//                 "",
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w500,
//                   color: Color.fromARGB(255, 88, 135, 146),
//                 ),
//               )
//             : Text(
//                 data.mobileno.toString(),
//                 style: TextStyle(
//                   fontSize: 10,
//                   fontWeight: FontWeight.w500,
//                   color: Color.fromARGB(255, 88, 135, 146),
//                 ),
//               ),
//         Spacer(),
//         Text(
//           data.emailid.toString(),
//           style: TextStyle(
//             fontSize: 10,
//             fontWeight: FontWeight.w500,
//             color: Color.fromARGB(255, 88, 135, 146),
//           ),
//         ),
//       ],
//     ),
//   ),
//   onExpansionChanged: (expanded) {
//     setState(() {
//       _isLoading = true;
//     });
//     globals.Glb_Mng_business = "";
//     globals.Glb_Mng_deposits = "";
//     globals.Glb_Mng_balance = "";
//     globals.Glb_Mng_acount = "";
//     globals.Glb_Mng_icount = "";
//     globals.Glb_Mng_total = "";

//     setState(() {
//       _isLoading = false;
//     });
//     setState(() {
//       if (expanded) {
//         _expandedTileIndex = index;
//       } else if (_expandedTileIndex == index) {
//         _expandedTileIndex = -1;
//       }
//     });
//   },
//   initiallyExpanded: _expandedTileIndex == index,
//   children: _expandedTileIndex == index
//       ? [
//           FutureBuilder<List<ManagerEMPDetails>>(
//             future: _fetchManagerDetails(
//                 data.empid.toString(), context),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState ==
//                   ConnectionState.waiting) {
//                 return Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: SizedBox(
//                     height: 60,
//                     width: 60,
//                     child: Center(
//                       child: LoadingIndicator(
//                         indicatorType:
//                             Indicator.ballClipRotateMultiple,
//                         colors: Colors.primaries,
//                         strokeWidth: 4.0,
//                       ),
//                     ),
//                   ),
//                 );
//               } else if (snapshot.hasError) {
//                 return Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Text('Error: ${snapshot.error}'),
//                 );
//               } else if (snapshot.hasData) {
//                 final salesManagerDetailsList = snapshot.data!;
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: salesManagerDetailsList
//                       .map((managerDetail) {
//                     return Padding(
//                       padding:
//                           const EdgeInsets.fromLTRB(20, 0, 15, 8),
//                       child: Column(children: [
//                         Row(
//                           mainAxisAlignment:
//                               MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "(B)  " +
//                                   managerDetail.business
//                                       .toString(),
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.green,
//                               ),
//                             ),
//                             Text(
//                               "(P)  " +
//                                   managerDetail.deposits
//                                       .toString(),
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.blue,
//                               ),
//                             ),
//                             Text(
//                               "(O)  " +
//                                   managerDetail.balance
//                                       .toString(),
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.red,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           mainAxisAlignment:
//                               MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Active (' +
//                                   managerDetail.active +
//                                   ')',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w500,
//                                 color: Color.fromARGB(
//                                     255, 31, 190, 52),
//                               ),
//                             ),
//                             Text(
//                               'Locked (' +
//                                   managerDetail.inactive +
//                                   ')',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w500,
//                                 color: Color.fromARGB(
//                                     255, 202, 24, 24),
//                               ),
//                             ),
//                             Text(
//                               'Total (' +
//                                   managerDetail.total +
//                                   ')',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w500,
//                                 color: Color.fromARGB(
//                                     255, 64, 17, 190),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ]),
//                     ); // Example field from patientDetail
//                   }).toList(),
//                 );
//               } else {
//                 return Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: NoContent3(),
//                 );
//               }
//             },
//           ),
//         ]
//       : [],
// ),

class ToggleButtonRow extends StatefulWidget {
  final Function(String) onButtonPressed;

  const ToggleButtonRow({Key? key, required this.onButtonPressed})
      : super(key: key);

  @override
  _ToggleButtonRowState createState() => _ToggleButtonRowState();
}

class _ToggleButtonRowState extends State<ToggleButtonRow> {
  String selectedButton = "B"; // Default selected button

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Container(
      color: Colors.white,
      height: 50, // Adjust the height as needed
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: screenWidth * 0.3,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  globals.Glb_Flag = "A_B";
                  selectedButton = "B";
                  widget.onButtonPressed(selectedButton);
                });
              },
              child: const Text('Business'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                backgroundColor: selectedButton == "B"
                    ? Colors.green // Active color
                    : Colors.blueGrey, // Inactive color
              ),
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: screenWidth * 0.3,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  globals.Glb_Flag = "A_P";
                  selectedButton = "P";
                  widget.onButtonPressed(selectedButton);
                });
              },
              child: const Text('Payments'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                backgroundColor: selectedButton == "P"
                    ? Colors.blue // Active color
                    : Colors.blueGrey, // Inactive color
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NoContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}
