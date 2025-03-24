import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';
import './service_group_wise_services.dart';
import 'Sales_Dashboard.dart';
import 'LocationWiseBusiness.dart';
import 'New_Login.dart';
import 'admin_dashboard.dart';
import 'globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'referal_test.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

double amount = 1;
String Business_Location_Name = '';
TextEditingController _Mobile_NoController = TextEditingController();
TextEditingController _billnoController = TextEditingController();

class summary_by_report extends StatefulWidget {
  int index;

  int selectedIndex;
  // String Business_Location_Name='';

  summary_by_report(
      this.index, this.selectedIndex, String business_location_name) {
    Business_Location_Name;
    Business_Location_Name = business_location_name;
  }

  @override
  State<summary_by_report> createState() =>
      _summary_by_reportState(this.index, this.selectedIndex);
}

class _summary_by_reportState extends State<summary_by_report> {
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
  _summary_by_reportState(this.index, this.selectedIndex);

  Updamount(double amt) {
    setState(() {
      amount += amt;
    });
    return amount;
  }

  @override
  ListView ClientChannelDeptListView(data, BuildContext context) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return report(data[index], context, index);
        });
  }

  Widget report(var data, BuildContext context, index) {
    return GestureDetector(
        onTap: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return BottomBar(
                  data.BILL_NO.toString(), data.PATIENT_NAME.toString());
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 0.0),
          child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.grey)),
              elevation: 4.0,
              child: ListTile(
                title: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 2, right: 8),
                            child: Icon(Icons.person,
                                color: Color.fromARGB(255, 153, 182, 209)),
                          ),
                          Text(data.PATIENT_NAME.toString(),
                              style: TextStyle(
                                  color: Color(0xff123456),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.0)),
                          Spacer(),
                          Text(data.BILL_AMOUNT.toString(),
                              style: TextStyle(
                                  color: Color.fromARGB(255, 218, 75, 65),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.0)),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 35, top: 6, bottom: 4),
                      child: Row(
                        children: [
                          Text(
                              data.BILL_NO.toString() +
                                  '  |  ' +
                                  data.BILL_DT.toString(),
                              style: TextStyle(
                                  color: Color.fromARGB(255, 90, 133, 173),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.0)),
                          /* Spacer(),
                      data.SERVICE_STATUS == "Completed"
                          ? InkWell(
                              onTap: () {
                                _launchURL(data.REPORT_CD.toString());
                              },
                              child: Icon(Icons.picture_as_pdf,
                                  size: 15, color: Colors.red))
                          : Container(), */
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 35,
                            ),
                            child: Text(data.SERVICE_NAME.toString(),
                                style: TextStyle(
                                    color: Color(0xff123456),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11.0)),
                          ),
                          Spacer(),
                          data.SERVICE_STATUS == "Approved"
                              ? Card(
                                  color: Color.fromRGBO(112, 194, 113, 1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          6.0, 4, 6, 4),
                                      child: Center(
                                        child: Text(
                                            data.SERVICE_STATUS.toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 11.0)),
                                      )))
                              : Card(
                                  color: Color.fromARGB(255, 231, 107, 102),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          6.0, 4, 6, 4),
                                      child: Center(
                                        child: Text(
                                            data.SERVICE_STATUS.toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 11.0)),
                                      ))),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
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
    Future<List<ClientChannelDept_class>> _fetchCenterWiseSummary() async {
      amount = 0;

      Map data = {
        "IP_SERVICE_ID": globals.SERVICE_ID_by_summary,
        "IP_LOCATION_ID": globals.LOC_ID,
        "IP_FROM_DT": "${selectedDate.toLocal()}".split(' ')[0],
        "IP_TO_DT": "${selectedDate.toLocal()}".split(' ')[0],
        "IP_SERVICE_GROUP_ID": globals.SERVICE_GROUP_ID_BY_SUMMARY,
        "connection": globals.Connection_Flag,
      };
      final jobsListAPIUrl =
          Uri.parse(globals.API_url + '/MobileSales/SERVICE_WISE_PATIENTS');
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
        return jsonResponse
            .map((managers) => ClientChannelDept_class.fromJson(managers))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget verticalListClientChannelRep = Container(
        height: MediaQuery.of(context).size.height * 0.75,
        child: FutureBuilder<List<ClientChannelDept_class>>(
            future: _fetchCenterWiseSummary(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data;
                return SizedBox(
                    child: ClientChannelDeptListView(data, context));
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

    Widget MyBOttomNavigation = Container(
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
                globals.Radio_Lab_Flag == "R"
                    ? globals.Radio_Lab_Flag = "R"
                    : globals.Radio_Lab_Flag = "L";
                globals.Radio_Lab_Flag == "L"
                    ? globals.Radio_Lab_Flag = "L"
                    : globals.Radio_Lab_Flag = "R";
                globals.SERVICE_NAME = "";
                globals.fromDate = "";
                globals.ToDate = "";
                globals.Count_Services = "";
                globals.SERVICE_ID_by_summary = "";
                globals.Counts == "";
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
                globals.SERVICE_NAME = "";
                globals.fromDate = "";
                globals.ToDate = "";
                globals.Count_Services = "";
                globals.SERVICE_ID_by_summary = "";
                globals.Counts == "";
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
                  globals.fromDate = "";
                  globals.ToDate = "";
                  total_amouont = "";
                  globals.SERVICE_NAME = "";
                  globals.Counts == "";
                  globals.Count_Services = "";
                  globals.SERVICE_ID_by_summary = "";

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Service_Group_Wise_Services(
                              Business_Location_Name)));
                },
                icon: Icon(Icons.arrow_back_ios_rounded)),
            Text(
              "Reports",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Spacer(),
            Text("${selectedDate.toLocal()}".split(' ')[0],
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8.0, 8, 8.0),
              child: Card(
                elevation: 4.0,
                color: Color.fromARGB(255, 205, 221, 230),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      const Icon(
                        Icons.medication_liquid_sharp,
                        color: Color.fromARGB(255, 36, 73, 151),
                        size: 20,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 250,
                        child: Text(
                          globals.SERVICE_NAME_SERVICES,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800]),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        globals.Count_Services,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            verticalListClientChannelRep,
          ],
        ),
      ),
      bottomNavigationBar: MyBOttomNavigation,
    );
  }
}

