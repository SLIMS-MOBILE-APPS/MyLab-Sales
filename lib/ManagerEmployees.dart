import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
// import 'package:progress_dialog/progress_dialog.dart';
import 'HashService.dart';
import './managerbusiness.dart';
import './popup.dart';
import 'Sales_Dashboard.dart';
import 'allbottomnavigationbar.dart';
import 'allinone.dart';
import 'clientprofile.dart';
import 'globals.dart' as globals;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:payu_checkoutpro_flutter/payu_checkoutpro_flutter.dart';
import 'package:payu_checkoutpro_flutter/PayUConstantKeys.dart';
import 'dart:convert';
import 'package:payu_checkoutpro_flutter/payu_checkoutpro_flutter.dart';
import 'package:payu_checkoutpro_flutter/PayUConstantKeys.dart';
import 'HashService.dart';
import 'deviceinformation.dart';
import 'globals.dart';

final TextEditingController _controller = TextEditingController();
final _formKey = GlobalKey<FormState>();
TextEditingController amountController = TextEditingController();
TextEditingController remarkController = TextEditingController();

TextEditingController Credit_amountController = TextEditingController();
TextEditingController Credit_remarkController = TextEditingController();

class ManagerEmployees extends StatefulWidget {
  int selectedDateIndex;
  ManagerEmployees({super.key, required this.selectedDateIndex});

  @override
  _ManagerEmployeesState createState() => _ManagerEmployeesState();
}

