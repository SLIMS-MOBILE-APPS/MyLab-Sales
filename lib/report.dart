import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';
import 'Sales_Dashboard.dart';
import 'LocationWiseBusiness.dart';
import 'New_Login.dart';
import 'admin_dashboard.dart';
import 'globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';

//var reportDataList = [];
double amount = 1;
TextEditingController _Mobile_NoController = TextEditingController();
TextEditingController _billnoController = TextEditingController();

class ReportData extends StatefulWidget {
  int index;

  int selectedIndex;
  ReportData(this.index, this.selectedIndex);
  @override
  State<ReportData> createState() =>
      _ReportDataState(this.index, this.selectedIndex);
}

class _ReportDataState extends State<ReportData> {
  DateTime selectedDate = DateTime.now();

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

  int index;

  String empID = "0";
  int selectedIndex;
  var selecteFromdt = '';
  var selecteTodt = '';
  _ReportDataState(this.index, this.selectedIndex);

  Updamount(double amt) {
    setState(() {
      amount += amt;
    });
    return amount;
  }

  @override
  ListView ClientChannelDeptListView(data, BuildContext context, String flag) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return report(data[index], context, index, flag);
        });
  }

  bool _printWithHeader = false;
  bool _printWithoutHeader = false;
  Widget report(
    var data,
    BuildContext context,
    index,
    flag,
  ) {
    return GestureDetector(
        child: SingleChildScrollView(
      child: Column(
        children: [
          index == 0
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
                  child: Card(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                            width: 0.8,
                            color: Color.fromARGB(255, 219, 215, 215))),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6, bottom: 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          index == 0
                              ? Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        side: BorderSide(
                                            color: Color.fromARGB(
                                                255, 229, 239, 246))),
                                    color: Color.fromARGB(255, 223, 228, 232),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 4, 15, 4),
                                      child: Row(
                                        children: [
                                          Text(
                                            'Patient Details',
                                            style: TextStyle(
                                                color: Color(0xff123456),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Spacer(),
                                          Icon(
                                            Icons.report_rounded,
                                            color: Color.fromARGB(
                                                255, 38, 103, 169),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(),
                          index == 0
                              ? Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 5, 10, 3),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        side: BorderSide(color: Colors.grey)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.person,
                                            color: Color.fromARGB(
                                                255, 29, 83, 138),
                                            size: 18,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 3),
                                            child: Text(
                                                data.PATIENT_NAME.toString(),
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 29, 83, 138),
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 12.0)),
                                          ),
                                          Spacer(),
                                          Text(data.Age.toString(),
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 221, 102, 83),
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 12.0)),
                                        ],
                                      ),
                                    ),
                                  ))
                              : SizedBox(),
                        ],
                      ),
                    ),
                  ),
                )
              : SizedBox(),
          index == 0
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                            color: Color.fromARGB(255, 217, 228, 236))),
                    color: Color.fromARGB(255, 223, 228, 232),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 6, 15, 6),
                      child: Row(
                        children: [
                          Text(
                            'Test Details',
                            style: TextStyle(
                                color: Color(0xff123456),
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          Spacer(),
                          // InkWell(
                          //     onTap: () {
                          //       // _launchURL(data.REPORT_CD.toString());
                          //       // PDFController.fetchDataAndLaunchPDF(
                          //       //     context, data.BILL_NO.toString());
                          //     },
                          //     child: Padding(
                          //       padding: const EdgeInsets.only(left: 18),
                          //       child: Icon(Icons.picture_as_pdf,
                          //           size: 20, color: Colors.red),
                          //     ))
                        ],
                      ),
                    ),
                  ),
                )
              : SizedBox(),
          // for (var i in reportDataList)
          Padding(
              padding: const EdgeInsets.fromLTRB(12, 2, 10, 2),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0, bottom: 8),
                            child: Text(data.SERVICE_NAME,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 22, 63, 99),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12.0)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0, bottom: 4),
                            child: Text(data.BILL_NO,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 22, 63, 99),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11.0)),
                          ),
                          Text(data.BILL_DT,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 22, 63, 99),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 11.0)),
                        ],
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Column(
                          children: [
                            data.srv_status == "Completed"
                                ? SizedBox(
                                    height: 30,
                                    width: 95,
                                    child: InkWell(
                                      onTap: () {
                                        // _launchURL(data.REPORT_CD.toString());
                                        // PDFController.fetchDataAndLaunchPDF(
                                        //     context, data.BILL_NO.toString());

                                        data.IS_REPORT_OPEN_WEB == "Y"
                                            ? showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return StatefulBuilder(
                                                    builder:
                                                        (context, setState) {
                                                      return AlertDialog(
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                        ),
                                                        title: Text(
                                                          'Select Option',
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors
                                                                .blueAccent,
                                                          ),
                                                        ),
                                                        content: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            CheckboxListTile(
                                                              activeColor: Colors
                                                                  .blueAccent,
                                                              title: Text(
                                                                'Print with Header',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                              value:
                                                                  _printWithHeader,
                                                              onChanged: (bool?
                                                                  value) {
                                                                setState(() {
                                                                  _printWithHeader =
                                                                      value!;
                                                                  if (_printWithHeader) {
                                                                    _printWithoutHeader =
                                                                        false;
                                                                  }
                                                                });
                                                              },
                                                            ),
                                                            CheckboxListTile(
                                                              activeColor: Colors
                                                                  .blueAccent,
                                                              title: Text(
                                                                'Print without Header',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                              value:
                                                                  _printWithoutHeader,
                                                              onChanged: (bool?
                                                                  value) {
                                                                setState(() {
                                                                  _printWithoutHeader =
                                                                      value!;
                                                                  if (_printWithoutHeader) {
                                                                    _printWithHeader =
                                                                        false;
                                                                  }
                                                                });
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: Text(
                                                              'Cancel',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .redAccent,
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                          TextButton(
                                                            child: Text(
                                                              'OK',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .blueAccent,
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              data.IS_REPORT_OPEN_WEB ==
                                                                  "Y";

                                                              if (_printWithoutHeader) {
                                                                _launchURLwithoutHeader(data
                                                                    .REPORT_CD
                                                                    .toString());
                                                              } else if (_printWithHeader) {
                                                                PDFController.fetchDataAndLaunchPDF(
                                                                    context,
                                                                    data.BILL_NO
                                                                        .toString(),
                                                                    data.IS_REPORT_OPEN_WEB
                                                                        .toString(),
                                                                    data.REPORT_CD
                                                                        .toString());
                                                              }
                                                              // Navigator.of(context).pop();
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                              )
                                            : PDFController
                                                .fetchDataAndLaunchPDF(
                                                    context,
                                                    data.BILL_NO.toString(),
                                                    data.IS_REPORT_OPEN_WEB
                                                        .toString(),
                                                    data.REPORT_CD.toString());
                                      },
                                      child: Card(
                                          color: Color.fromARGB(
                                              255, 112, 194, 113),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Center(
                                                child: Text(
                                              data.srv_status,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500),
                                            )),
                                          )),
                                    ),
                                  )
                                : SizedBox(
                                    height: 30,
                                    width: 95,
                                    child: Card(
                                        color:
                                            Color.fromARGB(255, 231, 107, 102),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Center(
                                              child: Text(
                                            "In Progress",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          )),
                                        )),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    ));
  }

  Widget build(BuildContext context) {
    final DateFormat formatter1 = DateFormat('dd-MMM-yyyy');
    var now = DateTime.now();

    if (globals.fromDate != "") {
      selecteFromdt = globals.fromDate;
      selecteTodt = globals.ToDate;
    } else if (selecteTodt == '') {
      selecteFromdt = formatter1.format(now);
      selecteTodt = formatter1.format(now);
    }
    String flag = "";

    double neaamount = 0;
    Future<List<ClientChannelDept_class>> _fetchManagerDetails() async {
      amount = 0;

      Map data = {
        "Emp_id": globals.loginEmpid,
        "session_id": "1",
        "flag": "",
        "from_dt": "${selectedDate.toLocal()}".split(' ')[0],
        "to_dt": "${selectedDate.toLocal()}".split(' ')[0],
        "location_wise_flg": "RE",
        "location_id": globals.LOC_ID,
        "IP_BILL_NO": globals.bill_no,
        "IP_BARCODE_NO": globals.mobile_no,
        "connection": globals.Connection_Flag
      };
      final jobsListAPIUrl =
          Uri.parse(globals.API_url + '/MobileSales/Centerwisetrans');
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
        _Mobile_NoController.text = "";
        _billnoController.text = "";
        // reportDataList = [];
        // for (int i = 0; i <= resposne['Data'].length - 1; i++) {
        //   reportDataList.add({
        //     'Service_Name': resposne['Data'][i]["SERVICE_NAME"],
        //     'Service_Status': resposne['Data'][i]["srv_status"],
        //     'Bill_No': resposne['Data'][i]["BILL_NO"],
        //     'Bill_Dt': resposne['Data'][i]["BILL_DT"],
        //   });
        // }
        return jsonResponse
            .map((managers) => ClientChannelDept_class.fromJson(managers))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget verticalListClientChannelRep = Container(
        height: MediaQuery.of(context).size.height * 0.78,
        child: FutureBuilder<List<ClientChannelDept_class>>(
            future: _fetchManagerDetails(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data;
                if (snapshot.data!.isEmpty == true) {
                  return NoContent();
                }
                return SizedBox(
                    child: ClientChannelDeptListView(data, context, flag));
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              return Center(
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballClipRotateMultiple,
                    colors: Colors.primaries,
                    strokeWidth: 4.0,
                  ),
                ),
              );
            }));

    Widget MybototomNavigation = Container(
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
                globals.bill_no = "";
                globals.mobile_no = "";
                globals.fromDate = "";
                globals.ToDate = "";
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
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: InkWell(
              onTap: () {},
              child: Column(
                children: [
                  Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "Profile",
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
        backgroundColor: const Color(0xff123456),
        title: Row(
          children: [
            IconButton(
                onPressed: () {
                  globals.bill_no = "";
                  globals.mobile_no = "";
                  globals.fromDate = "";
                  globals.ToDate = "";
                  total_amouont = "";
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back)),
            Text(
              "Reports",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Spacer(),
            Text("${selectedDate.toLocal()}".split(' ')[0],
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
            IconButton(
              icon: Icon(Icons.date_range_outlined),
              onPressed: () {
                _selectDate(context);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: verticalListClientChannelRep,
      ),
      bottomNavigationBar: MybototomNavigation,
    );
  }
}

class ClientChannelDept_class {
  final CLIENT_NAME;
  final CLIENT_AMOUNT;
  final CHANNEL_NAME;
  final CHANNEL_AMOUNT;
  final SERVICE_GROUP_NAME;
  final DEPT_AMOUNT;
  final TOTAL_CHANNEL_AMOUNT;
  final TOTAL_SRV_GRP_AMOUNT;
  final TOTAL_CLIENT_AMOUNT;
  final REF_AMOUNT;
  final TEMP_REF_DOC_ID;
  final REFERAL_DOCTOR;
  final CLIENT_ID;
  final TEST_AMOUNT;
  final SERVICE_GROUP_ID;
  final srv_status;
  final SERVICE_ID;
  final BILL_NO;
  final BILL_DT;
  final UMR_NO;
  final PATIENT_NAME;
  final Age;
  final SERVICE_NAME;
  final TOTAL;
  final REPORT_CD;
  final IS_REPORT_OPEN_WEB;

  ClientChannelDept_class({
    required this.CLIENT_NAME,
    required this.CLIENT_AMOUNT,
    required this.CHANNEL_NAME,
    required this.CHANNEL_AMOUNT,
    required this.SERVICE_GROUP_NAME,
    required this.DEPT_AMOUNT,
    required this.TOTAL_CHANNEL_AMOUNT,
    required this.TOTAL_SRV_GRP_AMOUNT,
    required this.TOTAL_CLIENT_AMOUNT,
    required this.REF_AMOUNT,
    required this.TEMP_REF_DOC_ID,
    required this.REFERAL_DOCTOR,
    required this.CLIENT_ID,
    required this.TEST_AMOUNT,
    required this.SERVICE_GROUP_ID,
    required this.srv_status,
    required this.SERVICE_ID,
    required this.BILL_NO,
    required this.BILL_DT,
    required this.UMR_NO,
    required this.PATIENT_NAME,
    required this.Age,
    required this.SERVICE_NAME,
    required this.TOTAL,
    required this.REPORT_CD,
    required this.IS_REPORT_OPEN_WEB,
  });

  factory ClientChannelDept_class.fromJson(Map<String, dynamic> json) {
    return ClientChannelDept_class(
      CHANNEL_NAME: json['CHANNEL_NAME'].toString(),
      SERVICE_GROUP_NAME: json['SERVICE_GROUP_NAME'].toString(),
      DEPT_AMOUNT: json['DEPT_AMOUNT'].toString(),
      CHANNEL_AMOUNT: json['CHANNEL_AMOUNT'].toString(),
      CLIENT_AMOUNT: json['CLIENT_AMOUNT'].toString(),
      CLIENT_NAME: json['CLIENT_NAME'].toString(),
      TOTAL_CHANNEL_AMOUNT: json['TOTAL_CHANNEL_AMOUNT'].toString(),
      TOTAL_SRV_GRP_AMOUNT: json['TOTAL_SRV_GRP_AMOUNT'].toString(),
      TOTAL_CLIENT_AMOUNT: json['TOTAL_CLIENT_AMOUNT'].toString(),
      REF_AMOUNT: json['REF_AMOUNT'].toString(),
      TEMP_REF_DOC_ID: json['TEMP_REF_DOC_ID'].toString(),
      REFERAL_DOCTOR: json['REFERAL_DOCTOR'].toString(),
      CLIENT_ID: json['CLIENT_ID'].toString(),
      TEST_AMOUNT: json['TEST_AMOUNT'].toString(),
      SERVICE_GROUP_ID: json['SERVICE_GROUP_ID'].toString(),
      srv_status: json['srv_status'].toString(),
      SERVICE_ID: json['SERVICE_ID'].toString(),
      BILL_NO: json['BILL_NO'].toString(),
      BILL_DT: json['BILL_DT'].toString(),
      UMR_NO: json['UMR_NO'].toString(),
      PATIENT_NAME: json['PATIENT_NAME'].toString(),
      Age: json['Age'].toString(),
      SERVICE_NAME: json['SERVICE_NAME'].toString(),
      TOTAL: json['TOTAL'].toString(),
      REPORT_CD: json['REPORT_CD'].toString(),
      IS_REPORT_OPEN_WEB: json['IS_REPORT_OPEN_WEB'].toString(),
    );
  }
}

class NoContent extends StatelessWidget {
  const NoContent();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
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

totbusinessClientWise() {
  return SizedBox(
    width: 350,
    height: 50,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(8, 0.0, 8, 0.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        color: Color.fromARGB(255, 27, 165, 114),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(9, 2, 9, 2),
          child: Row(
            children: [
              Text('Total Business :',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
              Spacer(),

              //setState({}),
              Text(globals.TOTAL_CLIENT_AMOUNT,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    ),
  );
}

totbusinessChannelWise() {
  return SizedBox(
    width: 350,
    height: 50,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(8, 0.0, 8, 0.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        color: Color.fromARGB(255, 27, 165, 114),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(9, 2, 9, 2),
          child: Row(
            children: [
              Text('Total Business :',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
              Spacer(),

              //setState({}),
              Text(amount.toString(),
                  // Text("amount.toString()",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    ),
  );
}

totbusinessDeptWise() {
  return SizedBox(
    width: 350,
    height: 50,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(8, 0.0, 8, 0.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        color: Color.fromARGB(255, 27, 165, 114),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(9, 2, 9, 2),
          child: Row(
            children: [
              Text('Total Business :',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
              Spacer(),

              //setState({}),
              Text(amount.toString(),
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    ),
  );
}

/*--------------------------------------------url Launcher----------------------------------------*/

_launchURL(REPORT_CD) async {
  // SfPdfViewer.network(
  //     "http://103.145.36.189/his/PUBLIC/HIMSREPORTVIEWER.ASPX?UNIUQ_ID=" +
  //         REPORT_CD +
  //         "");

  var url = globals.Glb_UPLOAD_ATTACHMENTS + REPORT_CD + "";
  if (await launch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_launchURLwithoutHeader(rportcde) async {
  var url = globals.Glb_WITHOUTHEAD_URL + rportcde + "";
  //  http://103.145.36.189/his_testing/PUBLIC/HIMSREPORTVIEWER.ASPX?UNIUQ_ID=
  if (await launch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
/*--------------------------------------------url Launcher----------------------------------------*/

Messagetoaster() {}

class PDFController {
  // Function to fetch data from API and launch PDF viewer
  static Future<void> fetchDataAndLaunchPDF(BuildContext context,
      String billNumber, String IS_REPORT_OPEN_WEB, String reportCd) async {
    String apiUrl = globals.Report_URL + '$billNumber';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Connecting...'),
        // duration: Duration(seconds: 2),
      ),
    );
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          // Add any necessary headers here
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        String base64Data = responseData['base64'];

        if (base64Data.isNotEmpty) {
          final tempDir = await getTemporaryDirectory();
          final file = File('${tempDir.path}/temp.pdf');

          await file.writeAsBytes(base64.decode(base64Data));

          if (file.existsSync()) {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();

            launchPDFViewer(context, file, base64Data);
          } else if (IS_REPORT_OPEN_WEB == "Y") {
            _launchURL(reportCd);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please wait for five minutes')),
            );
          }
        } else if (IS_REPORT_OPEN_WEB == "Y") {
          _launchURL(reportCd);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please wait for five minutes')),
          );
        }
      } else {
        throw Exception('Failed to load data from API');
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch data and launch PDF')),
      );
    }
  }

  // Function to launch PDF viewer
  static void launchPDFViewer(
      BuildContext context, File file, String base64Download) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PDFViewer(pdfFile: file, base64Download: base64Download),
      ),
    );
  }
}

class PDFViewer extends StatelessWidget {
  final File? pdfFile;
  final String? base64Download;

  const PDFViewer({required this.pdfFile, this.base64Download});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 0, 169, 132),
          title: Text('Reports'),
          actions: [
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                if (pdfFile != null) {
                  shareFile(context, pdfFile!);
                }
              },
            ),
          ],
        ),
        body: pdfFile != null
            ? PDFView(
                filePath: pdfFile!.path,
                onError: (error) {
                  print(error);
                },
              )
            : Container() //NoDataFoundWidget(tabName: ""),
        );
  }

  void shareFile(BuildContext context, File file) {
    Share.shareFiles([file.path],
        text: 'Sharing PDF file', subject: 'PDF File');
  }

  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      await Permission.storage.request();
    }
  }
}
