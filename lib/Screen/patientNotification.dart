// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tuk_boddy/Screen/patientOfferScreen.dart';

import 'package:tuk_boddy/api_service.dart';

class PatientNotification extends StatefulWidget {
  const PatientNotification({Key? key}) : super(key: key);

  @override
  State<PatientNotification> createState() => _PatientNotificationState();
}

class _PatientNotificationState extends State<PatientNotification> {
  bool isLoading = true;
  List<dynamic> bidList = [];

  @override
  void initState() {
    _patientBidList();
    super.initState();
  }

  _patientBidList() {
    ApiService.patientBidList().then((value) {
      setState(() {
        bidList = value['data'];
        isLoading = false;
        print(bidList);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(message);
    return Scaffold(
      body: SafeArea(
        child: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(
                color: Color(0xffff86b7),
              ))
            : bidList.isEmpty
                ? const Center(
                    child: Text(
                      'No Notification',
                      style: TextStyle(color: Colors.black54,fontSize: 15),
                    ),
                  )
                : SingleChildScrollView(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: bidList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: const EdgeInsets.only(left: 8, right: 8),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.topToBottom,
                                        child: PatientOfferScreen(
                                            bidList[index]["id"],
                                            bidList[index])));
                              },
                              child: Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                      radius: 20,
                                      child: ClipOval(
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: Image.network(
                                            '${URLS.IMAGE_URL}${bidList[index]["profile_pic"]}',
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      )),
                                  title: Text(
                                      '${bidList[index]['name']} has recently bid for your profile'),
                                  subtitle: Text(
                                      'Offer \$${bidList[index]['doctor_offer']}'),
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
      ),
    );
  }
}