class _ManagerEmployeesState extends State<ManagerEmployees>
    implements PayUCheckoutProProtocol {
  late PayUCheckoutProFlutter _checkoutPro; //this is written for pu money
  var selecteFromdt = '';
  var selecteTodt = '';
  DateTime selectedDate = DateTime.now();

  late Future<List<ManagerClients>> _futureClients;
  final TextEditingController _searchControllerClient = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String empID = "0";
  DateTime pastMonth = DateTime.now().subtract(Duration(days: 30));
  _CenterWiseBusinessDate(BuildContext context) async {
    final DateTimeRange? selected = await showDateRangePicker(
      context: context,
      firstDate: pastMonth,
      lastDate: DateTime(DateTime.now().year + 1),
      saveText: 'Done',
    );

    if (selected != null) {
      final int daysDifference = selected.end.difference(selected.start).inDays;

      if (daysDifference > 30) {
        // Show an error message or handle accordingly
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Invalid Date Range'),
              content: Text('Please select a date range within 30 days.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
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
          // globals.fromDate = selected.start.toString().split(' ')[0];
          // globals.ToDate = selected.end.toString().split(' ')[0];

          globals.fromDate = DateFormat('dd-MMM-yyyy').format(selected.start);

          globals.ToDate = DateFormat('dd-MMM-yyyy').format(selected.end);
          // _futureClients = _fetchSalespersons(); // Refresh the Future
          //  print(amount);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _futureClients = _fetchSalespersons();
    _checkoutPro = PayUCheckoutProFlutter(this);
  }

  @override
  Future<List<ManagerClients>> _fetchSalespersons() async {
    Map data = {
      "emp_id": globals.Glb_second_new_selectedEmpid,
      "session_id": "1",
      "IP_FLAG": globals.Glb_Flag,
      "IP_CLIENT_CD": "",
      "IP_FROM_DATE": selecteFromdt == ""
          ? "${selectedDate.toLocal()}".split(' ')[0]
          : selecteFromdt,
      "IP_TO_DATE": selecteTodt == ""
          ? "${selectedDate.toLocal()}".split(' ')[0]
          : selecteTodt,
      "connection": globals.Connection_Flag
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

  // Future<List<SalesManagers>>? _fetchSaleTransactionFuture;
  // List<SalesManagers>? _cachedSaleTransaction;

  // Future<List<SalesManagers>> _fetchSaleTransaction() async {
  //   if (_cachedSaleTransaction != null) {
  //     return _cachedSaleTransaction!;
  //   }

  //   Map data = {
  //     "emp_id":
  //         globals.Glb_second_new_selectedEmpid, //globals.new_selectedEmpid,
  //     "session_id": "1",
  //     "IP_SALES_EMP_CD": "",
  //     "IP_FLAG": "",
  //     "IP_FROM_DATE": selecteFromdt == ""
  //         ? "${selectedDate.toLocal()}".split(' ')[0]
  //         : selecteFromdt,
  //     "IP_TO_DATE": selecteTodt == ""
  //         ? "${selectedDate.toLocal()}".split(' ')[0]
  //         : selecteTodt,
  //     "connection": globals.Connection_Flag
  //   };

  //   final jobsListAPIUrl =
  //       Uri.parse(globals.API_url + '/MobileSales/MgnrEmpDtls');
  //   var response = await http.post(jobsListAPIUrl,
  //       headers: {
  //         "Accept": "application/json",
  //         "Content-Type": "application/x-www-form-urlencoded"
  //       },
  //       body: data,
  //       encoding: Encoding.getByName("utf-8"));

  //   if (response.statusCode == 200) {
  //     Map<String, dynamic> resposne = jsonDecode(response.body);
  //     List jsonResponse = resposne["Data"];

  //     _cachedSaleTransaction = jsonResponse
  //         .map((managers) => SalesManagers.fromJson(managers))
  //         .toList();

  //     return _cachedSaleTransaction!;
  //   } else {
  //     throw Exception('Failed to load jobs from API');
  //   }
  // }

  // // Call this method to get the sale transactions data
  // Future<List<SalesManagers>> getSaleTransaction() {
  //   if (_fetchSaleTransactionFuture == null) {
  //     _fetchSaleTransactionFuture = _fetchSaleTransaction();
  //   }
  //   return _fetchSaleTransactionFuture!;
  // }

  Future<List<SalesManagers>> _fetchSaleTransaction() async {
    var jobsListAPIUrl = null;
    var dsetName = '';
    List listresponse = [];

    Map data = {
      "emp_id":
          globals.Glb_second_new_selectedEmpid, //globals.new_selectedEmpid,
      "session_id": "1",
      "IP_SALES_EMP_CD": "",
      "IP_FLAG": "",
      "IP_FROM_DATE": selecteFromdt == ""
          ? "${selectedDate.toLocal()}".split(' ')[0]
          : selecteFromdt,
      "IP_TO_DATE": selecteTodt == ""
          ? "${selectedDate.toLocal()}".split(' ')[0]
          : selecteTodt,
      "connection": globals.Connection_Flag
    };

    dsetName = 'result';
    jobsListAPIUrl = Uri.parse(globals.API_url + '/MobileSales/MgnrEmpDtls');

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
          .map((strans) => SalesManagers.fromJson(strans))
          .toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget Application_Widget(var data, BuildContext context) {
      return GestureDetector(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => managerbusiness(0)),
            // );
          },
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 3,
                  child: ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: SizedBox(
                        child: Icon(
                          Icons.account_box,
                          size: 20,
                          color: Color.fromARGB(255, 107, 114, 151),
                        ),
                      ),
                    ),
                    title: Row(
                      children: [
                        Text(data.empname.toString(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            )),
                        Spacer(),
                        Text(data.EMPLOYEE_CD.toString(),
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 116, 111, 111))),
                      ],
                    ),
                    // subtitle: Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Text("(B)" + data.business.toString(),
                    //               style: TextStyle(
                    //                   fontSize: 12,
                    //                   fontWeight: FontWeight.w500,
                    //                   color: Colors.green)),
                    //           Text("(P)" + data.deposits.toString(),
                    //               style: TextStyle(
                    //                   fontSize: 12,
                    //                   fontWeight: FontWeight.w500,
                    //                   color: Colors.blue)),
                    //           Text("(O)" + data.balance.toString(),
                    //               style: TextStyle(
                    //                   fontSize: 12,
                    //                   fontWeight: FontWeight.w500,
                    //                   color: Colors.red)),
                    //         ],
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: const EdgeInsets.fromLTRB(0, 6, 0, 4),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           Text('Active (' + data.acount.toString() + ')',
                    //               style: TextStyle(
                    //                   fontSize: 12,
                    //                   fontWeight: FontWeight.w500,
                    //                   color: Color.fromARGB(255, 31, 190, 52))),
                    //           Text('Locked (' + data.icount.toString() + ')',
                    //               style: TextStyle(
                    //                   fontSize: 12,
                    //                   fontWeight: FontWeight.w500,
                    //                   color: Color.fromARGB(255, 202, 24, 24))),
                    //           Text('Total (' + data.total.toString() + ')',
                    //               style: TextStyle(
                    //                   fontSize: 12,
                    //                   fontWeight: FontWeight.w500,
                    //                   color: Color.fromARGB(255, 64, 17, 190))),
                    //         ],
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: const EdgeInsets.fromLTRB(0, 6, 0, 4),
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //         children: [
                    //           data.mobileno.toString() == "null"
                    //               ? Text("",
                    //                   style: TextStyle(
                    //                       fontSize: 12,
                    //                       fontWeight: FontWeight.w500,
                    //                       color: Colors.grey))
                    //               : Text(data.mobileno.toString(),
                    //                   style: TextStyle(
                    //                       fontSize: 12,
                    //                       fontWeight: FontWeight.w500,
                    //                       color: Colors.grey)),
                    //           Spacer(),
                    //           Text(data.emailid.toString(),
                    //               style: TextStyle(
                    //                   fontSize: 12,
                    //                   fontWeight: FontWeight.w500,
                    //                   color: Colors.grey)),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ))));
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

    Widget verticalList3 = Container(
      height: MediaQuery.of(context).size.height * 0.1,
      child: FutureBuilder<List<SalesManagers>>(
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
                    height: 30, width: 30, child: CircularProgressIndicator()));
          }),
    );
    Password_Confirmation_Message() {
      confirmPasswordController.text = "";
      return Fluttertoast.showToast(
          msg: "The password does not match",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(255, 212, 113, 47),
          textColor: Colors.white,
          fontSize: 16.0);
    }

    Widget _buildClientsCard(data, BuildContext context) {
      // DateTime now = DateTime.now();

      // int seed = now.millisecondsSinceEpoch;

      // Random random = Random(seed);

      // List<int> randomNumbers =
      //     List.generate(10, (_) => random.nextInt(100)); // Range 0 to 99

      void _showPopup(BuildContext context) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              // title: Text('Enter Money Price'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Color(0xff123456),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      padding: EdgeInsets.all(10),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Outstanding Due:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.white),
                            ),
                            SizedBox(
                                height:
                                    5), // Add some spacing between text and value
                            Text(
                              data.balance.toString(),
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _controller,
                      decoration: InputDecoration(hintText: 'Enter Amount'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a price';
                        }
                        final number = double.tryParse(value);
                        if (number == null || number <= 0) {
                          return 'Please enter a valid price';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromRGBO(3, 169, 244,
                          1), // Set the button's background color to light grey
                    ),
                    child: const Text("OK"),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Process the input

                        print('Entered price: ${_controller.text}');
                        globals.glb_entered_price = _controller.text;
                        globals.clientName = data.clientname;
                        globals.MailId = data.EMAIL_ID;
                        globals.glb_MOBILE_PHONE = data.MOBILE_NO;
                        globals.glb_merchantSalt = data.PAYU_MERCHANT_SALT;
                        globals.glb_merchantKey = data.PAYU_MERCHANT_KEY;
                        globals.glb_Transaction_Client_Id =
                            data.COMPANY_ID.toString();

                        _checkoutPro.openCheckoutScreen(
                          payUPaymentParams:
                              PayUParams.createPayUPaymentParams(),
                          payUCheckoutProConfig:
                              PayUParams.createPayUConfigParams(),
                        );
                        _controller.text = "";
                        Navigator.of(context).pop();
                      }
                    }),
              ],
            );
          },
        );
      }

      ClientName = '';
      clienlockflag = '';
      clienlockflag = data.locked;
      UPD_PASSWORD_MOBILE(BuildContext context, UserCODE, Password) async {
        newPasswordController.text = "";
        confirmPasswordController.text = "";
        Navigator.of(context).pop(); // Close the dialog
        Map data = {
          "IP_USER_NAME": UserCODE,
          "IP_PASSWORD": Password,
          "connection": globals.Connection_Flag
        };
        print(data.toString());
        final response = await http.post(
            Uri.parse(globals.API_url + '/MobileSales/UPD_PASSWORD_MOBILE'),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/x-www-form-urlencoded"
            },
            body: data,
            encoding: Encoding.getByName("utf-8"));

        if (response.statusCode == 200) {
          Successfully_Message();
          Map<String, dynamic> resposne = jsonDecode(response.body);
          if (resposne["message"] == "sucess") {
            Successfully_Message();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ManagerEmployees(
                        selectedDateIndex: 0,
                      )),
            );
          }
        }
      }

      // void showResetPasswordBottomSheet(BuildContext context) {
      //   showModalBottomSheet(
      //     isScrollControlled: true,
      //     context: context,
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.vertical(
      //           top: Radius.circular(15)), // Rounded corners at the top
      //     ),
      //     builder: (BuildContext context) {
      //       return Padding(
      //         padding: EdgeInsets.only(
      //           bottom: MediaQuery.of(context)
      //               .viewInsets
      //               .bottom, // To avoid keyboard overlap
      //         ),
      //         child: Wrap(
      //           children: [
      //             Padding(
      //               padding: const EdgeInsets.all(16.0),
      //               child: Column(
      //                 mainAxisSize: MainAxisSize.min,
      //                 children: <Widget>[
      //                   // Title
      //                   Text(
      //                     "Reset Password",
      //                     style: TextStyle(
      //                       fontSize: 18,
      //                       fontWeight: FontWeight.bold,
      //                     ),
      //                   ),
      //                   SizedBox(height: 20),

      //                   // User Name field (read-only)
      //                   Container(
      //                     width: double.infinity,
      //                     padding: EdgeInsets.symmetric(
      //                         vertical: 15, horizontal: 10),
      //                     decoration: BoxDecoration(
      //                       border: Border.all(color: Colors.grey),
      //                       borderRadius: BorderRadius.circular(10),
      //                     ),
      //                     child: Text(
      //                       data.clientname, // Replace with your data
      //                       style: TextStyle(fontSize: 16),
      //                     ),
      //                   ),
      //                   SizedBox(height: 10),

      //                   // New Password field
      //                   TextField(
      //                     controller: newPasswordController,
      //                     decoration: InputDecoration(
      //                       labelText: "New Password",
      //                       border: OutlineInputBorder(
      //                         borderRadius: BorderRadius.circular(10),
      //                       ),
      //                     ),
      //                     obscureText: true, // To hide the password text
      //                   ),
      //                   SizedBox(height: 10),

      //                   // Confirm Password field
      //                   TextField(
      //                     controller: confirmPasswordController,
      //                     decoration: InputDecoration(
      //                       labelText: "Confirm Password",
      //                       border: OutlineInputBorder(
      //                         borderRadius: BorderRadius.circular(10),
      //                       ),
      //                     ),
      //                     obscureText: true, // To hide the password text
      //                   ),
      //                   SizedBox(height: 20),

      //                   // Action buttons
      //                   ElevatedButton(
      //                     style: ElevatedButton.styleFrom(
      //                       minimumSize: const Size(double.infinity,
      //                           50), // Full width button with 50 height
      //                     ),
      //                     child: const Text("Update"),
      //                     onPressed: () {
      //                       if (newPasswordController.text ==
      //                           confirmPasswordController.text) {
      //                         UPD_PASSWORD_MOBILE(context, data.Client_CODE,
      //                             newPasswordController.text);
      //                       } else {
      //                         Password_Confirmation_Message();
      //                       }
      //                     },
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //       );
      //     },
      //   );
      // }
      void showResetPasswordBottomSheet(BuildContext context) {
        final _formKey = GlobalKey<FormState>();

        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(15),
            ),
          ),
          builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        // Title
                        Text(
                          "Reset Password",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),

                        // User Name field (read-only)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            data.clientname, // Replace with your data
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(height: 10),

                        // Form for password fields
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // New Password field
                              TextFormField(
                                controller: newPasswordController,
                                decoration: InputDecoration(
                                  labelText: "New Password",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please enter a new password";
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 10),

                              // Confirm Password field
                              TextFormField(
                                controller: confirmPasswordController,
                                decoration: InputDecoration(
                                  labelText: "Confirm Password",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Please confirm your password";
                                  }
                                  if (value != newPasswordController.text) {
                                    return "Passwords do not match";
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),

                        // Action buttons
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text("Update"),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              UPD_PASSWORD_MOBILE(context, data.Client_CODE,
                                  newPasswordController.text);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }

      CREDIT_NOTE(BuildContext context, amount, REMARKS, CLIENT_ID) async {
        Map data = {
          "IP_CLIENT_ID": CLIENT_ID,
          "IP_REMARKS": REMARKS,
          "IP_AMOUNT": amount,
          "IP_REFERENCE_TYPE_ID": "40",
          "IP_SESSION_ID": globals.Glb_SESSION_ID,
          "connection": globals.Connection_Flag
        };
        print(data.toString());
        final response = await http.post(
            Uri.parse(globals.API_url + '/MobileSales/CREDIT_DEBIT_NOTE'),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/x-www-form-urlencoded"
            },
            body: data,
            encoding: Encoding.getByName("utf-8"));

        if (response.statusCode == 200) {
          Successfully_Message();
          Map<String, dynamic> resposne = jsonDecode(response.body);
          if (resposne["message"] == "sucess") {
            Successfully_Message();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ManagerEmployees(
                        selectedDateIndex: 0,
                      )),
            );
          }
        }
      }

      // void _showCreditNoteBottomSheet(BuildContext context) {
      //   showModalBottomSheet(
      //     isScrollControlled:
      //         true, // Allows the bottom sheet to adjust for the keyboard
      //     context: context,
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.vertical(
      //           top: Radius.circular(15)), // Rounded corners at the top
      //     ),
      //     builder: (BuildContext context) {
      //       return Padding(
      //         padding: EdgeInsets.only(
      //           bottom: MediaQuery.of(context)
      //               .viewInsets
      //               .bottom, // Prevent overlap with the keyboard
      //         ),
      //         child: Wrap(
      //           children: [
      //             Padding(
      //               padding: const EdgeInsets.all(16.0),
      //               child: Column(
      //                 mainAxisSize: MainAxisSize.min,
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   // Title
      //                   Center(
      //                     child: Text(
      //                       'Credit Note',
      //                       style: TextStyle(
      //                         fontSize: 18,
      //                         fontWeight: FontWeight.bold,
      //                       ),
      //                     ),
      //                   ),
      //                   SizedBox(height: 20),

      //                   // Client Code field (read-only)
      //                   Container(
      //                     width: double.infinity,
      //                     padding: EdgeInsets.symmetric(
      //                         vertical: 15, horizontal: 10),
      //                     decoration: BoxDecoration(
      //                       border: Border.all(color: Colors.grey),
      //                       borderRadius: BorderRadius.circular(10),
      //                     ),
      //                     child: Text(
      //                       data.Client_CODE, // Replace with your data
      //                       style: TextStyle(fontSize: 16),
      //                     ),
      //                   ),
      //                   SizedBox(height: 15),

      //                   // Amount TextFormField
      //                   TextFormField(
      //                     controller: Credit_amountController,
      //                     decoration: InputDecoration(
      //                       labelText: 'Amount',
      //                       border: OutlineInputBorder(
      //                         borderRadius: BorderRadius.circular(10),
      //                       ),
      //                     ),
      //                     keyboardType: TextInputType.number, // Numeric input
      //                   ),
      //                   SizedBox(height: 15),

      //                   // Remark TextFormField
      //                   TextFormField(
      //                     controller: Credit_remarkController,
      //                     decoration: InputDecoration(
      //                       labelText: 'Remark',
      //                       border: OutlineInputBorder(
      //                         borderRadius: BorderRadius.circular(10),
      //                       ),
      //                     ),
      //                     maxLines: 3, // Allow multi-line input
      //                   ),
      //                   SizedBox(height: 20),

      //                   // Action buttons
      //                   ElevatedButton(
      //                     style: ElevatedButton.styleFrom(
      //                       primary: Colors.blue, // Button color
      //                       shape: RoundedRectangleBorder(
      //                         borderRadius: BorderRadius.circular(10),
      //                       ),
      //                       minimumSize: Size(double.infinity,
      //                           50), // Full width button with 50 height
      //                     ),
      //                     onPressed: () {
      //                       CREDIT_NOTE(
      //                         context,
      //                         Credit_amountController.text,
      //                         Credit_remarkController.text,
      //                         data.clientid.toString(),
      //                       );
      //                       Navigator.of(context)
      //                           .pop(); // Close the bottom sheet
      //                       Credit_amountController.clear();
      //                       Credit_remarkController.clear();
      //                     },
      //                     child: const Text('Save'),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //       );
      //     },
      //   );
      // }

      void _showCreditNoteBottomSheet(BuildContext context) {
        final _formKey = GlobalKey<FormState>();

        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          ),
          builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Center(
                            child: Text(
                              'Credit Note',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),

                          // Client Code field (read-only)
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              data.Client_CODE, // Replace with your data
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          SizedBox(height: 15),

                          // Amount TextFormField
                          TextFormField(
                            controller: Credit_amountController,
                            decoration: InputDecoration(
                              labelText: 'Amount',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            keyboardType: TextInputType.number, // Numeric input
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an amount';
                              }
                              if (double.tryParse(value) == null ||
                                  double.parse(value) <= 0) {
                                return 'Please enter a valid amount';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15),

                          // Remark TextFormField
                          TextFormField(
                            controller: Credit_remarkController,
                            decoration: InputDecoration(
                              labelText: 'Remark',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            maxLines: 3, // Allow multi-line input
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a remark';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),

                          // Action buttons
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue, // Button color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: Size(double.infinity, 50),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // If the form is valid, submit the data
                                CREDIT_NOTE(
                                  context,
                                  Credit_amountController.text,
                                  Credit_remarkController.text,
                                  data.clientid.toString(),
                                );
                                Navigator.of(context)
                                    .pop(); // Close the bottom sheet
                                Credit_amountController.clear();
                                Credit_remarkController.clear();
                              }
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }

      DEBIT_NOTE(BuildContext context, amount, REMARKS, CLIENT_ID) async {
        Map data = {
          "IP_CLIENT_ID": CLIENT_ID,
          "IP_REMARKS": REMARKS,
          "IP_AMOUNT": amount,
          "IP_REFERENCE_TYPE_ID": "41",
          "IP_SESSION_ID": globals.Glb_SESSION_ID,
          "connection": globals.Connection_Flag
        };
        print(data.toString());
        final response = await http.post(
            Uri.parse(globals.API_url + '/MobileSales/CREDIT_DEBIT_NOTE'),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/x-www-form-urlencoded"
            },
            body: data,
            encoding: Encoding.getByName("utf-8"));

        if (response.statusCode == 200) {
          Successfully_Message();
          Map<String, dynamic> resposne = jsonDecode(response.body);
          if (resposne["message"] == "sucess") {
            Successfully_Message();
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ManagerEmployees(
                        selectedDateIndex: 0,
                      )),
            );
          }
        }
      }

      // void _showDebitNoteBottomSheet(BuildContext context) {
      //   showModalBottomSheet(
      //     isScrollControlled:
      //         true, // Allows the bottom sheet to adjust for the keyboard
      //     context: context,
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.vertical(
      //           top: Radius.circular(15)), // Rounded corners at the top
      //     ),
      //     builder: (BuildContext context) {
      //       return Padding(
      //         padding: EdgeInsets.only(
      //           bottom: MediaQuery.of(context)
      //               .viewInsets
      //               .bottom, // Prevent overlap with the keyboard
      //         ),
      //         child: Wrap(
      //           children: [
      //             Padding(
      //               padding: const EdgeInsets.all(16.0),
      //               child: Column(
      //                 mainAxisSize: MainAxisSize.min,
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   // Title
      //                   Center(
      //                     child: Text(
      //                       'Debit Note',
      //                       style: TextStyle(
      //                         fontSize: 18,
      //                         fontWeight: FontWeight.bold,
      //                       ),
      //                     ),
      //                   ),
      //                   SizedBox(height: 20),

      //                   // Client Code field (read-only)
      //                   Container(
      //                     width: double.infinity,
      //                     padding: EdgeInsets.symmetric(
      //                         vertical: 15, horizontal: 10),
      //                     decoration: BoxDecoration(
      //                       border: Border.all(color: Colors.grey),
      //                       borderRadius: BorderRadius.circular(10),
      //                     ),
      //                     child: Text(
      //                       data.Client_CODE, // Replace with your data
      //                       style: TextStyle(fontSize: 16),
      //                     ),
      //                   ),
      //                   SizedBox(height: 15),

      //                   // Amount TextFormField
      //                   TextFormField(
      //                     controller: amountController,
      //                     decoration: InputDecoration(
      //                       labelText: 'Amount',
      //                       border: OutlineInputBorder(
      //                         borderRadius: BorderRadius.circular(10),
      //                       ),
      //                     ),
      //                     keyboardType: TextInputType.number, // Numeric input
      //                   ),
      //                   SizedBox(height: 15),

      //                   // Remark TextFormField
      //                   TextFormField(
      //                     controller: remarkController,
      //                     decoration: InputDecoration(
      //                       labelText: 'Remark',
      //                       border: OutlineInputBorder(
      //                         borderRadius: BorderRadius.circular(10),
      //                       ),
      //                     ),
      //                     maxLines: 3, // Allow multi-line input
      //                   ),
      //                   SizedBox(height: 20),

      //                   // Action buttons
      //                   ElevatedButton(
      //                     style: ElevatedButton.styleFrom(
      //                       primary: Colors.blue, // Button color
      //                       shape: RoundedRectangleBorder(
      //                         borderRadius: BorderRadius.circular(10),
      //                       ),
      //                       minimumSize: Size(double.infinity,
      //                           50), // Full width button with 50 height
      //                     ),
      //                     onPressed: () {
      //                       DEBIT_NOTE(
      //                         context,
      //                         amountController.text,
      //                         remarkController.text,
      //                         data.clientid.toString(),
      //                       );
      //                       Navigator.of(context)
      //                           .pop(); // Close the bottom sheet
      //                       remarkController.clear();
      //                       amountController.clear();
      //                     },
      //                     child: const Text('Save'),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //       );
      //     },
      //   );
      // }

      void _showDebitNoteBottomSheet(BuildContext context) {
        final _formKey = GlobalKey<FormState>();

        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          ),
          builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Center(
                            child: Text(
                              'Debit Note',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),

                          // Client Code field (read-only)
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              data.Client_CODE, // Replace with your data
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          SizedBox(height: 15),

                          // Amount TextFormField
                          TextFormField(
                            controller: amountController,
                            decoration: InputDecoration(
                              labelText: 'Amount',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter an amount';
                              }
                              if (double.tryParse(value) == null ||
                                  double.parse(value) <= 0) {
                                return 'Please enter a valid amount';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 15),

                          // Remark TextFormField
                          TextFormField(
                            controller: remarkController,
                            decoration: InputDecoration(
                              labelText: 'Remark',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            maxLines: 3,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a remark';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),

                          // Action buttons
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue, // Button color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: Size(double.infinity, 50),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                // If the form is valid, submit the data
                                DEBIT_NOTE(
                                  context,
                                  amountController.text,
                                  remarkController.text,
                                  data.clientid.toString(),
                                );
                                Navigator.of(context)
                                    .pop(); // Close the bottom sheet
                                remarkController.clear();
                                amountController.clear();
                              }
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }

      void _showUploadPrescriptionBottomSheet() {
        showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(15)), // Rounded corners at the top
          ),
          builder: (context) {
            return UploadPrescriptionBottomSheet();
          },
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Container(
          width: double.infinity,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 15, 12, 0),
                  child: GestureDetector(
                    onTap: () {
                      print(globals.selectedClientData);
                      globals.clientName = data.clientname;
                      globals.selectedClientData = data;
                      globals.selectedClientid = data.clientid.toString();

                      globals.fromDate = '';
                      globals.ToDate = '';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ClientProfile(0)),
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            data.clientname,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Spacer(),
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
                  ),
                ),
                Divider(color: Colors.grey),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "(B) ${data.business}",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color.fromARGB(255, 83, 76, 175),
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
                          color: Color.fromARGB(255, 244, 54, 181),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data.CREDIT_LIMT_AMNT.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: data.locked == 'Y' ? Colors.red : Colors.green,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      GestureDetector(
                        onTap: () {
                          globals.Client_CODE_Lock =
                              data.Client_CODE.toString();
                          globals.clientLockFlag = data.locked;
                          globals.clientName_Client_Lock = data.clientname;
                          globals.clientid_Client_Lock = data.locked;

                          globals.IS_CREDIT_LIMIT_REQ_Client_Lock =
                              data.clientid.toString();
                          globals.CREDIT_LIMT_AMNT_Client_Lock =
                              data.CREDIT_LIMT_AMNT.toString();
                          globals.balance_Client_Lock = data.balance.toString();

                          if (globals.Glb_IS_LOCK_REQ == "Y  ") {
                            showLockBottomSheet(context);
                          }
                        },
                        child: Icon(
                          data.locked == 'Y' ? Icons.lock : Icons.lock_open,
                          color: data.locked == 'Y'
                              ? Color.fromARGB(255, 216, 119, 112)
                              : Colors.green,
                          size: 25,
                        ),
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     Saving_Message();
                      //     globals.Glb_IS_LOCK_REQ == "Y"
                      //         ? showDialog(
                      //             context: context,
                      //             builder: (BuildContext context) =>
                      //                 PopupWidget(
                      //                     data.locked,
                      //                     data.clientname,
                      //                     data.clientid.toString(),
                      //                     data.IS_CREDIT_LIMIT_REQ.toString(),
                      //                     data.CREDIT_LIMT_AMNT.toString(),
                      //                     data.balance.toString()))
                      //         : Container();
                      //   },
                      //   child: Container(
                      //     height: 50,
                      //     width: 100,
                      //     decoration: BoxDecoration(
                      //       color:
                      //           data.locked == 'Y' ? Colors.red : Colors.green,
                      //       shape: BoxShape.rectangle,
                      //     ),
                      //     child: Icon(
                      //       data.locked == 'Y' ? Icons.lock : Icons.lock_open,
                      //       color: Color.fromARGB(255, 8, 8, 8),
                      //       size: 18,
                      //     ),
                      //   ),
                      // ),
                      data.PAYU_MERCHANT_SALT == "" ||
                              data.PAYU_MERCHANT_KEY == "" ||
                              data.PAYU_MERCHANT_SALT == "null" ||
                              data.PAYU_MERCHANT_KEY == "null" ||
                              data.PAYU_MERCHANT_SALT == null ||
                              data.PAYU_MERCHANT_KEY == null
                          ? Container(width: 100)
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(
                                    255, 122, 151, 219), // Light grey color
                                onPrimary: Colors.white, // Text color
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12), // Button padding
                                textStyle: TextStyle(
                                  fontSize: 16, // Font size
                                  fontWeight: FontWeight.bold, // Font weight
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // Rounded corners
                                ),
                              ),
                              child: const Text("Pay Now"),
                              onPressed: () async {
                                _showPopup(context);
                              },
                            ),
                    ],
                  ),
                ),
                globals.Glb_Dr_Cr_Note == "Yes"
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Credit Button
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(
                                    255, 0, 123, 255), // Blue color
                                onPrimary: Colors.white, // Text color
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                textStyle: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      10), // Rounded corners
                                ),
                              ),
                              child: const Text("C.Note",
                                  style: TextStyle(fontSize: 10)),
                              onPressed: () {
                                _showCreditNoteBottomSheet(context);
                              },
                            ),
                            // Debit Button
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(
                                    255, 40, 167, 69), // Green color
                                onPrimary: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                textStyle: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text("D.Note",
                                  style: TextStyle(fontSize: 10)),
                              onPressed: () {
                                _showDebitNoteBottomSheet(context);
                              },
                            ),
                            // Cancel Receipt Button
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(
                                    255, 220, 53, 69), // Red color
                                onPrimary: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                textStyle: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text("Cnl Rcpt",
                                  style: TextStyle(fontSize: 10)),
                              onPressed: () {
                                globals.Glb_CLIENT_NAME_RCPT_CNC =
                                    data.clientid.toString();

                                _showUploadPrescriptionBottomSheet();
                              },
                            ),
                            // Reset Password Button
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color.fromARGB(
                                    255, 108, 117, 125), // Grey color
                                onPrimary: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
                                textStyle: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text("Rest Pwd",
                                  style: TextStyle(fontSize: 10)),
                              onPressed: () {
                                showResetPasswordBottomSheet(context);
                              },
                            ),
                          ],
                        ),
                      )
                    : Container()
              ],
            ),
          ),
        ),
      );
    }

    Widget _buildHeader(BuildContext context) {
      return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => managerbusiness(0)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 6, 4, 6),
                child: ListTile(
                  leading: SizedBox(
                      child: Icon(
                    Icons.account_box,
                    size: 25,
                    color: Color.fromARGB(255, 15, 15,
                        15), // Replace Colors.blue with any color you prefer
                  )),
                  title: Row(
                    children: [
                      Text(globals.Glb_empname.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                      Spacer(),
                      Text(globals.Employee_Code.toString(),
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color.fromARGB(255, 116, 111, 111))),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 2, 0, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("(B)" + globals.Glb_business.toString(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.green)),
                              Text("(P)" + globals.glb_deposits.toString(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue)),
                              Text("(O)" + globals.Glb_balance.toString(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 6, 0, 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  'Active (' +
                                      globals.Glb_ACTIVE.toString() +
                                      ')',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 31, 190, 52))),
                              Text(
                                  'Locked (' +
                                      globals.Glb_IN_ACTIVE.toString() +
                                      ')',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 202, 24, 24))),
                              Text('Total (' + globals.Glb_TOTAL + ')',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color.fromARGB(255, 64, 17, 190))),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 6, 0, 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              globals.Glb_mobileno.toString() == "null"
                                  ? Text("",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey))
                                  : Text(globals.Glb_mobileno.toString(),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey)),
                              Spacer(),
                              Text(globals.Glb_emailid.toString(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ));
    }

    ListView ManagerClientsListView(data, BuildContext context) {
      return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return _buildClientsCard(data[index], context);
          });
    }

    final topAppBar = AppBar(
      elevation: 0.1,
      backgroundColor: Color(0xff123456),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          // Reset global values
          globals.Glb_IN_ACTIVE = "";
          globals.Glb_ACTIVE = "";
          globals.Glb_TOTAL = "";
          globals.Glb_empname = "";
          globals.Glb_business = "";
          globals.glb_deposits = "";
          globals.Glb_balance = "";
          globals.Glb_mobileno = "";
          // Navigator.of(context).pop();

          (int.parse(globals.Navigate_mngrcnt.toString()) > 1)
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AllinOne(selectedDateIndex: 0)))
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SalesManagerDashboard()));
        },
      ),
      title: Row(
        children: [
          Text("Clients List"),
          Spacer(),
          IconButton(
            icon: Icon(Icons.date_range_outlined),
            onPressed: () {
              _CenterWiseBusinessDate(context);
            },
          ),
        ],
      ),
    );
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
              backgroundColor: widget.selectedDateIndex == index &&
                      globals.fromDate == ''
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
              widget.selectedDateIndex = index;
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

              var prevMonth1stday = DateTime.utc(
                  DateTime.now().year, DateTime.now().month - 1, 1);
              var prevMonthLastday = DateTime.utc(
                DateTime.now().year,
                DateTime.now().month - 0,
              ).subtract(Duration(days: 1));

              if (widget.selectedDateIndex == 0) {
                // Today
                // total_amouont = "";
                selecteFromdt = formatter.format(now);
                selecteTodt = formatter.format(now);
              } else if (widget.selectedDateIndex == 1) {
                // yesterday
                //  total_amouont = "";
                selecteFromdt = formatter.format(yesterday);
                selecteTodt = formatter.format(yesterday);
              } else if (widget.selectedDateIndex == 2) {
                // LastWeek
                // total_amouont = "";
                selecteFromdt = formatter.format(lastWeek1stDay);
                selecteTodt = formatter.format(lastWeekLastDay);
              } else if (widget.selectedDateIndex == 3) {
                //  total_amouont = "";
                selecteFromdt = formatter.format(thisweek);
                selecteTodt = formatter.format(now);
              } else if (widget.selectedDateIndex == 4) {
                // Last Month
                // total_amouont = "";
                selecteFromdt = formatter.format(prevMonth1stday);
                selecteTodt = formatter.format(prevMonthLastday);
              } else if (widget.selectedDateIndex == 5) {
                // total_amouont = "";
                selecteFromdt = formatter.format(thismonth);
                selecteTodt = formatter.format(now);
                // _fetchSalespersons();
              }

              _futureClients = _fetchSalespersons(); // Refresh the Future
              print("From Date " + selecteFromdt);
              print("To Date " + selecteTodt);
              print(widget.selectedDateIndex);
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
          "FrequencyId": "0",
          "Frequency": "Today",
        },
        {
          "FrequencyId": "1",
          "Frequency": "Yesterday",
        },
        {
          "FrequencyId": "2",
          "Frequency": "Last Week",
        },
        {
          "FrequencyId": "3",
          "Frequency": "This Week",
        },
        {
          "FrequencyId": "4",
          "Frequency": "Last Month",
        },
        {
          "FrequencyId": "6",
          "Frequency": "This Month",
        },
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

    final DateFormat formatter1 = DateFormat('dd-MMM-yyyy');
    var now = DateTime.now();
    if (globals.fromDate != "") {
      setState(() {
        selecteFromdt = globals.fromDate;
        selecteTodt = globals.ToDate;
        _futureClients = _fetchSalespersons();
        _fetchSalespersons();
      });
    } else if (selecteTodt == '') {
      setState(() {
        selecteFromdt = formatter1.format(now);
        selecteTodt = formatter1.format(now);
        _futureClients = _fetchSalespersons();
        _fetchSalespersons();
      });
    }
