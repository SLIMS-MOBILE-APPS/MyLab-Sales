import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'globals.dart' as globals;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'Sales_Dashboard.dart';
import 'package:flutter/services.dart';

class CompanyAddScreen extends StatefulWidget {
  @override
  _CompanyAddScreenState createState() => _CompanyAddScreenState();
}

class _CompanyAddScreenState extends State<CompanyAddScreen> {
  String empID = "0";
  TextEditingController _textFieldController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController searchController = TextEditingController();
  final TextEditingController MKTG_Emp_searchController =
      TextEditingController();

  bool isCodeEnabled = false; // To manage the checkbox state
  TextEditingController codeController = TextEditingController();
  TextEditingController franchiseNameController = TextEditingController();
  TextEditingController tariffController = TextEditingController();
  TextEditingController ownerNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController employeeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  List<Map<String, String>> MKTG_Emp_filteredItems = [];
  List<Map<String, String>> filteredItems = [];
  List<Map<String, String>> selectedItems = [];
  List<Map<String, String>> MKTG_Emp_selectedItems = [];

  String formatted_fromDate = '';
  String formatted_toDate = '';

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
// Get the current date for 'from date'
    DateTime _fromDate = DateTime.now();

// Set the 'to date' with the year 2050
    DateTime _toDate = DateTime(2050, _fromDate.month, _fromDate.day);

// Format and assign to globals
    globals.Glb_From_Date =
        DateFormat('dd-MMM-yyyy').format(_fromDate).toString();
    globals.Glb_To_Date = DateFormat('dd-MMM-yyyy').format(_toDate).toString();

    filteredItems = [];
    MKTG_Emp_filteredItems = [];

    Product_Save(context);

    MKTG_Emp_Product_Save(context);
    COMPANY_TYPE_API();
    PR_GETALL_EMPLOYEE_API();
    globals.Glb_MKTG_Emp = "";
    globals.GLB_TARRIF_ID = "";
    globals.Glb_client_name = "";
    globals.Glb_client_name = "";
    globals.Glb_BILL_TYPE_ID = "";

    _textFieldController.text = "";
    globals.Glb_TARIFF_ID = "";

