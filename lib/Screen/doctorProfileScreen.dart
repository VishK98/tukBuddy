// ignore_for_file: file_names, avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuk_boddy/Screen/loginScreen.dart';
import 'package:tuk_boddy/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorProfileScreen extends StatefulWidget {
  const DoctorProfileScreen({Key? key}) : super(key: key);

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  List<dynamic> doctorData = [];
  List<dynamic> doctorPost = [];

  bool isLoading = true;
  bool isOptedforsale = false;
  bool isDistanceUnderMiles = false;
  bool isCityState = false;
  bool isOpenedUpDates = false;

  String userName = '';
  String userID = '';
  @override
  void initState() {
    _getUserInfo();
    _doctorDetails();
    _doctorPost();

    _getPermission();
    super.initState();
  }

  _getPermission() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("isPermission") == null) {
      prefs.setBool("isPermission", true);
      await ImagePicker().getImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
      );
    }
  }

  _logout() {
    ApiService.fetchData(context);
    ApiService.logOut().then((value) {
      print('PatientDetails ==> $value');
      Navigator.of(context).pop();

      _logoutUser();
    });
  }

  _logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    prefs.setBool("isPermission", true);
    prefs.setBool("isCameraPermission", true);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
        (Route<dynamic> route) => false);
  }

  _getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name')!;
      userID = prefs.getString('user_id')!;
      print('Name==>$userName');
      // print('ID==>$userID');
    });
  }

  bool isLoggedIn = false;

  _doctorDetails() {
    ApiService.doctorDetails().then((value) {
      // print('PatientDetails ==> $value');
      setState(() {
        doctorData = value['data'];
        // print('PatientDetails ==> $patientDetails');
        isLoading = false;
      });
    });
  }

  _doctorPost() {
    ApiService.doctorPost().then((value) {
      print('DoctorPost ==> $value');
      setState(() {
        doctorPost = value['data'];
        // print('PatientDetails ==> $patientDetails');
        isLoading = false;
      });
    });
  }

  _imageFull(image) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.black,
                elevation: 0,
                actions: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close))
                ]),
            body: Center(
              child: ClipRect(
                child: PhotoView(
                  imageProvider: NetworkImage('${URLS.IMAGE_URL}$image'),
                  minScale: PhotoViewComputedScale.contained * 1,
                  maxScale: PhotoViewComputedScale.covered * 2,
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // print('HERE==> ${widget.doctorID}');
    return Scaffold(
      body: SafeArea(
        child: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(
                color: Color(0xffff86b7),
              ))
            : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: doctorData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .270,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Image.asset(
                              'assets/images/background1.jpg',
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(width: 20),
                                    Text(
                                      '${doctorData[index]['UserInfo'][0]['name']}',
                                      style: const TextStyle(
                                          fontSize: 20,
                                          color: Colors.black54,
                                          fontStyle: FontStyle.italic),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.more_vert_rounded,
                                    size: 26,
                                    color: Color(0xff212121),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        barrierColor: Colors.transparent,
                                        context: context,
                                        builder: (ctx) => SimpleDialog(
                                              insetPadding:
                                                  const EdgeInsets.only(
                                                      left: 160,
                                                      right: 35,
                                                      bottom: 450),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                              ),
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                    left: 20,
                                                  ),
                                                  height: 200,
                                                  child: Column(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);

                                                          setState(() {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder: (ctx) {
                                                                  return AlertDialog(content: StatefulBuilder(builder: (BuildContext
                                                                          context,
                                                                      StateSetter
                                                                          setState) {
                                                                    return Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                              borderRadius: BorderRadius.circular(50)),
                                                                      height:
                                                                          290,
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceAround,
                                                                        children: [
                                                                          Container(
                                                                            margin:
                                                                                const EdgeInsets.only(left: 10),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                const Text(
                                                                                  "Notification Setting",
                                                                                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, color: const Color((0xff212121))),
                                                                                ),
                                                                                GestureDetector(
                                                                                  child: const Icon(
                                                                                    Icons.cancel,
                                                                                    color: Color(0xff4f4f4f),
                                                                                    size: 30,
                                                                                  ),
                                                                                  onTap: () {
                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                20,
                                                                          ),
                                                                          Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                const Text("Opted for sale", style: TextStyle(color: const Color(0xff544D4D), fontSize: 14, fontWeight: FontWeight.w500)),
                                                                                Switch(
                                                                                  value: isOptedforsale,
                                                                                  onChanged: (value) {
                                                                                    setState(
                                                                                      () {
                                                                                        isOptedforsale = value;
                                                                                      },
                                                                                    );
                                                                                  },
                                                                                  activeColor: Color(0xffff86b7),
                                                                                  activeTrackColor: Color(0xffff86b7),
                                                                                  inactiveThumbColor: Color(0xff4f4f4f),
                                                                                  inactiveTrackColor: Color(0xff4f4f4f),
                                                                                )
                                                                              ]),
                                                                          Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Text("Distance under miles", style: TextStyle(color: const Color(0xff544D4D), fontSize: 14, fontWeight: FontWeight.w500)),
                                                                                Switch(
                                                                                  value: isDistanceUnderMiles,
                                                                                  onChanged: (value) {
                                                                                    // state = value;
                                                                                    setState(
                                                                                      () {
                                                                                        isDistanceUnderMiles = value;
                                                                                        // soundupdatehdata();
                                                                                      },
                                                                                    );
                                                                                  },
                                                                                  activeColor: Color(0xffff86b7),
                                                                                  activeTrackColor: Color(0xffff86b7),
                                                                                  inactiveThumbColor: Color(0xff4f4f4f),
                                                                                  inactiveTrackColor: Color(0xff4f4f4f),
                                                                                ),
                                                                              ]),
                                                                          Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                const Text("State, City", style: TextStyle(color: const Color(0xff544D4D), fontSize: 14, fontWeight: FontWeight.w500)),
                                                                                Switch(
                                                                                  value: isCityState,
                                                                                  onChanged: (value) {
                                                                                    // state = value;
                                                                                    setState(
                                                                                      () {
                                                                                        isCityState = value;
                                                                                        // soundupdatehdata();
                                                                                      },
                                                                                    );
                                                                                  },
                                                                                  activeColor: Color(0xffff86b7),
                                                                                  activeTrackColor: Color(0xffff86b7),
                                                                                  inactiveThumbColor: Color(0xff4f4f4f),
                                                                                  inactiveTrackColor: Color(0xff4f4f4f),
                                                                                ),
                                                                              ]),
                                                                          Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                const Text("Opened Up Dates", style: TextStyle(color: const Color(0xff544D4D), fontSize: 14, fontWeight: FontWeight.w500)),
                                                                                Switch(
                                                                                  value: isOpenedUpDates,
                                                                                  // value: isNotification,
                                                                                  onChanged: (value) {
                                                                                    // state = value;

                                                                                    setState(
                                                                                      () {
                                                                                        // if (isNotification) {
                                                                                        isOpenedUpDates = value;
                                                                                        // } else {
                                                                                        //   isNotification = true;
                                                                                        // }

                                                                                        // soundupdatehdata();
                                                                                      },
                                                                                    );
                                                                                  },
                                                                                  activeColor: Color(0xffff86b7),
                                                                                  activeTrackColor: Color(0xffff86b7),
                                                                                  inactiveThumbColor: Color(0xff4f4f4f),
                                                                                  inactiveTrackColor: Color(0xff4f4f4f),
                                                                                ),
                                                                              ]),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  }));
                                                                });
                                                          });
                                                        },
                                                        child: Row(
                                                          children: const [
                                                            Icon(
                                                                Icons.settings),
                                                            SizedBox(
                                                              width: 20,
                                                            ),
                                                            Text(
                                                              'Setting',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 18,
                                                                  color: Color(
                                                                      (0xff212121))),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          Navigator.pop(
                                                              context);
                                                          showDialog(
                                                              context: context,
                                                              builder: (ctx) =>
                                                                  AlertDialog(
                                                                    content:
                                                                        Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        const Text(
                                                                          'Sure you want to \nlog out?                                  ',
                                                                        ),
                                                                        IconButton(
                                                                          icon:
                                                                              const Icon(
                                                                            Icons.close,
                                                                            size:
                                                                                25,
                                                                            color:
                                                                                Color(0xff212121),
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                        )
                                                                      ],
                                                                    ),
                                                                    actions: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceAround,
                                                                        children: [
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              alignment: Alignment.center,
                                                                              height: MediaQuery.of(context).size.height * 0.065,
                                                                              width: MediaQuery.of(context).size.width * 0.300,
                                                                              decoration: const BoxDecoration(color: Color(0xff4f4f4f), borderRadius: BorderRadius.all((Radius.circular(10)))),
                                                                              child: const Text(
                                                                                "Cancel",
                                                                                style: TextStyle(color: Color(0xffff86b7)),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          InkWell(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.pop(context);
                                                                              _logout();
                                                                            },
                                                                            child:
                                                                                Container(
                                                                              alignment: Alignment.center,
                                                                              height: MediaQuery.of(context).size.height * 0.065,
                                                                              width: MediaQuery.of(context).size.width * 0.300,
                                                                              decoration: const BoxDecoration(color: Color(0xff4f4f4f), borderRadius: BorderRadius.all((Radius.circular(10)))),
                                                                              child: const Text(
                                                                                "Log out",
                                                                                style: TextStyle(color: Color(0xffff86b7)),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            10,
                                                                      )
                                                                    ],
                                                                  ));
                                                        },
                                                        child: Row(
                                                          children: const [
                                                            Icon(Icons
                                                                .logout_outlined),
                                                            SizedBox(
                                                              width: 20,
                                                            ),
                                                            Text(
                                                              'Logout',
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: 18,
                                                                  color: Color(
                                                                      (0xff212121))),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ));
                                  },
                                ),
                              ],
                            ),
                            Positioned(
                              bottom: 0,
                              child: InkWell(
                                onTap: () {
                                  _imageFull(doctorData[index]['UserInfo'][0]
                                      ['profile_pic']);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: CircleAvatar(
                                      radius: 60,
                                      child: ClipOval(
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: Image.network(
                                            '${URLS.IMAGE_URL}${doctorData[index]['UserInfo'][0]['profile_pic']}',
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .730,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Card(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      const Text(
                                        'Basic Information',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black54,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      const Divider(),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .300,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text('Name of practice'),
                                                Text('Country'),
                                                Text('State'),
                                                Text('Consultation fee'),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  ':  ${doctorData[index]['DoctorInfo'][0]['name_of_practice']}'),
                                              Text(
                                                  ':  ${doctorData[index]['DoctorInfo'][0]['country']}'),
                                              Text(
                                                  ':  ${doctorData[index]['DoctorInfo'][0]['state']}'),
                                              Text(
                                                  ':  ${doctorData[index]['DoctorInfo'][0]['consultation_fee']}'),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Card(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Column(
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      const Text(
                                        'Office Location Details   ',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black54,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      const Divider(),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .300,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text('Address'),
                                                Text('Country'),
                                                Text('State'),
                                                Text('City'),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .600,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                FittedBox(
                                                  child: AutoSizeText(
                                                    ':  ${doctorData[index]['OfficeLocation'][0]['address']}',
                                                    maxLines: 2,
                                                  ),
                                                ),
                                                Text(
                                                    ':  ${doctorData[index]['OfficeLocation'][0]['country']}'),
                                                Text(
                                                    ':  ${doctorData[index]['OfficeLocation'][0]['state']}'),
                                                Text(
                                                    ':  ${doctorData[index]['OfficeLocation'][0]['city']}'),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Card(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      const Text(
                                        'Degree Information',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black54,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      const Divider(),
                                      Row(
                                        children: [
                                          SizedBox(
                                            // color: Colors.amber,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .350,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text('Degree name'),
                                                Text('Completation year'),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  ':  ${doctorData[index]['Degree'][0]['degree_name']}'),
                                              Text(
                                                  ':  ${doctorData[index]['Degree'][0]['year_completed']}'),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Card(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      const Text(
                                        'Office Timing Details',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black54,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      const Divider(),
                                      for (var i = 0;
                                          i <
                                              doctorData[index]['OfficeTimings']
                                                  .length;
                                          i++) ...[
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .350,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      '${doctorData[index]['OfficeTimings'][i]['open_days']}'),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    ':  ${doctorData[index]['OfficeTimings'][i]['open_timings']}'),
                                              ],
                                            )
                                          ],
                                        )
                                      ]
                                    ],
                                  ),
                                )),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Card(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      const Text(
                                        'Social media Information',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black54,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      const Divider(),
                                      Row(
                                        children: [
                                          SizedBox(
                                            // color: Colors.amber,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .350,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text('Instagram'),
                                                Text('Tik Tok'),
                                                Text('Facebook'),
                                                Text('Snapchat'),
                                                Text('Twitter'),
                                                Text('Pintrest'),
                                                Text('Other profile'),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  ':  ${doctorData[index]['SsocialInfo'][0]['insta_profile']}'),
                                              Text(
                                                  ':  ${doctorData[index]['SsocialInfo'][0]['tiktok_profile']}'),
                                              Text(
                                                  ':  ${doctorData[index]['SsocialInfo'][0]['facebook_profile']}'),
                                              Text(
                                                  ':  ${doctorData[index]['SsocialInfo'][0]['snapchat_profile']}'),
                                              Text(
                                                  ':  ${doctorData[index]['SsocialInfo'][0]['twitter_profile']}'),
                                              Text(
                                                  ':  ${doctorData[index]['SsocialInfo'][0]['pinterest_profile']}'),
                                              Text(
                                                  ':  ${doctorData[index]['SsocialInfo'][0]['other_profile']}'),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                              ),
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Column(
                                    children: [
                                      const Divider(),
                                      const Text(
                                        'Facility Images',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black54,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      SizedBox(
                                        height: 200,
                                        child: GridView.builder(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          gridDelegate:
                                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                                  maxCrossAxisExtent: 200,
                                                  mainAxisExtent: 185),
                                          itemCount: jsonDecode(
                                                  doctorData[index]
                                                          ['SsocialInfo'][0]
                                                      ['facility_pic'])
                                              .length,
                                          itemBuilder:
                                              (BuildContext context, index1) {
                                            var decodedResponse = jsonDecode(
                                                doctorData[index]['SsocialInfo']
                                                    [0]['facility_pic']);
                                            return InkWell(
                                              onTap: () {
                                                // print('Clicked $index1');
                                                _imageFull(
                                                    decodedResponse[index1]);
                                              },
                                              child: Card(
                                                child: AspectRatio(
                                                  aspectRatio: 1,
                                                  child: Image.network(
                                                    '${URLS.IMAGE_URL}${decodedResponse[index1]}',
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  )),
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Column(
                                    children: [
                                      const Divider(),
                                      const Text(
                                        'Before Images',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black54,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      SizedBox(
                                        height: 200,
                                        child: GridView.builder(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          gridDelegate:
                                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                                  maxCrossAxisExtent: 200,
                                                  mainAxisExtent: 185),
                                          itemCount: jsonDecode(
                                                  doctorData[index]
                                                          ['SsocialInfo'][0]
                                                      ['before_img'])
                                              .length,
                                          itemBuilder:
                                              (BuildContext context, index1) {
                                            var decodedResponse = jsonDecode(
                                                doctorData[index]['SsocialInfo']
                                                    [0]['before_img']);
                                            return InkWell(
                                              onTap: () {
                                                // print('Clicked $index1');
                                                _imageFull(
                                                    decodedResponse[index1]);
                                              },
                                              child: Card(
                                                child: AspectRatio(
                                                  aspectRatio: 1,
                                                  child: Image.network(
                                                    '${URLS.IMAGE_URL}${decodedResponse[index1]}',
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  )),
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Column(
                                    children: [
                                      const Divider(),
                                      const Text(
                                        'After Images',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black54,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      SizedBox(
                                        height: 200,
                                        child: GridView.builder(
                                          scrollDirection: Axis.horizontal,
                                          shrinkWrap: true,
                                          gridDelegate:
                                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                                  maxCrossAxisExtent: 200,
                                                  mainAxisExtent: 185),
                                          itemCount: jsonDecode(
                                                  doctorData[index]
                                                          ['SsocialInfo'][0]
                                                      ['after_img'])
                                              .length,
                                          itemBuilder:
                                              (BuildContext context, index1) {
                                            var decodedResponse = jsonDecode(
                                                doctorData[index]['SsocialInfo']
                                                    [0]['after_img']);
                                            return InkWell(
                                              onTap: () {
                                                // print('Clicked $index1');
                                                _imageFull(
                                                    decodedResponse[index1]);
                                              },
                                              child: Card(
                                                child: AspectRatio(
                                                  aspectRatio: 1,
                                                  child: Image.network(
                                                    '${URLS.IMAGE_URL}${decodedResponse[index1]}',
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  )),
                              const SizedBox(
                                height: 100,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                }),
      ),
    );
  }
}
