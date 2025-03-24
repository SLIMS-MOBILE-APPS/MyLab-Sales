import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'allbottomnavigationbar.dart';
import 'download_pdf_screen.dart';
import 'globals.dart' as globals;
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

List datasetval = [];
String emptyval = "";
bool isloaded = false;

class ClientProfile extends StatefulWidget {
  int selectedPage;
  ClientProfile(this.selectedPage);
  // const ClientProfile({Key? key}) : super(key: key);
  @override
  _ClientProfileState createState() => _ClientProfileState(this.selectedPage);
}

class _ClientProfileState extends State<ClientProfile> {
  int selectedPage;
  _ClientProfileState(this.selectedPage);
  String date = "";

  // _selectDate(BuildContext context) async {
  //   final DateTimeRange? selected = await showDateRangePicker(
  //     context: context,
  //     // initialDate: selectedDate,
  //     firstDate: DateTime(2010),
  //     lastDate: DateTime(2025),
  //     saveText: 'Done',
  //   );
  //   //  if (selected != null && selected != selectedDate) {
  //   setState(() {
  //     //  selectedDate = selected;
  //     //  globals.selectDate = selected as String;
  //     globals.fromDate = selected!.start.toString().split(' ')[0];
  //     globals.ToDate = selected.end.toString().split(' ')[0];

  //     //  globals.fromDate = DateFormat('dd-MMM-yyyy').format(selected!.start);

  //     // globals.ToDate = DateFormat('dd-MMM-yyyy').format(selected.end);
  //     // Navigator.push(
  //     //     context,
  //     //     MaterialPageRoute(
  //     //         builder: (context) =>
  //     //             ClientProfile(int.parse(globals.tab_index.toString()))));
  //   });
  //   // }
  // }

  _selectDate(BuildContext context) async {
    final DateTimeRange? selected = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
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
  Widget build(BuildContext context) {
    //   super.build(context);
    return DefaultTabController(
      initialIndex: selectedPage,
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff123456),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              icon: Icon(Icons.arrow_back)),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.date_range_outlined),
              onPressed: () {
                _selectDate(context);
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.verified_user), text: 'Sales'),
              Tab(icon: Icon(Icons.directions_transit), text: 'Ledger'),
              Tab(icon: Icon(Icons.money_outlined), text: 'Payments'),
              Tab(icon: Icon(Icons.money_outlined), text: 'Credits'),
              Tab(icon: Icon(Icons.money_outlined), text: 'Debits'),
            ],
            isScrollable: true,
          ),
          title: Text(globals.clientName.toString()),
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            SalesTabPage(0),
            LedgerTabPage(0),
            PaymentsTabPage(0),
            CreditNoteTransactionsTab(0),
            DebitNoteTransactionsTab(0)
          ],
        ),
        bottomNavigationBar: const AllbottomNavigation(),
      ),
    );
  }

  // @override
  // bool get wantKeepAlive => true;
}

class SalesTabPage extends StatefulWidget {
  final int selectedIndex;

  SalesTabPage(this.selectedIndex);

  @override
  _SalesTabPageState createState() => _SalesTabPageState();
}

class _SalesTabPageState extends State<SalesTabPage> {
  late int selectedIndex;
  var selecteFromdt = '';
  var selecteTodt = '';
  DateTime selectedDate = DateTime.now();
  late Future<List<SalesTransactions>> _futureSales;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;

    _futureSales = _fetchSaleTransaction();
  }

  Future<List<SalesTransactions>> _fetchSaleTransaction() async {
    var jobsListAPIUrl =
        Uri.parse(globals.API_url + '/MobileSales/UnbilledTransactionClient');
    var dsetName = 'Data';

    Map data = {
      "ReferalId": globals.selectedClientid,
      "session_id": "1",
      "From_Date": selecteFromdt,
      "To_Date": selecteTodt,
      "TYPE": "a",
      "connection": globals.Connection_Flag
    };

    var response = await http.post(jobsListAPIUrl,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      Map<String, dynamic> resposne = jsonDecode(response.body);
      List jsonResponse = resposne[dsetName];

      return jsonResponse
          .map((strans) => SalesTransactions.fromJson(strans))
          .toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }

  void _onDateIndexChanged(int index) {
    setState(() {
      globals.fromDate = '';
      globals.ToDate = '';
      selectedIndex = index;
      final DateFormat formatter = DateFormat('dd-MMM-yyyy');
      var now = DateTime.now();
      var yesterday = now.subtract(const Duration(days: 1));
      var thisweek = now.subtract(Duration(days: now.weekday - 1));
      var lastWeek1stDay =
          thisweek.subtract(Duration(days: thisweek.weekday + 6));
      var lastWeekLastDay =
          thisweek.subtract(Duration(days: thisweek.weekday - 0));
      var thismonth = DateTime(now.year, now.month, 1);
      var prevMonth1stday =
          DateTime.utc(DateTime.now().year, DateTime.now().month - 1, 1);
      var prevMonthLastday =
          DateTime.utc(DateTime.now().year, DateTime.now().month - 0)
              .subtract(Duration(days: 1));

      if (selectedIndex == 0) {
        selecteFromdt = formatter.format(now);
        selecteTodt = formatter.format(now);
      } else if (selectedIndex == 1) {
        selecteFromdt = formatter.format(yesterday);
        selecteTodt = formatter.format(yesterday);
      } else if (selectedIndex == 2) {
        selecteFromdt = formatter.format(lastWeek1stDay);
        selecteTodt = formatter.format(lastWeekLastDay);
      } else if (selectedIndex == 3) {
        selecteFromdt = formatter.format(thisweek);
        selecteTodt = formatter.format(now);
      } else if (selectedIndex == 4) {
        selecteFromdt = formatter.format(prevMonth1stday);
        selecteTodt = formatter.format(prevMonthLastday);
      } else if (selectedIndex == 5) {
        selecteFromdt = formatter.format(thismonth);
        selecteTodt = formatter.format(now);
      }

      print("From Date " + selecteFromdt);
      print("To Date " + selecteTodt);
      _futureSales = _fetchSaleTransaction();
    });
  }

  Widget _buildDatesCard(Map<String, String> data, int index) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextButton(
        child: Text(
          data["Frequency"]!,
          style: const TextStyle(fontSize: 12.0),
        ),
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            )),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            overlayColor:
                MaterialStateColor.resolveWith((states) => Colors.red),
            backgroundColor: selectedIndex == index && globals.fromDate == ''
                ? MaterialStateColor.resolveWith((states) => Colors.pink)
                : MaterialStateColor.resolveWith((states) => Colors.blueGrey),
            shadowColor:
                MaterialStateColor.resolveWith((states) => Colors.blueGrey),
            foregroundColor:
                MaterialStateColor.resolveWith((states) => Colors.white)),
        onPressed: () => _onDateIndexChanged(index),
        onLongPress: () => print('Long press'),
      ),
    );
  }

  ListView datesListView() {
    var myData = [
      {"FrequencyId": "1", "Frequency": "Today"},
      {"FrequencyId": "2", "Frequency": "Yesterday"},
      {"FrequencyId": "3", "Frequency": "Last Week"},
      {"FrequencyId": "4", "Frequency": "This Week"},
      {"FrequencyId": "5", "Frequency": "Last Month"},
      {"FrequencyId": "6", "Frequency": "This Month"},
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

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter1 = DateFormat('dd-MMM-yyyy');
    var now = DateTime.now();

    if (globals.fromDate != "") {
      selecteFromdt = globals.fromDate;
      selecteTodt = globals.ToDate;
    } else if (selecteTodt == '') {
      selecteFromdt = formatter1.format(now);
      selecteTodt = formatter1.format(now);
    }
    return Column(
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
        // Expanded(
        //   child: FutureBuilder<List<SalesTransactions>>(
        //     future: _futureSales,
        //     builder: (context, snapshot) {
        //       if (snapshot.connectionState == ConnectionState.waiting) {
        //         return Center(
        //           child: CircularProgressIndicator(),
        //         );
        //       } else if (snapshot.hasError) {
        //         return Text("${snapshot.error}");
        //       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        //         return Center(
        //           child: NoContent(),
        //         );
        //       } else {
        //         var data = snapshot.data!;
        //         return tabsListView(data, context, 'S');
        //       }
        //     },
        //   ),
        // ),
        // ElevatedButton(
        //   style: ElevatedButton.styleFrom(
        //     primary: Color(0xff123456), // Button color
        //     onPrimary: Colors.white, // Text color
        //     padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(8.0),
        //     ),
        //   ),
        //   onPressed: () {
        //     globals.fromDate = selecteFromdt;
        //     globals.ToDate = selecteTodt;
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => DownloadPDFScreen()),
        //     );
        //   },
        //   child: Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       Icon(Icons.picture_as_pdf, size: 24.0),
        //       SizedBox(width: 8.0), // Spacing between icon and text
        //       Text('Download Report'),
        //     ],
        //   ),
        // )
        Expanded(
          child: FutureBuilder<List<SalesTransactions>>(
            future: _futureSales,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: NoContent(),
                );
              } else {
                var data = snapshot.data!;
                return Column(
                  children: [
                    // Show the data list
                    Expanded(
                      child: tabsListView(data, context, 'S'),
                    ),

                    // Only show the Download Report button when data exists
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff123456), // Button color
                        onPrimary: Colors.white, // Text color
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () {
                        globals.fromDate = selecteFromdt;
                        globals.ToDate = selecteTodt;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DownloadPDFScreen()),
                        );
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.picture_as_pdf, size: 24.0),
                          SizedBox(width: 8.0), // Spacing between icon and text
                          Text('Download Report'),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
        SizedBox(height: 3)
      ],
    );
  }
}

