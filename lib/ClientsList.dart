import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import './allinone.dart';
import 'package:flutter/cupertino.dart';
import './managerbusiness.dart';

import './popup.dart';

import 'ClientBusiness.dart';
import 'clientprofile.dart';
import 'globals.dart' as globals;
import 'dart:async';
import 'package:http/http.dart' as http;

class ClientsList extends StatefulWidget {
  String empID = "0";

  ClientsList(String iEmpid) {
    this.empID = iEmpid;
  }
  @override
  _ClientsListState createState() => _ClientsListState(this.empID);
}

class _ClientsListState extends State<ClientsList> {
  String empID = "0";

  _ClientsListState(String iEmpid) {
    this.empID = iEmpid;
  }

  int _selectedValue = 0;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      //  _buildHeader(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AllinOne(selectedDateIndex: 0)),
      );
    });
  }

  // void clientHeader() {
  //   setState(() {
  //     _buildHeader(context);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Future<List<SalesManagers>> _fetchManagerClientpersons() async {
      Map data = {
        "emp_id": globals.loginEmpid, "session_id": "1",
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
        globals.activeclnt = jsonResponse[0]["ACTIVE"].toString();
        globals.lockedclnt = jsonResponse[0]["IN_ACTIVE"].toString();
        globals.totalclnt = jsonResponse[0]["TOTAL"].toString();

        // setState(() {
        //   _buildHeader(context);
        // });

        return jsonResponse
            .map((managers) => SalesManagers.fromJson(managers))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget verticalListManager = Container(
      margin: EdgeInsets.symmetric(vertical: 2.0),
      height: 670.0,
      child: FutureBuilder<List<SalesManagers>>(
          future: _fetchManagerClientpersons(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data;
              //   setState(() {});
              return SizedBox(child: salesDashboardListView(data, context));
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
          }),
    );

    Future<List<ManagerClients>> _fetchSalespersons() async {
      Map data = {
        "emp_id": globals.loginEmpid, "session_id": "1",
        "connection": globals.Connection_Flag
        //"Server_Flag":""
      };

      final jobsListAPIUrl =
          Uri.parse(globals.API_url + '/MobileSales/EmpReferalDetails');
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
            .map((managers) => ManagerClients.fromJson(managers))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget verticalList = Container(
      margin: EdgeInsets.symmetric(vertical: 2.0),
      height: MediaQuery.of(context).size.height * 1,
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder<List<ManagerClients>>(
          future: _fetchSalespersons(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data;
              return ManagerClientsListView(data, context);
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
          }),
    );

    final topAppBar = AppBar(
      elevation: 0.1,
      backgroundColor: Color(0xff123456),
      title: Text("Clients List"),
      leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, true)),
    );

    return Scaffold(
      appBar: topAppBar,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            verticalList,
            //verticalListManager,
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: InkWell(
      //         child: Icon(
      //           Icons.home,
      //           color: Colors.black,
      //         ),
      //       ),
      //       label: 'Home',
      //       backgroundColor: Colors.white,
      //     ),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.blur_on, color: Colors.black),
      //         label: 'Search',
      //         backgroundColor: Colors.white),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.account_box, color: Colors.black),
      //       label: 'Profile',
      //       backgroundColor: Colors.white,
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person, color: Colors.black),
      //       label: 'Clients',
      //       backgroundColor: Colors.white,
      //     ),
      //   ],
      //   type: BottomNavigationBarType.shifting,
      //   selectedItemColor: Colors.red,
      //   iconSize: 20,
      //   onTap: _onItemTapped,
      //   elevation: 5,
      // )
    );
  }
}

ListView ManagerClientsListView(data, BuildContext context) {
  return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _buildClientsCard(data[index], context);
      });
}

