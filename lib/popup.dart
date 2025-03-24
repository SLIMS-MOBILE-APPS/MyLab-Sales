import 'dart:convert';
import 'package:flutter/material.dart';
import 'ClientsList.dart';
import 'ManagerEmployees.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

TextEditingController limitController = TextEditingController();

enum menuitem { open, locked }

menuitem val = menuitem.open;

class BottomSheetWidget extends StatefulWidget {
  BottomSheetWidget() {}

  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  @override
  void initState() {
    super.initState();
    val = (globals.clientLockFlag == "Y") ? menuitem.locked : menuitem.open;
    limitController.text = globals.CREDIT_LIMT_AMNT_Client_Lock;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context)
                .viewInsets
                .bottom), // Adjusts for keyboard
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Client Name',
                  ),
                  controller: TextEditingController(
                    text: globals.clientName_Client_Lock,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(globals.Client_CODE_Lock),
                ),
                Row(
                  children: [
                    SizedBox(width: 3),
                    (globals.IS_CREDIT_LIMIT_REQ_Client_Lock == "Y")
                        ? Container(
                            width: 150.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                filled: true,
                                hintText: globals.CREDIT_LIMT_AMNT_Client_Lock,
                                labelText: 'Credit Limit',
                                labelStyle: TextStyle(fontSize: 12),
                                border: InputBorder.none,
                              ),
                              controller: limitController,
                              enabled: true,
                              style: TextStyle(
                                color: globals.clientLockFlag == 'Y'
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ),
                          )
                        : Container(
                            width: 120.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                filled: true,
                                hintText: globals.CREDIT_LIMT_AMNT_Client_Lock,
                                labelText: 'Credit Limit',
                                labelStyle: TextStyle(fontSize: 12),
                                border: InputBorder.none,
                              ),
                              controller: limitController,
                              enabled: true,
                            ),
                          ),
                    SizedBox(width: 3),
                    Container(
                      width: 120.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Outstanding Due",
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              globals.balance_Client_Lock,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 244, 54, 181),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                ListTile(
                  title: const Text('Open'),
                  trailing: Radio<menuitem>(
                    value: menuitem.open,
                    activeColor: Colors.green,
                    groupValue: val,
                    onChanged: (menuitem? value) {
                      setState(() {
                        val = menuitem.open;
                        globals.lockstat = val.toString();
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Lock'),
                  trailing: Radio<menuitem>(
                    activeColor: Colors.red,
                    value: menuitem.locked,
                    groupValue: val,
                    onChanged: (menuitem? value) {
                      setState(() {
                        val = menuitem.locked;
                        globals.lockstat = val.toString();
                      });
                    },
                  ),
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      updLockStatus();
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManagerEmployees(
                            selectedDateIndex: 0,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 140,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xff123456),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: const Center(
                        child: Text(
                          'APPLY',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

void showLockBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return BottomSheetWidget();
    },
  );
}

Future<void> updLockStatus() async {
  String Flagval = (val == menuitem.locked) ? "Y" : "N";

  if (limitController.text.isEmpty) {
    limitController.text = "0";
  }

  Map data = {
    "CLIENT_ID": globals.IS_CREDIT_LIMIT_REQ_Client_Lock,
    "CREDIT_LIMIT": limitController.text,
    "SESSION_ID": "1",
    "LOCK_CLIENT": Flagval,
    "connection": globals.Connection_Flag,
  };

  final response = await http.post(
    Uri.parse(globals.API_url + '/MobileSales/CreditLocking'),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded"
    },
    body: data,
    encoding: Encoding.getByName("utf-8"),
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> responseData = jsonDecode(response.body);
    if (responseData["message"] == "success") {
      limitController.clear();
      Fluttertoast.showToast(
        msg: "Successed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Color.fromARGB(255, 64, 238, 11),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      limitController.clear();
      Fluttertoast.showToast(
        msg: "Failed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Color.fromARGB(255, 238, 78, 38),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