class LedgerTabPage extends StatefulWidget {
  // const LedgerTabPage({Key? key}) : super(key: key);
  int selectedtab;
  LedgerTabPage(this.selectedtab);
  @override
  _LedgerTabPageState createState() => _LedgerTabPageState(this.selectedtab);
}

class _LedgerTabPageState extends State<LedgerTabPage> {
  int selectedIndex;
  var selecteFromdt = '';
  var selecteTodt = '';
  _LedgerTabPageState(this.selectedIndex);
  @override
  Widget build(BuildContext context) {
    globals.tab_index = this.selectedIndex.toString();
    final DateFormat formatter1 = DateFormat('dd-MMM-yyyy');
    var now = DateTime.now();

    if (globals.fromDate != "") {
      selecteFromdt = globals.fromDate;
      selecteTodt = globals.ToDate;
    } else if (selecteTodt == '') {
      selecteFromdt = formatter1.format(now);
      selecteTodt = formatter1.format(now);
    }

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
              )),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              overlayColor:
                  MaterialStateColor.resolveWith((states) => Colors.red),
              backgroundColor: selectedIndex == index && globals.fromDate == ''
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
              selectedIndex = index;

              final DateFormat formatter = DateFormat('dd-MMM-yyyy');
              var now = new DateTime.now();
              var yesterday = now.subtract(Duration(days: 1));
              //  var lastweek = now.subtract(Duration(days: 7));
              var prevMonth1stday = DateTime.utc(
                  DateTime.now().year, DateTime.now().month - 1, 1);
              var prevMonthLastday = DateTime.utc(
                DateTime.now().year,
                DateTime.now().month - 0,
              ).subtract(Duration(days: 1));
              var thisweek = now.subtract(Duration(days: now.weekday - 1));
              var lastWeek1stDay =
                  thisweek.subtract(Duration(days: thisweek.weekday + 6));
              var lastWeekLastDay =
                  thisweek.subtract(Duration(days: thisweek.weekday - 0));
              var thismonth = new DateTime(now.year, now.month, 1);

              if (selectedIndex == 0) {
                // Today
                selecteFromdt = formatter.format(now);
                selecteTodt = formatter.format(now);
              } else if (selectedIndex == 1) {
                // yesterday
                selecteFromdt = formatter.format(yesterday);
                selecteTodt = formatter.format(yesterday);
              } else if (selectedIndex == 2) {
                // LastWeek
                selecteFromdt = formatter.format(lastWeek1stDay);
                selecteTodt = formatter.format(lastWeekLastDay);
              } else if (selectedIndex == 3) {
                selecteFromdt = formatter.format(thisweek);
                selecteTodt = formatter.format(now);
              } else if (selectedIndex == 4) {
                // Last Month
                selecteFromdt = formatter.format(prevMonth1stday);
                selecteTodt = formatter.format(prevMonthLastday);
              } else if (selectedIndex == 5) {
                selecteFromdt = formatter.format(thismonth);
                selecteTodt = formatter.format(now);
              }

              print("From Date " + selecteFromdt);
              print("To Date " + selecteTodt);
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
          "FrequencyId": "1",
          "Frequency": "Today",
        },
        {
          "FrequencyId": "2",
          "Frequency": "Yesterday",
        },
        {
          "FrequencyId": "3",
          "Frequency": "Last Week",
        },
        {
          "FrequencyId": "4",
          "Frequency": "This Week",
        },
        {
          "FrequencyId": "5",
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

    Future<List<LedgerTransactions>> _fetchLedgerTransaction() async {
      var jobsListAPIUrl = null;
      var dsetName = '';

      Map data = {
        "Client_id": globals.selectedClientid,
        "session_id": "1",
        "From_Date": selecteFromdt,
        "To_Date": selecteTodt,
        "TYPE": "a",
        "connection": globals.Connection_Flag
        //"Server_Flag":""
      };

      dsetName = 'Data';
      jobsListAPIUrl =
          Uri.parse(globals.API_url + '/MobileSales/ClientLedgerDet');

      var response = await http.post(jobsListAPIUrl,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: data,
          encoding: Encoding.getByName("utf-8"));

      if (response.statusCode == 200) {
        Map<String, dynamic> resposne = jsonDecode(response.body);
        List jsonResponse = resposne[dsetName];

        return jsonResponse
            .map((ltrans) => new LedgerTransactions.fromJson(ltrans))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget verticalListLedger = FutureBuilder<List<LedgerTransactions>>(
        future: _fetchLedgerTransaction(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty == true) {
              return NoContent();
            }
            var data = snapshot.data;
            return tabsListView(data, context, 'L');
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(
            child: SizedBox(
              height: 100,
              width: 100,
              child: LoadingIndicator(
                indicatorType: Indicator.ballClipRotateMultiple,
                colors: Colors.primaries,
                strokeWidth: 4.0,
                //   pathBackgroundColor:ColorSwatch(Action[])
              ),
            ),
          );
        });

    return Column(
      children: [
        SizedBox(height: 48, child: DateSelection()),
        SizedBox(
            height: 15,
            child: Text(selecteFromdt + ' To ' + selecteTodt,
                style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0))),
        Expanded(
          child: verticalListLedger,
        ),
      ],
    );
  }
}

