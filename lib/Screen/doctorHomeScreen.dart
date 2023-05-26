// ignore_for_file: file_names, avoid_print, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:page_transition/page_transition.dart';

import 'package:tuk_boddy/Screen/patientDetails.dart';
import 'package:tuk_boddy/api_service.dart';

class MakePost {
  String post = '';
}

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({Key? key}) : super(key: key);

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  final MakePost _data = MakePost();
  final postController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  double? latitude;
  double? longitude;
  bool patientProfile = true;

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    placemarkFromCoordinates(position.latitude, position.longitude);
  }

  bool isLoading = true;

  List<dynamic> patientList = [];

  @override
  void initState() {
    _patientList();

    super.initState();
  }

  _trySubmitForm(latitude, longitude) {
    final bool? isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      // print(_data.password);
      debugPrint('Everything looks good!');
      _makePost(latitude, longitude);
    }
  }

  _makePost(latitude, longitude) {
    ApiService.fetchData(context);
    ApiService.doctorMakePost(_data.post, latitude, longitude).then((value) {
      // print('MakePost ==> $value');
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(value['message'])));
      if (value['status']) {
        postController.clear();
      }
    });
  }

  _patientList() {
    ApiService.patientList().then((value) {
      // print('PatientList ==> $value');
      setState(() {
        patientList = value['data'];
        //print('PatientList After ==> $patientList');
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * .7,
                  height: 50,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey.shade200,
                      borderRadius: BorderRadius.circular(5)),
                  child: Center(
                    child: TextFormField(
                      controller: postController,
                      textAlign: TextAlign.left,
                      autocorrect: false,
                      enableSuggestions: false,
                      autofocus: false,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Write something. ..',
                        hintStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.white70,
                        ),
                      ),
                      onChanged: ((value) {
                        _data.post = value;
                      }),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'This field is required';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * .2,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.shade200,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextButton(
                    child: const Text(
                      'Post',
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                    onPressed: () async {
                      Position position = await _getGeoLocationPosition();

                      setState(() {
                        latitude = position.latitude;
                        longitude = position.longitude;
                      });
                      GetAddressFromLatLong(position);
                      _trySubmitForm(latitude, longitude);
                      // _makePost(latitude, longitude);
                    },
                  ),
                ),
              ],
            ),
            const Divider(
                color: Color(
              0xffff86b7,
            )),
            const Text('Recommended patients lists for you'),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 200,
              child: isLoading == true
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: Color(0xffff86b7),
                    ))
                  : GridView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200, mainAxisExtent: 140),
                      itemCount: patientList.length,
                      itemBuilder: (BuildContext context, index) {
                        return InkWell(
                          onTap: () {
                            // print('Clicked');
                            Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.topToBottom,
                                    child: PatientDetails(
                                        patientList[index]["id"],
                                        patientProfile)));
                          },
                          child: Card(
                            shadowColor: Colors.grey,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    height: 100,
                                    width: 120,
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: Image.network(
                                        '${URLS.IMAGE_URL}${patientList[index]["profile_pic"]}',
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                  Text(patientList[index]['name']),
                                  Text(patientList[index]['category']),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
            ),
          ]),
        ),
      ),
    ));
  }
}
