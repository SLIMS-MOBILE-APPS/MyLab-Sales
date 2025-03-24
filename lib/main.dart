import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'Admin_Dashboard.dart';
import 'New_Login.dart';

import 'Sales_Dashboard.dart';
import 'globals.dart' as globals;

import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xff123456),
        colorScheme: ColorScheme.fromSwatch(
          primaryColorDark: const Color(0xff123456),
          accentColor: const Color(0xff123456),
        ),
      ),
      initialRoute: '/splash', // Set splash screen as the initial route
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => const MyAppHomeScreen(), // Your main app screen
      },
    );
  }
}

class MyAppHomeScreen extends StatelessWidget {
  const MyAppHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Your existing code for deciding the initial route
    return FutureBuilder(
      future: _getInitialRoute(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Navigator(
            initialRoute: snapshot.data.toString(),
            onGenerateRoute: (settings) {
              switch (settings.name) {
                case '/Admin_home':
                  return MaterialPageRoute(
                      builder: (_) => AdminDashboard("0", 0));
                case '/Sales_home':
                  return MaterialPageRoute(
                      builder: (_) => SalesManagerDashboard());
                default:
                  return MaterialPageRoute(builder: (_) => const LoginClass());
              }
            },
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return const Scaffold(
            body: Center(child: Text('Error occurred')),
          );
        }
      },
    );
  }

  Future<String> _getInitialRoute() async {
    globals.Glb_ManagerDetailsList = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    globals.USER_ID = prefs.getString('USER_ID') ?? '';
    globals.loginEmpid = prefs.getString('REFERENCE_ID') ?? '';
    globals.selectedEmpid = prefs.getString('REFERENCE_ID') ?? '';
    globals.Employee_Code = prefs.getString('EMP_CD') ?? '';
    globals.MailId = prefs.getString('EMAIL_ID') ?? '';
    globals.EmpName = prefs.getString('EMP_NAME') ?? '';
    globals.Glb_emailid = prefs.getString('EMAIL_ID') ?? '';
    globals.BILL_COUNT = prefs.getString('BILL_COUNT') ?? '';
    globals.SRV_COUNT = prefs.getString('SRV_COUNT') ?? '';
    globals.GROSS = prefs.getString('GROSS') ?? '';
    globals.NET = prefs.getString('NET') ?? '';
    globals.DISCOUNT = prefs.getString('DISCOUNT') ?? '';
    globals.CANCELLED = prefs.getString('CANCELLED') ?? '';
    globals.Sales_Gross = prefs.getString('GROSS_AMOUNT') ?? '';
    globals.Sales_Net = prefs.getString('NET_AMOUNT') ?? '';
    globals.Sales_Samples = prefs.getString('SAMPLES') ?? '';
    globals.Glb_IS_REQ_BUSINESS = prefs.getString('IS_REQ_BUSINESS') ?? '';
    globals.reference_type_id = prefs.getString('REFERENCE_TYPE_ID') ?? '';
    globals.Glb_SESSION_ID = prefs.getString('SESSION_ID') ?? '';
    globals.Glb_IS_ACCESS_ADD_CLIENT =
        prefs.getString('IS_ACCESS_ADD_CLIENT') ?? '';
    globals.Connection_Flag = prefs.getString('CONNECTION_STRING') ?? '';
    globals.Report_URL = prefs.getString('REPORT_URL') ?? '';
    globals.API_url = prefs.getString('API_URL') ?? '';
    globals.Logo = prefs.getString('COMPANY_LOGO') ?? '';

    globals.glb_user_name = prefs.getString('username') ?? '';
    globals.glb_password = prefs.getString('password') ?? '';
    globals.Glb_DESIGNATION_NAME = prefs.getString('DESIGNATION_NAME') ?? '';
    globals.Glb_UPLOAD_ATTACHMENTS =
        prefs.getString('UPLOAD_ATTACHMENTS') ?? '';

    globals.Glb_WITHOUTHEAD_URL = prefs.getString('WITHOUTHEAD_URL') ?? '';
    globals.Glb_WITHHEAD_URL = prefs.getString('WITHHEAD_URL') ?? '';

    globals.Glb_FILTER_BUSINESS_PAYMENTS =
        prefs.getString('FILTER_BUSINESS_PAYMENTS') ?? '';

    globals.Glb_Dr_Cr_Note = prefs.getString('Dr_Cr_Note') ?? '';
    globals.Glb_Client_Need = prefs.getString('Client_Need') ?? '';

    globals.Glb_Client_Need_Avg_Business =
        prefs.getString('Client_Need_Avg_Business') ?? '';
    globals.Glb_Client_Need_Avg_Deposits =
        prefs.getString('Client_Need_Avg_Deposits') ?? '';
    globals.Glb_Client_Need_Inventory_Purchase =
        prefs.getString('Client_Need_Inventory_Purchase') ?? '';
    globals.Glb_Client_Need_Inventory_Consumption =
        prefs.getString('Client_Need_Inventory_Consumption') ?? '';
    globals.Glb_Client_Need_Add_Franchise_Client =
        prefs.getString('Client_Need_Add_Franchise_Client') ?? '';
    globals.Glb_Client_Need_Location_Wise_Business =
        prefs.getString('Client_Need_Location_Wise_Business') ?? '';

    return (prefs.getString('REFERENCE_TYPE_ID') == null &&
            prefs.getString('REFERENCE_TYPE_ID') == null)
        ? ('/Login')
        : (prefs.getString('REFERENCE_TYPE_ID') == '8' ||
                prefs.getString('REFERENCE_TYPE_ID') == '28')
            ? ('/Sales_home')
            : ('/Admin_home');
  }
}

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     String empID = "0";
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//             primaryColor: const Color(0xff123456),
//             colorScheme: ColorScheme.fromSwatch(
//               primaryColorDark: Color(0xff123456),
//               accentColor: const Color(0xff123456),
//             )
//             // colorSchemeSeed: Color(0xff123456)
//             //  primaryColor: Colors.white
//             ),
//         home: FutureBuilder(
//           future: _getInitialRoute(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.done) {
//               return Navigator(
//                 initialRoute: snapshot.data.toString(),
//                 onGenerateRoute: (settings) {
//                   switch (settings.name) {
//                     case '/Admin_home':
//                       return MaterialPageRoute(
//                           builder: (_) => AdminDashboard(empID, 0));
//                     case '/Sales_home':
//                       return MaterialPageRoute(
//                           builder: (_) => const SalesManagerDashboard());
//                     default:
//                       return MaterialPageRoute(
//                           builder: (_) => const LoginClass());
//                   }
//                 },
//               );
//             } else if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Scaffold(
//                 body: Center(
//                   child:
//                       CircularProgressIndicator(), // Show a loading indicator
//                 ),
//               );
//             } else {
//               return const Scaffold(
//                 body: Center(
//                   child: Text('Error occurred'), // Show an error message
//                 ),
//               );
//             }
//           },
//         ));
//   }