class PaymentsTabPage extends StatefulWidget {
  // const PaymentsTabPage({Key? key}) : super(key: key);
  int selectedtab;
  PaymentsTabPage(this.selectedtab);
  @override
  _PaymentsTabPageState createState() =>
      _PaymentsTabPageState(this.selectedtab);
}

class _PaymentsTabPageState extends State<PaymentsTabPage> {
  int selectedtab;
  _PaymentsTabPageState(this.selectedtab);

  int selectedIndex = 0;
  var selecteFromdt = '';
  var selecteTodt = '';

  @override
  Widget build(BuildContext context) {
    globals.tab_index = this.selectedIndex.toString();
    final DateFormat formatter1 = DateFormat('dd-MMM-yyyy');
    var now = new DateTime.now();

    // String thismonthfrmdate = DateTime(now.year, now.month, 1).toString();
    // String thismonthtodte = DateTime.now().toString();

    // if (globals.fromDate != "") {
    //   selecteFromdt = globals.fromDate;
    //   selecteTodt = globals.ToDate;
    // } else if (selecteTodt == '') {
    //   selecteFromdt = thismonthfrmdate.split(' ')[0]; //formatter1.format(now);

    //   selecteTodt = thismonthtodte.split(' ')[0]; // formatter1.format(now);
    // }

    if (globals.fromDate != "") {
      selecteFromdt = globals.fromDate;
      selecteTodt = globals.ToDate;
    } else if (selecteTodt == '') {
      selecteFromdt = formatter1.format(now);
      selecteTodt = formatter1.format(now);
    }

    Widget _buildDatesCard(data, index) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        // height: double.infinity,
        // width: 80,
        //color: Colors.white,
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
              overlayColor:
                  MaterialStateColor.resolveWith((states) => Colors.red),
              backgroundColor: selectedIndex == index && globals.fromDate == ''
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
              selectedIndex = index;

              final DateFormat formatter = DateFormat('dd-MMM-yyyy');
              var now = new DateTime.now();
              var yesterday = now.subtract(Duration(days: 1));
              //   var lastweek = now.subtract(Duration(days: 7));
              var prevMonth1stday = DateTime.utc(
                  DateTime.now().year, DateTime.now().month - 1, 1);
              var prevMonthLastday = DateTime.utc(
                DateTime.now().year,
                DateTime.now().month - 0,
              ).subtract(Duration(days: 1));
              var thisweek = now.subtract(Duration(days: now.weekday - 1));
              var lastWeek1stDay =
                  thisweek.subtract(Duration(days: thisweek.weekday + 6));
              var lastWeekLastDay =
                  thisweek.subtract(Duration(days: thisweek.weekday - 0));
              var thismonth = new DateTime(now.year, now.month, 1);

              if (selectedIndex == 0) {
                // Today
                selecteFromdt = formatter.format(now);
                selecteTodt = formatter.format(now);
              } else if (selectedIndex == 1) {
                // yesterday
                selecteFromdt = formatter.format(yesterday);
                selecteTodt = formatter.format(yesterday);
              } else if (selectedIndex == 2) {
                // LastWeek
                selecteFromdt = formatter.format(lastWeek1stDay);
                selecteTodt = formatter.format(lastWeekLastDay);
              } else if (selectedIndex == 3) {
                selecteFromdt = formatter.format(thisweek);
                selecteTodt = formatter.format(now);
              } else if (selectedIndex == 4) {
                // Last Month
                selecteFromdt = formatter.format(prevMonth1stday);
                selecteTodt = formatter.format(prevMonthLastday);
              } else if (selectedIndex == 5) {
                selecteFromdt = formatter.format(thismonth);
                selecteTodt = formatter.format(now);
              }

              print("From Date " + selecteFromdt);
              print("To Date " + selecteTodt);

              // _fetchSaleTransaction();
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
          "FrequencyId": "1",
          "Frequency": "Today",
        },
        {
          "FrequencyId": "2",
          "Frequency": "Yesterday",
        },
        {
          "FrequencyId": "3",
          "Frequency": "Last Week",
        },
        {
          "FrequencyId": "4",
          "Frequency": "This Week",
        },
        {
          "FrequencyId": "5",
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
            // return  Text(myData[index]["Frequency"].toString());
            return _buildDatesCard(myData[index], index);
          });
    }

    Widget DateSelection() {
      return Container(child: datesListView());
    }

    Future<List<PaymentTransactions>> _fetchPaymentTransaction() async {
      var jobsListAPIUrl = null;
      var dsetName = '';
      // Map data={};

      Map data = {
        "ReferalId": globals.selectedClientid,
        "session_id": "1",
        "From_Date": selecteFromdt,
        "To_Date": selecteTodt,
        "TYPE": "a",
        "connection": globals.Connection_Flag
        //"Server_Flag":""
      };

      dsetName = 'Data';
      jobsListAPIUrl =
          Uri.parse(globals.API_url + '/MobileSales/PaymentForReferal');
      print(data);
      var response = await http.post(jobsListAPIUrl,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: data,
          encoding: Encoding.getByName("utf-8"));

      if (response.statusCode == 200) {
        //List jsonResponse = json.decode(response.body);
        Map<String, dynamic> resposne = jsonDecode(response.body);
        List jsonResponse = resposne[dsetName];
        return jsonResponse
            .map((ptrans) => new PaymentTransactions.fromJson(ptrans))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget verticalListLedger = FutureBuilder<List<PaymentTransactions>>(
        future: _fetchPaymentTransaction(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data;
            if (snapshot.data!.isEmpty == true) {
              return NoContent();
            } else {
              return tabsListView(data, context, 'P');
            }
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(
            child: SizedBox(
              height: 100,
              width: 100,
              child: LoadingIndicator(
                indicatorType: Indicator.ballClipRotateMultiple,
                colors: Colors.primaries,
                strokeWidth: 4.0,
                //   pathBackgroundColor:ColorSwatch(Action[])
              ),
            ),
          );
        });

    return Column(
      children: [
        SizedBox(height: 48, child: DateSelection()),
        SizedBox(
            height: 15,
            child: Text(selecteFromdt + ' To ' + selecteTodt,
                style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0))),
        Expanded(child: verticalListLedger),
      ],
    );
  }
}

class CreditNoteTransactionsTab extends StatefulWidget {
  //const CreditNoteTransactionsTab({Key? key}) : super(key: key);

