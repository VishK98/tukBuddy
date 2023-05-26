// ignore_for_file: prefer_const_constructors, unnecessary_new, avoid_print, library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuk_boddy/Screen/doctorHomeScreen.dart';
import 'package:tuk_boddy/Screen/doctorNotification.dart';
import 'package:tuk_boddy/Screen/doctorOpinionPool.dart';
import 'package:tuk_boddy/Screen/doctorProfileScreen.dart';

class DoctorBottomNav extends StatefulWidget {
  const DoctorBottomNav(this.pageIndex, {Key? key}) : super(key: key);
  final int pageIndex;

  @override
  _DoctorBottomNavState createState() => _DoctorBottomNavState();
}

class _DoctorBottomNavState extends State<DoctorBottomNav> {
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
        return DoctorHomeScreen();
      case 1:
        return DoctorNotification();
      case 2:
        return DoctorOpinoinPool();
      case 3:
        return DoctorProfileScreen();
    }
  }

  Future<bool> _willPopCallback() async {
    if (_selectedIndex != 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => DoctorBottomNav(0)));
    } else {
      SystemNavigator.pop();
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: _willPopCallback,
        child: Scaffold(
          body: _onItemTapped(_selectedIndex),
          bottomNavigationBar: Container(
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16), topLeft: Radius.circular(15)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
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
                    icon: Icon(Icons.poll_outlined),
                    label: 'Opinion Pool',
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
