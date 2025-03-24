import 'dart:async';
// import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import './clientprofile.dart';
import 'Admin_Dashboard.dart';
import 'Sales_Dashboard.dart';
import 'globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

TextEditingController nameController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController newpasswordController = TextEditingController();
TextEditingController reEnterpasswordController = TextEditingController();
TextEditingController OtpController = TextEditingController();
final FocusNode nameFocusNode = FocusNode();
bool _isVisible = false;

class LoginClass extends StatefulWidget {
  const LoginClass({Key? key}) : super(key: key);

  @override
  State<LoginClass> createState() => _LoginClassState();
}

class _LoginClassState extends State<LoginClass> {
  void clearText() {
    nameController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Background(),
            LoginForm(),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  DateTime selectedDate = DateTime.now();
  UserLogin(username, password, BuildContext context) async {
    var isLoading = true;

    Map data = {
      "IP_USER_NAME": username,
      "IP_PASSWORD": '',
      "connection": "7"
      //"Server_Flag":""
    };

    print(data.toString());
    final response = await http.post(
        Uri.parse(globals.Slims_API_url + '/Logistics/APP_VALIDATION_MOBILE'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)["message"] != "success") {
        ErrorMessages();
        nameController.clear();
        passwordController.clear();
        FocusScope.of(context).requestFocus(nameFocusNode);
      } else {
        Map<String, dynamic> resposne = jsonDecode(response.body);

        globals.Connection_Flag = resposne["Data"][0]["CONNECTION_STRING"];
        globals.Report_URL = resposne["Data"][0]["REPORT_URL"];
        globals.Logo = resposne["Data"][0]["COMPANY_LOGO"];
        globals.API_url = resposne["Data"][0]["API_URL"].trim();
        globals.Glb_UPLOAD_ATTACHMENTS =
            resposne["Data"][0]["UPLOAD_ATTACHMENTS"].trim();

        globals.Glb_WITHOUTHEAD_URL = resposne["Data"][0]["WITHOUTHEAD_URL"];

        globals.Glb_WITHHEAD_URL = resposne["Data"][0]["WITHHEAD_URL"];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs
            .setString(
                'CONNECTION_STRING', resposne["Data"][0]["CONNECTION_STRING"])
            .toString();

        prefs
            .setString(
                'UPLOAD_ATTACHMENTS', resposne["Data"][0]["UPLOAD_ATTACHMENTS"])
            .toString();

        prefs
            .setString(
                'WITHOUTHEAD_URL', resposne["Data"][0]["WITHOUTHEAD_URL"])
            .toString();

        prefs
            .setString('WITHHEAD_URL', resposne["Data"][0]["WITHHEAD_URL"])
            .toString();

        prefs
            .setString('REPORT_URL', resposne["Data"][0]["REPORT_URL"])
            .toString();
        prefs
            .setString('COMPANY_LOGO', resposne["Data"][0]["COMPANY_LOGO"])
            .toString();
        prefs.setString('API_URL', resposne["Data"][0]["API_URL"]).toString();
        login(nameController.text, passwordController.text, context,
            resposne["Data"][0]["CLIENT_USER_NAME"].trim());
        // showLoader(context);
      }
    } else {
      ErrorMessages();
    }
  }