//Date Selection...........................................
    return WillPopScope(
      onWillPop: () async {
        // Returning false prevents the back button action.
        return false;
      },
      child: Scaffold(
        appBar: topAppBar,
        body: Column(
          children: [
            SizedBox(height: 48, child: DateSelection()),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Container(
                  height: 15,
                  child: selecteFromdt == ""
                      ? Text(
                          "${selectedDate.toLocal()}".split(' ')[0] +
                              '  To   ' +
                              "${selectedDate.toLocal()}".split(' ')[0],
                          style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0))
                      : Text(selecteFromdt + '  To   ' + selecteTodt,
                          style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0))),
            ),
            // _buildHeader(context),
            verticalList3,
            Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TextField(
                controller: _searchControllerClient,
                onChanged: (value) {
                  setState(() {
                    // No need for logic here, just rebuilding the FutureBuilder
                  });
                },
                decoration: InputDecoration(
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 149, 149, 149),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 149, 149, 149),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 34, 98, 171),
                    ),
                  ),
                  // focusedErrorBorder: OutlineInputBorder(
                  //   borderRadius: BorderRadius.circular(16.0),
                  //   borderSide: const BorderSide(
                  //     color: Color.fromARGB(255, 149, 149, 149),
                  //   ),
                  // ),
                  // You can customize other properties like fillColor, filled, hintText, etc.
                  hintText: 'Search Client Code & Name',
                  hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 194, 193, 193)),
                  prefixIcon: const Icon(
                    Icons.person_search_outlined,
                    color: Color.fromARGB(255, 30, 66, 138),
                  ),
                ),
              ),
            ),
            // globals.Glb_FILTER_BUSINESS_PAYMENTS == "Yes"
            //     ? Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //         children: [
            //           Text(
            //             "Sort By:",
            //             style: TextStyle(
            //                 fontSize: 15,
            //                 color: Color.fromARGB(255, 17, 17, 17),
            //                 fontWeight: FontWeight.bold),
            //           ),
            //           ToggleButtonRow(
            //             onButtonPressed: (String selected) {
            //               setState(() {
            //                 _futureClients = _fetchSalespersons();
            //               });
            //             },
            //           ),
            //         ],
            //       )
            //     : Container(),
            Expanded(
              child: FutureBuilder<List<ManagerClients>>(
                future: _futureClients,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else if (!snapshot.hasData) {
                    return Center(
                      child: Text("No data found."),
                    );
                  } else {
                    var data = snapshot.data!;
                    // Filter data based on search query
                    if (_searchControllerClient.text.isNotEmpty) {
                      data = data
                          .where((client) =>
                              client.Client_CODE.toLowerCase().contains(
                                  _searchControllerClient.text.toLowerCase()) ||
                              client.clientname.toLowerCase().contains(
                                  _searchControllerClient.text.toLowerCase()))
                          .toList();
                    }
                    return ManagerClientsListView(data, context);
                  }
                },
              ),
            ),

            //verticalListManager,
          ],
        ),
        bottomNavigationBar: const AllbottomNavigation(),
      ),
    );
  }

  //.........................................................................Pay U Money

  showAlertDialog(BuildContext context, String title, String content) {
    globals.Response_Content = content;
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {
        Navigator.pop(context);
        // datasetval = [];
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => ClientDashboard()),
        // );
        Navigator.pop(context);
      },
    );

    String jsonString = content;

    // Define a regular expression to find 'txnid' value
    RegExp regExp = RegExp(r'"txnid":"([^"]+)"');
    RegExp regExp1 = RegExp(r'"amount":"([^"]+)"');
    RegExp regExp2 = RegExp(r'"phone":"([^"]+)"');
    RegExp regExp3 = RegExp(r'"email":"([^"]+)"');
    RegExp regExp4 = RegExp(r'"firstname":"([^"]+)"');
    RegExp regExp5 = RegExp(r'"status":"([^"]+)"');

    // Find the first match
    RegExpMatch? match = regExp.firstMatch(jsonString);
    RegExpMatch? match1 = regExp1.firstMatch(jsonString);
    RegExpMatch? match2 = regExp2.firstMatch(jsonString);
    RegExpMatch? match3 = regExp3.firstMatch(jsonString);
    RegExpMatch? match4 = regExp4.firstMatch(jsonString);
    RegExpMatch? match5 = regExp5.firstMatch(jsonString);

