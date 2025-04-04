import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:loading_indicator/loading_indicator.dart';
import './summary_by_report.dart';
import './total_business.dart';
import 'Center_Wise_Summary.dart';
import 'Sales_Dashboard.dart';
import 'LocationWiseBusiness.dart';
import 'New_Login.dart';
import 'admin_dashboard.dart';
import 'globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String total_business_loc_name = '';

class Service_Group_Wise_Services extends StatefulWidget {
  Service_Group_Wise_Services(Total_business_LOC_Name) {
    total_business_loc_name;
    total_business_loc_name = Total_business_LOC_Name;
  }
  @override
  State<Service_Group_Wise_Services> createState() =>
      _Service_Group_Wise_ServicesState();
}

class _Service_Group_Wise_ServicesState
    extends State<Service_Group_Wise_Services> {
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

  String empID = "0";

  var selecteFromdt = '';
  var selecteTodt = '';

  @override
  ListView ClientChannelDeptListView(data, BuildContext context) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return report(data[index], context);
        });
  }

  ListView ServiceGroupNameListView(data, BuildContext context) {
    return ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return ServiceGroupNameCard(data[index], context);
        });
  }

  Widget ServiceGroupNameCard(var data, BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 4, 10, 0),
          child: Card(
            elevation: 3.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: Color.fromARGB(255, 169, 165, 164),
              ),
            ),
            color: const Color.fromARGB(255, 229, 231, 231),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 3, 0, 3),
              child: Row(
                children: [
                  Icon(
                    Icons.location_pin,
                    size: 22,
                    color: Color.fromARGB(255, 36, 73, 151),
                    //  color: Color.fromARGB(255, 24, 167, 114),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      total_business_loc_name.toString(),
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 3.0, 8, 0.0),
          child: Card(
            elevation: 3.0,
            color: Color.fromARGB(255, 205, 221, 230),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.medical_services_outlined,
                        color: Color.fromARGB(255, 36, 73, 151),
                        size: 16,
                      ),
                      Text(
                        data.SERVICE_GROUP_NAME,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey[800]),
                      ),
                      // const Spacer(),
                      CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 196, 215, 233),
                        radius: 10.0,
                        child: ClipRRect(
                          child: Text(
                            data.TOTAL.toString(),
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          // borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget report(var data, BuildContext context) {
    return GestureDetector(
        child: Padding(
      padding: const EdgeInsets.fromLTRB(12, 2, 12, 0.0),
      child: InkWell(
        onTap: (() {
          globals.SERVICE_ID_by_summary = data.SERVICE_ID.toString();
          globals.SERVICE_NAME_SERVICES = data.SERVICE_NAME.toString();
          globals.Count_Services = data.CNT.toString();
          globals.SERVICE_GROUP_ID_BY_SUMMARY =
              data.SERVICE_GROUP_ID.toString();
          globals.CNT_BY_SUMMARY = data.CNT.toString();
          globals.SERVICE_GROUP_NAME_BY_SUMMARY =
              data.SERVICE_GROUP_NAME.toString();

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      summary_by_report(0, 0, total_business_loc_name)));
        }),
        child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.0)),
            elevation: 4.0,
            child: ListTile(
              title: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.medication_liquid_sharp,
                        color: Color.fromARGB(255, 36, 73, 151),
                        size: 18,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 6.0),
                        child: SizedBox(
                          width: 200,
                          child: Text(data.SERVICE_NAME,
                              style: TextStyle(
                                  color: Color(0xff123456),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.0)),
                        ),
                      ),
                      Spacer(),
                      CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 196, 215, 233),
                        radius: 10.0,
                        child: ClipRRect(
                          child: Text(
                            data.CNT.toString(),
                            style: TextStyle(fontSize: 14, color: Colors.black),
                          ),
                          //   borderRadius: BorderRadius.circular(70.0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ),
    ));
  }

  Widget build(BuildContext context) {
    final DateFormat formatter1 = DateFormat('dd-MMM-yyyy');
    var now = DateTime.now();
    Future<List<Service_Group_Wise_Services_Model>>
        _fetchManagerDetails() async {
      Map data = {
        // "IP_SRV_GRP_ID": globals.Glb_service_group_id,
        // "IP_DATE": "16-sep-2022",
        // "connection": globals.Connection_Flag

        "IP_SRV_GRP_ID": globals.Glb_service_group_id,
        "IP_DATE": "${selectedDate.toLocal()}".split(' ')[0],
        "IP_LOCATION_ID": globals.LOC_ID,
        "connection": globals.Connection_Flag
      };
      final jobsListAPIUrl = Uri.parse(
          globals.API_url + '/MobileSales/SERVICE_GROUP_WISE_SERVICES');
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
            .map((managers) =>
                Service_Group_Wise_Services_Model.fromJson(managers))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget verticalListClientChannelRep = Container(
        height: MediaQuery.of(context).size.height * 0.70,
        child: FutureBuilder<List<Service_Group_Wise_Services_Model>>(
            future: _fetchManagerDetails(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data;
                if (snapshot.data!.isEmpty == true) {
                  return NoContent();
                }
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

    Widget ServiceGroupName = Container(
        height: 95,
        child: FutureBuilder<List<Service_Group_Wise_Services_Model>>(
            future: _fetchManagerDetails(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var data = snapshot.data;
                if (snapshot.data!.isEmpty == true) {
                  return NoContent();
                }
                return SizedBox(child: ServiceGroupNameListView(data, context));
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              return Container();
            }));

    Widget BottOmNaviGation = Container(
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
                globals.Service_Group_Name = "R";
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
              child: Column(children: const [
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
                children: const [
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
                  globals.Glb_service_group_id = "";
                  globals.LOC_ID = "";
                  globals.fromDate = "";
                  globals.ToDate = "";
                  total_amouont = "";
                  globals.Radio_Lab_Flag == "R" || globals.Radio_Lab_Flag == "L"
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LocationWiseCollection()))
                      : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Total_Business()));
                },
                icon: Icon(Icons.arrow_back_ios)),
            Text(
              "Services",
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
            Container(child: ServiceGroupName),
            Container(child: verticalListClientChannelRep),
          ],
        ),
      ),
      bottomNavigationBar: BottOmNaviGation,
    );
  }
}

