import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';
import './report.dart';
import './total_business.dart';
import 'Business/Screens/Business.dart';
import 'Center_Wise_Summary.dart';
import 'New_Login.dart';
import 'Sales_Dashboard.dart';
import 'LocationWiseBusiness.dart';
import 'globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

double amount = 0;
TextEditingController _Mobile_NoController = TextEditingController();
TextEditingController _billnoController = TextEditingController();
var _selflag = "";
var datasetval = [];

class AdminDashboard extends StatefulWidget {
  String empID = "0";
  int selectedIndex;
  AdminDashboard(String iEmpid, this.selectedIndex) {
    empID = iEmpid;
    this.empID = iEmpid;
  }

  @override
  State<AdminDashboard> createState() =>
      _AdminDashboardState(this.empID, this.selectedIndex);
}

class _AdminDashboardState extends State<AdminDashboard> {
  DateTime pastMonth = DateTime.now().subtract(Duration(days: 30));
  DateTime nextMonth = DateTime.now().add(Duration(days: 30));
  DateTime selectedDate = DateTime.now();

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
          globals.fromDate = "";
          globals.fromDate = DateFormat('dd-MMM-yyyy').format(selected.start);
          globals.ToDate = DateFormat('dd-MMM-yyyy').format(selected.end);
        });
      }
    }
  }

  int selectedIndex;
  var selecteFromdt = '';
  var selecteTodt = '';
  String empID = "0";
  _AdminDashboardState(String iEmpid, this.selectedIndex) {
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
            //total business amount coding start
            if (_selflag == "CH") {
              globals.TOTAL_CHANNEL_AMOUNT = amount.toString();
            } else if (_selflag == "CL") {
              globals.TOTAL_CLIENT_AMOUNT = amount.toString();
            } else {
              globals.TOTAL_SRV_GRP_AMOUNT = amount.toString();
            }
            //total business amount coding end
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
        "FrequencyId": "1",
        "Frequency": "Today",
      },
      {
        "FrequencyId": "2",
        "Frequency": "Yesterday",
      },
      {
        "FrequencyId": "3",
        "Frequency": "Last Week",
      },
      {
        "FrequencyId": "4",
        "Frequency": "This Week",
      },
      {
        "FrequencyId": "5",
        "Frequency": "Last Month",
      },
      {
        "FrequencyId": "6",
        "Frequency": "This Month",
      }
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

    if (globals.fromDate != "") {
      selecteFromdt = globals.fromDate;
      selecteTodt = globals.ToDate;
    } else if (selecteTodt == '') {
      selecteFromdt = formatter1.format(now);
      selecteTodt = formatter1.format(now);
    }

    Future<List<ManagerDetails>> _fetchManagerDetails() async {
      datasetval = [];
      Map data = {
        "user_name": globals.glb_user_name,
        "password": globals.glb_password,
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
          Uri.parse(globals.API_url.trim() + '/MobileSales/Login');
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
        datasetval = jsonDecode(response.body)["Data"];
        Map<String, dynamic> user = resposne['Data'][0];

        globals.loginEmpid = user['REFERENCE_ID'].toString();
        globals.Glb_IS_REQ_BUSINESS = user['IS_REQ_BUSINESS'].toString();

        return jsonResponse
            .map((managers) => ManagerDetails.fromJson(managers))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget verticalListManagerDetails = Container(
        height: MediaQuery.of(context).size.height * 0.72,
        child: FutureBuilder<List<ManagerDetails>>(
            future: _fetchManagerDetails(),
            builder: (context, snapshot) {
              if (snapshot.hasData && datasetval.length > 0) {
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
                    //   pathBackgroundColor:ColorSwatch(Action[])
                  ),
                ),
              );
            }));

    Widget myBottomnavigationbar = Container(
        // height: 150,
        width: MediaQuery.of(context).size.width,
        height: 48,
        color: Color(0xff123456),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 5, 0, 0),
            child: InkWell(
              onTap: () {
                globals.reference_type_id != '28' &&
                        globals.reference_type_id != '8'
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminDashboard(empID, 0)))
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SalesManagerDashboard()));
              },
              child: Column(children: [
                Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 18,
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  "Home",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                )
              ]),
            ),
          ),
          globals.Glb_IS_REQ_BUSINESS == 'Y'
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BusinessNew()),
                      );
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.business,
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          "Business",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: InkWell(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => BusinessNew()),
                      // );
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.business,
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          "Business",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        )
                      ],
                    ),
                  ),
                ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 20, 0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginClass()),
                );
              },
              child: Column(
                children: [
                  Icon(
                    Icons.logout_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "Log Out",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  )
                ],
              ),
            ),
          ),
        ]));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Builder(
                builder: (context) => IconButton(
                  iconSize: 60,
                  icon: Image(image: NetworkImage(globals.Logo)),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
            ),
            Text('Admin Dashboard'),
            Spacer(),
            IconButton(
              icon: Icon(Icons.date_range_outlined),
              onPressed: () async {
                await _centerWiseBusinessDate(context);
              },
            ),
          ],
        ),
        backgroundColor: Color(0xff123456),
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
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  // Remove multiple data entries
                  prefs.remove('USER_NAME');
                  prefs.remove('USER_ID');
                  prefs.remove('REFERENCE_ID');
                  prefs.remove('REFERENCE_ID');
                  prefs.remove('EMP_CD');
                  prefs.remove('EMAIL_ID');
                  prefs.remove('EMP_NAME');
                  prefs.remove('EMAIL_ID');
                  prefs.remove('BILL_COUNT');
                  prefs.remove('SRV_COUNT');
                  prefs.remove('GROSS');
                  prefs.remove('NET_AMOUNT');
                  prefs.remove('DISCOUNT');
                  prefs.remove('CANCELLED');
                  prefs.remove('GROSS_AMOUNT');
                  prefs.remove('NET_AMOUNT');
                  prefs.remove('SAMPLES');
                  prefs.remove('IS_REQ_BUSINESS');
                  prefs.remove('REFERENCE_TYPE_ID');
                  prefs.remove('SESSION_ID');
                  prefs.remove('IS_ACCESS_ADD_CLIENT');
                  prefs.remove('CONNECTION_STRING');
                  prefs.remove('REPORT_URL');
                  prefs.remove('API_URL');
                  prefs.remove('COMPANY_LOGO');
                  prefs.remove('username');
                  prefs.remove('username');

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginClass()),
                  );
                },
                leading: const Icon(Icons.logout_rounded),
                title: const Text("Log Out")),
            Stack(children: [
              Positioned(
                child: IgnorePointer(
                  ignoring: true,
                  child: Center(
                    child: Opacity(
                        opacity: 0.1,
                        child: Image.asset("assets/images/emislogo.png",
                            fit: BoxFit.contain)),
                  ),
                ),
              ),
            ])
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
                  height: 20,
                  child: selecteFromdt == ""
                      ? Text(
                          "${selectedDate.toLocal()}".split(' ')[0] +
                              '  To   ' +
                              "${selectedDate.toLocal()}".split(' ')[0],
                          style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0))
                      : Text(selecteFromdt + '  To  ' + selecteTodt,
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
      bottomNavigationBar: myBottomnavigationbar,
    );
  }
}