    // late DateTime _fromDate = DateTime.now();
    // formatted_fromDate = DateFormat('dd-MMM-yyyy').format(_fromDate);
    // globals.Glb_From_Date = formatted_fromDate.toString();
    // late DateTime _toDate = DateTime.now();
    // formatted_toDate = DateFormat('dd-MMM-yyyy').format(_toDate);
    // globals.Glb_To_Date = formatted_toDate.toString();
  }

  List<Map<String, String>> allItems = [];
  List<Map<String, String>> MKTG_Emp_allItems = [];

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

  MKTG_Emp_Product_Save(BuildContext context) async {
    Map data = {
      "IP_COLUMN_NAME": "",
      "IP_PREFIXTEXT": "",
      "IP_FROM_DT": "",
      "IP_TO_DT": "",
      "IP_PAGENUM": "",
      "IP_PAGESIZE": "",
      "IP_FLAG": "",
      "OP_COUNT": "0",
      "IP_SESSION_ID": "1",
      "connection": globals.Connection_Flag,
    };
    print(data.toString());
    final response = await http.post(
        Uri.parse(globals.API_url + '/MobileSales/GETALL_EMPLOYEE'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);
      if (resposne["message"] == "success") {
        List<dynamic> MKTG_Empresults = resposne["Data"];

        MKTG_Empresults.forEach((MKTG_Empitem) {
          MKTG_Emp_allItems.add({
            'ID': MKTG_Empitem['ID'].toString(),
            'FIRST_NAME': MKTG_Empitem['FIRST_NAME'].toString(),
            'CODE': MKTG_Empitem['CODE'].toString(),
          });
        });
      }
    }
  }

  // void MKTG_Emp_filterSearchResults(String MKTG_Emp_query) {
  //   List<Map<String, String>> MKTG_Emp_dummyList = [];

  //   if (MKTG_Emp_query.isNotEmpty) {
  //     // Filter items by checking if 'PRODUCT_NAME' contains the query
  //     MKTG_Emp_dummyList = MKTG_Emp_allItems.where((MKTG_Emp_item) =>
  //         MKTG_Emp_item['FIRST_NAME'] != null &&
  //         MKTG_Emp_item['FIRST_NAME']!
  //             .toLowerCase()
  //             .contains(MKTG_Emp_query.toLowerCase())).toList();

  //     setState(() {
  //       // Clear the filteredItems list and update it with filtered results
  //       filteredItems.clear();
  //       MKTG_Emp_dummyList.forEach((MKTG_Emp_item) {
  //         MKTG_Emp_filteredItems.add({
  //           'ID': MKTG_Emp_item['ID'].toString(),
  //           'FIRST_NAME': MKTG_Emp_item['FIRST_NAME'].toString(),
  //           'CODE': MKTG_Emp_item['CODE'].toString(),
  //         });
  //       });
  //     });
  //   } else {
  //     // If query is empty, clear the filteredItems list
  //     setState(() {
  //       MKTG_Emp_filteredItems.clear();
  //     });
  //   }
  // }

  void MKTG_Emp_filterSearchResults(String MKTG_Emp_query) {
    List<Map<String, String>> MKTG_Emp_dummyList = [];

    if (MKTG_Emp_query.isNotEmpty) {
      // Filter items by checking if 'FIRST_NAME' contains the query
      MKTG_Emp_dummyList = MKTG_Emp_allItems.where((MKTG_Emp_item) =>
          MKTG_Emp_item['FIRST_NAME'] != null &&
          MKTG_Emp_item['FIRST_NAME']!
              .toLowerCase()
              .contains(MKTG_Emp_query.toLowerCase())).toList();

      setState(() {
        // Clear the filteredItems list and update it with filtered results
        MKTG_Emp_filteredItems.clear();
        MKTG_Emp_dummyList.forEach((MKTG_Emp_item) {
          MKTG_Emp_filteredItems.add({
            'ID': MKTG_Emp_item['ID'] ?? '',
            'FIRST_NAME': MKTG_Emp_item['FIRST_NAME'] ?? '',
            'CODE': MKTG_Emp_item['CODE'] ?? '',
          });
        });
      });
    } else {
      // If query is empty, clear the filteredItems list
      setState(() {
        MKTG_Emp_filteredItems.clear();
      });
    }
  }

  void MKTG_Emp_selectItem(Map<String, String> MKTG_Emp_selectedItem) {
    setState(() {
      // Check if the selected item is not already in the list
      if (!MKTG_Emp_selectedItems.contains(MKTG_Emp_selectedItem)) {
        MKTG_Emp_selectedItems.add(
            MKTG_Emp_selectedItem); // Add the map directly to the list
      }
      MKTG_Emp_searchController.clear();
      MKTG_Emp_filteredItems
          .clear(); // Clear the filtered list after selection (if that's what you intend)
    });
  }

  // void selectItem(String selectedItem) {

  void filterSearchResults(String query) {
    List<Map<String, String>> dummyList = [];

    if (query.isNotEmpty) {
      dummyList = allItems
          .where((item) =>
              item['TARIFF_NAME'] != null &&
              item['TARIFF_NAME']!.toLowerCase().contains(query.toLowerCase()))
          .toList();

      setState(() {
        // Update filteredItems with filtered results
        filteredItems.clear();
        filteredItems.addAll(dummyList.map((item) => {
              'TARIFF_ID': item['TARIFF_ID'] ?? '',
              'TARIFF_NAME': item['TARIFF_NAME'] ?? '',
              'TARIFF_CD': item['TARIFF_CD'] ?? '',
            }));
      });
    } else {
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

  var _selectedItem;
  var _selectedItem1;

  late Map<String, dynamic> map;
  late Map<String, dynamic> params;
  List data = []; //employee

  late Map<String, dynamic> map1;
  late Map<String, dynamic> params1;
  List data1 = []; //employee

  COMPANY_TYPE_API() async {
    params = {
      "IP_SESSION_ID": "1",
      "IP_TYPE": "",
      "IP_FLAG": "",
      "connection": globals.Connection_Flag,
    };

    final response = await http.post(
        Uri.parse(globals.API_url + '/MobileSales/company_type_sales_mobile'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: params,
        encoding: Encoding.getByName("utf-8"));
    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);
      Map<String, dynamic> user = resposne['Data'][1];
      globals.Glb_BILL_TYPE_ID = user['BILL_TYPE_ID'].toString();
    }

    return "Sucess";
  }

  PR_GETALL_EMPLOYEE_API() async {
    params1 = {
      "IP_COLUMN_NAME": "",
      "IP_PREFIXTEXT": "",
      "IP_FROM_DT": "",
      "IP_TO_DT": "",
      "IP_PAGENUM": "",
      "IP_PAGESIZE": "",
      "IP_FLAG": "",
      "OP_COUNT": "0",
      "IP_SESSION_ID": "1",
      "connection": globals.Connection_Flag,
    };

    final response = await http.post(
        Uri.parse(globals.API_url + '/MobileSales/GETALL_EMPLOYEE'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: params1,
        encoding: Encoding.getByName("utf-8"));

    print('im here');
    print(response.body);
    map1 = json.decode(response.body);
    print(response.body);
    if (response.statusCode == 200) {}
    setState(() {
      data1 = map1["Data"] as List;
    });

    return "Sucess";
  }

  List<String> SearchList = [];

  Accept_Permission() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        contentPadding: EdgeInsets.only(top: 15, left: 10.0, right: 10.0),
        content: Center(
          heightFactor: 1,
          child: Container(
            height: 70,
            child: Column(
              children: [
                MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                  child: Text(
                    'Please click Yes to proceed ahead',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(textScaleFactor: 1.0),
                            child: Text("No"))),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          WaitingFunciton();
                        },
                        child: MediaQuery(
                            data: MediaQuery.of(context)
                                .copyWith(textScaleFactor: 1.0),
                            child: Text("Yes"))),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isButtonDisabled = false;
  Future<void> WaitingFunciton() async {
    if (!isButtonDisabled) {
      setState(() {
        isButtonDisabled = true; // Disable the button
      });
      if (globals.Glb_MKTG_Emp == "") {
        MKTG_Emp_Message();
      } else if (selectedItems.isEmpty) {
        TARRIF_ID_Message();
      } else {
        CompanyAdding();
      }

      Future.delayed(Duration(seconds: 5), () {
        // Enable the button again after the delay
        setState(() {
          isButtonDisabled = false;
        });
      });
    }
  }

  CompanyAdding() async {
    var isLoading = true;

    Map<String, dynamic> body = {
      "IP_COMPANY_ID": "0",
      "IP_TARRIF_ID": globals.Glb_TARIFF_ID,
      "IP_EMP_ID": globals.selectedEmpid,
      "IP_SESSION_ID": globals.Glb_SESSION_ID,
      "IP_COMPANY_NAME": globals.Glb_Name,
      "IP_COMPANY_DESC": globals.Glb_Name,
      "IP_COMPANY_REV_NO": "1",
      "IP_COMPANY_EXCHANGE_REV_NO": "1",
      "IP_COMPANY_ADDR_REV_NO": "1",
      "IP_REFERENCE_TYPE_ID": "8",
      "IP_BILLING_TYPE_ID": globals.Glb_BILL_TYPE_ID,
      "IP_EFFECT_FROM_DT": globals.Glb_From_Date,
      "IP_EFFECT_TO_DT": globals.Glb_To_Date,
      "IP_COMPANY_CD": globals.Glb_Code,
      "IP_TRADE_NAME": globals.Glb_Name,
      "IP_EXTENSION": globals.Glb_Owner_Name,
      "IP_MOBILE": globals.Glb_Mobile,
      "IP_MOBILE2": globals.Glb_Mobile,
      "IP_EMAIL": globals.Glb_Mail_Id,
      "IP_ADDRESS1": globals.Glb_Address,
      "IP_CMP_EMPLOYEE_ID": globals.Glb_MKTG_Emp,
      "IP_SPECIALIZATION": "",
      "IP_MARKETING_AREA_ID": "",
      "IP_REFRL_ID": "",
      "connection": globals.Connection_Flag,
    };

    final response = await http.post(
        Uri.parse(
            globals.API_url + '/MobileSales/COMPANY_DETAILS_COM_SALES_MOBILE'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: body,
        encoding: Encoding.getByName("utf-8"));

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);

      if (resposne["message"] == "success") {
        globals.Glb_TARIFF_ID = "";
        globals.selectedEmpid = "";
        globals.Glb_SESSION_ID = "";
        globals.Glb_Name = "";
        globals.Glb_Name = "";
        globals.Glb_BILL_TYPE_ID = "";
        globals.Glb_From_Date = "";
        globals.Glb_To_Date = "";
        globals.Glb_Code = "";
        globals.Glb_Name = "";
        globals.Glb_Owner_Name = "";
        globals.Glb_Mobile = "";
        globals.Glb_Mobile = "";
        globals.Glb_Mail_Id = "";
        globals.Glb_Address = "";
        globals.Glb_MKTG_Emp = "";
        selectedItems.clear();
        Successtoaster();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CompanyAddScreen()),
        );
      } else {
        failurestoaster();
      }
    }
  }

  String? _selectedCompanyType;
  String? _selectedTariff;
  TextEditingController _clientNameController = TextEditingController();
  late DateTime _fromDate = DateTime.now();
  late DateTime _toDate = DateTime.now();
  List<String> _filteredData = [];

  void _filterData(String query) {
    _filteredData.clear();
    if (query.isEmpty) {
      _filteredData.addAll(SearchList);
    } else {
      _filteredData.addAll(
        SearchList.where(
            (item) => item.toLowerCase().contains(query.toLowerCase())),
      );
    }
    setState(() {});
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
    final COMPANY_TYPE_DROPDOWN = SizedBox(
      width: 340,
      height: 48,
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              isDense: true,
              isExpanded: true,
              value: _selectedItem,
              hint: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: Text('Select COMPANY TYPE'),
              ),
              onChanged: (value) {
                setState(() {
                  _selectedItem = value;
                  globals.Glb_BILL_TYPE_ID = _selectedItem;
                });
              },
              items: data.map((ldata) {
                return DropdownMenuItem(
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: Text(
                      ldata['COMPANY_TYPE_NAME'].toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  value: ldata['BILL_TYPE_ID'].toString(),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
    final GETALL_EMPLOYEE_API_DROPDOWN = SizedBox(
      width: 340,
      height: 48,
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              isDense: true,
              isExpanded: true,
              value: _selectedItem1,
              hint: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: Text('Select MKTG Employee'),
              ),
              onChanged: (value) {
                setState(() {
                  _selectedItem1 = value;
                  globals.Glb_MKTG_Emp = _selectedItem1;
                });
              },
              items: data1.map((ldata) {
                return DropdownMenuItem(
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: Text(
                      ldata['FIRST_NAME'].toString(),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  value: ldata['ID'].toString(),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff123456),
        title: Text('Franchise Creation Field Request'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SalesManagerDashboard()),
            );
          },
        ),
      ),
      resizeToAvoidBottomInset:
          true, // Allows layout to resize when the keyboard opens
      body: SingleChildScrollView(
        controller: _scrollController,
        // Allows scrolling to prevent overflow when keyboard appears
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
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
                        keyboardType: TextInputType.text,
                        enabled: isCodeEnabled,
                        decoration: InputDecoration(labelText: 'Code'),
                        validator: (value) {
                          if (isCodeEnabled &&
                              (value == null || value.isEmpty)) {
                            return 'Please enter Code';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
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
                TextFormField(
                  controller: mobileController,
                  decoration: InputDecoration(labelText: 'Mobile'),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter
                        .digitsOnly, // Allows only digits
                    LengthLimitingTextInputFormatter(
                        10), // Limits input to 10 characters
                  ],
                  validator: (value) {
                    // Check if the value is null or empty
                    if (value == null || value.isEmpty) {
                      return 'Please enter Mobile Number';
                    }

                    // Check if the value contains exactly 10 digits
                    if (value.length != 10) {
                      return 'Mobile number must be exactly 10 digits';
                    }

                    // Check if the value contains only digits
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Mobile number must contain only digits';
                    }

                    return null; // Return null if validation passes
                  },
                ),

                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Mail ID'),
                  keyboardType: TextInputType.emailAddress,
                  validator: validateEmail,
                ),
                TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: 'Address'),
                  maxLines: 3,
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
                // SizedBox(height: 20),
                // COMPANY_TYPE_DROPDOWN,
                SizedBox(height: 20),
                // GETALL_EMPLOYEE_API_DROPDOWN,
                TextField(
                  controller: MKTG_Emp_searchController,
                  decoration: InputDecoration(
                    labelText: 'Search MKTG Emp',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: MKTG_Emp_filterSearchResults,
                ),

                if (MKTG_Emp_filteredItems.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics:
                        NeverScrollableScrollPhysics(), // Prevents ListView from scrolling separately
                    itemCount: MKTG_Emp_filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = MKTG_Emp_filteredItems[index];
                      final FIRST_NAME = item['FIRST_NAME'];
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      });
                      return GestureDetector(
                        onTap: () {
                          MKTG_Emp_selectedItems.clear();
                          MKTG_Emp_selectItem(item);
                        },
                        child: Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              FIRST_NAME.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                if (MKTG_Emp_selectedItems.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      final MKTG_Emp_item = MKTG_Emp_selectedItems[0];
                      final FIRST_NAME = MKTG_Emp_item['FIRST_NAME'];
                      final CODE = MKTG_Emp_item['CODE'];
                      globals.Glb_MKTG_Emp = MKTG_Emp_item['CODE'].toString();

                      globals.Glb_BILL_TYPE_ID = MKTG_Emp_item['ID'].toString();

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
                                    'Selected:',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 150,
                                    child: Text(
                                      FIRST_NAME.toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    CODE.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
//...............................................................................
                SizedBox(height: 20),
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: 'Search TARIFF NAME',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: filterSearchResults,
                ),

                if (filteredItems.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    physics:
                        NeverScrollableScrollPhysics(), // Prevents ListView from scrolling separately
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final TARIFF_NAME = item['TARIFF_NAME'];
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      });

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
                            child: Text(
                              TARIFF_NAME.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                if (selectedItems.isNotEmpty)
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      final item = selectedItems[0];
                      final TARIFF_NAME = item['TARIFF_NAME'];
                      final TARIFF_CD = item['TARIFF_CD'];
                      globals.Glb_TARIFF_ID = item['TARIFF_ID'].toString();

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
                                    'Selected:',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 150,
                                    child: Text(
                                      TARIFF_NAME.toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    TARIFF_CD.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              globals.Glb_Code = codeController.text;
              globals.Glb_Name = franchiseNameController.text;
              globals.Glb_Owner_Name = ownerNameController.text;
              globals.Glb_Mobile = mobileController.text;
              globals.Glb_Mail_Id = emailController.text;
              globals.Glb_Address = addressController.text;

              final item = selectedItems.isNotEmpty ? selectedItems[0] : null;

              // if (globals.Glb_BILL_TYPE_ID == "") {
              //   BILL_TYPE_ID_Message();
              // }
              // else
              if (globals.Glb_MKTG_Emp == "") {
                MKTG_Emp_Message();
              } else if (selectedItems.isEmpty) {
                TARRIF_ID_Message();
              } else {
                Accept_Permission();
              }
            }
          },
          style: ElevatedButton.styleFrom(
            primary: Color(0xff123456),
            onPrimary: Colors.white,
            textStyle: TextStyle(fontWeight: FontWeight.bold),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
          ),
          child: Text('Accept Request'),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
          globals.Glb_From_Date =
              DateFormat('dd-MMM-yyyy').format(_fromDate).toString();
        } else {
          _toDate = picked;
          globals.Glb_To_Date =
              DateFormat('dd-MMM-yyyy').format(_toDate).toString();
        }
      });
    }
  }

  @override
  void dispose() {
    _clientNameController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

Successtoaster() {
  return Fluttertoast.showToast(
      msg: "Client Added Successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 93, 204, 89),
      textColor: Colors.white,
      fontSize: 16.0);
}

failurestoaster() {
  return Fluttertoast.showToast(
      msg: "Some thing went wrong",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 230, 17, 45),
      textColor: Colors.white,
      fontSize: 16.0);
}

BILL_TYPE_ID_Message() {
  return Fluttertoast.showToast(
      msg: "Select Company Type",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 230, 17, 45),
      textColor: Colors.white,
      fontSize: 16.0);
}

MKTG_Emp_Message() {
  return Fluttertoast.showToast(
      msg: "Select MKTG Employee",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 230, 17, 45),
      textColor: Colors.white,
      fontSize: 16.0);
}

client_name_Message() {
  return Fluttertoast.showToast(
      msg: "Enter Client Name",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 230, 17, 45),
      textColor: Colors.white,
      fontSize: 16.0);
}

TARRIF_ID_Message() {
  return Fluttertoast.showToast(
      msg: "Select TARRIF",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Color.fromARGB(255, 230, 17, 45),
      textColor: Colors.white,
      fontSize: 16.0);
}