  int selectedtab;
  CreditNoteTransactionsTab(this.selectedtab);
  @override
  _CreditNoteTransactionsTabState createState() =>
      _CreditNoteTransactionsTabState(this.selectedtab);
}

class _CreditNoteTransactionsTabState extends State<CreditNoteTransactionsTab> {
  int selectedtab;
  _CreditNoteTransactionsTabState(this.selectedtab);

  int selectedIndex = 0;
  var selecteFromdt = '';
  var selecteTodt = '';

  @override
  Widget build(BuildContext context) {
    globals.tab_index = this.selectedIndex.toString();
    final DateFormat formatter1 = DateFormat('dd-MMM-yyyy');
    var now = new DateTime.now();

    if (globals.fromDate != "") {
      selecteFromdt = globals.fromDate;
      selecteTodt = globals.ToDate;
    } else if (selecteTodt == '') {
      selecteFromdt = formatter1.format(now);

      selecteTodt = formatter1.format(now);
    }

    Future<List<CreditNoteTransactions>> _fetchSaleTransaction() async {
      var jobsListAPIUrl = null;
      var dsetName = '';
      List listresponse = [];

      Map data = {
        "Referalid": globals.selectedClientid,
        "session_id": "1",
        "FromDate": selecteFromdt,
        "ToDate": selecteTodt,
        "TYPE": "a",
        "connection": globals.Connection_Flag
        //"Server_Flag":""
      };

      dsetName = 'Data';
      jobsListAPIUrl = Uri.parse(globals.API_url + '/MobileSales/CreditNote');
      var response = await http.post(jobsListAPIUrl,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: data,
          encoding: Encoding.getByName("utf-8"));

      if (response.statusCode == 200) {
        print('before fetch list method');
        Map<String, dynamic> jsonresponse = jsonDecode(response.body);
        print(jsonresponse.containsKey('Data'));
        listresponse = jsonresponse[dsetName];
        return listresponse
            .map((cntrnans) => new CreditNoteTransactions.fromJson(cntrnans))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget verticalListSales = FutureBuilder<List<CreditNoteTransactions>>(
        future: _fetchSaleTransaction(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data;
            if (snapshot.data!.isEmpty == true) {
              return NoContent();
            } else {
              return tabsListView(data, context, 'CN');
            }
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(
            child: SizedBox(
              height: 100,
              width: 100,
              child: LoadingIndicator(
                indicatorType: Indicator.ballClipRotateMultiple,
                colors: Colors.primaries,
                strokeWidth: 4.0,
                //   pathBackgroundColor:ColorSwatch(Action[])
              ),
            ),
          );
        });

    Widget _buildDatesCard(data, index) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        // height: double.infinity,
        // width: 80,
        //color: Colors.white,
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
              overlayColor:
                  MaterialStateColor.resolveWith((states) => Colors.red),
              backgroundColor: selectedIndex == index && globals.fromDate == ''
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
              selectedIndex = index;

              final DateFormat formatter = DateFormat('dd-MMM-yyyy');
              var now = new DateTime.now();
              var yesterday = now.subtract(Duration(days: 1));
              // var lastweek = now.subtract(Duration(days: 7));
              var prevMonth1stday = DateTime.utc(
                  DateTime.now().year, DateTime.now().month - 1, 1);
              var prevMonthLastday = DateTime.utc(
                DateTime.now().year,
                DateTime.now().month - 0,
              ).subtract(Duration(days: 1));
              var thisweek = now.subtract(Duration(days: now.weekday - 1));
              var lastWeek1stDay =
                  thisweek.subtract(Duration(days: thisweek.weekday + 6));
              var lastWeekLastDay =
                  thisweek.subtract(Duration(days: thisweek.weekday - 0));
              var thismonth = new DateTime(now.year, now.month, 1);

              if (selectedIndex == 0) {
                // Today
                selecteFromdt = formatter.format(now);
                selecteTodt = formatter.format(now);
              } else if (selectedIndex == 1) {
                // yesterday
                selecteFromdt = formatter.format(yesterday);
                selecteTodt = formatter.format(yesterday);
              } else if (selectedIndex == 2) {
                // LastWeek
                selecteFromdt = formatter.format(lastWeek1stDay);
                selecteTodt = formatter.format(lastWeekLastDay);
              } else if (selectedIndex == 3) {
                selecteFromdt = formatter.format(thisweek);
                selecteTodt = formatter.format(now);
              } else if (selectedIndex == 4) {
                // Last Month
                selecteFromdt = formatter.format(prevMonth1stday);
                selecteTodt = formatter.format(prevMonthLastday);
              } else if (selectedIndex == 5) {
                selecteFromdt = formatter.format(thismonth);
                selecteTodt = formatter.format(now);
              }

              print("From Date " + selecteFromdt);
              print("To Date " + selecteTodt);
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
          "FrequencyId": "1",
          "Frequency": "Today",
        },
        {
          "FrequencyId": "2",
          "Frequency": "Yesterday",
        },
        {
          "FrequencyId": "3",
          "Frequency": "Last Week",
        },
        {
          "FrequencyId": "4",
          "Frequency": "This Week",
        },
        {
          "FrequencyId": "5",
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
            // return  Text(myData[index]["Frequency"].toString());
            return _buildDatesCard(myData[index], index);
          });
    }

    Widget DateSelection() {
      return Container(child: datesListView());
    }

    return Column(
      children: [
        SizedBox(height: 48, child: DateSelection()),
        SizedBox(
            height: 15,
            child: Text(selecteFromdt + ' To ' + selecteTodt,
                style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0))),
        Expanded(
          child: verticalListSales,
        ),
      ],
    );
  }
}

class DebitNoteTransactionsTab extends StatefulWidget {
  //const DebitNoteTransactionsTab({Key? key}) : super(key: key);
  int selectedtab;
  DebitNoteTransactionsTab(this.selectedtab);
  @override
  _DebitNoteTransactionsTabState createState() =>
      _DebitNoteTransactionsTabState(this.selectedtab);
}

class _DebitNoteTransactionsTabState extends State<DebitNoteTransactionsTab> {
  int selectedtab;
  _DebitNoteTransactionsTabState(this.selectedtab);

  int selectedIndex = 0;
  var selecteFromdt = '';
  var selecteTodt = '';

