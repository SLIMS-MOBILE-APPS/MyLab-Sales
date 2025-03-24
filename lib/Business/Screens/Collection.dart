import 'package:flutter/material.dart';

import '../Controllers/CollectionControlers.dart';
import '../Controllers/LocationControllers.dart';
import '../Models/CollectionModels.dart';
import '../Models/LocatioDropdownModels.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  // Variables to store selected date and location
  DateTime selectedDate = DateTime.now();
  int selectedDateIndex = 0; // Track the selected index
  late int? _selectedLocationId;

  List<LocationDropdownOption> _locationDropdownOptions = [];

  CollectionData? _collectionData; // To store fetched revenue data
  List<TransactionData>? _transactionData;
  // List<ChannelDepartmentData>? _departmentData;

  @override
  void initState() {
    super.initState();
    _fetchLocationDropdownOptions();
    _selectedLocationId = null;
    _fetchCollectionData(); // Fetch revenue data initially
  }

  // Function to handle date selection
  void _selectDate(DateTime date, int index) {
    setState(() {
      // Adjust the selected date based on the index
      if (index == 0) {
        selectedDate = DateTime.now(); // Today
      } else if (index == 1) {
        // Yesterday
        selectedDate = DateTime.now().subtract(Duration(days: 1));
      } else if (index == 2) {
        // Day Before Yesterday
        selectedDate = DateTime.now().subtract(Duration(days: 2));
      } else if (index == 3) {
        // Month to Date (considering the first day of the month)
        selectedDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
      } else {
        // Year to Date (considering the first day of the year)
        selectedDate = DateTime(DateTime.now().year, 1, 1);
      }

      selectedDateIndex = index; // Update the selected index
    });

    _fetchCollectionData(); // Fetch revenue data after date selection
  }

  // Function to return text for each date option
  String _getDateOptionText(int index) {
    switch (index) {
      case 0:
        return 'Today';
      case 1:
        return 'Yesterday';
      case 2:
        return 'Day Before Yesterday';
      case 3:
        return 'Month to Date';
      default:
        return 'Year to Date';
    }
  }

  Future<void> _fetchLocationDropdownOptions() async {
    try {
      List<LocationDropdownOption> locations =
          await DropdownController.fetchLocationDropdownOptions();
      setState(() {
        _locationDropdownOptions = locations;
      });
    } catch (e) {
      // Handle error
      print('Error fetching location dropdown options: $e');
    }
  }

  // Function to fetch revenue data with selected date and location
  Future<void> _fetchCollectionData() async {
    try {
      DateTime fromDate; // Define fromDate variable
      DateTime toDate; // Define toDate variable

      // Adjust fromDate and toDate based on selectedDateIndex
      if (selectedDateIndex == 3) {
        // If "Month to Date" is selected, set fromDate to the start of the current month
        fromDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
        // Set toDate to today's date
        toDate = DateTime.now();
      } else if (selectedDateIndex == 4) {
        // If "Year to Date" is selected, set fromDate to the start of the current year
        fromDate = DateTime(DateTime.now().year, 1, 1);
        // Set toDate to today's date
        toDate = DateTime.now();
      } else {
        // Otherwise, set fromDate and toDate to selectedDate
        fromDate = selectedDate;
        toDate = selectedDate;
      }

      // Make the API call to fetch revenue data
      if (_selectedLocationId == null) {
        // If no location is selected, fetch revenue data with the fromDate and toDate
        CollectionData collectionData =
            await CollectionDataController.fetchCollectionData(
                fromDate, toDate, null, "");
        setState(() {
          _collectionData = collectionData;
        });
      } else {
        // If a location is selected, fetch revenue data with the fromDate, toDate, and selected location
        CollectionData collectionData =
            await CollectionDataController.fetchCollectionData(
                fromDate, toDate, _selectedLocationId, "N");
        setState(() {
          _collectionData = collectionData;
        });
      }
    } catch (e) {
      // Handle error
      print('Error fetching revenue data: $e');
    }
  }

  // Modify _fetchChannelData and _fetchDepartmentData methods
  Future<void> _fetchTransactionData() async {
    try {
      DateTime fromDate;
      DateTime toDate;

      // Set fromDate and toDate based on selectedDateIndex...
      if (selectedDateIndex == 3) {
        fromDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
        toDate = DateTime.now();
      } else if (selectedDateIndex == 4) {
        fromDate = DateTime(DateTime.now().year, 1, 1);
        toDate = DateTime.now();
      } else {
        fromDate = selectedDate;
        toDate = selectedDate;
      }

      final transactionData =
          await CollectionDataController.fetchTransactionData(
              fromDate, toDate, _selectedLocationId, "T");
      setState(() {
        _transactionData = transactionData;
      });
    } catch (e) {
      print('Error fetching channel data: $e');
    }
  }

  // Future<void> _fetchDepartmentData() async {
  //   try {
  //     DateTime fromDate;
  //     DateTime toDate;

  //     // Set fromDate and toDate based on selectedDateIndex...
  //     if (selectedDateIndex == 3) {
  //       fromDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  //       toDate = DateTime.now();
  //     } else if (selectedDateIndex == 4) {
  //       fromDate = DateTime(DateTime.now().year, 1, 1);
  //       toDate = DateTime.now();
  //     } else {
  //       fromDate = selectedDate;
  //       toDate = selectedDate;
  //     }

  //     final departmentData =
  //         await RevenueDataController.fetchChannelDepartmentWiseData(
  //             fromDate, toDate, _selectedLocationId, "S");
  //     setState(() {
  //       _departmentData = departmentData;
  //     });
  //   } catch (e) {
  //     print('Error fetching department data: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return
        // Revenue Tab Content
        SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // Date Selection
      Container(
        height: 55,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
              child: SizedBox(
                width: 120,
                child: Card(
                  color: selectedDateIndex == index ? Colors.pink : Colors.grey,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.white, width: 0.3)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: ListTile(
                      title: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            _getDateOptionText(index),
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      onTap: () {
                        _selectDate(DateTime.now(), index);
                        // _fetchRevenueData(); // Fetch revenue data after date selection
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(12, 15, 12, 0),
        child: Center(
          child: DropdownButtonFormField<String>(
            value: _selectedLocationId?.toString(),
            onChanged: (locationID) {
              setState(() {
                _selectedLocationId =
                    locationID != null ? int.parse(locationID) : null;
              });
              _fetchCollectionData(); // Fetch revenue data after location selection
            },
            items: _locationDropdownOptions.map((state) {
              return DropdownMenuItem<String>(
                value: state.LOC_ID.toString(),
                child: Text(state.LOCATION_NAME,
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
              );
            }).toList(),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 188, 187, 187),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 149, 149, 149),
                ),
              ),
              hintText: 'Select Location',
              hintStyle:
                  const TextStyle(color: Color.fromARGB(255, 194, 193, 193)),
              prefixIcon: const Icon(
                Icons.south_america_outlined,
                color: Color.fromARGB(255, 30, 66, 138),
              ),
            ),
            dropdownColor: Colors.white,
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            isExpanded: true,
            elevation: 4,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),

      Padding(
        padding: const EdgeInsets.fromLTRB(10, 16, 10, 4),
        child: Row(
          children: [
            Expanded(
              child: Card(
                color: Color.fromARGB(255, 204, 222, 237),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ListTile(
                    title: Center(
                        child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text('Gross Amount',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    )),
                    subtitle: Center(
                        child: (_collectionData != null)
                            ? Text('${_collectionData!.gross}',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600))
                            : Text('0',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600))),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                color: Color.fromARGB(255, 204, 222, 237),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ListTile(
                    title: Center(
                        child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text('Net Amount',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    )),
                    subtitle: Center(
                        child: (_collectionData != null)
                            ? Text('${_collectionData!.net}',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600))
                            : Text('0',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600))),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
        child: Row(
          children: [
            Expanded(
              child: Card(
                color: Color.fromARGB(255, 204, 222, 237),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ListTile(
                    title: Center(
                        child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text('Concession Amount',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    )),
                    subtitle: Center(
                        child: (_collectionData != null)
                            ? Text('${_collectionData!.concessionAmount}',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600))
                            : Text('0',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600))),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Card(
                color: Color.fromARGB(255, 204, 222, 237),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: ListTile(
                    title: Center(
                        child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text('Cancel Amount',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    )),
                    subtitle: Center(
                        child: (_collectionData != null)
                            ? Text('${_collectionData!.cancelAmount}',
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w600))
                            : Text('0',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600))),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: const BorderSide(
                      color: Color.fromARGB(255, 211, 211, 211))),
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  gradient: const LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Color.fromARGB(255, 255, 255, 255),
                      Color.fromARGB(255, 232, 231, 231),
                    ],
                  ),
                ),
                child: ExpansionTile(
                  title: Text(
                    'Transactions',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 18, 56, 122)),
                  ),
                  onExpansionChanged: (isExpanded) {
                    if (isExpanded) {
                      _fetchTransactionData(); // Call function when expanding
                    }
                  },
                  children: _transactionData != null
                      ? _transactionData!.map((data) {
                          return ListTile(
                            title: Text(
                              data.LOCATION_NAME ?? '',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              'Amount: ${data.AMOUNT}',
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500),
                            ),
                          );
                        }).toList()
                      : [
                          if (_transactionData == null)
                            ListTile(
                              title: Center(
                                child:
                                    CircularProgressIndicator(), // Loading indicator
                              ),
                            )
                          else
                            Text('No channel wise data')
                        ],
                ),
              ))),
    ]));
  }
}