Widget _buildHeader(BuildContext context) {
  return GestureDetector(
    //     child: Container(
    //   child: Column(
    //     children: [
    //       Padding(
    //         padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 2.0),
    //         child: Card(
    //           elevation: 4.0,
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(8.0),
    //           ),
    //           child: Column(
    //             children: [
    //               InkWell(
    //                   child: Padding(
    //                 padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0.0),
    //                 child: Column(
    //                   children: [
    //                     Row(
    //                       children: [
    //                         Icon(Icons.person),
    //                         SizedBox(
    //                           width: 20,
    //                         ),
    //                         Text(
    //                           globals.selectedManagerData.empname,
    //                           style: TextStyle(
    //                               fontSize: 18, fontWeight: FontWeight.bold),
    //                         ),
    //                         Spacer(),
    //                         Icon(
    //                           Icons.verified_rounded,
    //                           color: Colors.green,
    //                         )
    //                       ],
    //                     ),
    //                     Row(
    //                       children: [
    //                         SizedBox(
    //                           width: 35,
    //                         ),
    //                         Icon(Icons.phone_rounded,
    //                             size: 16, color: Colors.green),
    //                         Text(globals.selectedManagerData.mobileno.toString(),
    //                             style: new TextStyle(
    //                                 color: Colors.grey,
    //                                 fontWeight: FontWeight.bold,
    //                                 fontSize: 13.0)),
    //                         SizedBox(height: 30.0),
    //                         Spacer(),
    //                         Icon(Icons.email_rounded,
    //                             size: 16, color: Colors.red),
    //                         Text(globals.selectedManagerData.emailid.toString(),
    //                             style: new TextStyle(
    //                                 color: Colors.grey,
    //                                 fontWeight: FontWeight.bold,
    //                                 fontSize: 13.0)),
    //                       ],
    //                     )
    //                   ],
    //                 ),
    //               )),
    //               Divider(
    //                 thickness: 1.0,
    //                 color: Colors.grey[300],
    //               ),
    //               InkWell(
    //                 child: Padding(
    //                   padding: const EdgeInsets.fromLTRB(6.0, 3.0, 6.0, 0.0),
    //                   child: Row(
    //                     children: [
    //                       Icon(Icons.person,
    //                           color: Color.fromARGB(255, 83, 235, 109)),
    //                       SizedBox(
    //                         width: 10,
    //                       ),
    //                       Text('Active Client',
    //                           style: TextStyle(
    //                               color: Colors.black,
    //                               fontWeight: FontWeight.w500)),
    //                       Spacer(),
    //                       Text(globals.activeclnt.toString(),
    //                           style: const TextStyle(
    //                               color: Colors.black,
    //                               fontWeight: FontWeight.w500))
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //               Divider(
    //                 thickness: 1.0,
    //                 color: Colors.grey[300],
    //               ),
    //               InkWell(
    //                 child: Padding(
    //                   padding: const EdgeInsets.fromLTRB(6.0, 3.0, 6.0, 0.0),
    //                   child: Row(
    //                     children: [
    //                       Icon(Icons.person, color: Colors.red),
    //                       SizedBox(
    //                         width: 10,
    //                       ),
    //                       Text('Locked Client',
    //                           style: const TextStyle(
    //                               color: Colors.black,
    //                               fontWeight: FontWeight.w500)),
    //                       Spacer(),
    //                       Text(globals.lockedclnt.toString(),
    //                           style: const TextStyle(
    //                               color: Colors.black,
    //                               fontWeight: FontWeight.w500))
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //               Divider(
    //                 thickness: 1.0,
    //                 color: Colors.grey[300],
    //               ),
    //               InkWell(
    //                 child: Padding(
    //                   padding: const EdgeInsets.fromLTRB(6.0, 3.0, 6.0, 6.0),
    //                   child: Row(
    //                     children: [
    //                       Icon(Icons.person,
    //                           color: Color.fromARGB(255, 65, 125, 235)),
    //                       SizedBox(
    //                         width: 10,
    //                       ),
    //                       Text('Total Client',
    //                           style: const TextStyle(
    //                               color: Colors.black,
    //                               fontWeight: FontWeight.w500)),
    //                       Spacer(),
    //                       Text(globals.totalclnt.toString(),
    //                           style: const TextStyle(
    //                               color: Colors.black,
    //                               fontWeight: FontWeight.w500))
    //                     ],
    //                   ),
    //                 ),
    //               )
    //             ],
    //           ),
    //         ),
    //       ),
    //       Padding(
    //         padding: EdgeInsets.all(10.0),
    //         child: Card(
    //           elevation: 4.0,
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(8.0),
    //           ),
    //           child: Column(
    //             children: [
    //               InkWell(
    //                 child: Padding(
    //                   padding: const EdgeInsets.all(5.0),
    //                   child: Row(
    //                     children: [
    //                       Icon(Icons.business_sharp,
    //                           color: Color.fromARGB(255, 90, 136, 236)),
    //                       SizedBox(
    //                         width: 10,
    //                       ),
    //                       Text('My Business',
    //                           style: TextStyle(
    //                               color: Colors.black,
    //                               fontWeight: FontWeight.w500)),
    //                       Spacer(),
    //                       Text(
    //                           '\u{20B9} ' +
    //                               globals.selectedManagerData.business.toString(),
    //                           style: const TextStyle(
    //                               color: Colors.black,
    //                               fontWeight: FontWeight.w500))
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //               Divider(
    //                 thickness: 1.0,
    //                 color: Colors.grey[300],
    //               ),
    //               InkWell(
    //                 child: Padding(
    //                   padding: const EdgeInsets.all(5.0),
    //                   child: Row(
    //                     children: [
    //                       Icon(Icons.payments_outlined,
    //                           color: Color.fromARGB(255, 163, 230, 165)),
    //                       SizedBox(
    //                         width: 10,
    //                       ),
    //                       Text('My Collections',
    //                           style: const TextStyle(
    //                               color: Colors.black,
    //                               fontWeight: FontWeight.w500)),
    //                       Spacer(),
    //                       Text(
    //                           '\u{20B9} ' +
    //                               globals.selectedManagerData.deposits.toString(),
    //                           style: const TextStyle(
    //                               color: Colors.black,
    //                               fontWeight: FontWeight.w500))
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //               Divider(
    //                 thickness: 1.0,
    //                 color: Colors.grey[300],
    //               ),
    //               InkWell(
    //                 child: Padding(
    //                   padding: const EdgeInsets.all(5.0),
    //                   child: Row(
    //                     children: [
    //                       Icon(Icons.money_rounded,
    //                           color: Color.fromARGB(255, 20, 169, 206)),
    //                       SizedBox(
    //                         width: 10,
    //                       ),
    //                       Text('My Dues',
    //                           style: const TextStyle(
    //                               color: Colors.black,
    //                               fontWeight: FontWeight.w500)),
    //                       Spacer(),
    //                       Text(
    //                           '\u{20B9} ' +
    //                               globals.selectedManagerData.balance.toString(),
    //                           style: const TextStyle(
    //                               color: Colors.black,
    //                               fontWeight: FontWeight.w500))
    //                     ],
    //                   ),
    //                 ),
    //               )
    //             ],
    //           ),
    //         ),
    //       ),
    //       Padding(
    //         padding: const EdgeInsets.all(10.0),
    //         child: Card(
    //           elevation: 4.0,
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(8.0),
    //           ),
    //           child: Column(
    //             children: [],
    //           ),
    //         ),
    //       )
    //     ],
    //   ),
    // ));

    child: Container(
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          // color: MaterialStateColor.resolveWith(
          //     (states) => Color.fromARGB(255, 226, 243, 236)),
          elevation: 6.0,
          child: Column(
            children: [
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.account_circle, size: 25, color: Colors.grey),
                    SizedBox(width: 15),
                    Text(globals.EmpName,
                        style: new TextStyle(
                            color: Color(0xff123456),
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0)),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),

                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(width: 5),
                    Text(globals.Glb_business.toString(),
                        style:
                            new TextStyle(color: Colors.green, fontSize: 14.0)),
                    SizedBox(width: 5),
                    Text(globals.glb_deposits.toString(),
                        style:
                            new TextStyle(color: Colors.blue, fontSize: 14.0)),
                    SizedBox(width: 10),
                    SizedBox(width: 5),
                    Text(globals.Glb_balance.toString(),
                        style:
                            new TextStyle(color: Colors.red, fontSize: 14.0)),
                  ],
                ),
                // ),
                trailing: Icon(Icons.double_arrow_outlined, color: Colors.red),
              ),
              SizedBox(height: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.lock_open_rounded, size: 16, color: Colors.green),
                  Text('Active (' + globals.activeclnt.toString() + ')',
                      style: new TextStyle(
                          color: Color(0xff123456),
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0)),
                  Icon(Icons.lock_rounded, size: 16, color: Colors.red),
                  Text('Locked (' + globals.lockedclnt.toString() + ')',
                      style: new TextStyle(
                          color: Color(0xff123456),
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0)),
                  Icon(Icons.summarize, size: 16, color: Colors.blue),
                  Text('Total(' + globals.totalclnt.toString() + ')',
                      style: new TextStyle(
                          color: Color(0xff123456),
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.phone_rounded, size: 16, color: Colors.green),
                  Text(globals.Glb_emailid.toString(),
                      style: new TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0)),
                  SizedBox(height: 30.0),
                  Icon(Icons.email_rounded, size: 16, color: Colors.red),
                  Text(globals.MailId,
                      style: new TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12.0)),
                  InkWell(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.verified_rounded,
                            color: Colors.green,
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => managerbusiness(0)),
                        );
                      })
                ],
              ),
            ],
          )),
    ),
  );
}