  @override
  Widget build(BuildContext context) {
    globals.tab_index = this.selectedIndex.toString();
    final DateFormat formatter1 = DateFormat('dd-MMM-yyyy');
    var now = new DateTime.now();

    if (globals.fromDate != "") {
      selecteFromdt = globals.fromDate;
      selecteTodt = globals.ToDate;
    } else if (selecteTodt == '') {
      selecteFromdt = formatter1.format(now);

      selecteTodt = formatter1.format(now);
    }

    Future<List<DebitNoteTransactions>> _fetchSaleTransaction() async {
      var jobsListAPIUrl = null;
      var dsetName = '';
      List listresponse = [];

      Map data = {
        "Referalid": globals.selectedClientid,
        "session_id": "1",
        "FromDate": selecteFromdt,
        "ToDate": selecteTodt,
        "TYPE": "a",
        "connection": globals.Connection_Flag
        //"Server_Flag":""
      };

      dsetName = 'Data';
      jobsListAPIUrl = Uri.parse(globals.API_url + '/MobileSales/DebitNote');
      var response = await http.post(jobsListAPIUrl,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: data,
          encoding: Encoding.getByName("utf-8"));

      if (response.statusCode == 200) {
        print('before fetch list method');
        Map<String, dynamic> jsonresponse = jsonDecode(response.body);

        List responseData = jsonresponse['Data'];
        // Map JSON data to ManagerDetails objects
        Map<String, dynamic> user = jsonresponse['Data'][0];
        globals.Glb_IS_REPORT_OPEN_WEB = user['IS_REPORT_OPEN_WEB'].toString();

        print(jsonresponse.containsKey('Data'));
        listresponse = jsonresponse[dsetName];
        return listresponse
            .map((dbttrans) => new DebitNoteTransactions.fromJson(dbttrans))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget verticalListSales = FutureBuilder<List<DebitNoteTransactions>>(
        future: _fetchSaleTransaction(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data;
            if (snapshot.data!.isEmpty == true) {
              return NoContent();
            } else {
              return tabsListView(data, context, 'DN');
            }
          } else if (snapshot.hasError) {
            return NoContent();
          }
          return Center(
            child: SizedBox(
              height: 100,
              width: 100,
              child: LoadingIndicator(
                indicatorType: Indicator.ballClipRotateMultiple,
                colors: Colors.primaries,
                strokeWidth: 4.0,
                //   pathBackgroundColor:ColorSwatch(Action[])
              ),
            ),
          );
        });

    Widget _buildDatesCard(data, index) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        // height: double.infinity,
        // width: 80,
        //color: Colors.white,
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
              backgroundColor: selectedIndex == index && globals.fromDate == ''
                  ? MaterialStateColor.resolveWith((states) => Colors.pink)
                  : MaterialStateColor.resolveWith((states) => Colors.blueGrey),
              shadowColor:
                  MaterialStateColor.resolveWith((states) => Colors.blueGrey),
              foregroundColor:
                  MaterialStateColor.resolveWith((states) => Colors.white)),
          onPressed: () {
            print(index.toString());
            setState(() {
              globals.selectDate = '';
              selectedIndex = index;

              final DateFormat formatter = DateFormat('dd-MMM-yyyy');
              var now = new DateTime.now();
              var yesterday = now.subtract(Duration(days: 1));
              //  var lastweek = now.subtract(Duration(days: 7));
              var prevMonth1stday = DateTime.utc(
                  DateTime.now().year, DateTime.now().month - 1, 1);
              var prevMonthLastday = DateTime.utc(
                DateTime.now().year,
                DateTime.now().month - 0,
              ).subtract(Duration(days: 1));
              var thisweek = now.subtract(Duration(days: now.weekday - 1));
              var lastWeek1stDay =
                  thisweek.subtract(Duration(days: thisweek.weekday + 6));
              var lastWeekLastDay =
                  thisweek.subtract(Duration(days: thisweek.weekday - 0));
              var thismonth = new DateTime(now.year, now.month, 1);

              if (selectedIndex == 0) {
                // Today
                selecteFromdt = formatter.format(now);
                selecteTodt = formatter.format(now);
              } else if (selectedIndex == 1) {
                // yesterday
                selecteFromdt = formatter.format(yesterday);
                selecteTodt = formatter.format(yesterday);
              } else if (selectedIndex == 2) {
                // LastWeek
                selecteFromdt = formatter.format(lastWeek1stDay);
                selecteTodt = formatter.format(lastWeekLastDay);
              } else if (selectedIndex == 3) {
                selecteFromdt = formatter.format(thisweek);
                selecteTodt = formatter.format(now);
              } else if (selectedIndex == 4) {
                // Last Month
                selecteFromdt = formatter.format(prevMonth1stday);
                selecteTodt = formatter.format(prevMonthLastday);
              } else if (selectedIndex == 5) {
                selecteFromdt = formatter.format(thismonth);
                selecteTodt = formatter.format(now);
              }

              print("From Date " + selecteFromdt);
              print("To Date " + selecteTodt);

              _fetchSaleTransaction();
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
          "FrequencyId": "1",
          "Frequency": "Today",
        },
        {
          "FrequencyId": "2",
          "Frequency": "Yesterday",
        },
        {
          "FrequencyId": "3",
          "Frequency": "Last Week",
        },
        {
          "FrequencyId": "4",
          "Frequency": "This Week",
        },
        {
          "FrequencyId": "5",
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
            // return  Text(myData[index]["Frequency"].toString());
            return _buildDatesCard(myData[index], index);
          });
    }

    Widget DateSelection() {
      return Container(child: datesListView());
    }

    return Column(
      children: [
        SizedBox(height: 48, child: DateSelection()),
        SizedBox(
            height: 15,
            child: Text(selecteFromdt + ' To ' + selecteTodt,
                style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0))),
        Expanded(
          child: verticalListSales,
        ),
      ],
    );
  }
}

class SalesTransactions {
  final String umrno;
  final String billno;
  final String pname;
  final String billdt;
  final String billamt;
  final String cmpdueamt;
  final String billingloc;
  final age;
  final gender;
  final DMS_PATH;
  final IMAGES;

  SalesTransactions({
    required this.umrno,
    required this.billno,
    required this.pname,
    required this.billdt,
    required this.billamt,
    required this.cmpdueamt,
    required this.billingloc,
    required this.age,
    required this.gender,
    required this.DMS_PATH,
    required this.IMAGES,
  });

  factory SalesTransactions.fromJson(Map<String, dynamic> json) {
    print('Sales Transaction');
    print(json);
    return SalesTransactions(
        umrno: json['UMR_NO'].toString(),
        billno: json['BILL_NO'].toString(),
        pname: json['PATIENT_NAME'].toString(),
        billdt: json['BILL_DT'].toString(),
        billamt: json['BILL_AMOUNT'].toString(),
        billingloc: json['FB_LOC_NAME'].toString(),
        cmpdueamt: json['CMP_DUE_AMT'].toString(),
        age: json['AGE'].toString(),
        gender: json['GENDER'].toString(),
        DMS_PATH: json['DMS_PATH'].toString(),
        IMAGES: json['IMAGES'].toString());
  }
}

class PaymentTransactions {
  final String clientcd;
  final String clientname;
  final String paymentdt;
  final String paymentamt;
  final String ptype;
  final String pmode;

  PaymentTransactions({
    required this.clientcd,
    required this.clientname,
    required this.paymentdt,
    required this.paymentamt,
    required this.ptype,
    required this.pmode,
  });

  factory PaymentTransactions.fromJson(Map<String, dynamic> json) {
    return PaymentTransactions(
      clientcd: json['REFRL_CD'].toString(),
      clientname: json['REFERAL_NAME'].toString(),
      paymentdt: json['CREATE_DT'].toString(),
      paymentamt: json['AMOUNT'].toString(),
      ptype: json['TYPE'].toString(),
      pmode: json['PAYMENT_MODE_ID'].toString(),
    );
  }
}

class LedgerTransactions {
  final String tranno;
  final String trandt;
  final String creditamt;
  final String debitamt;
  final String ttype;
  final String remarks;
  final String closingbal;