class Service_Group_Wise_Services_Model {
  final SERVICE_NAME;
  final SERVICE_STATUS;
  final PATIENT_NAME;
  final BILL_NO;
  final BILL_AMOUNT;
  final NET_AMOUNT;
  final CONCESSION_AMOUNT;
  final BILL_ID;
  final UMR_NO;
  final BILL_DT;
  final CNT;
  final SERVICE_GROUP_NAME;
  final SERVICE_GROUP_ID;
  final SERVICE_ID;
  final TOTAL;

  Service_Group_Wise_Services_Model({
    required this.SERVICE_NAME,
    required this.SERVICE_STATUS,
    required this.PATIENT_NAME,
    required this.BILL_NO,
    required this.BILL_AMOUNT,
    required this.NET_AMOUNT,
    required this.CONCESSION_AMOUNT,
    required this.BILL_ID,
    required this.UMR_NO,
    required this.BILL_DT,
    required this.CNT,
    required this.SERVICE_GROUP_NAME,
    required this.SERVICE_GROUP_ID,
    required this.SERVICE_ID,
    required this.TOTAL,
  });

  factory Service_Group_Wise_Services_Model.fromJson(
      Map<String, dynamic> json) {
    return Service_Group_Wise_Services_Model(
      SERVICE_NAME: json['SERVICE_NAME'].toString(),
      SERVICE_STATUS: json['PATIENT_NAME'].toString(),
      BILL_NO: json['BILL_NO'].toString(),
      BILL_AMOUNT: json['BILL_AMOUNT'].toString(),
      NET_AMOUNT: json['NET_AMOUNT'].toString(),
      CONCESSION_AMOUNT: json['CONCESSION_AMOUNT'].toString(),
      BILL_ID: json['BILL_ID'].toString(),
      UMR_NO: json['UMR_NO'].toString(),
      BILL_DT: json['BILL_DT'].toString(),
      PATIENT_NAME: json['PATIENT_NAME'].toString(),
      CNT: json['CNT'].toString(),
      SERVICE_GROUP_NAME: json['SERVICE_GROUP_NAME'].toString(),
      SERVICE_GROUP_ID: json['SERVICE_GROUP_ID'].toString(),
      SERVICE_ID: json['SERVICE_ID'].toString(),
      TOTAL: json['TOTAL'].toString(),
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