class ClientChannelDept_class {
  final PATIENT_NAME;
  final BILL_NO;
  final BILL_AMOUNT;
  final NET_AMOUNT;
  final BILL_DT;
  final SERVICE_STATUS;
  final BILL_ID;
  final SERVICE_NAME;

  ClientChannelDept_class({
    required this.PATIENT_NAME,
    required this.BILL_NO,
    required this.BILL_AMOUNT,
    required this.NET_AMOUNT,
    required this.BILL_DT,
    required this.SERVICE_STATUS,
    required this.BILL_ID,
    required this.SERVICE_NAME,
  });

  factory ClientChannelDept_class.fromJson(Map<String, dynamic> json) {
    return ClientChannelDept_class(
      PATIENT_NAME: json['PATIENT_NAME'].toString(),
      BILL_NO: json['BILL_NO'].toString(),
      BILL_AMOUNT: json['BILL_AMOUNT'].toString(),
      NET_AMOUNT: json['NET_AMOUNT'].toString(),
      BILL_DT: json['BILL_DT'].toString(),
      SERVICE_STATUS: json['SERVICE_STATUS'].toString(),
      BILL_ID: json['BILL_ID'].toString(),
      SERVICE_NAME: json['SERVICE_NAME'].toString(),
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

  var url = globals.Report_URL + REPORT_CD + "";
  if (await launch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

/*--------------------------------------------url Launcher----------------------------------------*/

Messagetoaster() {}

var Bill_value = "";
var PatientName = "";

class BottomBar extends StatefulWidget {
  BottomBar(BILL_NO, PATIENT_NAME) {
    Bill_value = "";
    PatientName = "";
    PatientName = PATIENT_NAME.toString();
    Bill_value = BILL_NO.toString();
  }

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  Widget Application_Widget(var data, BuildContext context) {
    return GestureDetector(
        onTap: () {
          globals.selectedPatientData = data;
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 3, 8, 1),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Color.fromARGB(255, 184, 195, 223))),
            elevation: 4.0,
            color: Color.fromARGB(255, 248, 248, 248),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 250,
                      child: Text(data.srvname,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color.fromARGB(255, 29, 63, 125),
                          )),
                    ),
                    Spacer(),
                    Text(
                      data.srvstats1,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
                child: Row(
                  children: [
                    SizedBox(
                      width: 250,
                      child: Text(data.REFERAL_NAME,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Color.fromARGB(255, 29, 63, 125),
                          )),
                    ),
                  ],
                ),
              ),
              (data.srvstats1 == "Completed" || data.srvstats1 == "Dispatch")
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12, bottom: 8),
                          child: InkWell(
                              onTap: () {
                                // _launchURL(data.reportCd.toString());
                                PDFController.fetchDataAndLaunchPDF(
                                    context, data.billNo.toString());
                              },
                              child: Icon(
                                Icons.picture_as_pdf,
                                color: Colors.red,
                                size: 22,
                              )),
                        ),
                      ],
                    )
                  : Text('')
            ]),
          ),
        ));
  }

  ListView Application_ListView(data, BuildContext context) {
    if (data != null) {
      return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Application_Widget(data[index], context);
          });
    }
    return ListView();
  }

  Future<List<Services_Data_Model>> _fetchSaleTransaction() async {
    var jobsListAPIUrl = null;
    var dsetName = '';
    List listresponse = [];

    Map data = {"bill_id": Bill_value, "connection": globals.Connection_Flag};

    dsetName = 'result';
    jobsListAPIUrl = Uri.parse(globals.API_url + '/MobileSales/BillServices');

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
          .map((strans) => Services_Data_Model.fromJson(strans))
          .toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget verticalList3 = Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: FutureBuilder<List<Services_Data_Model>>(
          future: _fetchSaleTransaction(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty == true) {
                return NoContent3();
              }
              var data = snapshot.data;
              return SizedBox(child: Application_ListView(data, context));
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
          }),
    );

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 40,
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xff123456),
          title: Text(
            PatientName,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
        body: Container(child: verticalList3));
  }
}