//   Future<String> _getInitialRoute() async {
//     globals.Glb_ManagerDetailsList = [];
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     globals.USER_ID = prefs.getString('USER_ID') ?? '';
//     globals.loginEmpid = prefs.getString('REFERENCE_ID') ?? '';
//     globals.selectedEmpid = prefs.getString('REFERENCE_ID') ?? '';
//     globals.Employee_Code = prefs.getString('EMP_CD') ?? '';
//     globals.MailId = prefs.getString('EMAIL_ID') ?? '';
//     globals.EmpName = prefs.getString('EMP_NAME') ?? '';
//     globals.Glb_emailid = prefs.getString('EMAIL_ID') ?? '';
//     globals.BILL_COUNT = prefs.getString('BILL_COUNT') ?? '';
//     globals.SRV_COUNT = prefs.getString('SRV_COUNT') ?? '';
//     globals.GROSS = prefs.getString('GROSS') ?? '';
//     globals.NET = prefs.getString('NET') ?? '';
//     globals.DISCOUNT = prefs.getString('DISCOUNT') ?? '';
//     globals.CANCELLED = prefs.getString('CANCELLED') ?? '';
//     globals.Sales_Gross = prefs.getString('GROSS_AMOUNT') ?? '';
//     globals.Sales_Net = prefs.getString('NET_AMOUNT') ?? '';
//     globals.Sales_Samples = prefs.getString('SAMPLES') ?? '';
//     globals.Glb_IS_REQ_BUSINESS = prefs.getString('IS_REQ_BUSINESS') ?? '';
//     globals.reference_type_id = prefs.getString('REFERENCE_TYPE_ID') ?? '';
//     globals.Glb_SESSION_ID = prefs.getString('SESSION_ID') ?? '';
//     globals.Glb_IS_ACCESS_ADD_CLIENT =
//         prefs.getString('IS_ACCESS_ADD_CLIENT') ?? '';
//     globals.Connection_Flag = prefs.getString('CONNECTION_STRING') ?? '';
//     globals.Report_URL = prefs.getString('REPORT_URL') ?? '';
//     globals.API_url = prefs.getString('API_URL') ?? '';
//     globals.Logo = prefs.getString('COMPANY_LOGO') ?? '';

//     globals.glb_user_name = prefs.getString('username') ?? '';
//     globals.glb_password = prefs.getString('password') ?? '';
//     globals.Glb_DESIGNATION_NAME = prefs.getString('DESIGNATION_NAME') ?? '';
//     globals.Glb_UPLOAD_ATTACHMENTS =
//         prefs.getString('UPLOAD_ATTACHMENTS') ?? '';

//     globals.Glb_WITHOUTHEAD_URL = prefs.getString('WITHOUTHEAD_URL') ?? '';
//     globals.Glb_WITHHEAD_URL = prefs.getString('WITHHEAD_URL') ?? '';

//     globals.Glb_FILTER_BUSINESS_PAYMENTS =
//         prefs.getString('FILTER_BUSINESS_PAYMENTS') ?? '';

//     return (prefs.getString('REFERENCE_TYPE_ID') == null &&
//             prefs.getString('REFERENCE_TYPE_ID') == null)
//         ? ('/Login')
//         : (prefs.getString('REFERENCE_TYPE_ID') == '8' ||
//                 prefs.getString('REFERENCE_TYPE_ID') == '28')
//             ? ('/Sales_home')
//             : ('/Admin_home');
//   }
// }

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:
            const Color(0xff123456), // Change this to your splash color
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: SizedBox(
              width: 100,
              height: 100,
              child: LoadingIndicator(
                indicatorType:
                    Indicator.ballSpinFadeLoader, // Choose your indicator type
                colors: [Colors.blue, Colors.red, Colors.green],
                strokeWidth: 2,
              ),
            ),
          ),
        ));
  }
}