//..............................................txnid
    if (match != null) {
      // Extract the txnid value
      String txnid = match.group(1)!;
      globals.glb_Transaction_txnid = txnid;
      print("txnid: $txnid");
    } else {
      print("txnid not found");
    }
    //..............................................amount
    if (match1 != null) {
      // Extract the txnid value
      String amount = match1.group(1)!;
      globals.glb_Transaction_amount = amount;
      print("amount: $amount");
    } else {
      print("amount not found");
    }
    //..............................................phone
    if (match2 != null) {
      // Extract the txnid value
      String phone = match2.group(1)!;
      globals.glb_Transaction_phone = phone;
      print("phone: $phone");
    } else {
      print("phone not found");
    }
    //..............................................email
    if (match3 != null) {
      // Extract the txnid value
      String email = match3.group(1)!;
      globals.glb_Transaction_email = email;

      print("email: $email");
    } else {
      print("email not found");
    }
    //..............................................firstname
    if (match4 != null) {
      // Extract the txnid value
      String firstname = match4.group(1)!;
      globals.glb_Transaction_firstname = firstname;
      print("firstname: $firstname");
    } else {
      print("firstname not found");
    }

    //..............................................status
    if (match5 != null) {
      // Extract the txnid value
      String status = match5.group(1)!;
      globals.glb_Transaction_status = status;
      print("status: $status");
    } else {
      print("status not found");
    }
    Pay_U_Money_Integration_Function_One(context);

    globals.glb_Transaction_txnid.toString() != ""
        ? Pay_U_Money_Integration_Function_Two(context)
        : Container();
    // showLoader(context);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ManagerEmployees(
                selectedDateIndex: 0,
              )),
    );
  }

  @override
  generateHash(Map response) {
    // Backend will generate the hash which you need to pass to SDK
    // hashResponse: is the response which you get from your server

    Map hashResponse = {};

    //Keep the salt and hash calculation logic in the backend for security reasons. Don't use local hash logic.
    //Uncomment following line to test the test hash.
    hashResponse = HashService.generateHash(response);
    try {
      ///_checkoutPro.hashGenerated(hash: response);
      _checkoutPro.hashGenerated(hash: hashResponse);
    } catch (e) {
      print("cathe error : $e");
    }
  }

  @override
  onPaymentSuccess(dynamic response) {
    // Future.delayed(Duration(seconds: 10), () {
    //       Navigator.of(context, rootNavigator: true).pop();

    //     });

    showAlertDialog(context, "onPaymentSuccess", response.toString());
  }

  @override
  onPaymentFailure(dynamic response) {
    showAlertDialog(context, "onPaymentFailure", response.toString());
  }

  @override
  onPaymentCancel(Map? response) {
    showAlertDialog(context, "onPaymentCancel", response.toString());
  }

  @override
  onError(Map? response) {
    showAlertDialog(context, "onError", response.toString());
  }
}

