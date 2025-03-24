import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';
import 'ManagerEmployees.dart';
import 'add_company.dart';
import 'allbottomnavigationbar.dart';
import 'New_Login.dart';
import './report.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './allinone.dart';
import 'LocationWiseBusiness.dart';
import 'client_by_search.dart';
import 'clients_search.dart';
import 'globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

double amount = 0;

TextEditingController _Mobile_NoController = TextEditingController();
TextEditingController _billnoController = TextEditingController();

TextEditingController Client_Code_Controller = TextEditingController();

var Dashboarddatasetval = [];

class SalesManagerDashboard extends StatefulWidget {
  String empID = "0";
  int selectedIndex;
  SalesManagerDashboard(String iEmpid, this.selectedIndex) {
    empID = iEmpid;
    this.empID = iEmpid;
  }

  @override
  State<SalesManagerDashboard> createState() =>
      _SalesManagerDashboardState(this.empID, this.selectedIndex);
}

class _SalesManagerDashboardState extends State<SalesManagerDashboard> {
  bool isLoading = false;
  bool _validate = false;
  DateTime selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();

    globals.Glb_ManagerDetailsList = [];

    globals.Glb_myUpdateData = "";
    globals.Glb_CMP_AMOUNTS = "";
    globals.Glb_COMPANY_WISE_LAST_PAYMENT = "";
    globals.Glb_IN_ACTIVE = "";
    globals.Glb_ACTIVE = "";
    globals.Glb_TOTAL = "";
    globals.Glb_empname = "";
    globals.Glb_business = "";
    globals.glb_deposits = "";
    globals.Glb_balance = "";
    globals.Glb_mobileno = "";
  }

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
          globals.fromDate = selected.start.toString().split(' ')[0];
          globals.ToDate = selected.end.toString().split(' ')[0];
          print(amount);
        });
      }
    }
  }

  int selectedIndex;
  var selecteFromdt = '';
  var selecteTodt = '';
  String empID = "0";
  _SalesManagerDashboardState(String iEmpid, this.selectedIndex) {
    this.empID = iEmpid;
  }

  String date = "";

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
            backgroundColor: selectedIndex == index && globals.fromDate == ''
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
            selectedIndex = index;
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

            var prevMonth1stday =
                DateTime.utc(DateTime.now().year, DateTime.now().month - 1, 1);
            var prevMonthLastday = DateTime.utc(
              DateTime.now().year,
              DateTime.now().month - 0,
            ).subtract(Duration(days: 1));

            if (selectedIndex == 0) {
              // Today
              total_amouont = "";
              selecteFromdt = formatter.format(now);
              selecteTodt = formatter.format(now);
            } else if (selectedIndex == 1) {
              // yesterday
              total_amouont = "";
              selecteFromdt = formatter.format(yesterday);
              selecteTodt = formatter.format(yesterday);
            } else if (selectedIndex == 2) {
              // LastWeek
              total_amouont = "";
              selecteFromdt = formatter.format(lastWeek1stDay);
              selecteTodt = formatter.format(lastWeekLastDay);
            } else if (selectedIndex == 3) {
              total_amouont = "";
              selecteFromdt = formatter.format(thisweek);
              selecteTodt = formatter.format(now);
            } else if (selectedIndex == 4) {
              // Last Month
              total_amouont = "";
              selecteFromdt = formatter.format(prevMonth1stday);
              selecteTodt = formatter.format(prevMonthLastday);
            } else if (selectedIndex == 5) {
              total_amouont = "";
              selecteFromdt = formatter.format(thismonth);
              selecteTodt = formatter.format(now);
            }
            Dashboarddatasetval = [];
            print("From Date " + selecteFromdt);
            print("To Date " + selecteTodt);
            print(selectedIndex);
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
        "FrequencyId": "5",
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

