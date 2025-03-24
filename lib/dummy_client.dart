import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
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
  const Client_Search({super.key});

  @override
  State<Client_Search> createState() => _Client_SearchState();
}

class _Client_SearchState extends State<Client_Search> {
  var selecteFromdt = '';
  var selecteTodt = '';
  DateTime selectedDate = DateTime.now();

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

    // Widget Application_Widget(data, BuildContext context) {
    //   String clientName = data.clientname;
    //   String clientLockFlag = data.locked;

    //   return GestureDetector(
    //     onTap: () {
    //       globals.selectedClientid = data.clientid.toString();
    //       globals.clientName = data.clientname;
    //       globals.selectedClientData = data;
    //       globals.selectedClientid = data.clientid.toString();
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(builder: (context) => ClientProfile(0)),
    //       );
    //     },
    //     child: Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
    //       child: Container(
    //         width: double.infinity,
    //         child: Card(
    //           elevation: 4,
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(12),
    //           ),
    //           child: Padding(
    //             padding: const EdgeInsets.all(12),
    //             child: ListTile(
    //               title: Row(
    //                 children: [
    //                   Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Row(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: [
    //                           Expanded(
    //                             flex: 2,
    //                             child: Text(
    //                               clientName,
    //                               style: TextStyle(
    //                                 fontSize: 16,
    //                                 fontWeight: FontWeight.bold,
    //                               ),
    //                               overflow: TextOverflow.ellipsis,
    //                             ),
    //                           ),
    //                           SizedBox(width: 8),
    //                           Column(
    //                             children: [
    //                               GestureDetector(
    //                                 onTap: () {
    //                                   // Saving_Message();
    //                                   if (globals.Glb_IS_LOCK_REQ == "Y") {
    //                                     showDialog(
    //                                       context: context,
    //                                       builder: (BuildContext context) =>
    //                                           Lock_Widget(
    //                                               clientLockFlag,
    //                                               clientName,
    //                                               data.clientid.toString(),
    //                                               data.IS_CREDIT_LIMIT_REQ
    //                                                   .toString(),
    //                                               data.CREDIT_LIMT_AMNT
    //                                                   .toString(),
    //                                               data.balance.toString(),
    //                                               data.Client_CODE.toString()),
    //                                     );
    //                                   }
    //                                 },
    //                                 child: Row(
    //                                   children: [
    //                                     Text(
    //                                       data.CREDIT_LIMT_AMNT.toString(),
    //                                       style: TextStyle(
    //                                         fontSize: 14,
    //                                         fontWeight: FontWeight.bold,
    //                                         color: data.locked == 'Y'
    //                                             ? Colors.red
    //                                             : Colors.green,
    //                                       ),
    //                                       overflow: TextOverflow.ellipsis,
    //                                     ),
    //                                     SizedBox(width: 5),
    //                                     Container(
    //                                       // height: 50,
    //                                       decoration: BoxDecoration(
    //                                         color: Color.fromARGB(
    //                                             255, 175, 213, 224),
    //                                         shape: BoxShape.rectangle,
    //                                       ),
    //                                       child: Padding(
    //                                         padding: const EdgeInsets.fromLTRB(
    //                                             0, 0, 0, 0),
    //                                         child: Icon(
    //                                           data.locked == 'Y'
    //                                               ? Icons.lock
    //                                               : Icons.lock_open,
    //                                           color: data.locked == 'Y'
    //                                               ? Colors.red
    //                                               : Colors.green,
    //                                           size: 18,
    //                                         ),
    //                                       ),
    //                                     ),
    //                                   ],
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                         ],
    //                       ),
    //                       Text(
    //                         data.Client_CODE,
    //                         style: TextStyle(
    //                           fontSize: 14,
    //                           fontWeight: FontWeight.bold,
    //                           color: Colors.grey,
    //                         ),
    //                         overflow: TextOverflow.ellipsis,
    //                       ),
    //                     ],
    //                   ),
    //                   Column(
    //                     children: [Text("This is second widget")],
    //                   )
    //                 ],
    //               ),
    //               subtitle: Padding(
    //                 padding: const EdgeInsets.only(top: 8.0),
    //                 child: Column(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Divider(color: Colors.grey),
    //                     SizedBox(height: 8),
    //                     Row(
    //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                       children: [
    //                         Text(
    //                           "(B) ${data.business}",
    //                           style: TextStyle(
    //                             fontSize: 14,
    //                             fontWeight: FontWeight.w500,
    //                             color: Colors.green,
    //                           ),
    //                         ),
    //                         Text(
    //                           "(P) ${data.deposits}",
    //                           style: TextStyle(
    //                             fontSize: 14,
    //                             fontWeight: FontWeight.w500,
    //                             color: Colors.blue,
    //                           ),
    //                         ),
    //                         Text(
    //                           "(O) ${data.balance}",
    //                           style: TextStyle(
    //                             fontSize: 14,
    //                             fontWeight: FontWeight.w500,
    //                             color: Colors.red,
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   );
    // }

    Widget Application_Widget(data, BuildContext context) {
      String clientName = data.clientname;
      String clientLockFlag = data.locked;

      PAYMENT_CANCELLATION(BuildContext context) async {
        Map data = {
          "IP_BILL_ID": "",
          "IP_REMARKS": "",
          "IP_AUTHORISED_BY": "",
          "IP_SESSION_ID": "",
          "connection": globals.Connection_Flag
        };
        print(data.toString());
        final response = await http.post(
            Uri.parse(
                globals.API_url + '/MobileSales/PAYMENT_CANCELLATION_APP'),
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
          }
        }
      }

      void showReceiptCancellationDialog(BuildContext context) {
        TextEditingController billNoController = TextEditingController();
        TextEditingController clientNameController = TextEditingController();
        TextEditingController amountController = TextEditingController();
        TextEditingController remarkController = TextEditingController();

        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Receipt Cancellation"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // Section for Bill No. with OK button
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Bill No.",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: billNoController,
                                decoration: InputDecoration(
                                  hintText: "Enter Bill No.",
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.check),
                              onPressed: () {
                                // Receipt_Cnll(context, billNoController.text,
                                //     data.clientid);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Section for Client Name
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Client Name",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: 300,
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            globals
                                .Glb_CLIENT_NAME_RCPT_CNC, // Replace with your data
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Section for Amount
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Amount",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: 300,
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            globals
                                .Glb_BILL_AMOUNT_RCPT_CNC, // Replace with your data
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Section for Remark
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Remark",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextFormField(
                          controller: remarkController,
                          decoration: InputDecoration(
                            hintText: 'Enter Remark',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          maxLines: 3, // Allow multi-line input
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                // Cancel Button
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                // Submit Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    PAYMENT_CANCELLATION(context);
                    Navigator.of(context)
                        .pop(); // Close the dialog after submission
                  },
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      }

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
          }
        }
      }

      void showResetPasswordDialog(BuildContext context) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Reset Password"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // User Name field

                    // TextFormField(
                    //   decoration: InputDecoration(
                    //     labelText: data.clientname,
                    //     border: OutlineInputBorder(
                    //       borderRadius: BorderRadius.circular(10),
                    //     ),
                    //   ),
                    //   readOnly: true, // Makes the field read-only
                    // ),
                    Container(
                      width: 300,
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
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

                    // New Password field
                    TextField(
                      controller: newPasswordController,
                      decoration: InputDecoration(
                        labelText: "New Password",
                      ),
                      obscureText: true, // To hide the password text
                    ),
                    SizedBox(height: 10),

                    // Confirm Password field
                    TextField(
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                      ),
                      obscureText: true, // To hide the password text
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                // Cancel button
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    newPasswordController.text = "";
                    Navigator.of(context)
                        .pop(); // Close the dialog without any action
                  },
                ),
                // Submit button
                ElevatedButton(
                  child: Text("Submit"),
                  onPressed: () {
                    newPasswordController.text == confirmPasswordController.text
                        ? (UPD_PASSWORD_MOBILE(context, data.Client_CODE,
                            newPasswordController.text))
                        : Password_Confirmation_Message();
                  },
                ),
              ],
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
          }
        }
      }

      void _showCreditNotePopup(BuildContext context) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(15), // Rounded corners for dialog
              ),
              title: const Text(
                'Credit Note',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Client Code TextField
                    Container(
                      width: 300,
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
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
                    // Amount TextFormField with keyboardType for numbers
                    TextFormField(
                      controller: Credit_amountController, // Add the controller
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.number, // Numeric input
                    ),
                    SizedBox(height: 15),
                    // Remark TextFormField
                    TextFormField(
                      controller: Credit_remarkController, // Add the controller
                      decoration: InputDecoration(
                        labelText: 'Remark',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      maxLines: 3, // Allow multi-line input
                    ),
                  ],
                ),
              ),
              actions: [
                // Cancel Button
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                // Submit Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    CREDIT_NOTE(context, Credit_amountController.text,
                        Credit_remarkController.text, data.clientid.toString());
                    Navigator.of(context).pop(); // Close the dialog
                    Credit_amountController.text = "";
                    Credit_amountController.text = "";
                  },
                  child: const Text('Submit'),
                ),
              ],
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
          }
        }
      }

      void _showDebitNotePopup(BuildContext context) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(15), // Rounded corners for dialog
              ),
              title: const Text(
                'Debit Note',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Client Code TextField
                    Container(
                      width: 300,
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
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
                    // Amount TextFormField with keyboardType for numbers
                    TextFormField(
                      controller: amountController, // Add the controller
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.number, // Numeric input
                    ),
                    SizedBox(height: 15),
                    // Remark TextFormField
                    TextFormField(
                      controller: remarkController, // Add the controller
                      decoration: InputDecoration(
                        labelText: 'Remark',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      maxLines: 3, // Allow multi-line input
                    ),
                  ],
                ),
              ),
              actions: [
                // Cancel Button
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                // Submit Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue, // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    DEBIT_NOTE(context, amountController.text,
                        remarkController.text, data.clientid.toString());
                    Navigator.of(context).pop(); // Close the dialog
                    remarkController.text = "";
                    amountController.text = "";
                  },
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      }

      void _showUploadPrescriptionBottomSheet() {
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
          builder: (context) {
            return UploadPrescriptionBottomSheet();
          },
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
        child: Container(
          width: double.infinity,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 12, bottom: 12, left: 0, right: 0),
              child: ListTile(
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              globals.selectedClientid =
                                  data.clientid.toString();
                              globals.clientName = data.clientname;
                              globals.selectedClientData = data;
                              globals.selectedClientid =
                                  data.clientid.toString();
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
                                    clientName,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 8),
                              ],
                            ),
                          ),
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
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
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
                              globals.balance_Client_Lock =
                                  data.balance.toString();
                              globals.Client_CODE_Lock =
                                  data.Client_CODE.toString();
                              Saving_Message();
                              if (globals.Glb_IS_LOCK_REQ == "Y  ") {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      Lock_Widget(),
                                );
                              }
                            },
                            child: Row(
                              children: [
                                Text(
                                  data.CREDIT_LIMT_AMNT.toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: data.locked == 'Y'
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(width: 5),
                                Container(
                                  height: 50,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                        ],
                      ),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(color: Colors.grey),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "(B) ${data.business}",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.green,
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
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      Row(
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
                            child: const Text("Credit",
                                style: TextStyle(fontSize: 10)),
                            onPressed: () {
                              _showCreditNotePopup(context);
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
                            child: const Text("Debit",
                                style: TextStyle(fontSize: 10)),
                            onPressed: () {
                              _showDebitNotePopup(context);
                            },
                          ),
                          // Cancel Receipt Button
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary:
                                  Color.fromARGB(255, 220, 53, 69), // Red color
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
                              showResetPasswordDialog(context);
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
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
      height: MediaQuery.of(context).size.height * 0.7,
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
    Widget All_Test_Widget(var data, BuildContext context) {
      return SingleChildScrollView(
        child: Column(
          children: [
            if (data.length > 0)
              Container(
                width: double.infinity,
                child: Card(
                  elevation: 7,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
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
                              data[0]['EMPLOYEE_NAME'],
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            SizedBox(
                              width: 30,
                            ),
                            SizedBox(
                              width: 60,
                              child: Text('Emp cd:',
                                  style: TextStyle(fontSize: 12)),
                            ),
                            Text(data[0]['EMPLOYEE_CD'],
                                style: TextStyle(fontSize: 12)),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 30,
                            ),
                            SizedBox(
                              width: 60,
                              child: Text('Email:',
                                  style: TextStyle(fontSize: 12)),
                            ),
                            Text(data[0]['EMAIL_ID'],
                                style: TextStyle(fontSize: 12)),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 30,
                            ),
                            SizedBox(
                              width: 60,
                              child: Text('Phone:',
                                  style: TextStyle(fontSize: 12)),
                            ),
                            Text(data[0]['MOBILE_PHONE'],
                                style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    function_widet() {
      return All_Test_Widget(globals.Glb_ManagerDetailsList, context);
    }

    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Manager & Clients'),
        backgroundColor: const Color(0xff123456),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Container(height: 120, child: function_widet()),
              Container(
                height: screenHeight * 0.15,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, top: 8.0, bottom: 8.0),
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

  // This method will be called when the OK button is clicked.
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
          clientName = user['CLIENT_NAME'].toString();
          billAmount = user['BILL_AMOUNT'].toString();
        });
        Receipt_Cnll_Successfully_Message();
      } else {
        Receipt_Cnll_No_Data_Message();
      }
    }
  }

  void Receipt_Cnll_Confirmation(BuildContext context, billNo) async {
    Map data = {
      "IP_BILL_ID": billNo,
      "IP_REMARKS": "",
      "IP_AUTHORISED_BY": globals.Glb_second_new_selectedEmpid,
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
        Receipt_Cnll_Successfully_Message();
      } else {
        Receipt_Cnll_No_Data_Message();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receipt Cancellation'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bill No TextField
              Text(
                'Bill No:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: billNoController,
                      decoration: InputDecoration(
                        hintText: "Enter Bill No.",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Receipt_Cnll_Confirmation(context, billNoController.text);
                    },
                    child: Text('Submit'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Cancel and close the popup
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: Text('Cancel'),
                  ),
                ],
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