  LedgerTransactions({
    required this.tranno,
    required this.trandt,
    required this.creditamt,
    required this.debitamt,
    required this.ttype,
    required this.remarks,
    required this.closingbal,
  });

  factory LedgerTransactions.fromJson(Map<String, dynamic> json) {
    return LedgerTransactions(
        tranno: json['TRANSACTION_NO'].toString(),
        trandt: json['TRANSACTION_DATE'].toString(),
        creditamt: json['CREDIT_AMOUNT'].toString(),
        debitamt: json['DEBIT_AMOUNT'].toString(),
        ttype: json['TYPE'].toString(),
        remarks: json['REMARKS'].toString(),
        closingbal: json['CLOSING_BALANCE'].toString());
  }
}

class CreditNoteTransactions {
  final String clientcd;
  final String clientname;
  final String ttype;
  final String pmode;
  final String tdate;
  final String tamt;

  CreditNoteTransactions(
      {required this.clientcd,
      required this.clientname,
      required this.ttype,
      required this.pmode,
      required this.tdate,
      required this.tamt});

  factory CreditNoteTransactions.fromJson(Map<String, dynamic> json) {
    print('Sales Transaction');
    print(json);
    return CreditNoteTransactions(
      clientcd: json['REFRL_CD'].toString(),
      clientname: json['REFERAL_NAME'].toString(),
      ttype: json['TYPE'].toString(),
      pmode: json['PAYMENT_MODE_ID'].toString(),
      tdate: json['CREATE_DT'].toString(),
      tamt: json['AMOUNT'].toString(),
    );
  }
}

class DebitNoteTransactions {
  final String clientcd;
  final String clientname;
  final String ttype;
  final String pmode;
  final String tdate;
  final String tamt;

  DebitNoteTransactions(
      {required this.clientcd,
      required this.clientname,
      required this.ttype,
      required this.pmode,
      required this.tdate,
      required this.tamt});

  factory DebitNoteTransactions.fromJson(Map<String, dynamic> json) {
    print('Sales Transaction');
    print(json);
    return DebitNoteTransactions(
      clientcd: json['REFRL_CD'].toString(),
      clientname: json['REFERAL_NAME'].toString(),
      ttype: json['TYPE'].toString(),
      pmode: json['PAYMENT_MODE_ID'].toString(),
      tdate: json['CREATE_DT'].toString(),
      tamt: json['AMOUNT'].toString(),
    );
  }
}

class NoContent extends StatelessWidget {
  const NoContent();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
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

Widget tabsListView(data, BuildContext context, String tabType) {
  int i = 0;
  return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _buildSalesCard(data[index], context, tabType, '');
      });
}

Widget _buildSalesCard(
    data, BuildContext context, String flg, String trantype) {
  // datasetval = data;
  var inoutflg = '';
  var subheading = '';
  var subtitle = '';
  var tranamt = '';
  var supportingText = 'Advance amount 5000 collected for rolling advance';
  var head = '';
  if (flg == 'S') {
    supportingText = 'Bill No ' +
        data.billno +
        ', patient ' +
        data.pname +
        ' of Amount ' +
        data.billamt +
        ' has been added.';
    head = data.pname;
    subheading = '\u{20B9}' + data.billamt;
    subtitle = data.billno + " | " + data.billdt;
  } else if (flg == 'P') {
    head = '';
    subtitle =
        'Advance amount ' + data.paymentamt + ' collected for rolling advance.';
    head = data.clientname;
    subheading = '\u{20B9}' + data.paymentamt;
    subtitle = data.pmode + " | " + data.paymentdt;
  } else if (flg == 'CN') {
    head = '';
    supportingText = 'Credit Note of ' + data.tamt + ' Added.';
    subtitle = 'Credit Note of ' + data.tamt + ' Added.';
    head = data.clientname;
    subheading = '\u{20B9}' + data.tamt;
    subtitle = data.pmode + " | " + data.tdate;
    inoutflg = 'I';
  } else if (flg == 'DN') {
    head = '';
    inoutflg = 'O';
    supportingText = 'Debit Note of ' + data.tamt + ' Added.';
    subtitle = ' Note of ' + data.tamt + ' Added.';
    head = data.clientname;
    subheading = '\u{20B9}' + data.tamt;
    subtitle = data.pmode + " | " + data.tdate;
  } else if (flg == 'L') {
    trantype = data.ttype;
    head = data.ttype;
    tranamt = data.debitamt.toString();
    if (trantype == 'Opening Balance') {
      tranamt = '\u{20B9}' + data.debitamt.toString();
    } else if (trantype == 'Sales') {
      tranamt = '\u{20B9}' + data.debitamt.toString();
      inoutflg = 'I';
    } else if (trantype == 'Credit Payments') {
      head = 'Payment';
      tranamt = '\u{20B9}' + data.creditamt.toString();
      inoutflg = 'O';
    } else if (trantype == 'Credit Note') {
      //  head = '\u{20B9}' + data.creditamt;
      tranamt = '\u{20B9}' + data.creditamt.toString();
      inoutflg = 'I';
    } else if (trantype == 'Debit Note') {
      //  head = 'Debit';
      tranamt = '\u{20B9}' + data.debitamt.toString();
      inoutflg = 'O';
    }
    subtitle = data.tranno + " | " + data.trandt;
    supportingText = data.remarks;
    subheading = '\u{20B9}' + data.closingbal;
  }

  return GestureDetector(
      onTap: () {
        globals.selectedPatientData = data;
        (flg == "S") ? _showPicker1(context, data.billno.toString()) : Card();
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ListTile(
            leading: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Container(
                height: 26,
                width: 26,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 31, 96, 161),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    (flg == 'P')
                        ? Icons.trending_down
                        : (flg == 'S')
                            ? Icons.person
                            : Icons.trending_up_sharp,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
            title: Text(head,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                )),
            subtitle: Text(subtitle,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey)),
            trailing: Column(
              children: [
                Text(subheading,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 211, 77, 68))),
                globals.Glb_Client_Need_Location_Wise_Business == "Accepted"
                    ? data.IMAGES != "null"
                        ? SizedBox(
                            width: 50,
                            height: 30,
                            child: IconButton(
                              icon: Icon(Icons
                                  .download_for_offline_rounded), // Use any icon, e.g., Icons.image for an image icon
                              color: Colors.blue, // Set the color of the icon
                              onPressed: () {
                                List<String> imageUrls = data.IMAGES
                                    .split(',')
                                    .map((imageName) => imageName
                                        .trim()) // Remove extra whitespace, if any
                                    .toList()
                                    .cast<String>();

                                showDialog(
                                  context: context,
                                  builder: (context) => ImagePopupDialog(
                                    dmsPath: data
                                        .DMS_PATH, // Pass DMS path separately
                                    imageUrls:
                                        imageUrls, // Pass the list of image URLs
                                  ),
                                );
                              },
                              tooltip:
                                  'View Image', // Tooltip shown on long-press
                            ),
                          )
                        : SizedBox(
                            width: 50,
                            height: 30,
                          )
                    : SizedBox(
                        width: 50,
                        height: 30,
                      )
              ],
            ),
          ),
        ),
      ));
}