//Date Selection...........................................
  @override
  Widget build(BuildContext context) {
    globals.tab_index = this.selectedIndex.toString();
    final DateFormat formatter1 = DateFormat('dd-MMM-yyyy');
    var now = DateTime.now();
    String flag = "call";

    if (globals.fromDate != "") {
      selecteFromdt = globals.fromDate;
      selecteTodt = globals.ToDate;
    } else if (selecteTodt == '') {
      selecteFromdt = formatter1.format(now);
      selecteTodt = formatter1.format(now);
    }
    void clearText() {
      _Mobile_NoController.clear();
      _billnoController.clear();
    }

    Future<List<ManagerDetails>> _fetchManagerDetails(String sessionID) async {
      // if (Dashboarddatasetval != null && Dashboarddatasetval.isNotEmpty) {
      //   return Dashboarddatasetval.map(
      //       (strans) => ManagerDetails.fromJson(strans)).toList();
      // }

      // Check if login verification is true
      if (globals.Login_verification == "false") {
        // Return an empty list or handle the condition as needed
        return [];
      }

      Dashboarddatasetval = [];

      globals.Glb_myUpdateData = "";
      globals.Glb_CMP_AMOUNTS = "";
      globals.Glb_COMPANY_WISE_LAST_PAYMENT = "";
      Map data = {
        "employee_id": globals.loginEmpid, "session_id": sessionID,
        "from_dt": selecteFromdt == ""
            ? "${selectedDate.toLocal()}".split(' ')[0]
            : selecteFromdt,
        "to_dt": selecteTodt == ""
            ? "${selectedDate.toLocal()}".split(' ')[0]
            : selecteTodt,
        "connection": globals.Connection_Flag
        //"Server_Flag":""
      };
      final jobsListAPIUrl =
          Uri.parse(globals.API_url + '/MobileSales/ManagerEmpDetails');
      var response = await http.post(jobsListAPIUrl,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: data,
          encoding: Encoding.getByName("utf-8"));

      if (response.statusCode == 200) {
        Map<String, dynamic> resposne = jsonDecode(response.body);
        Map<String, dynamic> user = resposne['Data'][0];
        globals.Glb_IN_ACTIVE = user['IN_ACTIVE'].toString();
        globals.Glb_ACTIVE = user['ACTIVE'].toString();
        globals.Glb_TOTAL = user['TOTAL'].toString();
        globals.Glb_empname = user['EMPLOYEE_NAME'].toString();
        globals.Glb_business = user['BUSINESS'].toString();
        globals.glb_deposits = user['DEPOSITS'].toString();
        globals.Glb_balance = user['BALANCE'].toString();
        globals.Glb_mobileno = user['MOBILE_PHONE'].toString();
        globals.selectedEmpid = user['EMPLOYEE_ID'].toString();
        globals.new_selectedEmpid = user['EMPLOYEE_ID'].toString();
        globals.Employee_Code = user['EMPLOYEE_CD'].toString();
        if (globals.Glb_IS_LOCK_REQ == "null" ||
            globals.Glb_IS_LOCK_REQ == "") {
          globals.Glb_IS_LOCK_REQ = user['IS_LOCK_REQ'].toString();
        }

        globals.Glb_emailid = user['EMAIL_ID'].toString();
        globals.Glb_myUpdateData = user['COMPANY_CDS'].toString();
        globals.Glb_COMPANY_WISE_LAST_PAYMENT =
            user['COMPANY_WISE_LAST_PAYMENT'].toString();
        globals.Glb_CMP_AMOUNTS = user['CMP_AMOUNTS'].toString();

        if (globals.Glb_ManagerDetailsList.isEmpty && sessionID == "1") {
          globals.Glb_ManagerDetailsList.add({
            'EMPLOYEE_NAME': globals.Glb_empname,
            'EMPLOYEE_CD': globals.Employee_Code,
            'MOBILE_PHONE': globals.Glb_mobileno,
            'EMAIL_ID': globals.Glb_emailid
          });
        }

        Dashboarddatasetval = jsonDecode(response.body)["Data"];
        List jsonResponse = resposne["Data"];

        return jsonResponse
            .map((managers) => ManagerDetails.fromJson(managers))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget _buildManagerDetails(var data, BuildContext context, index) {
      // Split the data by commas to create lists

      final List<String> cmpAmountsList = globals.Glb_CMP_AMOUNTS.split(',');
      final List<String> cmpPaymentDateList =
          globals.Glb_COMPANY_WISE_LAST_PAYMENT.split(',');
      return Column(
        children: [
          GestureDetector(
              child: Container(
            color: const Color.fromARGB(255, 250, 248, 248),
            child: Column(children: [
              Divider(
                thickness: 1.0,
                color: Colors.grey[300],
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 0),
                  child: Container(
                    width: double.infinity,
                    child: Card(
                      elevation: 7,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
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
                                    )),
                                Text(
                                  data.empname,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
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
                                        style: TextStyle(fontSize: 12))),
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
                                        style: TextStyle(fontSize: 12))),
                                Text(globals.Employee_Code,
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
                                        style: TextStyle(fontSize: 12))),
                                Text(data.emailid,
                                    style: TextStyle(fontSize: 12))
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
                                        style: TextStyle(fontSize: 12))),
                                Text(data.mobileno,
                                    style: TextStyle(fontSize: 12))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 4.0,
                  child: Column(
                    children: [
                      // InkWell(
                      //   child: Padding(
                      //     padding:
                      //         const EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                      //     child: Row(
                      //       children: [
                      //         Expanded(
                      //           child: TextFormField(
                      //             controller: Client_Code_Controller,
                      //             decoration: InputDecoration(
                      //               hintText: "Enter Client Code",
                      //               contentPadding: EdgeInsets.symmetric(
                      //                   vertical: 10.0, horizontal: 10.0),
                      //               border: OutlineInputBorder(
                      //                 borderRadius: BorderRadius.circular(8.0),
                      //                 borderSide: BorderSide(
                      //                   color: Colors.blueAccent,
                      //                   width: 2.0,
                      //                 ),
                      //               ),
                      //               focusedBorder: OutlineInputBorder(
                      //                 borderRadius: BorderRadius.circular(8.0),
                      //                 borderSide: BorderSide(
                      //                   color: Colors.blue,
                      //                   width: 2.0,
                      //                 ),
                      //               ),
                      //               errorText: _validate
                      //                   ? 'Please enter a client code'
                      //                   : null,
                      //             ),
                      //             onChanged: (text) {
                      //               if (_validate != text.isEmpty) {
                      //                 setState(() {
                      //                   _validate = text.isEmpty;
                      //                 });
                      //               }
                      //             },
                      //           ),
                      //         ),
                      //         SizedBox(width: 8.0),
                      //         Container(
                      //           decoration: BoxDecoration(
                      //             border: Border.all(
                      //                 color: Colors.blueAccent, width: 2.0),
                      //             borderRadius: BorderRadius.circular(8.0),
                      //           ),
                      //           child: IconButton(
                      //             icon: Icon(Icons.search),
                      //             color: Colors.blue,
                      //             onPressed: () {
                      //               if (Client_Code_Controller.text.isEmpty) {
                      //                 setState(() {
                      //                   _validate = true;
                      //                 });
                      //               } else {
                      //                 setState(() {
                      //                   _validate = false;
                      //                 });
                      //                 globals.Glb_Client_Code =
                      //                     Client_Code_Controller.text;
                      //                 Client_Code_Controller.text = "";
                      //                 globals.new_selectedEmpid =
                      //                     data.empid.toString();

                      //                 Navigator.push(
                      //                   context,
                      //                   MaterialPageRoute(
                      //                     builder: (context) => Client_Search(),
                      //                   ),
                      //                 );
                      //               }
                      //             },
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      //   onTap: () {
                      //     // Handle InkWell tap
                      //   },
                      // ),
                      // Divider(
                      //   thickness: 1.0,
                      //   color: Colors.grey[300],
                      // ),
                      (int.parse(data.mngrcnt.toString()) > 1)
                          ? InkWell(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    15.0, 2.0, 15.0, 2.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.groups_sharp,
                                        color: Colors.deepOrange),
                                    const SizedBox(
                                      height: 40,
                                      width: 10,
                                    ),
                                    SizedBox(
                                      width: 200,
                                      child: const Text('My Team',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                    Icon(
                                      Icons.double_arrow_rounded,
                                      color: Colors.grey.withOpacity(0.3),
                                      size: 30.0,
                                    ),
                                    const Spacer(),
                                    Text(data.mngrcnt.toString(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500))
                                  ],
                                ),
                              ),
                              onTap: () {
                                globals.Navigate_mngrcnt =
                                    data.mngrcnt.toString();
                                globals.Glb_empname = "";
                                globals.Employee_Code = "";
                                globals.Glb_IS_LOCK_REQ =
                                    data.IS_LOCK_REQ.toString();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AllinOne(selectedDateIndex: 0)));
                              })
                          : InkWell(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    15.0, 2.0, 15.0, 2.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.groups_sharp,
                                        color: Colors.deepOrange),
                                    const SizedBox(
                                      height: 40,
                                      width: 10,
                                    ),
                                    SizedBox(
                                      width: 200,
                                      child: const Text('My Clients',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                    const Spacer(),
                                    Text(data.My_Clients.toString(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500))
                                  ],
                                ),
                              ),
                              onTap: () {
                                globals.Navigate_mngrcnt =
                                    data.mngrcnt.toString();
                                globals.Glb_second_new_selectedEmpid =
                                    data.empid;
                                globals.Glb_IN_ACTIVE = data.InActive;
                                globals.Glb_ACTIVE = data.Active;
                                globals.Glb_TOTAL = data.My_Clients;
                                globals.Glb_empname = data.empname;
                                globals.Glb_business = data.business;
                                globals.glb_deposits = data.deposits;
                                globals.Glb_balance = data.balance;
                                globals.Glb_mobileno = data.mobileno;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ManagerEmployees(
                                              selectedDateIndex: 0,
                                            )));
                              }),
                      Divider(
                        thickness: 1.0,
                        color: Colors.grey[300],
                      ),
                      InkWell(
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                            child: Row(
                              children: [
                                const Icon(Icons.business_sharp,
                                    color: Color.fromARGB(255, 90, 136, 236)),
                                const SizedBox(
                                  height: 40,
                                  width: 10,
                                ),
                                const Text('Business',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500)),
                                const Spacer(),
                                Text(data.business.toString(),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500))
                              ],
                            ),
                          ),
                          onTap: () {}),
                      Divider(
                        thickness: 1.0,
                        color: Colors.grey[300],
                      ),
                      InkWell(
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                            child: Row(
                              children: [
                                const Icon(Icons.payments_outlined,
                                    color: Color.fromARGB(255, 163, 230, 165)),
                                const SizedBox(
                                  height: 40,
                                  width: 10,
                                ),
                                const Text('Deposits',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500)),
                                const Spacer(),
                                Text(data.deposits.toString(),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500))
                              ],
                            ),
                          ),
                          onTap: () {}),
                      Divider(
                        thickness: 1.0,
                        color: Colors.grey[300],
                      ),
                      ExpansionTile(
                        title: Row(
                          children: [
                            const Icon(Icons.money_rounded,
                                color: Color.fromARGB(255, 20, 169, 206)),
                            const SizedBox(
                              height: 20,
                              width: 10,
                            ),
                            const Text('Outstanding',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500)),
                            // const Spacer(),
                            // Text(data.balance.toString(),
                            //     style: const TextStyle(
                            //         color: Colors.black,
                            //         fontWeight: FontWeight.w500))
                          ],
                        ),
                        children: <Widget>[
                          // Using FutureBuilder to fetch data and display inside the ExpansionTile
                          FutureBuilder<List<ManagerDetails>>(
                            future: _fetchManagerDetails("2"),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: Center(
                                      child: LoadingIndicator(
                                        indicatorType:
                                            Indicator.ballClipRotateMultiple,
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
                                  children: salesManagerDetailsList
                                      .map((managerDetail) {
                                    return ListTile(
                                      trailing: Text(managerDetail.balance,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight
                                                  .w500)), // Example field from patientDetail
                                      // subtitle: Text('Details: ${patientDetail.details}'
                                    ); // Example field from patientDetail
                                  }).toList(),
                                );
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: NoContent3(),
                                );
                              }
                            },
                          ),
                        ],
                        onExpansionChanged: (bool expanded) {
                          // Optional: Handle expansion state changes if needed
                          Dashboarddatasetval = [];
                        },
                      ),

                      Divider(
                        thickness: 1.0,
                        color: Colors.grey[300],
                      ),

                      (int.parse(data.mngrcnt.toString()) > 1)
                          ? InkWell(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    15.0, 2.0, 15.0, 2.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.person,
                                        color: Colors.blue),
                                    const SizedBox(
                                      height: 40,
                                      width: 10,
                                    ),
                                    SizedBox(
                                      width: 200,
                                      child: const Text('Clients Count',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                    Icon(
                                      Icons.double_arrow_rounded,
                                      color: Colors.grey.withOpacity(0.3),
                                      size: 30.0,
                                    ),
                                    const Spacer(),
                                    Text(data.My_Clients.toString(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500))
                                  ],
                                ),
                              ),
                              onTap: () {
                                globals.new_selectedEmpid =
                                    data.empid.toString();

                                globals.Glb_empname = data.empname.toString();
                                globals.Glb_emailid = data.emailid.toString();
                                globals.Glb_mobileno = data.mobileno.toString();
                                globals.Employee_Code.toString();

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage(
                                            globals.new_selectedEmpid =
                                                data.empid.toString())));
                              })
                          : Container(),
                      (int.parse(data.mngrcnt.toString()) > 1)
                          ? Divider(
                              thickness: 1.0,
                              color: Colors.grey[300],
                            )
                          : Container(),
                      InkWell(
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.report_gmailerrorred,
                                        color:
                                            Color.fromARGB(255, 104, 9, 228)),
                                    SizedBox(
                                      height: 40,
                                      width: 10,
                                    ),
                                    Text('Reports',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500)),
                                    Spacer(),
                                    Spacer(),
                                    Icon(Icons.double_arrow,
                                        color: Color.fromARGB(255, 9, 228, 75)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(32.0))),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Mobile No. :'),
                                        TextField(
                                          controller: _Mobile_NoController,
                                          decoration: InputDecoration(
                                              hintText:
                                                  "Enter here Mobile No. "),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Center(
                                          child: Text('OR',
                                              style: TextStyle(
                                                  color: Colors.indigo)),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text('Bill No.:'),
                                        TextField(
                                          controller: _billnoController,
                                          decoration: InputDecoration(
                                              hintText:
                                                  "Enter here Bill No.:  "),
                                        ),
                                        Center(
                                          child: SizedBox(
                                            height: 50,
                                            width: 100,
                                            child: InkWell(
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18)),
                                                color: Colors.green,
                                                child: Center(
                                                    child: Text(
                                                  'OK',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                )),
                                              ),
                                              onTap: () {
                                                // ClientChannelDeptWise(5, 0);

                                                if (_billnoController.text ==
                                                        "" &&
                                                    _Mobile_NoController.text ==
                                                        "") {
                                                  // return false;

                                                  Fluttertoast.showToast(
                                                      msg: "Enter Valid Number",
                                                      toastLength:
                                                          Toast.LENGTH_SHORT,
                                                      gravity:
                                                          ToastGravity.CENTER,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor:
                                                          Color.fromARGB(
                                                              255, 180, 17, 17),
                                                      textColor: Colors.white,
                                                      fontSize: 16.0);
                                                }

                                                if (_billnoController.text !=
                                                        "" ||
                                                    _Mobile_NoController.text !=
                                                        "") {
                                                  globals.mobile_no =
                                                      _Mobile_NoController.text;
                                                  globals.bill_no =
                                                      _billnoController.text;
                                                  ReportData(5, 0);
                                                  Navigator.pop(context);
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ReportData(
                                                                  0, 0)));
                                                }
                                                clearText();
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          }),
                      globals.Glb_IS_ACCESS_ADD_CLIENT == "Y"
                          ? Divider(
                              thickness: 1.0,
                              color: Colors.grey[300],
                            )
                          : Container(),
                      globals.Glb_IS_ACCESS_ADD_CLIENT == "Y"
                          ? InkWell(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    15.0, 2.0, 15.0, 2.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.add_comment_outlined,
                                            color: Color.fromARGB(
                                                255, 233, 20, 197)),
                                        SizedBox(
                                          height: 40,
                                          width: 10,
                                        ),
                                        Text('Add Franchise/Client',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w500)),
                                        Spacer(),
                                        Spacer(),
                                        Icon(Icons.double_arrow,
                                            color: Color.fromARGB(
                                                255, 19, 32, 207)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CompanyAddScreen()));
                              })
                          : Container(),
                      // globals.Glb_IS_ACCESS_ADD_CLIENT == "Y"
                      //     ? Divider(
                      //         thickness: 1.0,
                      //         color: Colors.grey[300],
                      //       )
                      //     : Container(),
                      // globals.Glb_IS_ACCESS_ADD_CLIENT == "Y"
                      //     ? InkWell(
                      //         child: Padding(
                      //           padding: const EdgeInsets.fromLTRB(
                      //               15.0, 2.0, 15.0, 2.0),
                      //           child: Column(
                      //             children: [
                      //               Row(
                      //                 children: [
                      // Icon(Icons.password,
                      //     color: Color.fromARGB(
                      //         255, 104, 9, 228)),
                      // SizedBox(
                      //   width: 10,
                      // ),
                      //                   Text('Reset Password',
                      //                       style: TextStyle(
                      //                           color: Colors.black,
                      //                           fontWeight:
                      //                               FontWeight.w500)),
                      //                   Spacer(),
                      //                   Spacer(),
                      //                   Icon(Icons.double_arrow,
                      //                       color: Color.fromARGB(
                      //                           255, 241, 238, 61)),
                      //                 ],
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //         onTap: () {
                      //           Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                   builder: ((context) =>
                      //                       const newPassPopup())));
                      //         })
                      //     : Container(),
                      Divider(
                        thickness: 1.0,
                        color: Colors.grey[300],
                      ),
                      // InkWell(
                      //     child: ExpansionTile(
                      //       title: Row(
                      //         children: [
                      //           Icon(Icons.recent_actors_sharp,
                      //               color:
                      //                   Color.fromARGB(255, 104, 9, 228)),
                      //           SizedBox(
                      //             width: 10,
                      //           ),
                      //           Text("Recent Payment",
                      //               style: TextStyle(
                      //                   color: Colors.black,
                      //                   fontWeight: FontWeight.w500)),
                      //         ],
                      //       ), // Replace "Title" with your desired title
                      //       children: [
                      //         // Column(
                      //         //   children: [
                      //         //     ListTile(
                      //         //       leading: Container(
                      //         //         height: 20,
                      //         //         width: 20,
                      //         //         color: Color(0xff123456),
                      //         //         clipBehavior: Clip.antiAlias,
                      //         //         decoration: ShapeDecoration(
                      //         //             shape: RoundedRectangleBorder(
                      //         //                 borderRadius:
                      //         //                     BorderRadius.circular(8))),
                      //         //         child: Icon(Icons.trending_up_sharp),
                      //         //       ),
                      //         //     ),
                      //         //   ],
                      //         // )
                      //         Padding(
                      //           padding: const EdgeInsets.fromLTRB(
                      //               30.0, 2.0, 15.0, 2.0),
                      //           child: Column(
                      //             children: [
                      //               ListTile(
                      //                 contentPadding: EdgeInsets.zero,
                      //                 title: Row(
                      //                   mainAxisAlignment:
                      //                       MainAxisAlignment
                      //                           .spaceBetween,
                      //                   children: [
                      //                     Container(
                      //                       width: 50,
                      //                       child: Text(
                      //                         globals.Glb_myUpdateData
                      //                                 .split(',')
                      //                             .join('\n'),
                      //                         textAlign: TextAlign.start,
                      //                         style:
                      //                             TextStyle(fontSize: 12),
                      //                       ),
                      //                     ),
                      //                     Container(
                      //                       width: 40,
                      //                       child: Text(
                      //                         globals.Glb_CMP_AMOUNTS
                      //                                 .split(',')
                      //                             .join('\n'),
                      //                         textAlign: TextAlign.start,
                      //                         style:
                      //                             TextStyle(fontSize: 12),
                      //                       ),
                      //                     ),
                      //                     Spacer(),
                      //                     Container(
                      //                       width: 180,
                      //                       child: Text(
                      //                         globals.Glb_COMPANY_WISE_LAST_PAYMENT
                      //                                 .split(',')
                      //                             .join('\n'),
                      //                         textAlign: TextAlign.start,
                      //                         style:
                      //                             TextStyle(fontSize: 12),
                      //                       ),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //     onTap: () {})
                      ExpansionTile(
                        title: Row(
                          children: [
                            Icon(
                              Icons.recent_actors_sharp,
                              color: Color.fromARGB(255, 104, 9, 228),
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Recent Payments",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        children: [
                          FutureBuilder<List<ManagerDetails>>(
                            future: _fetchManagerDetails("2"),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: Center(
                                      child: LoadingIndicator(
                                        indicatorType:
                                            Indicator.ballClipRotateMultiple,
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
                                  children: salesManagerDetailsList
                                      .map((managerDetail) {
                                    final List<String> CodeDataList =
                                        managerDetail.COMPANY_CDS.split(',');

                                    final List<String> cmpAmountsList =
                                        managerDetail.CMP_AMOUNTS.split(',');
                                    final List<String> cmpPaymentDateList =
                                        managerDetail.COMPANY_WISE_LAST_PAYMENT
                                            .split(',');
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.0, vertical: 2.0),
                                      child: Column(
                                        children: List.generate(
                                            CodeDataList.length, (index) {
                                          return Column(
                                            children: [
                                              ListTile(
                                                leading: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 4.0),
                                                  child: Container(
                                                    height: 26,
                                                    width: 26,
                                                    decoration: BoxDecoration(
                                                      color: Color.fromARGB(
                                                          255, 31, 96, 161),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Center(
                                                      child: Icon(
                                                        Icons.trending_down,
                                                        color: Colors.white,
                                                        size: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                title: Text(CodeDataList[index],
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    )),
                                                subtitle: Text(
                                                    cmpPaymentDateList[index],
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.grey)),
                                                trailing: Text(
                                                    cmpAmountsList[index],
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Color.fromARGB(
                                                            255, 211, 77, 68))),
                                              ),
                                              if (index !=
                                                  CodeDataList.length - 1)
                                                Divider(),
                                            ],
                                          );
                                        }),
                                      ),
                                    );
                                  }).toList(),
                                );
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: NoContent3(),
                                );
                              }
                            },
                          ),
                        ],
                        onExpansionChanged: (bool expanded) {
                          Dashboarddatasetval = [];

                          // Optional: Handle expansion state changes if needed
                        },
                      ),
                    ],
                  ),
                ),
              )
            ]),
          )),
        ],
      );
    }

    Widget _buildCombinedManagerDetails(
        dynamic data, BuildContext context, int index) {
      return Column(
        children: [
          // _buildManagerDetails2(data, context, index),
          _buildManagerDetails(data, context, index),
        ],
      );
    }

    ListView ManagerDetailsDasboardListView(data, BuildContext context) {
      return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return _buildCombinedManagerDetails(data[index], context, index);
          });
    }

    Widget verticalListManagerDetails = Container(
        height: MediaQuery.of(context).size.height * 0.72,
        child: FutureBuilder<List<ManagerDetails>>(
            future: _fetchManagerDetails("1"),
            builder: (context, snapshot) {
              if (snapshot.hasData && Dashboarddatasetval.length > 0) {
                var data = snapshot.data;
                return SizedBox(
                    child: ManagerDetailsDasboardListView(data, context));
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return SizedBox(
                height: 100,
                width: 100,
                child: Center(
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballClipRotateMultiple,
                    colors: Colors.primaries,
                    strokeWidth: 4.0,
                  ),
                ),
              );
            }));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Builder(
                builder: (context) => IconButton(
                  icon: Image(image: NetworkImage(globals.Logo)),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            ),
            Text('Sales Dashboard'),
            Spacer(),
            IconButton(
              icon: Icon(Icons.date_range_outlined),
              onPressed: () {
                _CenterWiseBusinessDate(context);
              },
            ),
          ],
        ),
        backgroundColor: const Color(0xff123456),
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: const Color(0xff123456),
              ),
              child: Container(
                child: Column(
                  children: [
                    const Text(
                      'Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: Image(image: NetworkImage(globals.Logo)),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      globals.EmpName,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    Text(
                      globals.MailId,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
                onTap: () async {
                  Dashboarddatasetval = [];
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  // Remove multiple data entries
                  prefs.clear();
                  // prefs.remove('USER_NAME');
                  // prefs.remove('USER_ID');
                  // prefs.remove('REFERENCE_ID');
                  // prefs.remove('REFERENCE_ID');
                  // prefs.remove('EMP_CD');
                  // prefs.remove('EMAIL_ID');
                  // prefs.remove('EMP_NAME');
                  // prefs.remove('EMAIL_ID');
                  // prefs.remove('BILL_COUNT');
                  // prefs.remove('SRV_COUNT');
                  // prefs.remove('GROSS');
                  // prefs.remove('NET_AMOUNT');
                  // prefs.remove('DISCOUNT');
                  // prefs.remove('CANCELLED');
                  // prefs.remove('GROSS_AMOUNT');
                  // prefs.remove('NET_AMOUNT');
                  // prefs.remove('SAMPLES');
                  // prefs.remove('IS_REQ_BUSINESS');
                  // prefs.remove('REFERENCE_TYPE_ID');
                  // prefs.remove('SESSION_ID');
                  // prefs.remove('IS_ACCESS_ADD_CLIENT');
                  // prefs.remove('CONNECTION_STRING');
                  // prefs.remove('REPORT_URL');
                  // prefs.remove('API_URL');
                  // prefs.remove('COMPANY_LOGO');
                  // prefs.remove('username');
                  // prefs.remove('username');

                  globals.USER_ID = '';
                  globals.loginEmpid = '';
                  globals.selectedEmpid = '';
                  globals.Employee_Code = '';
                  globals.MailId = '';
                  globals.EmpName = '';
                  globals.Glb_emailid = '';
                  globals.BILL_COUNT = '';
                  globals.SRV_COUNT = '';
                  globals.GROSS = '';
                  globals.NET = '';
                  globals.DISCOUNT = '';
                  globals.CANCELLED = '';
                  globals.Sales_Gross = '';
                  globals.Sales_Net = '';
                  globals.Sales_Samples = '';
                  globals.Glb_IS_REQ_BUSINESS = '';
                  globals.reference_type_id = '';
                  globals.Glb_SESSION_ID = '';
                  globals.Glb_IS_ACCESS_ADD_CLIENT = '';
                  globals.Connection_Flag = '';
                  globals.Report_URL = '';
                  globals.API_url = '';
                  globals.Logo = '';

                  globals.glb_user_name = '';
                  globals.glb_password = '';
                  globals.Login_verification = "false";
                  globals.Glb_ManagerDetailsList = [];

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginClass()),
                  );
                },
                leading: const Icon(Icons.logout_rounded),
                title: const Text("Log Out"))
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
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
            Container(
              child: verticalListManagerDetails,
            ),
          ],
        ),
      ),
      bottomNavigationBar: AllbottomNavigation(),
    );
  }
}

