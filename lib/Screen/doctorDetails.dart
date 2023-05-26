// ignore_for_file: avoid_print, must_be_immutable, file_names, deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tuk_boddy/api_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';

class DoctorDetails extends StatefulWidget {
  DoctorDetails(this.doctorID, {Key? key}) : super(key: key);
  int doctorID;
  @override
  State<DoctorDetails> createState() => _DoctorDetailsState();
}

class _DoctorDetailsState extends State<DoctorDetails> {
  List<dynamic> doctorData = [];
  bool isLoading = true;
  @override
  void initState() {
    _doctorDetails(widget.doctorID);
    super.initState();
  }

  _doctorDetails(doctorID) {
    ApiService.doctorDetailsSeenByPatient(doctorID).then((value) {
      // print('PatientDetails ==> $value');
      setState(() {
        doctorData = value['data'];
        // print('_doctorDetails ==> $doctorData');
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
              child: PhotoView(
                imageProvider: NetworkImage('${URLS.IMAGE_URL}$image'),
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
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.arrow_back_ios,
                                      size: 20,
                                    )),
                                const SizedBox(
                                  width: 20,
                                ),
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
                                          '${URLS.IMAGE_URL}${doctorData[index]['UserInfo'][0]['profile_pic']}',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          RaisedButton(
                            color: const Color(0xff4f4f4f),
                            onPressed: () async {
                              Uri phoneno = Uri.parse(
                                  'tel:${doctorData[index]['UserInfo'][0]['mobile']}');
                              if (await launchUrl(phoneno)) {
                                //dialer opened
                              } else {
                                //dailer is not opened
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                Icon(
                                  Icons.call,
                                  color: Color(0xffff86b7),
                                ),
                                SizedBox(
                                  width: 40,
                                ),
                                Text('Call ',
                                    style: TextStyle(
                                        color: Color(0xffff86b7),
                                        fontSize: 17.0,
                                        fontStyle: FontStyle.italic)),
                              ],
                            ),
                          ),
                          RaisedButton(
                            color: const Color(0xff4f4f4f),
                            onPressed: () async {
                              Uri mail = Uri.parse(
                                  "mailto:${doctorData[index]['UserInfo'][0]['email']}");
                              if (await launchUrl(mail)) {
                                //email app opened
                              } else {
                                //email app is not opened
                              }
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: const [
                                Icon(
                                  Icons.email_outlined,
                                  color: Color(0xffff86b7),
                                ),
                                SizedBox(
                                  width: 40,
                                ),
                                Text('Email',
                                    style: TextStyle(
                                        color: Color(0xffff86b7),
                                        fontSize: 17.0,
                                        fontStyle: FontStyle.italic)),
                              ],
                            ),
                          )
                        ],
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
                                        'Doctor Information',
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
                                        'Doctor Office Details',
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
                                        'Office Timing',
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
                                height: 80,
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
