// ignore_for_file: avoid_print, must_be_immutable

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuk_boddy/api_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:video_player/video_player.dart';

// import 'package:string_extensions/string_extensions.dart';
// import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
// import 'package:video_uploader/video_uploader.dart';

class LoginUser {
  String amount = '';
}

class PatientDetails extends StatefulWidget {
  PatientDetails(this.patientDetails, this.patientProfile, {Key? key})
      : super(key: key);
  int patientDetails;
  bool patientProfile;
  @override
  State<PatientDetails> createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails> {
  // late VideoPlayerController _controller;

  var _videoPath;
  var _videoName;

  final ImagePicker _picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();
  final LoginUser _data = LoginUser();

  List<dynamic> patientData = [];
  List<dynamic> images = [];

  bool isLoading = true;
  final amountController = TextEditingController();
  final dOBController = TextEditingController();
  final videoInfo = FlutterVideoInfo();

  @override
  void initState() {
    _patienDetails(widget.patientDetails);
    super.initState();
  }

  String videoFilePath = "";
  String info = "";
  double? duration;

  getVideoInfo(videoPath) async {
    /// here file path of video required
    if (Platform.isIOS) {
      videoFilePath = videoPath;
      // print('Here==> $videoFilePath');
    } else if (Platform.isAndroid) {
      videoFilePath = videoPath;
      // print('Here==> $videoFilePath');
    }
    var a = await videoInfo.getVideoInfo(videoFilePath);
    setState(() {
      info =
          "title=> ${a!.title}\npath=> ${a.path}\nauthor=> ${a.author}\nmimetype=> ${a.mimetype}";
      info +=
          "\nheight=> ${a.height}\nwidth=> ${a.width}\nfileSize=> ${a.filesize} Bytes\nduration=> ${a.duration} milisec";
      info +=
          "\norientation=> ${a.orientation}\ndate=> ${a.date}\nframerate=> ${a.framerate}";
      info += "\nlocation=> ${a.location}";
    });
    // print('INFORMATION==>$info');
    print('DURATION==>${a!.duration}');
    setState(() {
      duration = a.duration;
    });
  }

  _trySubmitForm() {
    final bool? isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      // print(_data.password);
      debugPrint('Everything looks good!');
      _doctorBidding();
    }
  }