class ManagerDetails {
  final empid;
  final empname;
  final reportmgrid;
  final reportmgrname;
  final deposits;
  final business;
  final balance;
  final InActive;
  final Active;
  final My_Clients;
  final mobileno;
  final emailid;
  final mngrcnt;
  final monthWiseAchieveAmt;
  final monthWiseTargetAmt;
  final dayWiseAchieveAmt;
  final dayWiseTargetAmt;
  final Total_CWB_AMOUNTS;
  final GROSS_AMOUNT;
  final NET_AMOUNT;
  final ORDERS;
  final SAMPLES;
  final LAB_BUSINESS;
  final RAD_BUSINESS;
  final COMPANY_CDS;
  final COMPANY_WISE_LAST_PAYMENT;
  final CMP_AMOUNTS;
  final IS_LOCK_REQ;
  final EMPLOYEE_CD;

  ManagerDetails(
      {required this.empid,
      required this.empname,
      required this.reportmgrid,
      required this.reportmgrname,
      required this.deposits,
      required this.business,
      required this.balance,
      required this.InActive,
      required this.Active,
      required this.My_Clients,
      required this.mobileno,
      required this.emailid,
      required this.mngrcnt,
      required this.monthWiseAchieveAmt,
      required this.monthWiseTargetAmt,
      required this.dayWiseAchieveAmt,
      required this.dayWiseTargetAmt,
      required this.Total_CWB_AMOUNTS,
      required this.GROSS_AMOUNT,
      required this.NET_AMOUNT,
      required this.ORDERS,
      required this.SAMPLES,
      required this.LAB_BUSINESS,
      required this.RAD_BUSINESS,
      required this.COMPANY_CDS,
      required this.COMPANY_WISE_LAST_PAYMENT,
      required this.CMP_AMOUNTS,
      required this.IS_LOCK_REQ,
      required this.EMPLOYEE_CD});
  factory ManagerDetails.fromJson(Map<String, dynamic> json) {
    if (json['EMPLOYEE_NAME'].toString() == "null") {
      json['EMPLOYEE_NAME'] = "";
    }
    if (json['MNGR_CNT'].toString() == "null") {
      json['MNGR_CNT'] = "0";
    }
    if (json['BUSINESS'].toString() == "null") {
      json['BUSINESS'] = "0";
    }
    if (json['DEPOSITS'].toString() == "null") {
      json['DEPOSITS'] = "0";
    }
    if (json['BALANCE'].toString() == "null") {
      json['BALANCE'] = "0";
    }
    if (json['TOTAL'].toString() == "null") {
      json['TOTAL'] = "0";
    }

    if (json['EMAIL_ID'] == "") {
      json['EMAIL_ID'] = 'Not Specified.';
    }
    // globals.daypay = json['DAY_WISE_ACHIEVED'].toString();
    // globals.daybusin = json['DAY_WISE_TARGET'].toString();

    return ManagerDetails(
      empid: json['EMPLOYEE_ID'].toString(),
      empname: json['EMPLOYEE_NAME'].toString(),
      reportmgrid: json['REPORTING_MNGR_ID'].toString(),
      reportmgrname: json['REPORTING_MNGR_NAME'].toString(),
      deposits: json['DEPOSITS'].toString(),
      business: json['BUSINESS'].toString(),
      balance: json['BALANCE'].toString(),
      InActive: json['IN_ACTIVE'].toString(),
      Active: json['ACTIVE'].toString(),
      My_Clients: json['TOTAL'].toString(),
      mobileno: json['MOBILE_PHONE'].toString(),
      emailid: json['EMAIL_ID'].toString(),
      mngrcnt: json['MNGR_CNT'].toString(),
      monthWiseTargetAmt: json['ACHIEVED_AMOUNT'].toString(),
      monthWiseAchieveAmt: json['TARGET_AMOUNT'].toString(),
      dayWiseTargetAmt: json['DAY_WISE_TARGET'].toString(),
      dayWiseAchieveAmt: json['DAY_WISE_ACHIEVED'].toString(),
      Total_CWB_AMOUNTS: json['AMOUNTS'].toString(),
      GROSS_AMOUNT: json['GROSS_AMOUNT'].toString(),
      NET_AMOUNT: json['NET_AMOUNT'].toString(),
      ORDERS: json['ORDERS'].toString(),
      SAMPLES: json['SAMPLES'].toString(),
      LAB_BUSINESS: json['LAB_BUSINESS'].toString(),
      RAD_BUSINESS: json['RAD_BUSINESS'].toString(),
      COMPANY_CDS: json['COMPANY_CDS'].toString(),
      COMPANY_WISE_LAST_PAYMENT: json['COMPANY_WISE_LAST_PAYMENT'].toString(),
      CMP_AMOUNTS: json['CMP_AMOUNTS'].toString(),
      IS_LOCK_REQ: json['IS_LOCK_REQ'].toString(),
      EMPLOYEE_CD: json['EMPLOYEE_CD'].toString(),
    );
  }
}