Widget _buildClientHeaderSales(BuildContext context) {
  return GestureDetector(
    onTap: () {
      // print( globals.selectedClientData);
    },
    child: Container(
      //width: 175,
      child: Card(
        elevation: 5.0,
        margin: EdgeInsets.all(2.5),
        child: Column(
          children: [
            SizedBox(
              height: 90,
              child: ListTile(
                //minVerticalPadding:5,
                // leading: (index%2==0) ? const Icon(Icons.lock_open, color: Colors.green) : const Icon(Icons.lock, color: Colors.red) ,
                // trailing: Icon(Icons.arrow_forward,color: Colors.green,),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //  SizedBox(width: 10),
                    Text(
                      globals.selectedClientData.clientname,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(width: 100),
                    // (globals.selectedClientData.locked == 'Y')
                    //     ? const Icon(
                    //         Icons.lock_rounded,
                    //         color: Colors.red,
                    //         size: 20,
                    //       )
                    //     : const Icon(Icons.lock_open_rounded,
                    //         size: 18, color: Colors.green),
                  ],
                ),

                subtitle:
                    //  SizedBox(
                    //   // height: 80,
                    //   // width: 5,
                    //   child:
                    Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          icon: Icon(Icons.verified_rounded,
                              size: 13, color: Colors.green),
                          label: Text(
                            globals.selectedClientData.business.toString(),
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.green),
                          ),
                          onPressed: () {},
                        ),
                        TextButton.icon(
                          icon: Icon(
                            Icons.camera,
                            size: 12,
                            color: Colors.blue,
                          ),
                          label: Text(
                            globals.selectedClientData.deposits.toString(),
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue),
                          ),
                          onPressed: () {},
                        ),
                        TextButton.icon(
                          icon: Icon(Icons.camera, size: 12, color: Colors.red),
                          label: Text(
                            globals.selectedClientData.balance.toString(),
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.red),
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Last Payment on',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                        Text(
                          globals.selectedClientData.lastpaiddt.toString(),
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                        Text(
                          'Paid Amt ',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                        Text(
                          globals.selectedClientData.lastpaidamt.toString(),
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      ],
                    )
                  ],
                  //),
                ),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/*-------------------------------------popupservices------------------------------------*/

var Bill_noval = "";

class SelectionPickerBottom extends StatefulWidget {
  SelectionPickerBottom(billno) {
    Bill_noval = "";
    Bill_noval = billno.toString();
  }

//Bill_noval=billno.toString();
  @override
  _SelectionPickerBottomState createState() => _SelectionPickerBottomState();
}

class _SelectionPickerBottomState extends State<SelectionPickerBottom> {
  @override
  Widget build(BuildContext context) {
    Future<List<patientDetails>> _fetchSaleTransaction() async {
      var jobsListAPIUrl = null;
      var dsetName = '';

      Map data = {"bill_id": Bill_noval, "connection": globals.Connection_Flag};
      dsetName = 'Data';
      jobsListAPIUrl = Uri.parse(globals.API_url + '/MobileSales/BillServices');
      var response = await http.post(jobsListAPIUrl,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: data,
          encoding: Encoding.getByName("utf-8"));

      if (response.statusCode == 200) {
        Map<String, dynamic> resposne = jsonDecode(response.body);
        List jsonResponse = resposne[dsetName];

        return jsonResponse
            .map((strans) => new patientDetails.fromJson(strans))
            .toList();
      } else {
        throw Exception('Failed to load jobs from API');
      }
    }

    Widget verticalListSalesBusiness = Container(
      height: MediaQuery.of(context).size.height * 0.5,
      margin: EdgeInsets.symmetric(vertical: 2.0),
      child: FutureBuilder<List<patientDetails>>(
          future: _fetchSaleTransaction(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data;
              if (snapshot.data!.isEmpty == true) {
                return NoContent();
              } else {
                return popupListView(data);
              }
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(
              child: SizedBox(
                height: 100,
                width: 100,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballClipRotateMultiple,
                  colors: Colors.primaries,
                  strokeWidth: 4.0,
                  //   pathBackgroundColor:ColorSwatch(Action[])
                ),
              ),
            );
          }),
    );

    return WillPopScope(
      onWillPop: () async {
        // Returning false prevents the back button action.
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 141, 143, 145),
          automaticallyImplyLeading:
              false, // This removes the default back button
          title: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 4, 15, 4),
              child: Row(
                children: [
                  Text(
                    'Test Details',
                    style: TextStyle(
                        color: Color.fromARGB(255, 28, 28, 29),
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
              child: Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(
                        width: 0.8, color: Color.fromARGB(255, 219, 215, 215))),
                child: Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 3),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Colors.grey)),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: Container(
                                              height: 26,
                                              width: 26,
                                              decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 31, 96, 161),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.person,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                              ))),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 3),
                                        child: Text(
                                            globals.selectedPatientData.pname
                                                .toString(),
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 29, 83, 138),
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12.0)),
                                      ),
                                      Spacer(),
                                      Text(
                                          globals.selectedPatientData.age
                                                  .split(',')[0]
                                                  .toString() +
                                              '/' +
                                              globals.selectedPatientData.gender
                                                  .toString(),
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 221, 102, 83),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12.0)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: verticalListSalesBusiness,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: const AllbottomNavigation(),
      ),
    );
  }
}

Widget popupListView(data) {
  int i = 0;
  return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _buildBusinessCard(data[index], context, index);
      });
}

