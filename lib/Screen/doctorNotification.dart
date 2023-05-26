// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tuk_boddy/Screen/doctorBidOffer.dart';
import 'package:tuk_boddy/Screen/patientDetails.dart';
import 'package:tuk_boddy/api_service.dart';

class DoctorNotification extends StatefulWidget {
  const DoctorNotification({Key? key}) : super(key: key);

  @override
  State<DoctorNotification> createState() => _DoctorNotificationState();
}

class _DoctorNotificationState extends State<DoctorNotification> {
  List<dynamic> doctorBidlist = [];
  List<dynamic> notifications = [];
  List<dynamic> Allnotifications = [];
  bool patientProfile = true;
  bool isLoading = true;
  @override
  void initState() {
    _doctorBidList();
    super.initState();
  }

  _doctorBidList() {
    ApiService.doctorBidList().then((value) {
      setState(() {
        doctorBidlist = value['data'];
      });
      for (var i = 0; i < value["data"].length; i++) {
        setState(() {
          Allnotifications.add({
            'notification_type': 'bidList',
            'name': value['data'][i]['name'],
            'description': 'This user has been bid on your profile',
            'user_id': value['data'][i]['patient_user_id']
          });
        });
      }
      _notification();
    });
  }

  _notification() {
    ApiService.getNotification().then((value) {
      setState(() {
        notifications = value['data'];
        isLoading = false;
      });
      for (var i = 0; i < value["data"].length; i++) {
        setState(() {
          Allnotifications.add({
            'notification_type': 'wishlisted',
            'name': value['data'][i]['title'],
            'description': value['data'][i]['description'],
            'user_id': value['data'][i]['user_from_id']
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xffff86b7),
                ),
              )
            : Container(
                child: Allnotifications.isEmpty && !isLoading
                    ? const Center(
                        child: Text(
                          'No Notification',
                          style: TextStyle(color: Colors.black54, fontSize: 15),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: Allnotifications.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      // print(
                                      //     Allnotifications[index]["notification_type"]);
                                      if (Allnotifications[index]
                                              ['notification_type'] ==
                                          'bidList') {
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                type: PageTransitionType
                                                    .topToBottom,
                                                child: DoctorBidOffer(
                                                    doctorBidlist[index]
                                                        ["patient_user_id"],
                                                    doctorBidlist[index])));
                                      } else if ((Allnotifications[index]
                                              ['notification_type'] ==
                                          'wishlisted')) {
                                        // print('wishlisted');
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                type: PageTransitionType
                                                    .topToBottom,
                                                child: PatientDetails(
                                                  Allnotifications[index]
                                                      ['user_id'],
                                                  patientProfile,
                                                )));
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Card(
                                        child: Column(
                                          children: [
                                            ListTile(
                                              title: Text(
                                                  Allnotifications[index]
                                                      ['name']),
                                              subtitle: Text(
                                                  Allnotifications[index]
                                                      ['description']),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ],
                        ),
                      ),
              ),
      ),
    );
  }
}