  login(username, password, BuildContext context, LOGIN_USER_NAME) async {
    // ProgressDialog progressDialog = ProgressDialog(context);
    // progressDialog.style(message: 'Loading...'); // Customize the loader message
    // progressDialog.show(); // Show the loader
    EasyLoading.show(status: 'Loading...');
    if (username.contains(':')) {
      username = username.split(':')[1];
    } else {
      username = LOGIN_USER_NAME;
    }
    Map data = {
      "user_name": username,
      "password": password,
      "from_dt": "${selectedDate.toLocal()}".split(' ')[0],
      "to_dt": "${selectedDate.toLocal()}".split(' ')[0],
      "connection": globals.Connection_Flag
    };

    globals.glb_user_name = username;
    globals.glb_password = password;
    print(data.toString());
    final response = await http.post(
      Uri.parse(globals.API_url.trim() + '/MobileSales/Login'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: data,
      encoding: Encoding.getByName("utf-8"),
    );

    setState(() {});

    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);
      // progressDialog.hide(); // Hide the loader
      EasyLoading.dismiss();
      if (resposne["message"] != "Invalid Username or Password" &&
          resposne["message"] != "Please Select password") {
        print(resposne["Data"]);
        Map<String, dynamic> user = resposne['Data'][0];
        globals.fromDate = "";
        globals.ToDate = "";

        globals.Glb_FILTER_BUSINESS_PAYMENTS =
            user['FILTER_BUSINESS_PAYMENTS'].toString();
        globals.Glb_Dr_Cr_Note = user['Dr_Cr_Note'].toString();
        globals.Glb_Client_Need = user['Client_Need'].toString();

        globals.USER_ID = user['USER_ID'].toString();
        String empID = user['REFERENCE_ID'].toString();
        globals.loginEmpid = user['REFERENCE_ID'].toString();
        globals.selectedEmpid = user['REFERENCE_ID'].toString();
        globals.Employee_Code = user['EMP_CD'].toString();
        globals.MailId = user['EMAIL_ID'].toString();
        globals.EmpName = user['EMP_NAME'].toString();
        globals.glb_deposits = "";
        globals.Glb_business = "";
        globals.Glb_balance = "";
        globals.Glb_mobileno = "";
        globals.Glb_emailid = user['EMAIL_ID'].toString();
        globals.BILL_COUNT = user['BILL_COUNT'].toString();
        globals.SRV_COUNT = user['SRV_COUNT'].toString();
        globals.GROSS = user['GROSS'].toString();
        globals.NET = user['NET'].toString();
        globals.DISCOUNT = user['DISCOUNT'].toString();
        globals.CANCELLED = user['CANCELLED'].toString();
        globals.Sales_Gross = user['GROSS_AMOUNT'].toString();
        globals.Sales_Net = user['NET_AMOUNT'].toString();
        globals.Sales_Samples = user['ORDERS'].toString();
        globals.Sales_Test = user['SAMPLES'].toString();
        globals.Glb_IS_REQ_BUSINESS = user['IS_REQ_BUSINESS'].toString();
        globals.controllerUserName = nameController.text.toString();
        globals.controllerPassword = passwordController.text.toString();
        globals.reference_type_id = user['REFERENCE_TYPE_ID'].toString();
        globals.Glb_SESSION_ID = user['SESSION_ID'].toString();
        globals.Glb_IS_ACCESS_ADD_CLIENT =
            user['IS_ACCESS_ADD_CLIENT'].toString();

        globals.Glb_DESIGNATION_NAME = user['DESIGNATION_NAME'].toString();

        globals.Glb_Client_Need_Avg_Business =
            user['Client_Need_Avg_Business'].toString();
        globals.Glb_Client_Need_Avg_Deposits =
            user['Client_Need_Avg_Deposits'].toString();
        globals.Glb_Client_Need_Inventory_Purchase =
            user['Client_Need_Inventory_Purchase'].toString();
        globals.Glb_Client_Need_Inventory_Consumption =
            user['Client_Need_Inventory_Consumption'].toString();
        globals.Glb_Client_Need_Add_Franchise_Client =
            user['Client_Need_Add_Franchise_Client'].toString();
        globals.Glb_Client_Need_Location_Wise_Business =
            user['Client_Need_Location_Wise_Business'].toString();

//here we are using Shared Preferences for logged in functionality
        SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('username', username.toString());
        prefs.setString('password', password.toString());

        prefs.setString('USER_ID', user['USER_ID'].toString()).toString();
        prefs
            .setString('REFERENCE_ID', user['REFERENCE_ID'].toString())
            .toString();
        prefs
            .setString('FILTER_BUSINESS_PAYMENTS',
                user['FILTER_BUSINESS_PAYMENTS'].toString())
            .toString();
        prefs
            .setString('Client_Need', user['Client_Need'].toString())
            .toString();
        prefs.setString('Dr_Cr_Note', user['Dr_Cr_Note'].toString()).toString();
        prefs.setString('EMP_CD', user['EMP_CD'].toString()).toString();
        prefs.setString('EMAIL_ID', user['EMAIL_ID'].toString()).toString();
        prefs.setString('EMP_NAME', user['EMP_NAME'].toString()).toString();

        prefs.setString('EMAIL_ID', user['EMAIL_ID'].toString()).toString();
        prefs.setString('BILL_COUNT', user['BILL_COUNT'].toString()).toString();
        prefs.setString('SRV_COUNT', user['SRV_COUNT'].toString()).toString();
        prefs.setString('GROSS', user['GROSS'].toString()).toString();
        prefs.setString('NET', user['NET'].toString()).toString();

        prefs.setString('DISCOUNT', user['DISCOUNT'].toString()).toString();
        prefs.setString('CANCELLED', user['CANCELLED'].toString()).toString();
        prefs
            .setString('GROSS_AMOUNT', user['GROSS_AMOUNT'].toString())
            .toString();
        prefs.setString('NET_AMOUNT', user['NET_AMOUNT'].toString()).toString();
        prefs.setString('ORDERS', user['ORDERS'].toString()).toString();

        prefs.setString('SAMPLES', user['SAMPLES'].toString()).toString();
        prefs
            .setString('IS_REQ_BUSINESS', user['IS_REQ_BUSINESS'].toString())
            .toString();
        prefs
            .setString(
                'REFERENCE_TYPE_ID', user['REFERENCE_TYPE_ID'].toString())
            .toString();
        prefs.setString('SESSION_ID', user['SESSION_ID'].toString()).toString();
        prefs
            .setString(
                'IS_ACCESS_ADD_CLIENT', user['IS_ACCESS_ADD_CLIENT'].toString())
            .toString();

        prefs
            .setString('DESIGNATION_NAME', user['DESIGNATION_NAME'].toString())
            .toString();

        prefs
            .setString('Client_Need_Avg_Business',
                user['Client_Need_Avg_Business'].toString())
            .toString();
        prefs
            .setString('Client_Need_Avg_Deposits',
                user['Client_Need_Avg_Deposits'].toString())
            .toString();
        prefs
            .setString('Client_Need_Inventory_Purchase',
                user['Client_Need_Inventory_Purchase'].toString())
            .toString();
        prefs
            .setString('Client_Need_Inventory_Consumption',
                user['Client_Need_Inventory_Consumption'].toString())
            .toString();
        prefs
            .setString('Client_Need_Add_Franchise_Client',
                user['Client_Need_Add_Franchise_Client'].toString())
            .toString();
        prefs
            .setString('Client_Need_Location_Wise_Business',
                user['Client_Need_Location_Wise_Business'].toString())
            .toString();

        if (user['REFERENCE_TYPE_ID'].toString() == '8') {
          globals.selectedClientid = globals.loginEmpid;

          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => ClientProfile(0))));
        } else if (user['REFERENCE_TYPE_ID'].toString() != '8' &&
            user['REFERENCE_TYPE_ID'].toString() != '28') {
          nameController.clear();
          passwordController.clear();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminDashboard(empID, 0)),
          );
        } else {
          nameController.clear();
          passwordController.clear();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SalesManagerDashboard()),
          );
        }
      } else {
        errormsg();
      }
    }
  }

  bool isButtonDisabled = false;
  Future<void> WaitingFunciton() async {
    if (!isButtonDisabled) {
      setState(() {
        isButtonDisabled = true; // Disable the button
      });

      WaitMessage();
      globals.Glb_IS_REQ_BUSINESS = "";
      globals.Connection_Flag = "";
      globals.Report_URL = "";
      globals.Logo = "";
      globals.API_url = "";
      UserLogin(nameController.text, passwordController.text, context);

      Future.delayed(Duration(seconds: 5), () {
        // Enable the button again after the delay
        setState(() {
          isButtonDisabled = false;
        });
      });
    }
  }

  OTPGenerate() async {
    newpasswordController.text = '';
    reEnterpasswordController.text = '';
    OtpController.text = '';
    Map data = {
      "user_name": nameController.text.toString(), "session_id": "1"
      //"Server_Flag":""
    };
    final response = await http.post(
        Uri.parse(globals.API_url + '/AllDashboards/GenerateOTP'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);
      if (resposne["message"] == "success") {
        globals.generateOtp = resposne["Data"][0]["MSG_ID"].toString();
        OtpSent();
        Navigator.push(context,
            MaterialPageRoute(builder: ((context) => const otpGenerate())));
      } else {
        return Fluttertoast.showToast(
            msg: "Enter correct Username",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Color.fromARGB(255, 238, 78, 38),
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  void updateStatus() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  void showLoader(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 8),
              Text("Logging in..."),
            ],
          ),
        );
      },
    );

    Timer(Duration(seconds: 30), () {
      Navigator.pop(context); // Dismiss the loader dialog
    });
  }

  @override
  void dispose() {
    // Clean up the focus nodes when the widget is disposed.
    nameFocusNode.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 60),
            child: Container(
              height: 80,
              width: 150,
              decoration: const BoxDecoration(
                  // shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage("assets/images/emisbackground.png"),
                      fit: BoxFit.fitHeight)),
            ),
          ),
          SizedBox(
            height: 150,
            child: Stack(
              children: [
                Container(
                  height: 150,
                  margin: const EdgeInsets.only(
                    right: 70,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(100),
                      bottomRight: Radius.circular(100),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 16, right: 32),
                        child: TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            //  hintStyle: TextStyle(fontSize: 20),
                            border: InputBorder.none,
                            icon: Icon(Icons.account_circle_rounded),
                            hintText: "Enter Username",
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 16, right: 32),
                        child: TextField(
                          controller: passwordController,
                          obscureText: _isVisible ? false : true,
                          decoration: InputDecoration(
                            // hintStyle: TextStyle(fontSize: 22),
                            border: InputBorder.none,
                            icon: Icon(Icons.lock_outline_rounded),
                            suffixIcon: IconButton(
                              onPressed: () => updateStatus(),
                              icon: Icon(_isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                            hintText: "Enter Password",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(right: 15),
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green[200]!.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xff123456),
                          Color.fromARGB(255, 35, 59, 125),
                        ],
                      ),
                    ),
                    child: TextButton(
                        onPressed: () {
                          WaitingFunciton();
                          globals.Login_verification = "true";
                        },
                        child: Text('Sign in',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16))),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(right: 16, top: 16),
                child: TextButton(
                  // style: TextButton.styleFrom(
                  //   //primary: Colors.green,
                  //   backgroundColor: Color(0xff123456), // Text Color
                  // ),
                  onPressed: () {
                    OTPGenerate();
                  },
                  //textColor: Color(0xff123456),
                  child: Text('Forgot Password'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Background extends StatefulWidget {
  @override
  _MyPainterState createState() => _MyPainterState();
}

class _MyPainterState extends State<Background> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Center(
        child: Container(
          color: Colors.white,
          child: CustomPaint(
            size: Size(size.width, size.height),
            painter: Curved(),
          ),
        ),
      ),
    );
  }
}

class Curved extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var rect = Offset.zero & size;
    // Path rectPathThree = Path();
    Paint paint = Paint();
    paint.shader = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      stops: [.01, .25],
      colors: [
        Color(0xff123456),
        Color(0xff123456),
      ],
    ).createShader(rect);

    Paint paint2 = Paint();
    paint2.shader = const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      stops: [.05, 1],
      colors: [
        Color(0xff123456),
        Color(0xff123456),
      ],
    ).createShader(rect);

    var path = Path();
    var path2 = Path();

    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.1,
      size.width * 0.6,
      size.height * 0.1,
    );
    path.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.1,
      size.width * 0.1,
      size.height * 0.3,
    );
    path.quadraticBezierTo(
      size.width * 0.06,
      size.height * 0.4,
      size.width * 0,
      size.height * 0.4,
    );
    path.close();
    //
    path2.moveTo(size.width, size.height);
    path2.lineTo(size.width, size.height * 0.7);
    path2.quadraticBezierTo(
      size.width,
      size.height * .65,
      size.width,
      size.height * 0.7,
    );
    path2.quadraticBezierTo(
      size.width * .9,
      size.height * .95,
      size.width * 0.2,
      size.height * 0.97,
    );
    path2.quadraticBezierTo(
      size.width * .1,
      size.height * .98,
      size.width * 0.1,
      size.height,
    );
    //
    canvas.drawPath(path, paint);
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