Future<void> Pay_U_Money_Integration_Function_One(BuildContext context) async {
  Map data = {
    "IP_COVID_REG_INTEGRATION_ID": "",
    "IP_ORDER_ID": globals.glb_Transaction_Client_Id +
        "/" +
        globals.glb_Transaction_txnid.toString(),
    "IP_MOBILE_NO": globals.glb_Transaction_phone.toString(),
    "IP_EMAIL_ID": globals.glb_Transaction_email.toString(),
    "IP_PATIENT_NAME": globals.glb_Transaction_firstname.toString(),
    "IP_FRN_APP_BILL_ID": "",
    "IP_REQUEST_DATA": "", //it is needed
    "IP_RESPONSE_DATA": globals.Response_Content,
    "IP_AMOUNT": globals.glb_Transaction_amount.toString(),
    "IP_PAYMENT_STATUS": globals.glb_Transaction_status,
    "OP_COUNT": "",
    "IP_SESSION_ID": globals.Glb_SESSION_ID,
    "connection": globals.Connection_Flag
  };

  final response = await http.post(
      Uri.parse(globals.API_url + '/MobileSales/PayU_MoneyIntegration_API_ONE'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: data,
      encoding: Encoding.getByName("utf-8"));

  if (response.statusCode == 200) {
    Map<String, dynamic> resposne = jsonDecode(response.body);

    globals.glb_Transaction_txnid = "";
    globals.glb_Transaction_phone = "";
    globals.glb_Transaction_email = "";
    globals.glb_Transaction_firstname = "";
    globals.glb_Transaction_amount = "";
    globals.glb_entered_price = "";
    globals.glb_merchantSalt = "";
    globals.glb_merchantKey = "";
  }
}

Future<void> Pay_U_Money_Integration_Function_Two(BuildContext context) async {
  Map data = {
    "IP_REFERAL_SOURCE_ID": "",
    "IP_REFERAL_ID": "",
    "IP_AMOUNT": globals.glb_Transaction_amount,
    "IP_PAYU_TRANSACTION_CD":
        globals.glb_Transaction_Client_Id + "/" + globals.glb_Transaction_txnid,
    "IP_PAYMENTMODE": "6",
    "IP_SESSION_ID": globals.Glb_SESSION_ID,
    "IP_COMPANY_ID": globals.glb_Transaction_Client_Id,
    "connection": globals.Connection_Flag
  };

  final response = await http.post(
      Uri.parse(globals.API_url + '/MobileSales/PayU_MoneyIntegration_API_TWO'),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: data,
      encoding: Encoding.getByName("utf-8"));

  if (response.statusCode == 200) {
    Map<String, dynamic> resposne = jsonDecode(response.body);
    globals.glb_Transaction_amount = "";

    globals.glb_Transaction_txnid = "";
    globals.glb_merchantSalt = "";
    globals.glb_merchantKey = "";
  }
}

//.........................................................................Pay U Money
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
  final EMAIL_ID;
  final PAYU_MERCHANT_SALT;
  final PAYU_MERCHANT_KEY;

  final COMPANY_ID;
  final MOBILE_NO;

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
      required this.CREDIT_LIMT_AMNT,
      required this.EMAIL_ID,
      required this.PAYU_MERCHANT_SALT,
      required this.PAYU_MERCHANT_KEY,
      required this.COMPANY_ID,
      required this.MOBILE_NO});

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
        CREDIT_LIMT_AMNT: json["CREDIT_LIMT_AMNT"],
        EMAIL_ID: json["EMAIL_ID"],
        PAYU_MERCHANT_SALT: json["PAYU_MERCHANT_SALT"],
        PAYU_MERCHANT_KEY: json["PAYU_MERCHANT_KEY"],
        COMPANY_ID: json["COMPANY_ID"],
        MOBILE_NO: json["MOBILE_NO"]);
  }
}

