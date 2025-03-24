import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'globals.dart' as globals;

class DownloadPDFScreen extends StatefulWidget {
  @override
  _DownloadPDFScreenState createState() => _DownloadPDFScreenState();
}

class _DownloadPDFScreenState extends State<DownloadPDFScreen> {
  bool downloading = false;
  late int selectedIndex;
  String progress = '0';
  String? filePath;
  List<SalesTransactions> salesManagers = [];
  var selecteFromdt = '';
  var selecteTodt = '';
  @override
  void initState() {
    super.initState();
    // selectedIndex = widget.selectedIndex;
    final DateFormat formatter1 = DateFormat('dd-MMM-yyyy');
    var now = DateTime.now();

    if (globals.fromDate != "") {
      selecteFromdt = globals.fromDate;
      selecteTodt = globals.ToDate;
    } else {
      selecteFromdt = formatter1.format(now);
      selecteTodt = formatter1.format(now);
    }
    _fetchSalespersons(); // Start the download process immediately
  }

  Future<void> _fetchSalespersons() async {
    setState(() {
      downloading = true;
    });

    Map data = {
      "ReferalId": globals.selectedClientid,
      "session_id": "1",
      "From_Date": globals.fromDate,
      "To_Date": globals.ToDate,
      "TYPE": "a",
      "connection": globals.Connection_Flag
    };
    final jobsListAPIUrl =
        Uri.parse(globals.API_url + '/MobileSales/UnbilledTransactionClient');
    var response = await http.post(jobsListAPIUrl,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: data,
        encoding: Encoding.getByName("utf-8"));

    if (response.statusCode == 200) {
      print(response.body); // Add this line to debug the response
      Map<String, dynamic> responseJson = jsonDecode(response.body);
      List jsonResponse = responseJson["Data"];

      salesManagers = jsonResponse
          .map((managers) => SalesTransactions.fromJson(managers))
          .toList();

      setState(() {
        downloading = false;
      });

      await downloadPDF();
    } else {
      setState(() {
        downloading = false;
      });
      throw Exception('Failed to load jobs from API');
    }
  }

  Future<void> downloadPDF() async {
    final pdf = pw.Document();
    final double fontSize = 10;
    final double headerFontSize = 12;
    final double rowHeight = 20;
    final double pageHeight = PdfPageFormat.a4.availableHeight;
    final double headerHeight = rowHeight;
    final double footerHeight = rowHeight;
    final double contentHeight = pageHeight - headerHeight - footerHeight;

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) {
          return [
            pw.Column(
              children: [
                pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 1,
                      child: pw.Text(
                        'UMR No',
                        style: pw.TextStyle(
                            fontSize: headerFontSize,
                            fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Text(
                        'Patient Name',
                        style: pw.TextStyle(
                            fontSize: headerFontSize,
                            fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Text(
                        'Bill No.',
                        style: pw.TextStyle(
                            fontSize: headerFontSize,
                            fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Text(
                        'Bill Date',
                        style: pw.TextStyle(
                            fontSize: headerFontSize,
                            fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Text(
                        'Test Rate',
                        style: pw.TextStyle(
                            fontSize: headerFontSize,
                            fontWeight: pw.FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                pw.Divider(),
                ...salesManagers.map((manager) {
                  return pw.Row(
                    children: [
                      pw.Expanded(
                        flex: 1,
                        child: pw.Text(manager.umrno,
                            style: pw.TextStyle(fontSize: fontSize)),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Text(manager.pname,
                            style: pw.TextStyle(fontSize: fontSize)),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Text(manager.billno,
                            style: pw.TextStyle(fontSize: fontSize)),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Text(manager.billdt,
                            style: pw.TextStyle(fontSize: fontSize)),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Text(manager.billamt,
                            style: pw.TextStyle(fontSize: fontSize)),
                      ),
                    ],
                  );
                }).toList(),
              ],
            ),
          ];
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/sales_managers.pdf");
    await file.writeAsBytes(await pdf.save());

    setState(() {
      filePath = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff123456), // Button color,
        title: Text('Download PDF Example'),
      ),
      body: Center(
        child: downloading
            ? CircularProgressIndicator()
            : filePath != null
                ? PdfPreview(
                    build: (format) => File(filePath!).readAsBytesSync(),
                    pdfFileName: 'sales_managers.pdf',
                  )
                : Text('PDF generated successfully!'),
      ),
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
        gender: json['GENDER'].toString());
  }
}