Widget _buildBusinessCard(data, BuildContext context, index) {
  bool _printWithHeader = false;
  bool _printWithoutHeader = false;
  return Padding(
      padding: const EdgeInsets.fromLTRB(12, 2, 10, 2),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 8),
                      child: Container(
                        width: 170,
                        child: Text(data.srvname,
                            style: TextStyle(
                                color: Color.fromARGB(255, 22, 63, 99),
                                fontWeight: FontWeight.w700,
                                fontSize: 12.0)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0, bottom: 4),
                      child: Text(data.billNo,
                          style: TextStyle(
                              color: Color.fromARGB(255, 22, 63, 99),
                              fontWeight: FontWeight.w500,
                              fontSize: 11.0)),
                    ),
                    Text(data.BILL_DT,
                        style: TextStyle(
                            color: Color.fromARGB(255, 22, 63, 99),
                            fontWeight: FontWeight.w700,
                            fontSize: 11.0)),
                  ],
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Column(
                    children: [
                      (data.srvstats1 == "Approved" ||
                              data.srvstats1 == "Dispatch")
                          ? SizedBox(
                              height: 30,
                              width: 95,
                              child: InkWell(
                                onTap: () {
                                  data.IS_REPORT_OPEN_WEB == "Y"
                                      ? showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return StatefulBuilder(
                                              builder: (context, setState) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0),
                                                  ),
                                                  title: Text(
                                                    'Select Option',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.blueAccent,
                                                    ),
                                                  ),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      CheckboxListTile(
                                                        activeColor:
                                                            Colors.blueAccent,
                                                        title: Text(
                                                          'Print with Header',
                                                          style: TextStyle(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        value: _printWithHeader,
                                                        onChanged:
                                                            (bool? value) {
                                                          setState(() {
                                                            _printWithHeader =
                                                                value!;
                                                            if (_printWithHeader) {
                                                              _printWithoutHeader =
                                                                  false;
                                                            }
                                                          });
                                                        },
                                                      ),
                                                      CheckboxListTile(
                                                        activeColor:
                                                            Colors.blueAccent,
                                                        title: Text(
                                                          'Print without Header',
                                                          style: TextStyle(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        value:
                                                            _printWithoutHeader,
                                                        onChanged:
                                                            (bool? value) {
                                                          setState(() {
                                                            _printWithoutHeader =
                                                                value!;
                                                            if (_printWithoutHeader) {
                                                              _printWithHeader =
                                                                  false;
                                                            }
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text(
                                                        'Cancel',
                                                        style: TextStyle(
                                                          color:
                                                              Colors.redAccent,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text(
                                                        'OK',
                                                        style: TextStyle(
                                                          color:
                                                              Colors.blueAccent,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        data.IS_REPORT_OPEN_WEB ==
                                                            "Y";

                                                        if (_printWithoutHeader) {
                                                          _launchURLwithoutHeader(
                                                              data.reportCd
                                                                  .toString());
                                                        } else if (_printWithHeader) {
                                                          PDFController
                                                              .fetchDataAndLaunchPDF(
                                                            context,
                                                            data.billNo
                                                                .toString(),
                                                            data.IS_REPORT_OPEN_WEB
                                                                .toString(),
                                                            data.reportCd
                                                                .toString(),
                                                          );
                                                        }
                                                        // Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        )
                                      : PDFController.fetchDataAndLaunchPDF(
                                          context,
                                          data.billNo.toString(),
                                          data.IS_REPORT_OPEN_WEB.toString(),
                                          data.reportCd.toString());
                                },
                                child: Card(
                                    color: Color.fromARGB(255, 112, 194, 113),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Center(
                                          child: Text(
                                        "Completed",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500),
                                      )),
                                    )),
                              ),
                            )
                          : SizedBox(
                              height: 30,
                              width: 95,
                              child: Card(
                                  color: Color.fromARGB(255, 231, 107, 102),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Center(
                                        child: Text(
                                      "In Progress",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500),
                                    )),
                                  )),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
}

void _showPicker1(BuildContext context, billno) {
  var res = showModalBottomSheet(
    context: context,
    builder: (_) => Container(
      //  width: ,
      height: MediaQuery.of(context).size.height * 0.6,
      //  color: Color(0xff123456),
      child: SelectionPickerBottom(billno.toString()),
    ),
  );
  print(res);
}

class patientDetails {
  final srvname;
  final srvstats1;
  final billNo;
  final displyName;
  final mobNo1;
  final age;
  final gendr;
  final reportCd;
  final BILL_DT;
  final IS_REPORT_OPEN_WEB;

  patientDetails({
    required this.srvname,
    required this.srvstats1,
    required this.billNo,
    required this.displyName,
    required this.mobNo1,
    required this.age,
    required this.gendr,
    required this.reportCd,
    required this.BILL_DT,
    required this.IS_REPORT_OPEN_WEB,
  });

  factory patientDetails.fromJson(Map<String, dynamic> json) {
    return patientDetails(
      srvname: json['SERVICE_NAME'].toString(),
      srvstats1: json['SERVICE_STATUS1'].toString(),
      billNo: json['BILL_NO'].toString(),
      displyName: json['DISPLAY_NAME'].toString(),
      mobNo1: json['MOBILE_NO1'].toString(),
      age: json['AGE'].toString(),
      gendr: json['GENDER'].toString(),
      reportCd: json['REPORT_CD'].toString(),
      BILL_DT: json['BILL_DT'].toString(),
      IS_REPORT_OPEN_WEB: json['IS_REPORT_OPEN_WEB'].toString(),
    );
  }
}

/*---------------------------------------------popupservices---------------------------------*/

/*--------------------------------------------url Launcher----------------------------------------*/

_launchURL(rportcde) async {
  var url = globals.Glb_WITHHEAD_URL + rportcde + "";
  //  http://103.145.36.189/his_testing/PUBLIC/HIMSREPORTVIEWER.ASPX?UNIUQ_ID=
  if (await launch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_launchURLwithoutHeader(rportcde) async {
  var url = globals.Glb_WITHOUTHEAD_URL + rportcde + "";
  //  http://103.145.36.189/his_testing/PUBLIC/HIMSREPORTVIEWER.ASPX?UNIUQ_ID=
  if (await launch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
/*--------------------------------------------url Launcher----------------------------------------*/

class PDFController {
  // Function to fetch data from API and launch PDF viewer
  static Future<void> fetchDataAndLaunchPDF(BuildContext context,
      String billNumber, String IS_REPORT_OPEN_WEB, String reportCd) async {
    String apiUrl = globals.Report_URL + '$billNumber';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Connecting...'),
        // duration: Duration(seconds: 2),
      ),
    );
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          // Add any necessary headers here
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        String base64Data = responseData['base64'];

        if (base64Data.isNotEmpty) {
          final tempDir = await getTemporaryDirectory();
          final file = File('${tempDir.path}/temp.pdf');

          await file.writeAsBytes(base64.decode(base64Data));

          if (file.existsSync()) {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();

            launchPDFViewer(context, file, base64Data);
          } else if (IS_REPORT_OPEN_WEB == "Y") {
            _launchURL(reportCd);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please wait for five minutes')),
            );
          }
        } else if (IS_REPORT_OPEN_WEB == "Y") {
          _launchURL(reportCd);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please wait for five minutes')),
          );
        }
      } else {
        throw Exception('Failed to load data from API');
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch data and launch PDF')),
      );
    }
  }

  // Function to launch PDF viewer
  static void launchPDFViewer(
      BuildContext context, File file, String base64Download) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PDFViewer(pdfFile: file, base64Download: base64Download),
      ),
    );
  }
}

class PDFViewer extends StatelessWidget {
  final File? pdfFile;
  final String? base64Download;

  const PDFViewer({required this.pdfFile, this.base64Download});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 0, 169, 132),
          title: Text('Reports'),
          actions: [
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                if (pdfFile != null) {
                  shareFile(context, pdfFile!);
                }
              },
            ),
          ],
        ),
        body: pdfFile != null
            ? PDFView(
                filePath: pdfFile!.path,
                onError: (error) {
                  print(error);
                },
              )
            : Container() //NoDataFoundWidget(tabName: ""),
        );
  }

  void shareFile(BuildContext context, File file) {
    Share.shareFiles([file.path],
        text: 'Sharing PDF file', subject: 'PDF File');
  }

  Future<void> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      await Permission.storage.request();
    }
  }
}

class ImagePopupDialog extends StatelessWidget {
  final String dmsPath;
  final List<String> imageUrls;

  ImagePopupDialog({required this.dmsPath, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: imageUrls.map((imageName) {
            String fullUrl = "$dmsPath/$imageName";
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(fullUrl),
            );
          }).toList(),
        ),
      ),
    );
  }
}