/* Manager Lock */

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
  final IS_ACCESS_ADD_CLIENT;
  final EMPLOYEE_CD;

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
    required this.IS_ACCESS_ADD_CLIENT,
    required this.EMPLOYEE_CD,
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
      IS_ACCESS_ADD_CLIENT: json['IS_ACCESS_ADD_CLIENT'],
      EMPLOYEE_CD: json['EMPLOYEE_CD'],
    );
  }
}

class NoContent3 extends StatelessWidget {
  const NoContent3();

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

//'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
class PayUTestCredentials {
  ///Test
  //static const merchantKey = "JG7OaQ";//"AzfKKD";// Add you Merchant Key ----> Test
  /// Production
  static final merchantKey = globals.glb_merchantKey.toLowerCase(); // "SCp4Te";
  static const iosSurl =
      "https://emr.doctor9.com/napi_cmn/apt/api/payu/fail/payments";
  static const iosFurl =
      "https://emr.doctor9.com/napi_cmn/apt/api/payu/fail/payments";
  //static const androidSurl = "https://cbjs.payu.in/sdk/success"; //"<ADD YOUR ANDROID SURL>";
  static const androidSurl =
      "https://emr.doctor9.com/napi_cmn/apt/api/payu/success/payments"; //"<ADD YOUR ANDROID SURL>";
  static const androidFurl =
      "https://emr.doctor9.com/napi_cmn/apt/api/payu/fail/payments"; //"<ADD YOUR ANDROID FURL>";
  static const merchantAccessKey = ""; //Add Merchant Access Key - Optional
  static const sodexoSourceId = ""; //Add sodexo Source Id - Optional
}

//Pass these values from your app to SDK, this data is only for test purpose
class PayUParams {
  static Map createPayUPaymentParams() {
    /*var siParams = {
      PayUSIParamsKeys.isFreeTrial: true,
      PayUSIParamsKeys.billingAmount: '1',              //Required
      PayUSIParamsKeys.billingInterval: 1,              //Required
      PayUSIParamsKeys.paymentStartDate: '2024-05-10',  //Required
      PayUSIParamsKeys.paymentEndDate: '2024-05-11',    //Required
      PayUSIParamsKeys.billingCycle:                    //Required
      'daily', //C'an be any of 'daily','weekly','yearly','adhoc','once','monthly
      PayUSIParamsKeys.remarks: 'Test SI transaction',
      PayUSIParamsKeys.billingCurrency: 'INR',
      PayUSIParamsKeys.billingLimit: 'ON', //ON, BEFORE, AFTER
      PayUSIParamsKeys.billingRule: 'MAX', //MAX, EXACT
    };*/

    /*var siParams = {
      PayUSIParamsKeys.isFreeTrial: true,
      PayUSIParamsKeys.billingAmount: '1',              //Required
      PayUSIParamsKeys.billingInterval: 1,              //Required
      PayUSIParamsKeys.paymentStartDate: '2024-05-10',  //Required
      PayUSIParamsKeys.paymentEndDate: '2024-05-11',    //Required
      PayUSIParamsKeys.billingCycle:                    //Required
      'daily', //Can be any of 'daily','weekly','yearly','adhoc','once','monthly'
      PayUSIParamsKeys.remarks: 'Test SI transaction',
      PayUSIParamsKeys.billingCurrency: 'INR',
      PayUSIParamsKeys.billingLimit: 'ON', //ON, BEFORE, AFTER
      PayUSIParamsKeys.billingRule: 'MAX', //MAX, EXACT
    };*/

    var cartDetails = [
      {"GST": "5%"},
      {"Delivery Date": "25 Dec"},
      {"Status": "In Progress"}
    ];

    var additionalParam = {
      PayUAdditionalParamKeys.udf1: deviceInformation["appName"],
      //PayUAdditionalParamKeys.udf1: deviceInformation["deviceOS"],
      PayUAdditionalParamKeys.udf2: deviceInformation["appversion"],
      //PayUAdditionalParamKeys.udf2: deviceInformation["DEVICE_MANUFACTURER"],
      // PayUAdditionalParamKeys.udf3: deviceInformation["deviceOS"],
      PayUAdditionalParamKeys.udf3: deviceInformation["DEVICE_MANUFACTURER"],
      PayUAdditionalParamKeys.udf4: "Mobile",
      //PayUAdditionalParamKeys.udf4: deviceInformation["appName"],
      PayUAdditionalParamKeys.udf5: "Udf",
      //PayUAdditionalParamKeys.udf5: deviceInformation["appversion"],
      PayUAdditionalParamKeys.merchantAccessKey:
          PayUTestCredentials.merchantAccessKey,
      PayUAdditionalParamKeys.sourceId: PayUTestCredentials.sodexoSourceId,
    };

    /* var spitPaymentDetails = {
      "type": "absolute",
      "splitInfo": {
        PayUTestCredentials.merchantKey: {
          "aggregatorSubTxnId": "1234567540099887766650011", //unique for each transaction
          "aggregatorSubAmt": "1"
        }
      }
    };*/
    globals.glb_entered_price = _controller.text;

    var payUPaymentParams = {
      PayUPaymentParamKey.key: PayUTestCredentials.merchantKey,
      PayUPaymentParamKey.amount: globals.glb_entered_price,
      PayUPaymentParamKey.productInfo: "Info",
      PayUPaymentParamKey.firstName: globals.clientName,
      PayUPaymentParamKey.email: globals.MailId,
      PayUPaymentParamKey.phone: globals.glb_MOBILE_PHONE,
      PayUPaymentParamKey.ios_surl: PayUTestCredentials.iosSurl,
      PayUPaymentParamKey.ios_furl: PayUTestCredentials.iosFurl,
      PayUPaymentParamKey.android_surl: PayUTestCredentials.androidSurl,
      PayUPaymentParamKey.android_furl: PayUTestCredentials.androidFurl,
      PayUPaymentParamKey.environment: "0", //0 => Production 1 => Test
      PayUPaymentParamKey.userCredential:
          "", //Pass user credential to fetch saved cards => A:B - Optional
      PayUPaymentParamKey.transactionId:
          DateTime.now().millisecondsSinceEpoch.toString(),
      PayUPaymentParamKey.additionalParam: additionalParam,
      PayUPaymentParamKey.enableNativeOTP: false,
      // PayUPaymentParamKey.splitPaymentDetails:json.encode(spitPaymentDetails),
      PayUPaymentParamKey.userToken:
          "", //Pass a unique token to fetch offers. - Optional
      //PayUPaymentParamKey.payUSIParams:siParams,
    };

    return payUPaymentParams;
  }

