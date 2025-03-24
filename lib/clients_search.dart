import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'dart:convert';
import 'allbottomnavigationbar.dart';
import 'client_lock.dart';
import 'clientprofile.dart';
import 'globals.dart' as globals;
import 'package:flutter/material.dart';

TextEditingController newPasswordController = TextEditingController();
TextEditingController confirmPasswordController = TextEditingController();
TextEditingController billNoController = TextEditingController();
TextEditingController clientNameController = TextEditingController();
TextEditingController amountController = TextEditingController();
TextEditingController remarkController = TextEditingController();

TextEditingController Credit_amountController = TextEditingController();
TextEditingController Credit_remarkController = TextEditingController();

class Client_Search extends StatefulWidget {
  int selectedDateIndex;
  Client_Search({super.key, required this.selectedDateIndex});

  @override
  State<Client_Search> createState() => _Client_SearchState();
}

class _Client_SearchState extends State<Client_Search> {
  List<Map<String, String>> Expension_allItems = [];
  var selecteFromdt = '';
  var selecteTodt = '';
  DateTime selectedDate = DateTime.now();
  String formattedDate = '';
  @override
  void initState() {
    super.initState();
    formattedDate = formattedDate = DateFormat('dd-MMM-yyyy')
        .format(selectedDate); // Format as "10 Oct 2024"
  }

