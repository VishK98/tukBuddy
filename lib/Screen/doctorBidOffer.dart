// ignore_for_file: avoid_print, must_be_immutable, deprecated_member_use, file_names

import 'package:flutter/material.dart';
import 'package:tuk_boddy/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorBidOffer extends StatefulWidget {
  DoctorBidOffer(this.patientDetails, this.bidList, {Key? key})
      : super(key: key);
  int patientDetails;
  Map bidList = {};

  @override
  State<DoctorBidOffer> createState() => _DoctorBidOfferState();
}

class _DoctorBidOfferState extends State<DoctorBidOffer> {
  List<dynamic> patientData = [];
  bool isLoading = true;

  @override
  void initState() {
    _patienDetails(widget.patientDetails);

    super.initState();
  }

  _patienDetails(patientDetails) {
    ApiService.patientDetails(patientDetails).then((value) {
      // print('PatientDetails ==> $value');
      setState(() {
        patientData = value['data'];
        // print('PatientDetails ==> $patientDetails');
        isLoading = false;
      });
    });
  }

  _acceptCounterOffer() async {
    ApiService.fetchData(context);

    ApiService.acceptCounterOfferByDoctor(widget.bidList['id'], 5)
        .then((value) {
      // print(value);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(value['message'])));
      if (value['status']) {
        Navigator.of(context).pop();
        //   // amountController.clear();

        //   // Navigator.pushNamed(context, 'PatientThirdForm');
      }
    });
  }

  _rejectCounterOffer() async {
    ApiService.fetchData(context);

    ApiService.rejectCounterOfferByDoctor(widget.bidList['id'], 4)
        .then((value) {
      // print(value);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(value['message'])));
      if (value['status']) {
        Navigator.of(context).pop();
        //   // amountController.clear();

        //   // Navigator.pushNamed(context, 'PatientThirdForm');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.patientDetails);
    print(widget.bidList);
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
                  // print(patientData.length);
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
                                  '${patientData[index]['UserInfo'][0]['name']}',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          RaisedButton(
                            color: const Color(0xff4f4f4f),
                            onPressed: () async {
                              Uri phoneno = Uri.parse(
                                  'tel:${patientData[index]['UserInfo'][0]['mobile']}');
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
                                  "mailto:${patientData[index]['UserInfo'][0]['email']}");
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
                                        'Patient Information',
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
                                            Icons.date_range_outlined,
                                            color: Color(0xffff86b7),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                              '${patientData[index]['PatientInfo'][0]['d_o_b']}'),
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
                                        'Bid Information',
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
                                                Text('Your offer :'),
                                                Text('Patient offer :'),
                                                Text('Offer status :'),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  '\$${widget.bidList['doctor_offer']}'),
                                              Text(
                                                  '\$${widget.bidList['patient_offer']}'),
                                              widget.bidList[
                                                          'is_offer_accepted'] ==
                                                      0
                                                  ? const Text('pending')
                                                  : widget.bidList[
                                                              'is_offer_accepted'] ==
                                                          1
                                                      ? const Text('rejected')
                                                      : const Text('accepted')
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
                                        'Patient Health Information',
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
                                        'Patient Problem Information',
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
                                        'Patient Surgical Informations',
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
                                        'Patient Wishlist Informations',
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
                                                Text('Doctor\'s name :'),
                                                Text('Doctor\'s email :'),
                                              ],
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  '${patientData[index]['PatientWishlist'][0]['doctor_name']}'),
                                              Text(
                                                  '${patientData[index]['PatientWishlist'][0]['doctor_email']}'),
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                              ),
                              widget.bidList['is_offer_accepted'] == 0
                                  ? Container()
                                  : widget.bidList['is_offer_accepted'] == 1
                                      ? Container()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            RaisedButton(
                                              color: const Color(0xff4f4f4f),
                                              onPressed: () {
                                                _acceptCounterOffer();
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: const [
                                                  SizedBox(width: 20),
                                                  Text('Accept ',
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xffff86b7),
                                                          fontSize: 17.0,
                                                          fontStyle: FontStyle
                                                              .italic)),
                                                  SizedBox(width: 20),
                                                ],
                                              ),
                                            ),
                                            RaisedButton(
                                              color: const Color(0xff4f4f4f),
                                              onPressed: () {
                                                _rejectCounterOffer();
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: const [
                                                  SizedBox(width: 20),
                                                  Text('Reject',
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xffff86b7),
                                                          fontSize: 17.0,
                                                          fontStyle: FontStyle
                                                              .italic)),
                                                  SizedBox(width: 20),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
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