  static Map createPayUConfigParams() {
    var paymentModesOrder = [
      {"Wallets": "PHONEPE"},
      {"UPI": "TEZ"},
      {"Wallets": ""},
      {"EMI": ""},
      {"NetBanking": ""}
    ];

    var cartDetails = [
      {"GST": "5%"},
      {"Delivery Date": "25 Dec"},
      {"Status": "In Progress"}
    ];
    var customNotes = [
      {
        "custom_note": "Its Common custom note for testing purpose",
        "custom_note_category": [
          PayUPaymentTypeKeys.emi,
          PayUPaymentTypeKeys.card
        ]
      },
      {
        "custom_note": "Payment options custom note",
        "custom_note_category": null
      }
    ];

    var payUCheckoutProConfig = {
      PayUCheckoutProConfigKeys.primaryColor: "#4994EC",
      PayUCheckoutProConfigKeys.secondaryColor: "#FFFFFF",
      PayUCheckoutProConfigKeys.merchantName: "PayU",
      PayUCheckoutProConfigKeys.merchantLogo: "logo",
      PayUCheckoutProConfigKeys.showExitConfirmationOnCheckoutScreen: true,
      PayUCheckoutProConfigKeys.showExitConfirmationOnPaymentScreen: true,
      PayUCheckoutProConfigKeys.cartDetails: cartDetails,
      PayUCheckoutProConfigKeys.paymentModesOrder: paymentModesOrder,
      PayUCheckoutProConfigKeys.merchantResponseTimeout: 30000,
      PayUCheckoutProConfigKeys.customNotes: customNotes,
      PayUCheckoutProConfigKeys.autoSelectOtp: true,
      PayUCheckoutProConfigKeys.waitingTime: 30000,
      PayUCheckoutProConfigKeys.autoApprove: true,
      PayUCheckoutProConfigKeys.merchantSMSPermission: true,
      PayUCheckoutProConfigKeys.showCbToolbar: true,
    };
    return payUCheckoutProConfig;
  }
}

Saving_Message() {
  return Fluttertoast.showToast(
      msg: "Please wait",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 12, 192, 123),
      textColor: Colors.white,
      fontSize: 16.0);
}