  @override
  Widget build(BuildContext context) {
    Future<List<ManagerClients>> _fetchSaleTransaction() async {
      var jobsListAPIUrl = null;
      var dsetName = '';
      List listresponse = [];

      Map data = {
        "emp_id": globals.new_selectedEmpid,
        "session_id": "1",
        "IP_FLAG": "",
        "IP_CLIENT_CD": globals.Glb_Client_Code,
        "IP_FROM_DATE": selecteFromdt.isEmpty
            ? "${selectedDate.toLocal()}".split(' ')[0]
            : selecteFromdt,
        "IP_TO_DATE": selecteTodt.isEmpty
            ? "${selectedDate.toLocal()}".split(' ')[0]
            : selecteTodt,
        "connection": globals.Connection_Flag
      };

      dsetName = 'result';
      jobsListAPIUrl =
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
            .map((strans) => ManagerClients.fromJson(strans))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget Application_Widget(data, BuildContext context) {
      String clientName = data.clientname;
      String clientLockFlag = data.locked;

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
                  builder: (context) => Client_Search(
                        selectedDateIndex: 0,
                      )),
            );
          }
        }
      }

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
                  builder: (context) => Client_Search(
                        selectedDateIndex: 0,
                      )),
            );
          }
        }
      }

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
                  builder: (context) => Client_Search(
                        selectedDateIndex: 0,
                      )),
            );
          }
        }
      }

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

      Expension_Sales_Data(BuildContext context) async {
        Map data = {
          "emp_id": globals.new_selectedEmpid,
          "session_id": "1",
          "IP_FLAG": "Y",
          "IP_CLIENT_CD": globals.Glb_Client_Code,
          "IP_FROM_DATE": selecteFromdt.isEmpty
              ? "${selectedDate.toLocal()}".split(' ')[0]
              : selecteFromdt,
          "IP_TO_DATE": selecteTodt.isEmpty
              ? "${selectedDate.toLocal()}".split(' ')[0]
              : selecteTodt,
          "connection": globals.Connection_Flag
        };
        print(data.toString());
        final response = await http.post(
            Uri.parse(globals.API_url + '/MobileSales/EmpReferalDetails'),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/x-www-form-urlencoded"
            },
            body: data,
            encoding: Encoding.getByName("utf-8"));

        if (response.statusCode == 200) {
          Map<String, dynamic> resposne = jsonDecode(response.body);
          if (resposne["message"] == "success") {
            List<dynamic> results = resposne["Data"];

            results.forEach((item) {
              Expension_allItems.add({
                'Amounts': item['Amounts'].toString(),
                'Transaction_Dates': item['Transaction_Dates'].toString(),
                'Transaction_Types': item['Transaction_Types'].toString(),
              });
            });

            setState(() {
              Expension_allItems;
            });
          }
        }
      }

      bool isExpanded = false;

      void _handleExpansion(bool expanded) {
        setState(() {
          isExpanded = expanded;
          String Expended_Open = "Open";
        });
        if (expanded) {
          Expension_allItems = [];
          var session_id = "2";
          Expension_Sales_Data(context); // Call the function only when expanded
        }
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
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
                      SizedBox(
                        width: 50,
                        child: Text(
                          data.CREDIT_LIMT_AMNT.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color:
                                data.locked == 'Y' ? Colors.red : Colors.green,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
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
                          globals.balance_Client_Lock = data.balance.toString();
                          globals.Client_CODE_Lock =
                              data.Client_CODE.toString();

                          if (globals.Glb_IS_LOCK_REQ == "Y  ") {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16.0)),
                              ),
                              builder: (BuildContext context) {
                                return Lock_Widget();
                              },
                            );
                          }
                        },
                        child: Row(
                          children: [
                            SizedBox(width: 5),
                            Container(
                              height: 50,
                              width: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.rectangle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: Icon(
                                  data.locked == 'Y'
                                      ? Icons.lock
                                      : Icons.lock_open,
                                  color: data.locked == 'Y'
                                      ? Colors.red
                                      : Colors.green,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(
                              255, 122, 151, 219), // Light grey color
                          onPrimary: Colors.white, // Text color
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12), // Button padding
                          textStyle: TextStyle(
                            fontSize: 16, // Font size
                            fontWeight: FontWeight.bold, // Font weight
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10), // Rounded corners
                          ),
                        ),
                        child: const Text("Pay Now"),
                        onPressed: () async {
                          // _showPopup(context);
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
                              child: const Text("Cr.Note",
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
                              child: const Text("Dr.Note",
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
                    : Container(),
                Divider(),
                ExpansionTile(
                  title: Row(
                    children: [
                      Icon(
                        Icons.recent_actors,
                        color: Color.fromARGB(255, 224, 133, 13),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Recent Payments',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                  onExpansionChanged: _handleExpansion,
                  children: Expension_allItems.isEmpty
                      ? [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                CircularProgressIndicator(), // Show loading indicator when expanding
                          )
                        ]
                      : Expension_allItems.expand((item) {
                          // Split CMP_AMOUNTS and COMPANY_CDS by commas
                          List<String> Amounts =
                              item['Amounts']?.split(',') ?? [];
                          List<String> Transaction_Dates =
                              item['Transaction_Dates']?.split(',') ?? [];
                          List<String> Transaction_Types =
                              item['Transaction_Types']?.split(',') ?? [];

                          // Ensure both lists have the same length
                          int length = Amounts.length < Transaction_Dates.length
                              ? Amounts.length
                              : Transaction_Dates.length;

                          // Create ListTile for each pair of amount and companyCd
                          return List.generate(length, (index) {
                            return ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                      width: 130,
                                      child:
                                          Text('${Transaction_Dates[index]}')),
                                  Container(
                                      width: 80,
                                      child:
                                          Text('${Transaction_Types[index]}')),
                                  Container(child: Text('${Amounts[index]}')),
                                ],
                              ),
                            );
                          });
                        }).toList(),
                ),
              ],
            ),
          ),
        ),
      );
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
      height: MediaQuery.of(context).size.height * 0.55,
      child: FutureBuilder<List<ManagerClients>>(
          future: _fetchSaleTransaction(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty == true) {
                return NoContent();
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

    var screenHeight = MediaQuery.of(context).size.height;
    DateTime pastMonth = DateTime.now().subtract(Duration(days: 30));
    _CenterWiseBusinessDate(BuildContext context) async {
      final DateTimeRange? selected = await showDateRangePicker(
        context: context,
        firstDate: pastMonth,
        lastDate: DateTime(DateTime.now().year + 1),
        saveText: 'Done',
      );

      if (selected != null) {
        final int daysDifference =
            selected.end.difference(selected.start).inDays;

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
          });
        }
      }
    }

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

              // _futureClients = _fetchSalespersons(); // Refresh the Future
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
        // _futureClients = _fetchSalespersons();
        // _fetchSalespersons();
      });
    } else if (selecteTodt == '') {
      setState(() {
        selecteFromdt = formatter1.format(now);
        selecteTodt = formatter1.format(now);
        // _futureClients = _fetchSalespersons();
        // _fetchSalespersons();
      });
    }
