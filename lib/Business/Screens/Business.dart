import 'package:flutter/material.dart';

import 'Collection.dart';
import 'Revenue.dart'; // Import revenue data model

class BusinessNew extends StatefulWidget {
  const BusinessNew({Key? key}) : super(key: key);

  @override
  State<BusinessNew> createState() => _BusinessNewState();
}

class _BusinessNewState extends State<BusinessNew> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff123456),
          title: Text("Business"),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Revenue'),
              Tab(text: 'Collection'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Revenue Tab Content
            RevenuePage(),

            // Collection Tab Content
            CollectionPage(),
          ],
        ),
      ),
    );
  }
}