Alert_Message() {
  return Fluttertoast.showToast(
      msg: "Please wait don't click back",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 12, 192, 123),
      textColor: Colors.white,
      fontSize: 16.0);
}

void showLoader(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text("Loading..."),
              ],
            ),
          ),
        ),
      );
    },
  );

  Future.delayed(Duration(seconds: 10), () {
    Navigator.of(context, rootNavigator: true).pop();
  });
}

class ToggleButtonRow extends StatefulWidget {
  final Function(String) onButtonPressed;

  const ToggleButtonRow({Key? key, required this.onButtonPressed})
      : super(key: key);

  @override
  _ToggleButtonRowState createState() => _ToggleButtonRowState();
}

class _ToggleButtonRowState extends State<ToggleButtonRow> {
  String selectedButton = "B"; // Default selected button

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Container(
      color: Colors.white,
      height: 50, // Adjust the height as needed
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: screenWidth * 0.3,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  globals.Glb_Flag = "A_B";
                  selectedButton = "B";
                  widget.onButtonPressed(selectedButton);
                });
              },
              child: const Text('Business'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                backgroundColor: selectedButton == "B"
                    ? Colors.green // Active color
                    : Colors.blueGrey, // Inactive color
              ),
            ),
          ),
          SizedBox(width: 10),
          Container(
            width: screenWidth * 0.3,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  globals.Glb_Flag = "A_P";
                  selectedButton = "P";
                  widget.onButtonPressed(selectedButton);
                });
              },
              child: const Text('Payments'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
                backgroundColor: selectedButton == "P"
                    ? Colors.blue // Active color
                    : Colors.blueGrey, // Inactive color
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Successfully_Message() {
  return Fluttertoast.showToast(
      msg: "Saved Successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 11, 238, 79),
      textColor: Colors.white,
      fontSize: 16.0);
}

class UploadPrescriptionBottomSheet extends StatefulWidget {
  UploadPrescriptionBottomSheet();

  @override
  _UploadPrescriptionBottomSheetState createState() =>
      _UploadPrescriptionBottomSheetState();
}

class _UploadPrescriptionBottomSheetState
    extends State<UploadPrescriptionBottomSheet> {
  TextEditingController billNoController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  String clientName = '';
  String billAmount = '';

  void Receipt_Cnll(BuildContext context, billNo) async {
    Map data = {
      "Emp_id": globals.Glb_CLIENT_NAME_RCPT_CNC.toString(),
      "session_id": globals.Glb_SESSION_ID,
      "flag": "",
      "from_dt": "${DateTime.now().toLocal()}".split(' ')[0],
      "to_dt": "${DateTime.now().toLocal()}".split(' ')[0],
      "location_wise_flg": "CB",
      "location_id": globals.LOC_ID,
      "IP_BILL_NO": billNo,
      "IP_BARCODE_NO": "",
      "connection": globals.Connection_Flag
    };

    final response = await http.post(
        Uri.parse(globals.API_url + '/MobileSales/Centerwisetrans'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);

      if (resposne["message"] == "success") {
        Map<String, dynamic> user = resposne['Data'][0];

        setState(() {
          clientName = user['COMPANY_CD'].toString();
          billAmount = user['AMOUNT'].toString();
        });
        Receipt_Cnll_Successfully_Message();
      } else {
        Receipt_Cnll_No_Data_Message();
      }
    }
  }

  void Receipt_Cnll_Confirmation(BuildContext context, billNo, remark) async {
    Map data = {
      "IP_BILL_ID": billNo,
      "IP_REMARKS": remark,
      "IP_AUTHORISED_BY": globals.glb_EMPLOYEE_ID,
      "IP_SESSION_ID": globals.Glb_SESSION_ID,
      "connection": globals.Connection_Flag
    };

    final response = await http.post(
        Uri.parse(globals.API_url + '/MobileSales/PAYMENT_CANCELLATION_APP'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);

      if (resposne["message"] == "success") {
        Submit_Receipt_Cnll_Successfully_Message();
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ManagerEmployees(
                    selectedDateIndex: 0,
                  )),
        );
      } else {
        Receipt_Cnll_No_Data_Message();
      }
    }
  }

  Submit_Receipt_Cnll_Successfully_Message() {
    return Fluttertoast.showToast(
        msg: "Cancelled data Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 11, 238, 79),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(20), // Adjust the radius for roundness
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Receipt Cancellation',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Receipt No:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: billNoController,
                      decoration: InputDecoration(
                        hintText: "Enter Receipt No.",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.check),
                    onPressed: () {
                      Receipt_Cnll(context, billNoController.text);
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Sub-title for Client Details
              Text(
                'Details:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              // Client Name (read-only)
              TextField(
                controller: TextEditingController(text: clientName),
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 5),
              // Bill Amount (read-only)
              TextField(
                controller: TextEditingController(text: billAmount),
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 5),
              // Remark TextField
              TextField(
                controller: remarkController,
                decoration: InputDecoration(
                  hintText: 'Enter remark',
                  border: OutlineInputBorder(),
                ),
                maxLines: 1,
              ),
              SizedBox(height: 5),
              // Submit and Cancel buttons
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(
                      double.infinity, 50), // Full width button with 50 height
                ),
                onPressed: () {
                  Receipt_Cnll_Confirmation(
                      context, billNoController.text, remarkController.text);
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Receipt_Cnll_Successfully_Message() {
  return Fluttertoast.showToast(
      msg: "Fetch data Successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 11, 238, 79),
      textColor: Colors.white,
      fontSize: 16.0);
}

Receipt_Cnll_No_Data_Message() {
  return Fluttertoast.showToast(
      msg: "No Data Found",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 209, 23, 32),
      textColor: Colors.white,
      fontSize: 16.0);
}