// FOR PAINTING THE CIRCLE
class CirclePainter extends CustomPainter {
  final double radius;
  CirclePainter(this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Color.fromARGB(255, 120, 64, 251)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    var path = Path();
    path.addOval(Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: radius,
    ));
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class otpGenerate extends StatefulWidget {
  const otpGenerate({Key? key}) : super(key: key);

  @override
  State<otpGenerate> createState() => _otpGenerateState();
}

class _otpGenerateState extends State<otpGenerate> {
  OTPValidate() async {
    if (OtpController.text.toString() == "" ||
        OtpController.text.toString() == null) {
      plzEnterOtp();
      return false;
    }

    Map data = {
      "MSG_ID": globals.generateOtp.split('.')[0],
      "OTP": OtpController.text.toString()
      //"Server_Flag":""
    };
    final response = await http.post(
        Uri.parse(globals.API_url + '/AllDashboards/ValidateOTP'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);
      if (resposne["message"] == "success") {
        Successtoaster();
        Navigator.push(context,
            MaterialPageRoute(builder: ((context) => const newPassPopup())));
      } else {
        return Fluttertoast.showToast(
            msg: "Invalid OTP",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Color.fromARGB(255, 110, 95, 248),
            textColor: Color.fromARGB(255, 110, 95, 248),
            fontSize: 16.0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          labelText: 'Enter OTP'),
                      controller: OtpController),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        OTPValidate();
                      },
                      child: Container(
                          width: 100,
                          height: 40,
                          decoration: const BoxDecoration(
                              color: Color(0xff123456),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0))),
                          child: const Center(
                            child: Text('APPLY',
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

class newPassPopup extends StatefulWidget {
  const newPassPopup({Key? key}) : super(key: key);

  @override
  State<newPassPopup> createState() => _newPassPopupState();
}

class _newPassPopupState extends State<newPassPopup> {
  @override
  Widget build(BuildContext context) {
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

Successtoaster() {
  return Fluttertoast.showToast(
      msg: "Validate Successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 93, 204, 89),
      textColor: Colors.white,
      fontSize: 16.0);
}

OtpSent() {
  return Fluttertoast.showToast(
      msg: "OTP Sent",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 126, 224, 123),
      textColor: Colors.white,
      fontSize: 16.0);
}

errormsg() {
  return Fluttertoast.showToast(
      msg: "Invalid Password",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 238, 26, 11),
      textColor: Colors.white,
      fontSize: 16.0);
}

passwordmismatch() {
  return Fluttertoast.showToast(
      msg: "Password is mismatch",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 238, 26, 11),
      textColor: Colors.white,
      fontSize: 16.0);
}

plzEnterOtp() {
  return Fluttertoast.showToast(
      msg: "Enter OTP",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 236, 231, 230),
      textColor: Colors.black,
      fontSize: 16.0);
}

NewPassword(BuildContext context) async {
  if (newpasswordController.text.toString() !=
      reEnterpasswordController.text.toString()) {
    passwordmismatch();
    return false;
  }
  Map data = {
    "user_name": nameController.text.toString(),
    "password": newpasswordController.text.toString()
    //"Server_Flag":""
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
      Successtoaster();
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

errormsg1() {
  return Fluttertoast.showToast(
      msg: "Invalid UserName and Password",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 238, 26, 11),
      textColor: Colors.white,
      fontSize: 16.0);
}

WaitMessage() {
  return Fluttertoast.showToast(
      msg: "Verifying",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 17, 188, 17),
      textColor: Colors.white,
      fontSize: 20.0);
}

ErrorMessages() {
  return Fluttertoast.showToast(
      msg: "Invalid User Name",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 238, 26, 11),
      textColor: Colors.white,
      fontSize: 16.0);
}