ListView ManagerDetailsDasboardListView(data, BuildContext context) {
  return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _buildManagerDetails(data[index], context, index);
      });
}

Widget _buildManagerDetails(var data, BuildContext context, index) {
  return GestureDetector(
      child: Container(
    color: const Color.fromARGB(255, 250, 248, 248),
    child: Column(children: [
      Column(
        children: [
          GestureDetector(
              child: Container(
                  color: const Color.fromARGB(255, 250, 248, 248),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 3, 15, 0.0),
                    child: InkWell(
                        child: Card(
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Icon(
                                    Icons.account_box,
                                    size: 25,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        globals.EmpName,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[800]),
                                      ),
                                      Text(
                                        "Employee",
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.admin_panel_settings_outlined,
                                        color: Colors.grey,
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          globals.selectedEmpid = data.empid.toString();
                          globals.selectedEmname = globals.EmpName.toString();
                          // globals.selectedManagerData = data;
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => managerbusiness(0)),
                          // );
                        }),
                  ))),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.41,
                    child: Card(
                      // color: Color.fromARGB(255, 191, 227, 239),
                      // color: Color.fromARGB(147, 238, 243, 245),
                      color: Color.fromARGB(255, 225, 225, 225),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Icon(
                                  Icons.shopping_cart_rounded,
                                  size: 15,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                "Orders",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          // CircleAvatar(
                          //   backgroundColor: Color(0xff123456),
                          //   radius: 18.0,
                          //   child: ClipRRect(
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 6),
                            child: Text(
                              data.BILL_COUNT,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colors.blueGrey),
                            ),
                          ),
                          //     // borderRadius: BorderRadius.circular(70.0),
                          //   ),
                          // ),
                        ],
                      ),
                    )),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                    // width: 145,
                    // height: 90,
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.41,
                    child: Card(
                      // color: Color.fromARGB(255, 215, 241, 160),
                      // color: Color.fromARGB(147, 238, 243, 245),
                      color: Color.fromARGB(255, 225, 225, 225),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: Icon(
                                  Icons.bloodtype_rounded,
                                  color: Colors.black,
                                  size: 15,
                                ),
                              ),
                              Text(
                                "Tests",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          // CircleAvatar(
                          //   backgroundColor: Color(0xff123456),
                          //   radius: 18.0,
                          //   child: ClipRRect(
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 8),
                            child: Text(
                              data.SRV_COUNT,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colors.blueGrey),
                            ),
                          ),
                          //     //  borderRadius: BorderRadius.circular(70.0),
                          //  ),
                          // ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(15.0, 0.0, 15.0, 0.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          elevation: 4.0,
          child: Column(
            children: [
              InkWell(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 6.0, 15.0, 2.0),
                    child: Row(
                      children: [
                        Icon(Icons.business,
                            color: Color.fromARGB(255, 22, 82, 131)),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Total Business',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500)),
                        Spacer(),
                        Text(data.GROSS,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500)),
                        Icon(
                          Icons.double_arrow,
                          color: Colors.grey,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    globals.Radio_Lab_Flag = "D";
                    globals.fromDate = "";
                    globals.ToDate = "";
                    total_amouont = "";
                    globals.Amount_CWB = data.GROSS.toString();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Total_Business()));
                  }),
              Divider(
                thickness: 1.0,
                color: Colors.grey[300],
              ),
              InkWell(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 4.0),
                    child: Row(
                      children: [
                        Icon(Icons.library_books_outlined,
                            color: Color.fromARGB(255, 210, 154, 95)),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Radiology Business',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500)),
                        Spacer(),
                        Text(data.RAD_BUSINESS,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500)),
                        Icon(
                          Icons.double_arrow,
                          color: Colors.grey,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    total_amouont = "";
                    globals.fromDate = "";
                    globals.ToDate = "";
                    globals.Radio_Lab_Flag = "R";
                    // globals.Amount_CWB = data.Total_CWB_AMOUNTS.toString();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LocationWiseCollection()));
                  }),
              Divider(
                thickness: 1.0,
                color: Colors.grey[300],
              ),
              InkWell(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 4.0),
                    child: Row(
                      children: [
                        Icon(Icons.local_pharmacy_outlined,
                            color: Color.fromARGB(255, 229, 88, 40)),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Lab Business',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500)),
                        Spacer(),
                        Text(data.LAB_BUSINESS,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500)),
                        Icon(
                          Icons.double_arrow,
                          color: Colors.grey,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    globals.Radio_Lab_Flag = "L";
                    total_amouont = "";
                    globals.fromDate = "";
                    globals.ToDate = "";
                    // globals.Amount_CWB = data.Total_CWB_AMOUNTS.toString();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LocationWiseCollection()));
                  }),
              Divider(
                thickness: 1.0,
                color: Colors.grey[300],
              ),
              InkWell(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.report_gmailerrorred,
                                color: Colors.green),
                            SizedBox(
                              width: 10,
                            ),
                            Text('Reports',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500)),
                            Spacer(),
                            Icon(Icons.double_arrow,
                                color: Colors.grey, size: 15),
                          ],
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    showDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(32.0))),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Mobile No. :'),
                                TextField(
                                  controller: _Mobile_NoController,
                                  decoration: InputDecoration(
                                      hintText: "Enter Mobile Number"),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: Text('OR',
                                      style: TextStyle(color: Colors.indigo)),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text('Bill No.:'),
                                TextField(
                                  controller: _billnoController,
                                  decoration: InputDecoration(
                                      hintText: "Enter Bill Number"),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      //       SizedBox(
                                      //           height: 40,
                                      //           width: 80,
                                      //           child: InkWell(
                                      //             onTap: () {
                                      //               Navigator.pop(context);
                                      //             },
                                      //             child: Card(
                                      //               shape: RoundedRectangleBorder(
                                      //                   borderRadius:
                                      //                       BorderRadius.circular(
                                      //                           18)),
                                      //               color: Color.fromARGB(
                                      //                   255, 192, 213, 233),
                                      //               child: Center(
                                      //                   child: Text(
                                      //                 'Cancel',
                                      //                 style: TextStyle(
                                      //                     color: Colors.black,
                                      //                     fontSize: 14,
                                      //                     fontWeight:
                                      //                         FontWeight.bold),
                                      //               )),
                                      //             ),
                                      //           )),
                                      SizedBox(
                                        height: 40,
                                        width: 60,
                                        child: InkWell(
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18)),
                                            color: Color(0xff123456),
                                            child: Center(
                                                child: Text(
                                              'OK',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                          ),
                                          onTap: () {
                                            // ClientChannelDeptWise(5, 0);
                                            if (_billnoController.text == "" &&
                                                _Mobile_NoController.text ==
                                                    "") {
                                              // return false;

                                              Fluttertoast.showToast(
                                                  msg: "Enter Valid Number",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 180, 17, 17),
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            }

                                            if (_billnoController.text != "" ||
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
                                                          ReportData(0, 0)));
                                            }
                                            // clearText();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                  }),
              Divider(
                thickness: 1.0,
                color: Colors.grey[300],
              ),
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 6.0, 15.0, 6.0),
                  child: Row(
                    children: [
                      const Icon(Icons.discount_outlined,
                          color: Colors.lightBlue),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text('Total Discount',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                      const Spacer(),
                      Text(data.DISCOUNT,
                          style: const TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500))
                    ],
                  ),
                ),
                // onTap: () {}
              ),
              // Divider(
              //   thickness: 1.0,
              //   color: Colors.grey[300],
              // ),
              // InkWell(
              //   child: Padding(
              //     padding: const EdgeInsets.fromLTRB(15.0, 6.0, 15.0, 6.0),
              //     child: Row(
              //       children: [
              //         const Icon(Icons.payments_outlined,
              //             color: Color.fromARGB(255, 163, 230, 165)),
              //         const SizedBox(
              //           width: 10,
              //         ),
              //         const Text('Net Amt',
              //             style: TextStyle(
              //                 color: Colors.black,
              //                 fontWeight: FontWeight.w500)),
              //         const Spacer(),
              //         Text('\u{20B9} ' + data.NET,
              //             style: const TextStyle(
              //                 color: Colors.black, fontWeight: FontWeight.w500))
              //       ],
              //     ),
              //   ),
              //   // onTap: () {}
              // ),
              Divider(
                thickness: 1.0,
                color: Colors.grey[300],
              ),
              InkWell(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 6.0, 15.0, 6.0),
                  child: Row(
                    children: [
                      Icon(Icons.cancel_outlined, color: Colors.red),
                      SizedBox(
                        width: 10,
                      ),
                      const Text('Total Cancellation',
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500)),
                      const Spacer(),
                      globals.CANCELLED == 'null'
                          ? Text("0",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500))
                          : Text(data.CANCELLED,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500))
                    ],
                  ),
                ),
                // onTap: () {}
              ),
            ],
          ),
        ),
      ),
    ]),
  ));
}

