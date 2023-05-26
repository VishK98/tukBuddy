// ignore_for_file: file_names, avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuk_boddy/Screen/loginScreen.dart';

import 'package:tuk_boddy/api_service.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({Key? key}) : super(key: key);

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  List<dynamic> patientData = [];
  bool isLoading = true;
  bool isOptedforsale = false;
  bool isDistanceUnderMiles = false;
  bool isSelectYourSurgeon = false;
  bool isCityState = false;
  bool isOpenedUpDates = false;
  String dateOfBirth = '';

  final amountController = TextEditingController();

  @override
  void initState() {
    _patientProfile();
    super.initState();
  }

  showTimeAgo(dynamic timedata) {
    setState(() {
      dateOfBirth = DateFormat("dd-MM-yyyy").format(timedata);
    });
    print(dateOfBirth);
  }

  _patientProfile() {
    ApiService.patientProfile().then((value) {
      setState(() {
        patientData = value['data'];
        for (var i = 0; i < patientData.length; i++) {
          showTimeAgo(
              DateTime.tryParse(patientData[i]['PatientInfo'][0]['d_o_b']));
        }
        isLoading = false;
      });
    });
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
              child: PhotoView(
                imageProvider: NetworkImage('${URLS.IMAGE_URL}$image'),
              ),
            ),
          );
        });
  }

  Widget userInput(
    TextEditingController userInput,
    String hintTitle,
    TextInputType keyboardType, {
    required Null Function(dynamic value) onChanged,
    required String? Function(dynamic value) validator,
  }) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          color: Colors.blueGrey.shade200,
          borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: TextFormField(
          onChanged: onChanged,
          validator: validator,
          controller: userInput,
          autocorrect: false,
          enableSuggestions: false,
          autofocus: false,
          decoration: InputDecoration.collapsed(
            hintText: hintTitle,
            hintStyle: const TextStyle(
                fontSize: 15,
                color: Colors.white70,
                fontStyle: FontStyle.italic),
          ),
          keyboardType: keyboardType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(
                color: Color(0xffff86b7),
              ))
            : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                //scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: patientData.length,
                itemBuilder: (BuildContext context, int index) {
                  DateFormat.jm()
                      .format(DateFormat("hh:mm:ss").parse("22:30:00"));
                  print(patientData.length);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                      '${patientData[index]['UserInfo'][0]['name']}',
                                      style: const TextStyle(
                                        fontSize: 17,
                                        color: Colors.black54,
                                      ),
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
                                                                                const Text("Select Your Surgeon(Doctor)", style: TextStyle(color: const Color(0xff544D4D), fontSize: 14, fontWeight: FontWeight.w500)),
                                                                                Switch(
                                                                                  value: isSelectYourSurgeon,
                                                                                  onChanged: (value) {
                                                                                    // state = value;

                                                                                    setState(
                                                                                      () {
                                                                                        // if (isNotification) {
                                                                                        isSelectYourSurgeon = value;
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
                                          '${URLS.IMAGE_URL}${patientData[index]['UserInfo'][0]['profile_pic']}',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .730,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
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
                                          const Icon(
                                            Icons.home_work_outlined,
                                            color: Color(0xffff86b7),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                              '${patientData[index]['PatientInfo'][0]['address']}'),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.cake_outlined,
                                            color: Color(0xffff86b7),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            dateOfBirth,
                                            // '${patientData[index]['PatientInfo'][0]['d_o_b']}'
                                            // DateFormat('yyyy-MMMM-dd').format(
                                            //     patientData[index]
                                            //             ['PatientInfo'][0]
                                            //         ['d_o_b'])
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.people_alt_outlined,
                                            color: Color(0xffff86b7),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                              '${patientData[index]['PatientInfo'][0]['gender']}'),
                                        ],
                                      ),
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
                                        'Health Information',
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
                                                .350,
                                            // color: Colors.amber,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Text('Height :'),
                                                Text('Weight :'),
                                                Text('Body mass index :'),
                                                Text('Medical history  :'),
                                                Text('Medications  :'),
                                                Text('Number of child  :'),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  '${patientData[index]['PatientHealth'][0]['height']} cm'),
                                              Text(
                                                  '${patientData[index]['PatientHealth'][0]['weight']} lbs'),
                                              Text(
                                                  '${patientData[index]['PatientHealth'][0]['weight']} kg/m²'),
                                              Text(
                                                  '${patientData[index]['PatientHealth'][0]['medical_history']}'),
                                              Text(
                                                  '${patientData[index]['PatientHealth'][0]['medications']}'),
                                              Text(
                                                  '${patientData[index]['PatientHealth'][0]['children']}'),
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
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      const Text(
                                        'PriorSurgery Information',
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
                                                Text('Surgery name :'),
                                                Text('Year :'),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  '${patientData[index]['PriorSurgery'][0]['surgery_name']}'),
                                              Text(
                                                  '${patientData[index]['PriorSurgery'][0]['year_done']}'),
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
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      const Text(
                                        'Problem Information',
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
                                                Text('Body part :'),
                                                Text('Problem :'),
                                                Text('Desire outcomes :'),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  '${patientData[index]['PatientProblem'][0]['to_be_improved']}'),
                                              Text(
                                                  '${patientData[index]['PatientProblem'][0]['problem']}'),
                                              Text(
                                                  '${patientData[index]['PatientProblem'][0]['desired_outcome']}'),
                                            ],
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 200,
                                        child: GridView.builder(
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            gridDelegate:
                                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                                    maxCrossAxisExtent: 200,
                                                    mainAxisExtent: 180),
                                            itemCount: jsonDecode(
                                                    patientData[index]
                                                            ['PatientProblem']
                                                        [0]['body_part_image'])
                                                .length,
                                            itemBuilder:
                                                (BuildContext context, index1) {
                                              var decodedResponse = jsonDecode(
                                                  patientData[index]
                                                          ['PatientProblem'][0]
                                                      ['body_part_image']);

                                              return InkWell(
                                                onTap: () {
                                                  // print('Clicked $index1');
                                                  _imageFull(
                                                      decodedResponse[index1]);
                                                },
                                                child: Card(
                                                  shadowColor: Colors.grey,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: SizedBox(
                                                      height: 170,
                                                      width: 150,
                                                      child: AspectRatio(
                                                        aspectRatio: 1,
                                                        child: Image.network(
                                                          '${URLS.IMAGE_URL}${decodedResponse[index1]}',
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
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
                                        'Surgical Informations',
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
                                                Text('Time of surgery :'),
                                                Text('Willing to travel :'),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  '${patientData[index]['SurgicalInfo'][0]['time_of_surgery']}'),
                                              Text(
                                                  '${patientData[index]['SurgicalInfo'][0]['willing_to_travel']}'),
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
                                    // ignore: prefer_const_literals_to_create_immutables
                                    children: [
                                      const Text(
                                        'Wishlist Informations',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black54,
                                            fontStyle: FontStyle.italic),
                                      ),
                                      const Divider(),
                                      for (var i = 0;
                                          i <
                                              patientData[index]
                                                      ['PatientWishlist']
                                                  .length;
                                          i++) ...[
                                        SizedBox(
                                            child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .4,
                                              // color: Colors.amber,
                                              child: Text(
                                                  '${patientData[index]['PatientWishlist'][i]['doctor_name']}'),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .4,
                                              // color: Colors.red,
                                              child: FittedBox(
                                                child: AutoSizeText(
                                                  '${patientData[index]['PatientWishlist'][i]['doctor_email']}',
                                                ),
                                              ),
                                            )
                                          ],
                                        )),
                                      ],
                                    ],
                                  ),
                                )),
                              ),
                              const SizedBox(
                                height: 120,
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
