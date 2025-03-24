import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:salesapp/report.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'ManagerEmployees.dart';
import 'New_Login.dart';
import 'ReportsPopupWidgets.dart';
import 'allbottomnavigationbar.dart';
import 'allinone.dart';
import 'business_new.dart';
import 'clients_search.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;

class SalesManagerDashboard extends StatefulWidget {
  const SalesManagerDashboard({Key? key}) : super(key: key);

  @override
  State<SalesManagerDashboard> createState() => _SalesManagerDashboardState();
}

class _SalesManagerDashboardState extends State<SalesManagerDashboard> {
  late Future<List<ManagerDetails>> _dataFuture;
  DateTimeRange _selectedDateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  ); // Variable to store selected date range
  late String
      _selectedOption; // Variable to store selected option, default to 'Today'
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var Dashboarddatasetval = [];
  final TextEditingController _searchController = TextEditingController();
  TextEditingController _Mobile_NoController = TextEditingController();
  TextEditingController _billnoController = TextEditingController();
  // Initialize _selectedOption to 'Today' when the page loads
  @override
  void initState() {
    super.initState();
    _selectedOption = 'Today';
    _dataFuture =
        fetchData(_selectedDateRange.start, _selectedDateRange.end, '1');
  }

  @override
  void dispose() {
    _searchController.dispose();
    _Mobile_NoController.dispose();
    _billnoController.dispose();
    super.dispose();
  }

  Future<List<ManagerDetails>> fetchData(
      DateTime fromDate, DateTime toDate, String sessionID) async {
    // Prepare API request data
    Map<String, dynamic> data = {
      "employee_id": globals.loginEmpid,
      "session_id": sessionID,
      "from_dt": fromDate.toLocal().toString().split(' ')[0],
      "to_dt": toDate.toLocal().toString().split(' ')[0],
      "connection": globals.Connection_Flag
    };

    // Prepare API URL
    final jobsListAPIUrl =
        Uri.parse(globals.API_url + '/MobileSales/ManagerEmpDetails');

    try {
      // Make POST request
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
        // Parse response JSON
        Map<String, dynamic> resposne = jsonDecode(response.body);
        List responseData = resposne['Data'];
        // Map JSON data to ManagerDetails objects
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
        Dashboarddatasetval = resposne["Data"];
        List<ManagerDetails> managerDetailsList =
            responseData.map((json) => ManagerDetails.fromJson(json)).toList();
        return managerDetailsList;
      } else {
        // Handle API error
        throw Exception('Failed to load data');
      }
    } catch (e) {
      // Handle exception
      throw Exception('Exception occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xff123456),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Builder(
                builder: (context) => IconButton(
                  icon: Image(image: NetworkImage(globals.Logo)),
                  onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                ),
              ),
            ),
            const Text(
              'Sales Dashboard',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.date_range_outlined),
              onPressed: () async {
                await _centerWiseBusinessDate(context);
              },
            ),
          ],
        ),
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
                    const SizedBox(
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
                  // Dashboarddatasetval = [];
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  // Remove multiple data entries
                  prefs.clear();

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
                  globals.Glb_IS_LOCK_REQ = "";
                  globals.glb_user_name = '';
                  globals.glb_password = '';
                  globals.Login_verification = "false";
                  globals.Glb_ManagerDetailsList = [];

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginClass()),
                  );
                },
                leading: const Icon(Icons.logout_rounded),
                title: const Text("Log Out"))
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildDateOption(
                        'Today',
                        DateTime.now(),
                        DateTime.now(),
                      ),
                      _buildDateOption(
                          'Yesterday',
                          DateTime.now().subtract(const Duration(days: 1)),
                          DateTime.now().subtract(const Duration(days: 1))),
                      // _buildDateOption(
                      //     'Tomorrow',
                      //     DateTime.now().add(const Duration(days: 0)),
                      //     DateTime.now().add(const Duration(days: 0))),
                      _buildDateOption(
                          'This Month',
                          DateTime(
                              DateTime.now().year, DateTime.now().month, 1),
                          DateTime.now()),
                      _buildDateOption(
                          'Last Month',
                          DateTime(
                              DateTime.now().year, DateTime.now().month - 1, 1),
                          DateTime(
                              DateTime.now().year,
                              DateTime.now().month - 1,
                              DateTime(DateTime.now().year,
                                      DateTime.now().month, 0)
                                  .day)),
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child:
                  // _selectedDateRange == null
                  //     ? Text(
                  //         ' ${DateFormat('dd-MM-yyyy').format(DateTime.now())}'
                  //         ' To  ${DateFormat('dd-MM-yyyy').format(DateTime.now())}',
                  //         style: const TextStyle(
                  //           color: Colors.red,
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 12.0,
                  //         ),
                  //       )
                  //     :
                  Text(
                '${DateFormat('dd-MMM-yyyy').format(_selectedDateRange.start)} '
                ' To ${DateFormat('dd-MMM-yyyy').format(_selectedDateRange.end)}',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<ManagerDetails>>(
                future: _dataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    List<ManagerDetails>? managerDetailsList = snapshot.data;
                    return ListView.builder(
                      itemCount: managerDetailsList!.length,
                      itemBuilder: (context, index) {
                        ManagerDetails managerDetails =
                            managerDetailsList[index];
                        return Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 4),
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      width: 2, color: const Color(0xFFE6E9EF)),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x05192F54),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                    BoxShadow(
                                      color: Color(0x05192F54),
                                      blurRadius: 15,
                                      offset: Offset(0, 15),
                                    ),
                                    BoxShadow(
                                      color: Color(0x02192F54),
                                      blurRadius: 20,
                                      offset: Offset(0, 33),
                                    ),
                                    BoxShadow(
                                      color: Color(0x00192F54),
                                      blurRadius: 24,
                                      offset: Offset(0, 59),
                                    ),
                                    BoxShadow(
                                      color: Color(0x00192F54),
                                      blurRadius: 26,
                                      offset: Offset(0, 92),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 30,
                                          child: Icon(
                                            Icons.account_box,
                                            size: 25,
                                            color: Color.fromARGB(255, 107, 114,
                                                151), // Custom icon color
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 6.0),
                                          child: Text(
                                            managerDetails.empname,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    buildDetailRow('Designation:',
                                        globals.Glb_DESIGNATION_NAME),
                                    buildDetailRow(
                                        'Emp cd:', globals.Employee_Code),
                                    buildDetailRow(
                                        'Email:', managerDetails.emailid),
                                    buildDetailRow(
                                        'Phone:', managerDetails.mobileno),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 2.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 4),
                                clipBehavior: Clip.antiAlias,
                                decoration: ShapeDecoration(
                                    shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            width: 2, color: Color(0xFFE6E9EF)),
                                        borderRadius: BorderRadius.circular(8)),
                                    shadows: const [
                                      BoxShadow(
                                        color: Color(0x05192F54),
                                        blurRadius: 8,
                                        offset: Offset(0, 4),
                                        spreadRadius: 0,
                                      ),
                                      BoxShadow(
                                        color: Color(0x05192F54),
                                        blurRadius: 15,
                                        offset: Offset(0, 15),
                                        spreadRadius: 0,
                                      ),
                                      BoxShadow(
                                        color: Color(0x02192F54),
                                        blurRadius: 20,
                                        offset: Offset(0, 33),
                                        spreadRadius: 0,
                                      ),
                                      BoxShadow(
                                        color: Color(0x00192F54),
                                        blurRadius: 24,
                                        offset: Offset(0, 59),
                                        spreadRadius: 0,
                                      ),
                                      BoxShadow(
                                        color: Color(0x00192F54),
                                        blurRadius: 26,
                                        offset: Offset(0, 92),
                                        spreadRadius: 0,
                                      )
                                    ]),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: TextField(
                                            controller: _searchController,
                                            decoration: InputDecoration(
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16.0),
                                                borderSide: const BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 206, 206, 206),
                                                ),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16.0),
                                                borderSide: const BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 218, 214, 214),
                                                ),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16.0),
                                                borderSide: const BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 34, 98, 171),
                                                ),
                                              ),
                                              hintText: 'Search Client Code',
                                              hintStyle: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 194, 193, 193)),
                                              prefixIcon: const Icon(
                                                Icons.person_search_outlined,
                                                color: Color.fromARGB(
                                                    255, 30, 66, 138),
                                              ),
                                            ),
                                          )),
                                          IconButton(
                                            icon: const Icon(Icons.search),
                                            onPressed: () {
                                              //  String searchText = _searchController.text;
                                              globals.Glb_Client_Code =
                                                  _searchController.text;
                                              _searchController.text = "";
                                              globals.new_selectedEmpid =
                                                  managerDetails.empid
                                                      .toString();

                                              // Handle search button press and navigate to the search results page
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Client_Search(
                                                    selectedDateIndex: 0,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    (int.parse(managerDetails.mngrcnt
                                                .toString()) >
                                            1)
                                        ? DashboardInfoWidget(
                                            icon: Icons.groups_sharp,
                                            iconColor: Colors.deepOrange,
                                            title: 'My Team',
                                            isClick: true,
                                            value: managerDetails.mngrcnt,
                                            onTap: () {
                                              // Handle tap action
                                              globals.Navigate_mngrcnt =
                                                  managerDetails.mngrcnt
                                                      .toString();
                                              // globals.Glb_empname = "";
                                              globals.Employee_Code = "";
                                              globals.Glb_IS_LOCK_REQ =
                                                  managerDetails.IS_LOCK_REQ
                                                      .toString();
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AllinOne(
                                                              selectedDateIndex:
                                                                  0)));
                                            },
                                          )
                                        : DashboardInfoWidget(
                                            icon: Icons.groups_sharp,
                                            iconColor: Colors.deepOrange,
                                            title: 'My Clients',
                                            value: managerDetails.My_Clients
                                                .toString(),
                                            onTap: () {
                                              // Handle tap action
                                              globals.Navigate_mngrcnt =
                                                  managerDetails.mngrcnt
                                                      .toString();
                                              globals.Glb_second_new_selectedEmpid =
                                                  managerDetails.empid;
                                              globals.Glb_IN_ACTIVE =
                                                  managerDetails.InActive;
                                              globals.Glb_ACTIVE =
                                                  managerDetails.Active;
                                              globals.Glb_TOTAL =
                                                  managerDetails.My_Clients;
                                              globals.Glb_empname =
                                                  managerDetails.empname;
                                              globals.Glb_business =
                                                  managerDetails.business;
                                              globals.glb_deposits =
                                                  managerDetails.deposits;
                                              globals.Glb_balance =
                                                  managerDetails.balance;
                                              globals.Glb_mobileno =
                                                  managerDetails.mobileno;
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ManagerEmployees(
                                                            selectedDateIndex:
                                                                0,
                                                          )));
                                            },
                                          ),
                                    DashboardInfoWidget(
                                      icon: Icons.business_sharp,
                                      iconColor: const Color.fromARGB(
                                          255, 90, 136, 236),
                                      title: 'Business',
                                      value: managerDetails.business.toString(),
                                      onTap: () {
                                        // Handle tap action
                                        globals.Glb_Method = "Business";
                                        globals.new_selectedEmpid = "";
                                        globals.glb_session_id = "3";
                                        globals.Navigate_mngrcnt =
                                            managerDetails.mngrcnt.toString();
                                        globals.Glb_empname = "";
                                        globals.Employee_Code = "";
                                        globals.Glb_IS_LOCK_REQ = managerDetails
                                            .IS_LOCK_REQ
                                            .toString();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => businesss(
                                                    selectedIndex: 0,
                                                  )),
                                        );
                                      },
                                      isClick: true,
                                    ),
                                    DashboardInfoWidget(
                                      icon: Icons.payments_outlined,
                                      iconColor:
                                          Color.fromARGB(255, 184, 84, 26),
                                      title: 'Deposits',
                                      value: managerDetails.deposits.toString(),
                                      onTap: () {
                                        globals.new_selectedEmpid = "";
                                        globals.glb_session_id = "4";
                                        globals.Glb_Method = "Payments";
                                        globals.Glb_empname = "";
                                        globals.Employee_Code = "";
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => businesss(
                                                      selectedIndex: 0,
                                                    )));
                                      },
                                      isClick: true,
                                    ),
                                    DashboardInfoWidget(
                                      icon: Icons.percent,
                                      iconColor:
                                          Color.fromARGB(255, 64, 29, 161),
                                      title: 'Avg. Business',
                                      value: managerDetails.AVG_BUSINESS
                                          .toString(),
                                      onTap: () {},
                                      isClick: false,
                                    ),
                                    DashboardInfoWidget(
                                      icon: Icons.calculate_rounded,
                                      iconColor: Colors.blue,
                                      title: 'Avg. Deposits',
                                      value: managerDetails.AVG_DEPOSITS
                                          .toString(),
                                      onTap: () {},
                                      isClick: false,
                                    ),
                                    DashboardInfoWidget(
                                      icon: Icons.card_travel_sharp,
                                      iconColor:
                                          Color.fromARGB(255, 224, 170, 19),
                                      title: 'Inventory Purchase',
                                      value: managerDetails.Inventory_Purchase
                                                  .toString() ==
                                              "null"
                                          ? "0"
                                          : managerDetails.Inventory_Purchase
                                              .toString(),
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
                                                builder: (context) => businesss(
                                                      selectedIndex: 0,
                                                    )));
                                      },
                                      isClick: true,
                                    ),
                                    DashboardInfoWidget(
                                      icon: Icons.cases_rounded,
                                      iconColor:
                                          Color.fromARGB(255, 96, 132, 167),
                                      title: 'Inventory Consumption',
                                      value: managerDetails
                                                      .Inventory_Consumption
                                                  .toString() ==
                                              "null"
                                          ? "0"
                                          : managerDetails.Inventory_Consumption
                                              .toString(),
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
                                                builder: (context) => businesss(
                                                      selectedIndex: 0,
                                                    )));
                                      },
                                      isClick: true,
                                    ),
                                    DashboardInfoWidget(
                                        icon: Icons.money_rounded,
                                        iconColor: const Color.fromARGB(
                                            255, 20, 169, 206),
                                        title: 'Outstanding',
                                        value: '',
                                        onTap: () {
                                          // Handle tap action
                                        },
                                        isClick: true,
                                        isExpandable: true,
                                        isLast: true),
                                    DashboardInfoWidget(
                                      icon: Icons.person,
                                      iconColor: Colors.blue,
                                      title: 'Clients Count',
                                      value:
                                          managerDetails.My_Clients.toString(),
                                      onTap: () {},
                                      isClick: false,
                                    ),
                                    DashboardInfoWidget(
                                      icon: Icons.report_gmailerrorred,
                                      iconColor: const Color.fromARGB(
                                          255, 104, 9, 228),
                                      title: 'Reports',
                                      value: '',
                                      onTap: () {
                                        // Handle tap action
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return CustomPopupDialog(
                                              mobileNoController:
                                                  _Mobile_NoController,
                                              billNoController:
                                                  _billnoController,
                                              onSubmit: () {
                                                if (_billnoController.text ==
                                                        "" &&
                                                    _Mobile_NoController.text ==
                                                        "") {
                                                  Fluttertoast.showToast(
                                                    msg: "Enter Valid Number",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.CENTER,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 180, 17, 17),
                                                    textColor: Colors.white,
                                                    fontSize: 16.0,
                                                  );
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
                                                          ReportData(0, 0),
                                                    ),
                                                  );
                                                }
                                                _billnoController.text = '';
                                                _Mobile_NoController.text = '';
                                              },
                                            );
                                          },
                                        );
                                      },
                                      // isClick: true,
                                    ),
                                    DashboardInfoWidget(
                                      icon: Icons.add_comment_outlined,
                                      iconColor: const Color.fromARGB(
                                          255, 233, 20, 197),
                                      title: 'Recent Payments',
                                      value: '',
                                      onTap: () {
                                        // Handle tap action
                                      },
                                      isLast: true,
                                      isClick: true,
                                      isExpandable: true,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    return const Center(child: Text('No data available'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AllbottomNavigation(),
    );
  }

  // Function to handle date range selection
  DateTime pastMonth = DateTime.now().subtract(Duration(days: 30));
  Future<void> _centerWiseBusinessDate(BuildContext context) async {
    final DateTimeRange? selected = await showDateRangePicker(
      context: context,
      firstDate: DateTime(DateTime.now().year + 1),
      lastDate: pastMonth,
      saveText: 'Done1',
    );

    if (selected != null) {
      final int daysDifference = selected.end.difference(selected.start).inDays;

      if (daysDifference > 30) {
        // Show an error message or handle accordingly
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
          globals.fromDate = selected.start.toString().split(' ')[0];
          globals.ToDate = selected.end.toString().split(' ')[0];
          _selectedDateRange = selected;
          _selectedOption =
              'Today'; // Reset selected option to 'Today' after date selection
          _dataFuture = fetchData(selected.start, selected.end, '1');
        });
      }
    }
  }

  Widget _buildDateOption(String label, DateTime fromDate, DateTime toDate) {
    bool isSelected = _selectedOption == label;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedDateRange = _getDateRangeFromLabel(label, fromDate, toDate);
          _selectedOption = label; // Update selected option
          _dataFuture = fetchData(fromDate, toDate, '1');
        });
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        margin: const EdgeInsets.only(right: 10.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.pink : Colors.blueGrey,
          ),
          borderRadius: BorderRadius.circular(20.0),
          color: isSelected ? Colors.pink : Colors.blueGrey,
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  DateTimeRange _getDateRangeFromLabel(
      String label, DateTime fromDate, DateTime toDate) {
    switch (label) {
      case 'Today':
        return DateTimeRange(start: fromDate, end: toDate);
      case 'Yesterday':
        return DateTimeRange(
            start: fromDate.subtract(const Duration(days: 0)),
            end: toDate.subtract(const Duration(days: 0)));
      case 'Tomorrow':
        return DateTimeRange(
            start: fromDate.add(const Duration(days: 1)),
            end: toDate.add(const Duration(days: 1)));
      case 'This Month':
        return DateTimeRange(start: fromDate, end: toDate);
      case 'Last Month':
        return DateTimeRange(start: fromDate, end: toDate);
      default:
        return DateTimeRange(start: fromDate, end: toDate);
    }
  }

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 7),
      child: Row(
        children: [
          const SizedBox(width: 30),
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget DashboardInfoWidget({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? value,
    Function()? onTap,
    bool? isLast,
    bool? isClick,
    bool? isExpandable,
  }) {
    if (isExpandable ?? false) {
      return ExpansionTile(
        title: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 10),
            // Text(
            //   title,
            //   style: const TextStyle(
            //     color: Colors.black54,
            //     fontWeight: FontWeight.w500,
            //   ),
            // ),
            TextButton(
              onPressed: () {
                // Handle tap action
                globals.new_selectedEmpid = "";
                globals.glb_session_id = "4";
                globals.Glb_Method = "Payments";
                globals.Glb_empname = "";
                globals.Employee_Code = "";
                title == "Recent Payments"
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => businesss(
                                  selectedIndex: 0,
                                )),
                      )
                    : Container();
              },
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
        children: [
          FutureBuilder<List<ManagerDetails>>(
            future: fetchData(
                _selectedDateRange.start, _selectedDateRange.end, '2'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(12.0),
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
                    if (title == 'Outstanding') {
                      return ListTile(
                        trailing: Text(managerDetail.balance,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500)),
                        // title: Text('Discount: ${managerDetail.business}'),
                        // subtitle: Text('Deposits: ${managerDetail.deposits}'),
                        // trailing: Text('Balance: ${managerDetail.balance}'),
                      );
                      // }
                      // else if (title == 'Recent Payments') {
                      //   return ListTile(
                      //     title: Text('Payment Date: ${managerDetail.business}'),
                      //     subtitle: Text('Amount: ${managerDetail.deposits}'),
                      //     trailing: Text('Status: ${managerDetail.balance}'),
                      //   );
                    } else {
                      final List<String> CodeDataList =
                          managerDetail.COMPANY_CDS.split(',');

                      final List<String> cmpAmountsList =
                          managerDetail.CMP_AMOUNTS.split(',');
                      final List<String> cmpPaymentDateList =
                          managerDetail.COMPANY_WISE_LAST_PAYMENT.split(',');
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 2.0),
                        child: Column(
                          children: List.generate(CodeDataList.length, (index) {
                            return Column(
                              children: [
                                ListTile(
                                  leading: Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Container(
                                      height: 26,
                                      width: 26,
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 31, 96, 161),
                                        borderRadius: BorderRadius.circular(8),
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
                                        fontWeight: FontWeight.w500,
                                      )),
                                  subtitle: Text(cmpPaymentDateList[index],
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey)),
                                  trailing: Text(cmpAmountsList[index],
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Color.fromARGB(
                                              255, 211, 77, 68))),
                                ),
                                if (index != CodeDataList.length - 1) Divider(),
                              ],
                            );
                          }),
                        ),
                      );
                    }
                  }).toList(),
                );
              } else {
                return const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text('No data available'),
                );
              }
            },
          ),
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: InkWell(
          onTap: onTap,
          child: Column(
            children: [
              Row(
                children: [
                  Icon(icon, color: iconColor),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    value!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (isClick ?? true)
                    Icon(
                      Icons.double_arrow_rounded,
                      color: Color.fromARGB(255, 72, 34, 177).withOpacity(0.3),
                      size: 30.0,
                    ),
                ],
              ),
              if (isLast ?? true)
                Divider(
                  thickness: 1,
                  color: Colors.grey.withOpacity(0.4),
                ),
            ],
          ),
        ),
      );
    }
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
  final Inventory_Purchase;
  final Inventory_Consumption;
  final AVG_DEPOSITS;
  final AVG_BUSINESS;

  ManagerDetails({
    required this.empid,
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
    required this.EMPLOYEE_CD,
    required this.Inventory_Purchase,
    required this.Inventory_Consumption,
    required this.AVG_DEPOSITS,
    required this.AVG_BUSINESS,
  });
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
      Inventory_Purchase: json['Inventory Purchase'].toString(),
      Inventory_Consumption: json['Inventory Consumption'].toString(),
      AVG_DEPOSITS: json['AVG_DEPOSITS'].toString(),
      AVG_BUSINESS: json['AVG_BUSINESS'].toString(),
    );
  }
}