//Date Selection...........................................

    return Scaffold(
      appBar: AppBar(
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
        backgroundColor: const Color(0xff123456),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0, bottom: 16),
          child: Column(
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
              Container(
                height: screenHeight * 0.15,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 0, right: 0, top: 8.0, bottom: 8.0),
                      child: Row(
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
                            globals.glb_EMPLOYEE_NAME,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text(
                            globals.Glb_DESIGNATION_NAME,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 10)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 5),
              verticalList3,
              // Center(
              //   child: FutureBuilder(
              //     future: Future.delayed(Duration(seconds: 3)),
              //     builder: (context, snapshot) {
              //       if (snapshot.connectionState == ConnectionState.waiting) {
              //         // Show loader while waiting
              //         return Padding(
              //           padding: const EdgeInsets.only(top: 100.0),
              //           child: SizedBox(
              //             width: 100,
              //             height: 100,
              //             child: LoadingIndicator(
              //               indicatorType: Indicator
              //                   .ballSpinFadeLoader, // Choose your indicator type
              //               colors: [Colors.blue, Colors.red, Colors.green],
              //               strokeWidth: 2,
              //             ),
              //           ),
              //         );
              //       } else {
              //         // Loader finished after 30 seconds
              //         return verticalList3;
              //       }
              //     },
              //   ),
              // ),

              // Padding(
              //   padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              //   child: verticalList3,
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AllbottomNavigation(),
    );
  }
}

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

// Saving_Message() {
//   return Fluttertoast.showToast(
//       msg: "Loading...",
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.CENTER,
//       timeInSecForIosWeb: 1,
//       backgroundColor: Color.fromARGB(255, 12, 192, 123),
//       textColor: Colors.white,
//       fontSize: 16.0);
// }

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

// class UploadPrescriptionBottomSheet extends StatefulWidget {
//   UploadPrescriptionBottomSheet();

//   @override
//   _UploadPrescriptionBottomSheetState createState() =>
//       _UploadPrescriptionBottomSheetState();
// }

// class _UploadPrescriptionBottomSheetState
//     extends State<UploadPrescriptionBottomSheet> {
//   TextEditingController billNoController = TextEditingController();
//   TextEditingController remarkController = TextEditingController();
//   String clientName = '';
//   String billAmount = '';

//   // This method will be called when the OK button is clicked.
//   void Receipt_Cnll(BuildContext context, billNo) async {
//     Map data = {
//       "Emp_id": globals.Glb_CLIENT_NAME_RCPT_CNC.toString(),
//       "session_id": globals.Glb_SESSION_ID,
//       "flag": "",
//       "from_dt": "${DateTime.now().toLocal()}".split(' ')[0],
//       "to_dt": "${DateTime.now().toLocal()}".split(' ')[0],
//       "location_wise_flg": "CB",
//       "location_id": globals.LOC_ID,
//       "IP_BILL_NO": billNo,
//       "IP_BARCODE_NO": "",
//       "connection": globals.Connection_Flag
//     };

//     final response = await http.post(
//         Uri.parse(globals.API_url + '/MobileSales/Centerwisetrans'),
//         headers: {
//           "Accept": "application/json",
//           "Content-Type": "application/x-www-form-urlencoded"
//         },
//         body: data,
//         encoding: Encoding.getByName("utf-8"));

//     if (response.statusCode == 200) {
//       Map<String, dynamic> resposne = jsonDecode(response.body);

//       if (resposne["message"] == "success") {
//         Map<String, dynamic> user = resposne['Data'][0];

