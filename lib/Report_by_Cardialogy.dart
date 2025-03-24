import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';
import './total_business.dart';
import 'New_Login.dart';
import 'Sales_Dashboard.dart';
import 'LocationWiseBusiness.dart';
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
TextEditingController _Mobile_NoController = TextEditingController();
TextEditingController _billnoController = TextEditingController();

class Report_by_Cardialogy extends StatefulWidget {
  int index;

  int selectedIndex;
  Report_by_Cardialogy(this.index, this.selectedIndex);
  @override
  State<Report_by_Cardialogy> createState() =>
      _Report_by_CardialogyState(this.index, this.selectedIndex);
}

class _Report_by_CardialogyState extends State<Report_by_Cardialogy> {
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
  _Report_by_CardialogyState(this.index, this.selectedIndex);

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
        child: Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 0.0),
      child: InkWell(
        onTap: (() {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return BottomBar(
                  data.BILL_NO.toString(), data.PATIENT_NAME.toString());
            },
          );
        }),
        child: Card(
            elevation: 4.0,
            child: ListTile(
              // leading: Icon(Icons.verified_rounded, color: Colors.green),
              title: Column(
                children: [
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 30,
                        child: Icon(Icons.person, color: Colors.grey),
                      ),
                      Container(
                        width: 150,
                        child: Text(data.PATIENT_NAME.toString(),
                            style: TextStyle(
                                color: Color(0xff123456),
                                fontWeight: FontWeight.bold,
                                fontSize: 13.0)),
                      ),
                      Spacer(),
                      Text(data.BILL_AMOUNT.toString(),
                          style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.0)),
                    ],
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 30,
                      ),
                      Container(
                        width: 160,
                        child: Row(
                          children: [
                            Text(
                                data.BILL_NO.toString() +
                                    ' | ' +
                                    data.BILL_DT.toString(),
                                style: TextStyle(
                                    color: Color.fromARGB(255, 106, 199, 248),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.0)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 30,
                      ),
                      Container(
                        width: 150,
                        child: Text(data.SERVICE_NAME.toString(),
                            style: TextStyle(
                                color: Color(0xff123456),
                                fontWeight: FontWeight.bold,
                                fontSize: 11.0)),
                      ),
                      Spacer(),
                      Text(data.SERVICE_STATUS.toString(),
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 11.0)),
                      SizedBox(
                        height: 30,
                        child: data.SERVICE_STATUS == "Completed"
                            ? IconButton(
                                onPressed: () {
                                  // _launchURL(data.REPORT_CD.toString());
                                  PDFController.fetchDataAndLaunchPDF(
                                      context, data.BILL_NO.toString());
                                },
                                icon: Icon(Icons.picture_as_pdf,
                                    size: 15, color: Colors.red))
                            : Container(),
                      ),
                    ],
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 30,
                      ),
                      Container(
                        width: 150,
                        child: Text(data.TEMP_REF_DOC_ID.toString(),
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 11.0)),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ),
    ));
  }

  ListView ClientChannelDeptListView1(data, BuildContext context) {
    return ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return report1(data[index], context, index);
        });
  }

  Widget report1(var data, BuildContext context, index) {
    return GestureDetector(
        child: Padding(
      padding: const EdgeInsets.fromLTRB(8, 0.0, 8, 0.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: [
            // const SizedBox(
            //   height: 5,
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  const Icon(Icons.medication_liquid_sharp, color: Colors.pink),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 200,
                    child: Text(
                      data.SERVICE_NAME,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800]),
                    ),
                  ),
                  const Spacer(),
                  CircleAvatar(
                    radius: 15.0,
                    child: ClipRRect(
                      child: Text(
                        data.CNT,
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      borderRadius: BorderRadius.circular(70.0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
    Future<List<ClientChannelDept_class>> _fetchCenterWiseSummary() async {
      amount = 0;

      Map data = {
        "IP_SERVICE_ID": globals.SERVICE_ID_by_Cardialogy,
        "IP_LOCATION_ID": globals.LOC_ID,
        "IP_FROM_DT": "${selectedDate.toLocal()}".split(' ')[0],
        "IP_TO_DT": "${selectedDate.toLocal()}".split(' ')[0],
        "IP_SERVICE_GROUP_ID": "73",
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
                    //   pathBackgroundColor:ColorSwatch(Action[])
                  ),
                ),
              );
            }));

    Widget verticalListClientChannelRep1 = Container(
        height: MediaQuery.of(context).size.height * 0.05,
        child: FutureBuilder<List<ClientChannelDept_class>>(
            future: _fetchCenterWiseSummary(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data;
                return SizedBox(
                    child: ClientChannelDeptListView1(data, context));
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Container();
            }));

    Widget MyBOTTOMnavigation = Container(
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
                          builder: (context) => Total_Business()));
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
        child: Column(
          children: [
            Container(child: verticalListClientChannelRep1),
            Container(child: verticalListClientChannelRep),
          ],
        ),
      ),
      bottomNavigationBar: MyBOTTOMnavigation,
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
  final CNT;
  final TEMP_REF_DOC_ID;

  ClientChannelDept_class(
      {required this.PATIENT_NAME,
      required this.BILL_NO,
      required this.BILL_AMOUNT,
      required this.NET_AMOUNT,
      required this.BILL_DT,
      required this.SERVICE_STATUS,
      required this.BILL_ID,
      required this.SERVICE_NAME,
      required this.CNT,
      required this.TEMP_REF_DOC_ID});

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
        CNT: json['CNT'].toString(),
        TEMP_REF_DOC_ID: json['TEMP_REF_DOC_ID'].toString());
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
        child: Card(
          elevation: 4.0,
          color: MaterialStateColor.resolveWith(
              (states) => Color.fromARGB(255, 248, 248, 248)),
          child: Column(children: [
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 150,
                  child: Text(data.srvname,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      )),
                ),
                Spacer(),
                Text(
                  data.srvstats1,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                (data.srvstats1 == "Completed" || data.srvstats1 == "Dispatch")
                    ? IconButton(
                        onPressed: () {
                          // _launchURL(data.reportCd.toString());
                          PDFController.fetchDataAndLaunchPDF(
                              context, data.billNo.toString());
                        },
                        icon: Icon(
                          Icons.picture_as_pdf,
                          color: Colors.red,
                        ))
                    : IconButton(onPressed: () {}, icon: Icon(null))
              ],
            ),
          ]),
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

  Future<List<Cardiology_Data_Model>> _fetchSaleTransaction() async {
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
          .map((strans) => Cardiology_Data_Model.fromJson(strans))
          .toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget verticalList3 = Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: FutureBuilder<List<Cardiology_Data_Model>>(
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
                child: CircularProgressIndicator(
              strokeWidth: 4.0,
            ));
          }),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text(PatientName),
          backgroundColor: const Color(0xff123456),
        ),
        body: Container(child: verticalList3));
  }
}

class Cardiology_Data_Model {
  final srvname;
  final srvstats1;
  final billNo;
  final displyName;
  final mobNo1;
  final age;
  final gendr;
  final reportCd;

  Cardiology_Data_Model(
      {required this.srvname,
      required this.srvstats1,
      required this.billNo,
      required this.displyName,
      required this.mobNo1,
      required this.age,
      required this.gendr,
      required this.reportCd});

  factory Cardiology_Data_Model.fromJson(Map<String, dynamic> json) {
    return Cardiology_Data_Model(
        srvname: json['SERVICE_NAME'].toString(),
        srvstats1: json['SERVICE_STATUS1'].toString(),
        billNo: json['BILL_NO'].toString(),
        displyName: json['DISPLAY_NAME'].toString(),
        mobNo1: json['MOBILE_NO1'].toString(),
        age: json['AGE'].toString(),
        gendr: json['GENDER'].toString(),
        reportCd: json['REPORT_CD'].toString());
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
