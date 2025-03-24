import 'package:flutter/material.dart';
import 'Admin_Dashboard.dart';
import 'New_Login.dart';
import 'Sales_Dashboard.dart';
import 'globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class AllbottomNavigation extends StatefulWidget {
  const AllbottomNavigation({Key? key}) : super(key: key);

  @override
  State<AllbottomNavigation> createState() => _AllbottomNavigationState();
}

class _AllbottomNavigationState extends State<AllbottomNavigation> {
  String empID = "0";

  @override
  Widget build(BuildContext context) {
    return Container(
        // height: 150,
        width: MediaQuery.of(context).size.width,
        height: 48,
        color: Color(0xff123456),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(80, 5, 0, 0),
            child: InkWell(
              onTap: () {
                // Dashboarddatasetval = [];
                globals.Class_refresh = "";
                globals.reference_type_id != '28' &&
                        globals.reference_type_id != '8'
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdminDashboard(empID, 0)))
                    : Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SalesManagerDashboard()));
              },
              child: Column(children: [
                Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 18,
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  "Home",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                )
              ]),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          //   child: InkWell(
          //     onTap: () {
          //       // Navigator.push(
          //       //   context,
          //       //   MaterialPageRoute(builder: (context) => UsersProfile()),
          //       // );
          //     },
          //     child: Column(
          //       children: [
          //         Icon(
          //           Icons.person,
          //           color: Colors.white,
          //           size: 18,
          //         ),
          //         SizedBox(
          //           height: 2,
          //         ),
          //         Text(
          //           "Profile",
          //           style: TextStyle(color: Colors.white, fontSize: 12),
          //         )
          //       ],
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 80, 0),
            child: InkWell(
              onTap: () async {
                // Dashboarddatasetval = [];
                SharedPreferences prefs = await SharedPreferences.getInstance();
                globals.Login_verification = "false";
                globals.Glb_ManagerDetailsList = [];
                globals.Glb_IS_LOCK_REQ = "";
                prefs.clear();

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginClass()),
                );
              },
              child: Column(
                children: [
                  Icon(
                    Icons.logout_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "Log Out",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  )
                ],
              ),
            ),
          ),
        ]));
  }
}
