import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomPopupDialog extends StatelessWidget {
  final TextEditingController mobileNoController;
  final TextEditingController billNoController;
  final VoidCallback onSubmit;

  CustomPopupDialog({
    required this.mobileNoController,
    required this.billNoController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mobile No. :'),
          TextField(
            controller: mobileNoController,
            decoration: InputDecoration(hintText: "Enter here Mobile No."),
          ),
          SizedBox(height: 10),
          Center(
            child: Text('OR', style: TextStyle(color: Colors.indigo)),
          ),
          SizedBox(height: 10),
          Text('Bill No.:'),
          TextField(
            controller: billNoController,
            decoration: InputDecoration(hintText: "Enter here Bill No."),
          ),
          Center(
            child: SizedBox(
              height: 50,
              width: 100,
              child: InkWell(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  color: Colors.green,
                  child: Center(
                    child: Text(
                      'OK',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                onTap: onSubmit,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