class newPassPopup extends StatefulWidget {
  const newPassPopup({Key? key}) : super(key: key);

  @override
  State<newPassPopup> createState() => _newPassPopupState();
}

class _newPassPopupState extends State<newPassPopup> {
  @override
  Widget build(BuildContext context) {
    NewPassword(BuildContext context) async {
      if (newpasswordController.text.toString() !=
          reEnterpasswordController.text.toString()) {
        passwordmismatch();
        return false;
      }
      Map data = {
        "user_name": globals.EmpName,
        "password": newpasswordController.text.toString(),
        "connection": globals.Connection_Flag,
      };
      final response = await http.post(
          Uri.parse(globals.API_url + '/AllDashboards/UpdatePassword'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: data,
          encoding: Encoding.getByName("utf-8"));

      if (response.statusCode == 200) {
        Map<String, dynamic> resposne = jsonDecode(response.body);
        if (resposne["message"] == "success") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginForm()));
        } else {
          return Fluttertoast.showToast(
              msg: "Failed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Color.fromARGB(255, 238, 78, 38),
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    }

    return Dialog(
        backgroundColor: Colors.grey[200],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                children: [
                  TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          filled: true,
                          //  hintText: 'Enter text',
                          labelText: 'Enter new Password'),
                      controller: newpasswordController),
                  TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          filled: true,
                          //  hintText: 'Enter text',
                          labelText: 'Confirm Password'),
                      controller: reEnterpasswordController),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        NewPassword(context);
                      },
                      child: Container(
                          width: 100,
                          height: 40,
                          decoration: const BoxDecoration(
                              color: Color(0xff123456),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0))),
                          child: const Center(
                            child: Text('Submit',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white)),
                          )),
                    ),
                  ),
                ],
              ),
            ]));
  }
}