  _doctorBidding() async {
    ApiService.fetchData(context);

    ApiService.doctorBidding(
            widget.patientDetails, _data.amount, _videoPath, dOBController.text)
        .then((value) {
      print(value);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(value['message'])));
      if (value['status']) {
        Navigator.of(context).pop();
        amountController.clear();

        // Navigator.pushNamed(context, 'PatientThirdForm');
      }
    });
  }

  _patienDetails(patientDetails) async {
    ApiService.patientDetails(patientDetails).then((value) {
      // print('PatientDetails ==> $value');
      setState(() {
        patientData = value['data'];
        // print('PatientDetails ==> $patientDetails');
        isLoading = false;
      });
    });
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

  Widget userInput(
    TextEditingController userInput,
    String hintTitle,
    TextInputType keyboardType, {
    required Null Function(dynamic value) onChanged,
    required String? Function(dynamic value) validator,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * .9,
      height: 55,
      child: TextFormField(
        onChanged: onChanged,
        validator: validator,
        controller: userInput,
        autocorrect: false,
        enableSuggestions: false,
        autofocus: false,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(204, 221, 219, 219),
            ),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          hintText: hintTitle,
          hintStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('HERE_AFTER==> ${widget.patientProfile}');
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
                  // print(
                  //     'here==>${patientData[index]['PatientProblem'][0]['body_part_image']}');
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
                              child: InkWell(
                                onTap: () {
                                  _imageFull(patientData[index]['UserInfo'][0]
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
                                            '${URLS.IMAGE_URL}${patientData[index]['UserInfo'][0]['profile_pic']}',
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: const [
                                          Text('Doctor\'s name '),
                                          Text('Doctor\'s email '),
                                        ],
                                      ),
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
                              const SizedBox(height: 10),
                              widget.patientProfile == true
                                  ? Container(
                                      height: 60,
                                      width: 400,
                                      padding: const EdgeInsets.only(
                                          top: 5, left: 70, right: 70),
                                      child: RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        color: const Color(0xff4f4f4f),
                                        onPressed: () {
                                          showModalBottomSheet(
                                              isScrollControlled: true,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      30.0),
                                                              topRight: Radius
                                                                  .circular(
                                                                      30.0))),
                                              context: context,
                                              builder: (context) {
                                                return StatefulBuilder(builder:
                                                    (BuildContext context,
                                                        StateSetter setState) {
                                                  return SafeArea(
                                                    child: Scaffold(
                                                      body: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 20,
                                                                  left: 20,
                                                                  right: 20),
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              .5,
                                                          child: Form(
                                                            key: _formKey,
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    const Text(
                                                                      'Please enter your bid amount',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        color: Colors
                                                                            .black54,
                                                                      ),
                                                                    ),
                                                                    IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        icon:
                                                                            const Icon(
                                                                          Icons
                                                                              .arrow_drop_down_sharp,
                                                                          size:
                                                                              20,
                                                                        ))
                                                                  ],
                                                                ),
                                                                const Divider(),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          8.0),
                                                                  child:
                                                                      userInput(
                                                                    amountController,
                                                                    'Enter your amount',
                                                                    TextInputType
                                                                        .number,
                                                                    onChanged:
                                                                        ((value) {
                                                                      _data.amount =
                                                                          value;
                                                                    }),
                                                                    validator:
                                                                        (value) {
                                                                      if (value ==
                                                                              null ||
                                                                          value
                                                                              .trim()
                                                                              .isEmpty) {
                                                                        return 'This field is required';
                                                                      }
                                                                      return null;
                                                                    },
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  child:
                                                                      Container(
                                                                    height: 55,
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        .9,
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        top: 5,
                                                                        left: 7,
                                                                        right:
                                                                            7),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                    ),
                                                                    child:
                                                                        TextFormField(
                                                                      controller:
                                                                          dOBController,
                                                                      readOnly:
                                                                          true,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        suffixIcon: InkWell(
                                                                            onTap: () async {
                                                                              DateTime? pickedDate = await showDatePicker(
                                                                                  context: context,
                                                                                  initialDate: DateTime.now(),
                                                                                  firstDate: DateTime(1947), //DateTime.now() - not to allow to choose before today.
                                                                                  lastDate: DateTime(2101));

                                                                              if (pickedDate != null) {
                                                                                String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

                                                                                setState(() {
                                                                                  dOBController.text = formattedDate; //set output date to TextField value.
                                                                                  print(formattedDate);
                                                                                });
                                                                              } else {
                                                                                print("Date is not selected");
                                                                              }
                                                                            },
                                                                            child: const Icon(
                                                                              Icons.calendar_month_outlined,
                                                                              color: Colors.black54,
                                                                            )),
                                                                        focusedBorder:
                                                                            const OutlineInputBorder(
                                                                          borderSide:
                                                                              BorderSide(
                                                                            color: Color.fromARGB(
                                                                                204,
                                                                                221,
                                                                                219,
                                                                                219),
                                                                          ),
                                                                        ),
                                                                        border: OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10)),
                                                                        hintText:
                                                                            'Please enter expiry date for this offer',
                                                                        hintStyle:
                                                                            const TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () async {
                                                                      // _uploadVideo();
                                                                      var source =
                                                                          ImageSource
                                                                              .gallery;
                                                                      XFile?
                                                                          video =
                                                                          await _picker
                                                                              .pickVideo(
                                                                        source:
                                                                            source,
                                                                        maxDuration:
                                                                            const Duration(seconds: 60),
                                                                      );

                                                                      if (video !=
                                                                          null) {
                                                                        setState(
                                                                            () {
                                                                          try {
                                                                            _videoPath =
                                                                                video.path;
                                                                            _videoName =
                                                                                video.name;
                                                                            getVideoInfo(_videoPath);
                                                                          } catch (e) {
                                                                            log("Failed to get video: $e");
                                                                          }
                                                                        });
                                                                      }
                                                                    });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            15,
                                                                        top: 5),
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        top: 15,
                                                                        left: 7,
                                                                        right:
                                                                            7),
                                                                    height: 55,
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        .9,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                            border: Border.all(
                                                                              color: const Color.fromARGB(204, 120, 118, 118),
                                                                            )),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        _videoName ==
                                                                                null
                                                                            ? const Text(
                                                                                "Upload your video",
                                                                                style: TextStyle(
                                                                                  fontSize: 15,
                                                                                  color: Colors.black54,
                                                                                ),
                                                                              )
                                                                            : Text(
                                                                                _videoName,
                                                                                style: const TextStyle(
                                                                                  fontSize: 15,
                                                                                  color: Colors.black,
                                                                                ),
                                                                              ),
                                                                        const Icon(
                                                                          Icons
                                                                              .file_copy_outlined,
                                                                          color:
                                                                              Colors.black54,
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                                const Spacer(),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          20.0),
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      if (duration! >
                                                                          60000.0) {
                                                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                                            content:
                                                                                Text('Video duration should be less than 60 seconds.')));
                                                                      } else {
                                                                        _trySubmitForm();
                                                                      }
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width,
                                                                      height:
                                                                          50,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                        color: const Color(
                                                                            0xff4f4f4f),
                                                                      ),
                                                                      child: const Center(
                                                                          child: Text(
                                                                        "Update",
                                                                        style: TextStyle(
                                                                            color: Color(
                                                                                0xffff86b7),
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                      )),
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          )),
                                                    ),
                                                  );
                                                });
                                              });
                                        },
                                        child: const Text(
                                          'Enter your Bid',
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xffff86b7),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
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