class ManagerDetails {
  final BILL_COUNT;
  final SRV_COUNT;
  final GROSS;
  final NET;
  final DISCOUNT;
  final CANCELLED;
  final RAD_BUSINESS;
  final LAB_BUSINESS;
  final REFERENCE_ID;
  final IS_REQ_BUSINESS;

  ManagerDetails({
    required this.BILL_COUNT,
    required this.SRV_COUNT,
    required this.GROSS,
    required this.NET,
    required this.DISCOUNT,
    required this.LAB_BUSINESS,
    required this.RAD_BUSINESS,
    required this.CANCELLED,
    required this.REFERENCE_ID,
    required this.IS_REQ_BUSINESS,
  });
  factory ManagerDetails.fromJson(Map<String, dynamic> json) {
    return ManagerDetails(
      BILL_COUNT: json['BILL_COUNT'].toString(),
      SRV_COUNT: json['SRV_COUNT'].toString(),
      GROSS: json['GROSS'].toString(),
      NET: json['NET'].toString(),
      DISCOUNT: json['DISCOUNT'].toString(),
      CANCELLED: json['CANCELLED'].toString(),
      RAD_BUSINESS: json['RAD_BUSINESS'].toString(),
      LAB_BUSINESS: json['LAB_BUSINESS'].toString(),
      REFERENCE_ID: json['REFERENCE_ID'].toString(),
      IS_REQ_BUSINESS: json['IS_REQ_BUSINESS'].toString(),
    );
  }
}
