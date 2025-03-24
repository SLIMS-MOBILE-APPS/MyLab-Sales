import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'globals.dart' as globals;
import 'dart:convert';

class FranchiseCreationScreen extends StatefulWidget {
  @override
  _FranchiseCreationScreenState createState() =>
      _FranchiseCreationScreenState();
}

class _FranchiseCreationScreenState extends State<FranchiseCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController searchController = TextEditingController();

  List<Map<String, String>> filteredItems = [];
  List<Map<String, String>> selectedItems = [];
  List<Map<String, String>> allItems = [];

  var _selectedItem;

  late Map<String, dynamic> map;
  late Map<String, dynamic> params;
  List data = []; //employee

  late Map<String, dynamic> map1;
  late Map<String, dynamic> params1;
  List data1 = []; //employee

  bool isCodeEnabled = false; // To manage the checkbox state
  TextEditingController codeController = TextEditingController();
  TextEditingController franchiseNameController = TextEditingController();
  TextEditingController tariffController = TextEditingController();
  TextEditingController ownerNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController employeeController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  DateTime fromDate = DateTime.now(); // Default today's date
  DateTime toDate = DateTime(2050, 12, 31); // Default year 2050

  // Function to handle date picking
  Future<void> _selectDate(BuildContext context,
      {required bool isFromDate}) async {
    DateTime initialDate = isFromDate ? fromDate : toDate;
    DateTime firstDate = DateTime(2000);
    DateTime lastDate = DateTime(2050);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      setState(() {
        if (isFromDate) {
          fromDate = pickedDate;
        } else {
          toDate = pickedDate;
        }
      });
    }
  }

  // Email validation using regex
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter Mail ID';
    }
    // Regex for validating email
    final RegExp emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Product_Save(BuildContext context) async {
      Map data = {
        "IP_COLUMN_NAME": "",
        "IP_PREFIX_TEXT": "",
        "IP_ADVANCE_SEARCH": "",
        "IP_FLAG": "",
        "IP_PAGENUM": "1",
        "IP_PAGESIZE": "1000",
        "OP_COUNT": "0",
        "IP_SESSION_ID": "1",
        "connection": globals.Connection_Flag,
      };
      print(data.toString());
      final response = await http.post(
          Uri.parse(globals.API_url + '/MobileSales/GETALL_TARIFF_MOBILE'),
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
            allItems.add({
              'TARIFF_ID': item['TARIFF_ID'].toString(),
              'TARIFF_NAME': item['TARIFF_NAME'].toString(),
              'TARIFF_CD': item['TARIFF_CD'].toString(),
            });
          });
          print("All items: $allItems");
        }
      }
    }

    void filterSearchResults(String query) {
      List<Map<String, String>> dummyList = [];

      if (query.isNotEmpty) {
        // Filter items by checking if 'PRODUCT_NAME' contains the query
        dummyList = allItems
            .where((item) =>
                item['TARIFF_NAME'] != null &&
                item['TARIFF_NAME']!
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();

        setState(() {
          // Clear the filteredItems list and update it with filtered results
          filteredItems.clear();
          dummyList.forEach((item) {
            filteredItems.add({
              'TARIFF_ID': item['TARIFF_ID'].toString(),
              'TARIFF_NAME': item['TARIFF_NAME'].toString(),
              'TARIFF_CD': item['TARIFF_CD'].toString(),
            });
          });
        });
      } else {
        // If query is empty, clear the filteredItems list
        setState(() {
          filteredItems.clear();
        });
      }
    }
    // void selectItem(String selectedItem) {

    void selectItem(Map<String, String> selectedItem) {
      setState(() {
        // Check if the selected item is not already in the list
        if (!selectedItems.contains(selectedItem)) {
          selectedItems.add(selectedItem); // Add the map directly to the list
        }
        searchController.clear();
        filteredItems
            .clear(); // Clear the filtered list after selection (if that's what you intend)
      });
    }

    final COMPANY_TYPE_DROPDOWN = SizedBox(
        width: 340,
        height: 48,
        child: Card(
          elevation: 2.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                isDense: true,
                isExpanded: true,
                value: _selectedItem,
                hint: MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: Text('Select MKTG Employee')),
                onChanged: (value) {
                  setState(() {
                    _selectedItem = value;
                    // globals.Glb_BILL_TYPE_ID = _selectedItem;
                  });
                },
                items: data.map((ldata) {
                  return DropdownMenuItem(
                    child: MediaQuery(
                      data:
                          MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                      child: Text(
                        ldata['COMPANY_TYPE_NAME'].toString(),
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    value: ldata['BILL_TYPE_ID'].toString(),
                  );
                }).toList(),
                // style: TextStyle(color: Colors.black, fontSize: 20,fontFamily: "Montserrat"),
              ),
            ),
          ),
        ));

    @override
    void initState() {
      super.initState();
      filteredItems = [];
      Product_Save(context);
      // COMPANY_TYPE_API();
      // GETALL_TARIFF_API();
      globals.GLB_TARRIF_ID = "";
      globals.Glb_client_name = "";
      globals.Glb_client_name = "";
      globals.Glb_BILL_TYPE_ID = "";
      globals.Glb_From_Date = "";
      globals.Glb_To_Date = "";
      // _textFieldController.text = "";
      globals.Glb_TARIFF_ID = "";

      // late DateTime _fromDate = DateTime.now();
      // formatted_fromDate = DateFormat('dd-MMM-yyyy').format(_fromDate);
      // globals.Glb_From_Date = formatted_fromDate.toString();
      // late DateTime _toDate = DateTime.now();
      // formatted_toDate = DateFormat('dd-MMM-yyyy').format(_toDate);
      // globals.Glb_To_Date = formatted_toDate.toString();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Franchise Creation Field Request'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // Code Field with Checkbox
              Row(
                children: [
                  Checkbox(
                    value: isCodeEnabled,
                    onChanged: (bool? value) {
                      setState(() {
                        isCodeEnabled = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: codeController,
                      enabled: isCodeEnabled,
                      decoration: InputDecoration(labelText: 'Code'),
                      // Validator for Code field
                      validator: (value) {
                        if (isCodeEnabled && (value == null || value.isEmpty)) {
                          return 'Please enter Code';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),

              // Franchise Name
              TextFormField(
                controller: franchiseNameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Name';
                  }
                  return null;
                },
              ),

              // Tariff
              // TextFormField(
              //   controller: tariffController,
              //   decoration: InputDecoration(labelText: 'Tariff'),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter Tariff';
              //     }
              //     return null;
              //   },
              // ),

              // Owner Name
              TextFormField(
                controller: ownerNameController,
                decoration: InputDecoration(labelText: 'Owner Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Owner Name';
                  }
                  return null;
                },
              ),

              // Mobile
              TextFormField(
                controller: mobileController,
                decoration: InputDecoration(labelText: 'Mobile'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Mobile Number';
                  }
                  if (value.length != 10) {
                    return 'Mobile number must be 10 digits';
                  }
                  return null;
                },
              ),

              // Mail ID with Validation
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Mail ID'),
                keyboardType: TextInputType.emailAddress,
                validator: validateEmail,
              ),

              // // MKTG Employee (Required)
              // TextFormField(
              //   controller: employeeController,
              //   decoration: InputDecoration(labelText: 'MKTG Employee'),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter MKTG Employee';
              //     }
              //     return null;
              //   },
              // ),
              // SizedBox(
              //   height: 5,
              // ),
              // Address (Required, Minimum Length)
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  // border:
                  //     OutlineInputBorder(), // Optional: adds a border around the field
                ),
                maxLines:
                    3, // This will allow the text field to expand up to 2 lines
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Address';
                  }
                  if (value.length < 10) {
                    return 'Address must be at least 10 characters long';
                  }
                  return null;
                },
              ),
              COMPANY_TYPE_DROPDOWN,

              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search TARIFF NAME',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: filterSearchResults,
              ),
              SizedBox(height: 10),
              if (filteredItems.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final TARIFF_NAME = item['TARIFF_NAME'];
                      final TARIFF_CD = item['TARIFF_CD'];
                      final TARIFF_ID = item['TARIFF_ID'];

                      return GestureDetector(
                        onTap: () {
                          selectedItems.clear();
                          selectItem(item);
                        },
                        child: Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      TARIFF_NAME.toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ],
                                ),
                                // SizedBox(height: 10),
                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Text(
                                //       'TARIFF_CD:',
                                //       style: TextStyle(
                                //         fontWeight: FontWeight.bold,
                                //         fontSize: 12,
                                //       ),
                                //     ),
                                //     Text(
                                //       TARIFF_CD.toString(),
                                //       style: TextStyle(
                                //         fontSize: 12,
                                //         color: Colors.green,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                // SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              if (selectedItems.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: selectedItems.length > 1
                        ? 1
                        : selectedItems.length, // Limit to 1 item
                    itemBuilder: (context, index) {
                      final item = selectedItems[index];
                      final TARIFF_NAME = item['TARIFF_NAME'];
                      final TARIFF_CD = item['TARIFF_CD'];
                      final TARIFF_ID = item['TARIFF_ID'];

                      return Card(
                        elevation: 5,
                        margin:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'TARIFF_NAME:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    TARIFF_NAME.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'TARIFF_CD:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    TARIFF_CD.toString(),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
        // // From Date
        // ListTile(
        //   title: Text(
        //       "From Date: ${DateFormat('dd/MM/yyyy').format(fromDate)}"),
        //   trailing: Icon(Icons.calendar_today),
        //   onTap: () => _selectDate(context, isFromDate: true),
        // ),

        // // To Date
        // ListTile(
        //   title:
        //       Text("To Date: ${DateFormat('dd/MM/yyyy').format(toDate)}"),
        //   trailing: Icon(Icons.calendar_today),
        //   onTap: () => _selectDate(context, isFromDate: false),
        // ),

        // Submit Button
        // Align(
        //   alignment: Alignment.bottomCenter,
        //   child: ElevatedButton(
        //     onPressed: () {
        //       if (_formKey.currentState!.validate()) {
        //         // Perform submit logic
        //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //           content: Text('Form Submitted Successfully!'),
        //         ));
        //       }
        //     },
        //     child: Text('Submit'),
        //   ),
        // ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Perform submit logic
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Form Submitted Successfully!'),
              ));
            }
          },
          child: Text('Submit'),
        ),
      ),
    );
  }
}
