import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:tuk_boddy/Screen/PatientProfile.dart';
import 'package:tuk_boddy/Screen/doctorHomeScreen.dart';
import 'package:tuk_boddy/Screen/doctorNavBar.dart';
import 'package:tuk_boddy/Screen/doctorProfileScreen.dart';
import 'package:tuk_boddy/Screen/patientHomeScreen.dart';
import 'package:tuk_boddy/Screen/patientNotification.dart';

class PatientBottomNav extends StatefulWidget {
  const PatientBottomNav(this.pageIndex, {Key? key}) : super(key: key);
  final int pageIndex;

  @override
  State<PatientBottomNav> createState() => _PatientBottomNavState();
}

class _PatientBottomNavState extends State<PatientBottomNav> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.pageIndex;
  }

  List<dynamic> dataItem = [];
  bool userDetails = true;

  _onItemTapped(int index) {
    _selectedIndex = index;
    // print(_selectedIndex);
    setState(() {});
    switch (_selectedIndex) {
      case 0:
        return const PatientHomeScreen();

      case 1:
        return const PatientNotification();

      case 2:
        return const PatientProfileScreen();
    }
  }

  Future<bool> _willPopCallback() async {
    if (_selectedIndex != 0) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => PatientBottomNav(0)));
    } else {
      SystemNavigator.pop();
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _willPopCallback,
        child: Scaffold(
          // appBar: AppBar(
          //   automaticallyImplyLeading: false,
          //   toolbarHeight: 60,
          //   //elevation: 1,
          //   backgroundColor: Color(0xff4f4f4f),
          //   title: Row(
          //     children: [
          //       SizedBox(
          //         width: 80,
          //         child: Image.asset(
          //           'assets/images/tukBuddy.png',
          //           fit: BoxFit.fill,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          body: _onItemTapped(_selectedIndex),
          bottomNavigationBar: Container(
            height: 70,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16), topLeft: Radius.circular(15)),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              child: BottomNavigationBar(
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                currentIndex: _selectedIndex,
                selectedItemColor: Color(0xffff86b7),
                unselectedItemColor: Colors.white,
                selectedFontSize: 10,
                backgroundColor: Color(0xff4f4f4f),
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.notifications),
                    label: 'Notification',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_box_outlined),
                    label: 'Profile',
                  ),
                ],
                onTap: _onItemTapped,
              ),
            ),
          ),
        ));
  }
}
