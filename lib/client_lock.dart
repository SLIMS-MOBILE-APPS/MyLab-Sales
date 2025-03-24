import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'globals.dart' as globals;
import 'clients_search.dart';

TextEditingController limitController = TextEditingController();

enum menuitem { open, locked }

menuitem val = menuitem.open;

class Lock_Widget extends StatefulWidget {
  @override
  _Lock_WidgetState createState() => _Lock_WidgetState();
}

class _Lock_WidgetState extends State<Lock_Widget> {
  @override
  void initState() {
    super.initState();
    (globals.clientLockFlag == "Y")
        ? val = menuitem.locked
        : val = menuitem.open;
    limitController =
        TextEditingController(text: globals.CREDIT_LIMT_AMNT_Client_Lock);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom:
              MediaQuery.of(context).viewInsets.bottom), // Adjusts for keyboard
      child: SingleChildScrollView(
        // Wrapping to handle overflow
        child: Column(
          mainAxisSize: MainAxisSize.min, // Important for BottomSheet
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              children: [
                TextField(
                  decoration:
                      InputDecoration(filled: true, labelText: 'Client Name'),
                  controller: TextEditingController(
                    text: globals.clientName_Client_Lock,
                  ),
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
                              enabled: false,
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
                )
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
                  globals.Glb_Client_Code = globals.Client_CODE_Lock;
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Client_Search(selectedDateIndex: 0),
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
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

updLockStatus() async {
  String Flagval = "";
  (val.toString() == "menuitem.locked") ? Flagval = "Y" : Flagval = "N";

  (limitController.text == "")
      ? limitController.text = "0"
      : limitController.text;
  Map data = {
    "CLIENT_ID": globals.clientid_Client_Lock,
    "CREDIT_LIMIT": limitController.text,
    "SESSION_ID": "1",
    "LOCK_CLIENT": Flagval,
    "connection": globals.Connection_Flag
  };

  final response =
      await http.post(Uri.parse(globals.API_url + '/MobileSales/CreditLocking'),
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: data,
          encoding: Encoding.getByName("utf-8"));

  if (response.statusCode == 200) {
    Map<String, dynamic> resposne = jsonDecode(response.body);
    if (resposne["message"] == "success") {
      limitController.text = '';

      return Fluttertoast.showToast(
        msg: "Successed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 64, 238, 11),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      limitController.text = '';
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