//         setState(() {
//           clientName = user['COMPANY_CD'].toString();
//           billAmount = user['AMOUNT'].toString();
//         });
//         Receipt_Cnll_Successfully_Message();
//       } else {
//         Receipt_Cnll_No_Data_Message();
//       }
//     }
//   }

//   void Receipt_Cnll_Confirmation(BuildContext context, billNo, remark) async {
//     Map data = {
//       "IP_BILL_ID": billNo,
//       "IP_REMARKS": remark,
//       "IP_AUTHORISED_BY": globals.glb_EMPLOYEE_ID,
//       "IP_SESSION_ID": globals.Glb_SESSION_ID,
//       "connection": globals.Connection_Flag
//     };

//     final response = await http.post(
//         Uri.parse(globals.API_url + '/MobileSales/PAYMENT_CANCELLATION_APP'),
//         headers: {
//           "Accept": "application/json",
//           "Content-Type": "application/x-www-form-urlencoded"
//         },
//         body: data,
//         encoding: Encoding.getByName("utf-8"));

//     if (response.statusCode == 200) {
//       Map<String, dynamic> resposne = jsonDecode(response.body);

//       if (resposne["message"] == "success") {
//         Submit_Receipt_Cnll_Successfully_Message();
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => Client_Search(
//                     selectedDateIndex: 0,
//                   )),
//         );
//       } else {
//         Receipt_Cnll_No_Data_Message();
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius:
//                 BorderRadius.circular(20), // Adjust the radius for roundness
//           ),
//           padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Text(
//                   'Receipt Cancellation',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Text(
//                 'Receipt No:',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextField(
//                       controller: billNoController,
//                       decoration: InputDecoration(
//                         hintText: "Enter Receipt No.",
//                         border: OutlineInputBorder(),
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.check),
//                     onPressed: () {
//                       Receipt_Cnll(context, billNoController.text);
//                     },
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//               // Sub-title for Client Details
//               Text(
//                 'Details:',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(height: 5),
//               // Client Name (read-only)
//               TextField(
//                 controller: TextEditingController(text: clientName),
//                 readOnly: true,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 5),
//               // Bill Amount (read-only)
//               TextField(
//                 controller: TextEditingController(text: billAmount),
//                 readOnly: true,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               SizedBox(height: 5),
//               // Remark TextField
//               TextField(
//                 controller: remarkController,
//                 decoration: InputDecoration(
//                   hintText: 'Enter remark',
//                   border: OutlineInputBorder(),
//                 ),
//                 maxLines: 1,
//               ),
//               SizedBox(height: 5),
//               // Submit and Cancel buttons
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size(
//                       double.infinity, 50), // Full width button with 50 height
//                 ),
//                 onPressed: () {
//                   Receipt_Cnll_Confirmation(
//                       context, billNoController.text, remarkController.text);
//                 },
//                 child: const Text('Save'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
class UploadPrescriptionBottomSheet extends StatefulWidget {
  @override
  _UploadPrescriptionBottomSheetState createState() =>
      _UploadPrescriptionBottomSheetState();
}

class _UploadPrescriptionBottomSheetState
    extends State<UploadPrescriptionBottomSheet> {
  final _formKey = GlobalKey<FormState>(); // Key for the form
  TextEditingController billNoController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  String clientName = '';
  String billAmount = '';

  // Method to fetch client details by receipt number
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

  // Method to confirm cancellation
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
              builder: (context) => Client_Search(
                    selectedDateIndex: 0,
                  )),
        );
      } else {
        Receipt_Cnll_No_Data_Message();
      }
    }
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
          child: Form(
            key: _formKey, // Form key for validation
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
                      child: TextFormField(
                        controller: billNoController,
                        decoration: InputDecoration(
                          hintText: "Enter Receipt No.",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a receipt number';
                          }
                          return null;
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Receipt_Cnll(context, billNoController.text);
                        }
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
                // Submit button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                        const Size(double.infinity, 50), // Full width button
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Receipt_Cnll_Confirmation(context, billNoController.text,
                          remarkController.text);
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
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
