import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'ManagerEmployees.dart';
import 'allbottomnavigationbar.dart';
import 'client_lock.dart';
import 'clientprofile.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  final String empId;

  HomePage(this.empId);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  bool buttonClicked = false;
  bool buttonClicked1 = false;
  var selecteFromdt = '';
  var selecteTodt = '';
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

//manager code here closed

  Future<List<ManagerClients>> _fetchSaleTransaction() async {
    var jobsListAPIUrl =
        Uri.parse(globals.API_url + '/MobileSales/EmpReferalDetails');

    Map data = {
      "emp_id": widget.empId,
      "session_id": "1",
      "IP_FLAG": "",
      "IP_CLIENT_CD": _searchController.text,
      "IP_FROM_DATE": selecteFromdt.isEmpty
          ? "${selectedDate.toLocal()}".split(' ')[0]
          : selecteFromdt,
      "IP_TO_DATE": selecteTodt.isEmpty
          ? "${selectedDate.toLocal()}".split(' ')[0]
          : selecteTodt,
      "connection": globals.Connection_Flag
    };

    var response = await http.post(
      jobsListAPIUrl,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: data,
      encoding: Encoding.getByName("utf-8"),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = jsonDecode(response.body);
      List jsonResponse = responseJson["Data"];
      buttonClicked = false;
      return jsonResponse
          .map((strans) => ManagerClients.fromJson(strans))
          .toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  Widget Application_Widget(data, BuildContext context) {
    String clientName = data.clientname;
    String clientLockFlag = data.locked;

    return GestureDetector(
      onTap: () {
        globals.selectedClientid = data.clientid.toString();
        globals.clientName = data.clientname;
        globals.selectedClientData = data;
        globals.selectedClientid = data.clientid.toString();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ClientProfile(0)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
        child: Container(
          width: double.infinity,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            clientName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8),
                        // Expanded(
                        //   flex: 1,
                        //   child: Text(
                        //     data.Client_CODE,
                        //     style: TextStyle(
                        //       fontSize: 14,
                        //       fontWeight: FontWeight.bold,
                        //       color: Colors.grey,
                        //     ),
                        //     overflow: TextOverflow.ellipsis,
                        //   ),
                        // ),
                        // Spacer(),
                        GestureDetector(
                          onTap: () {
                            globals.clientLockFlag = clientLockFlag;
                            globals.clientName_Client_Lock = clientName;
                            globals.clientid_Client_Lock =
                                data.clientid.toString();
                            globals.IS_CREDIT_LIMIT_REQ_Client_Lock =
                                data.IS_CREDIT_LIMIT_REQ.toString();
                            globals.CREDIT_LIMT_AMNT_Client_Lock =
                                data.CREDIT_LIMT_AMNT.toString();
                            globals.balance_Client_Lock =
                                data.balance.toString();
                            globals.Client_CODE_Lock =
                                data.Client_CODE.toString();
                            if (globals.Glb_IS_LOCK_REQ == "Y") {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    Lock_Widget(),
                              );
                            }
                          },
                          child: Container(
                            height: 28,
                            width: 28,
                            decoration: BoxDecoration(
                              color: clientLockFlag == 'Y'
                                  ? Colors.red
                                  : Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Icon(
                                clientLockFlag == 'Y'
                                    ? Icons.lock
                                    : Icons.lock_open,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      data.Client_CODE,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(color: Colors.grey),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "(B) ${data.business}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            "(P) ${data.deposits}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            "(O) ${data.balance}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ListView Application_ListView(
      List<ManagerClients> data, BuildContext context) {
    if (data != null) {
      return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Application_Widget(data[index], context);
        },
      );
    }
    return ListView();
  }

  Widget verticalList3() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      child: FutureBuilder<List<ManagerClients>>(
        future: buttonClicked ? _fetchSaleTransaction() : null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                height: 100,
                width: 100,
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
            return Center(
              child: Text("${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox,
                      size: 50,
                      color: Color.fromARGB(255, 216, 13, 13),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'No Content',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 18, 9, 100),
                      ),
                    ),
                  ],
                ),
              );
            }
            var data = snapshot.data!;
            return SizedBox(child: Application_ListView(data, context));
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  size: 50,
                  color: Color.fromARGB(255, 199, 87, 87),
                ),
                SizedBox(height: 10),
                Text(
                  'Press search to fetch data',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 62, 16, 146),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    padding: const EdgeInsets.all(16.0),
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
                              width: 60,
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
                              width: 60,
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
                              width: 60,
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Manager & Clients'),
        backgroundColor: const Color(0xff123456),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Manager_Widget,
              Container(height: 120, child: function_widet()),
              SizedBox(height: 5),

              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(6, 0, 8, 0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: 'Search Clients by Code',
                          border: OutlineInputBorder(),
                          errorText:
                              buttonClicked1 && _searchController.text.isEmpty
                                  ? 'Please enter a client code'
                                  : null,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 1),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 148, 175,
                          197), // Set your desired background color
                      borderRadius: BorderRadius.circular(
                          8), // Optional: add border radius
                    ),
                    child: IconButton(
                      onPressed: () {
                        buttonClicked1 = true;
                        setState(() {
                          if (_searchController.text.isNotEmpty) {
                            // Call the API or set the state to trigger the API call
                            _fetchSaleTransaction();
                            buttonClicked = true;
                          }
                        });
                      },
                      icon: Icon(
                        Icons.search,
                        size: 30,
                        color: Color.fromARGB(255, 34, 35, 43),
                      ),
                      iconSize:
                          50, // Set the size of the button (not the icon itself)
                      padding: EdgeInsets.zero, // Remove the padding
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              verticalList3(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AllbottomNavigation(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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

String clienlockflag = '';
String ClientName = '';

class ManagerClients {
  final clientid;
  final clientname;
  final Client_CODE;
  final deposits;
  final business;
  final balance;
  final locked;
  final lastpaiddt;
  final lastpaidamt;
  final totaldeposits;
  final totalbusiness;
  final totalbalace;
  final paymentmode;
  final mobileno;
  final day_wisepay;
  final day_wisebusiness;
  final month_wisepay;
  final month_wisebusiness;
  final IS_CREDIT_LIMIT_REQ;
  final CREDIT_LIMT_AMNT;

  ManagerClients(
      {required this.clientid,
      required this.clientname,
      required this.Client_CODE,
      required this.locked,
      required this.deposits,
      required this.business,
      required this.balance,
      required this.lastpaiddt,
      required this.lastpaidamt,
      required this.totaldeposits,
      required this.totalbalace,
      required this.totalbusiness,
      required this.paymentmode,
      required this.mobileno,
      required this.day_wisepay,
      required this.day_wisebusiness,
      required this.month_wisepay,
      required this.month_wisebusiness,
      required this.IS_CREDIT_LIMIT_REQ,
      required this.CREDIT_LIMT_AMNT});

  factory ManagerClients.fromJson(Map<String, dynamic> json) {
    if (json['LAST_PAYMENT_DT'] == '') {
      json['LAST_PAYMENT_DT'] = 'No Payment done.';
    }
    if (json['LAST_PAY_AMT'] == '') {
      json['LAST_PAY_AMT'] = '0.00';
    }

    return ManagerClients(
        clientid: json['COMPANY_ID'],
        clientname: json['COMPANY_NAME'],
        Client_CODE: json['CMP_CD'],
        deposits: json['DEPOSITS'],
        business: json['BUSINESS'],
        balance: json['BALANCE'],
        lastpaiddt: json['LAST_PAYMENT_DT'],
        lastpaidamt: json['LAST_PAY_AMT'],
        paymentmode: json['CREDIT_CLIENT'],
        totaldeposits: json['TOTAL_DEPOSITS'],
        totalbusiness: json['TOTAL_BUSINESS'],
        totalbalace: json['TOTAL_BALANCE'],
        locked: json['CLIENT_LOCK_STATS'],
        mobileno: json['MOBILE_PHONE'],
        day_wisepay: json["DAY_WISE_PAYMENTAMOUNT"],
        day_wisebusiness: json["DAY_WISE_BUSINESSAMOUNT"],
        month_wisepay: json["MONTH_WISE_PAYMENTAMOUNT"],
        month_wisebusiness: json["MONTH_WISE_BUSINESSAMOUNT"],
        IS_CREDIT_LIMIT_REQ: json["IS_CREDIT_LIMIT_REQ"],
        CREDIT_LIMT_AMNT: json["CREDIT_LIMT_AMNT"]);
  }
}