class Services_Data_Model {
  final srvname;
  final srvstats1;
  final billNo;
  final displyName;
  final mobNo1;
  final age;
  final gendr;
  final reportCd;
  final REFERAL_NAME;

  Services_Data_Model(
      {required this.srvname,
      required this.srvstats1,
      required this.billNo,
      required this.displyName,
      required this.mobNo1,
      required this.age,
      required this.gendr,
      required this.reportCd,
      required this.REFERAL_NAME});

  factory Services_Data_Model.fromJson(Map<String, dynamic> json) {
    return Services_Data_Model(
        srvname: json['SERVICE_NAME'].toString(),
        srvstats1: json['SERVICE_STATUS1'].toString(),
        billNo: json['BILL_NO'].toString(),
        displyName: json['DISPLAY_NAME'].toString(),
        mobNo1: json['MOBILE_NO1'].toString(),
        age: json['AGE'].toString(),
        gendr: json['GENDER'].toString(),
        reportCd: json['REPORT_CD'].toString(),
        REFERAL_NAME: json['REFERAL_NAME'].toString());
  }
}

class PDFController {
  // Function to fetch data from API and launch PDF viewer
  static Future<void> fetchDataAndLaunchPDF(
      BuildContext context, String billNumber) async {
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
            // Navigation after successful download
            launchPDFViewer(context, file, base64Data);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please wait for five minutes')),
            );
          }
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