String clienlockflag = '';
String ClientName = '';
Widget _buildClientsCard(data, BuildContext context) {
  ClientName = '';
  clienlockflag = '';
  clienlockflag = data.locked;

  ClientName = data.clientname;

  return GestureDetector(
    onTap: () {
      print(globals.selectedClientData);
      globals.clientName = data.clientname;
      globals.selectedClientid = data.clientid.toString();
      globals.mybusiness = data.business.toString();
      globals.collection = data.totaldeposits.toString();
      globals.dues = data.balance.toString();
      globals.phoneno = data.mobileno.toString();
      globals.lastpay = data.lastpaidamt.toString();
      globals.lastdate = data.lastpaiddt.toString();
      globals.daypay = data.day_wisepay.toString();
      globals.daybusin = data.day_wisebusiness.toString();
      globals.monthpay = data.month_wisepay.toString();
      globals.monthbusi = data.month_wisebusiness.toString();
      globals.clientsid = data.clientid.toString();
      globals.dposit = data.deposits.toString();

      globals.fromDate = '';
      globals.ToDate = '';

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ClientProfile(0)),
      );
    },
    child: Container(
      width: 175.0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(7, 1, 7, 0.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          // color: Color.fromARGB(255, 229, 243, 240),
          elevation: 6.0,
          margin: EdgeInsets.all(2.5),
          child: Column(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 150,
                          child: Text(
                            data.clientname,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          data.MOBILE_NO.toString(),
                          style: TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        Text(
                          data.TEST_CNT.toString(),
                          style: TextStyle(fontSize: 14, color: Colors.red),
                        ),
                        if (data.IS_LOCK_PERMISSION != 'N')
                          IconButton(
                            icon: Icon(Icons.lock_open_rounded,
                                size: 22, color: Colors.green),
                            onPressed: () {
                              globals.Client_CODE_Lock =
                                  data.Client_CODE.toString();
                              globals.clientLockFlag = data.locked;
                              globals.clientName_Client_Lock = data.clientname;
                              globals.clientid_Client_Lock = data.locked;

                              globals.IS_CREDIT_LIMIT_REQ_Client_Lock =
                                  data.clientid.toString();
                              globals.CREDIT_LIMT_AMNT_Client_Lock =
                                  data.CREDIT_LIMT_AMNT.toString();
                              globals.balance_Client_Lock =
                                  data.balance.toString();
                              showLockBottomSheet(context);
                            },
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data.business.toString(),
                          style: TextStyle(fontSize: 14, color: Colors.green),
                        ),
                        Text(
                          data.deposits.toString(),
                          style: TextStyle(fontSize: 14, color: Colors.blue),
                        ),
                        Text(
                          data.balance.toString(),
                          style: TextStyle(fontSize: 14, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  SizedBox(
                    width: 150,
                    child: Text(
                      data.lastpaiddt.toString(),
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: Text(
                      data.lastpaidamt.toString(),
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    child: Icon(Icons.verified, color: Colors.green),
                    onTap: () {
                      globals.ClientBusinessId = data.clientid.toString();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ClientBusiness(data.clientid.toString())));
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class ManagerClients {
  final clientid;
  final clientname;
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
  final IS_LOCK_PERMISSION;

  final TEST_CNT;

  final MOBILE_NO;

  ManagerClients({
    required this.clientid,
    required this.clientname,
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
    required this.IS_LOCK_PERMISSION,
    required this.TEST_CNT,
    required this.MOBILE_NO,
  });

  factory ManagerClients.fromJson(Map<String, dynamic> json) {
    if (json['LAST_PAYMENT_DT'] == '' || json['LAST_PAYMENT_DT'] == null) {
      json['LAST_PAYMENT_DT'] = 'No Payment done.';
    }
    if (json['LAST_PAY_AMT'] == '' || json['LAST_PAY_AMT'] == null) {
      json['LAST_PAY_AMT'] = '0.00';
    }
    return ManagerClients(
        clientid: json['COMPANY_ID'],
        clientname: json['COMPANY_NAME'],
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
        IS_LOCK_PERMISSION: json["IS_LOCK_PERMISSION"],
        TEST_CNT: json["TEST_CNT"],
        MOBILE_NO: json["MOBILE_NO"]);
  }
}

/* Manager Lock */

ListView salesDashboardListView(data, BuildContext context) {
  return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _buildHeader(context);
      });
}

Widget _buildManagerLockCard(var data, BuildContext context) {
  // globals.selectedManagerData = data;
  return GestureDetector();
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
  });
  factory SalesManagers.fromJson(Map<String, dynamic> json) {
    if (json['EMAIL_ID'] == "") {
      json['EMAIL_ID'] = 'Not Specified.';
    }
    if (json['EMPLOYEE_NAME'] == null) {
      json['EMPLOYEE_NAME'] = ' ';
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
    );
  }
}

/* Manager Lock */
