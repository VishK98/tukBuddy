// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:tuk_boddy/Screen/patientDetails.dart';
import 'package:tuk_boddy/api_service.dart';

class DoctorOpinoinPool extends StatefulWidget {
  const DoctorOpinoinPool({Key? key}) : super(key: key);

  @override
  State<DoctorOpinoinPool> createState() => _DoctorOpinoinPoolState();
}

class _DoctorOpinoinPoolState extends State<DoctorOpinoinPool> {
  final AppinioSwiperController controller = AppinioSwiperController();
  bool _isLeftCard = true;
  List<dynamic> allOpinionPool = [];
  List<dynamic> option = [];
  bool _isSpinner = false;
  bool patientProfile = false;
  int totalSwipe = 0;
  @override
  void initState() {
    _allOpinionPool();
    super.initState();
  }

  _allOpinionPool() {
    setState(() {
      _isLeftCard = true;
      _isSpinner = true;
    });
    ApiService.allOpinionPool().then((value) {
      // print("allOpinionPool==>$value");
      setState(() {
        _isSpinner = false;
        allOpinionPool = value['data'];
      });
      print('here==>${allOpinionPool[0]['options']}');
    });
  }

  @override
  Widget build(BuildContext context) {
    print('HERE==> $patientProfile');
    return Scaffold(
      body: _isSpinner
          ? const Center(
              child: CircularProgressIndicator(
              color: Color(0xffff86b7),
            ))
          : !_isLeftCard
              ? Container(
                  margin: const EdgeInsets.only(top: 250),
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: const Text(
                            "There are no card to swipe",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                        InkWell(
                          onTap: _allOpinionPool,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0)),
                                color: Colors.white),
                            padding: const EdgeInsets.fromLTRB(
                                16.0, 16.0, 16.0, 16.0),
                            child: const Text("Reload",
                                style: TextStyle(fontWeight: FontWeight.w900)),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : CupertinoPageScaffold(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: AppinioSwiper(
                        swipeOptions: AppinioSwipeOptions.allDirections,
                        unlimitedUnswipe: false,
                        controller: controller,
                        unswipe: _unswipe,
                        onSwipe: _swipe,
                        onEnd: _onEnd,
                        cardsCount: allOpinionPool.length,
                        cardsBuilder: (BuildContext context, int index) {
                          return Card(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child: allOpinionPool[index]["image"] == ''
                                      ? const Center(
                                          child: Text('No image avilable'))
                                      : Image.network(
                                          '${URLS.IMAGE_URL}${allOpinionPool[index]["image"]}',
                                          fit: BoxFit.fill,
                                        ),
                                ),
                                Positioned(
                                  top: 80,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextButton(
                                        child: Text(
                                          allOpinionPool[index]['name'],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400),
                                          textAlign: TextAlign.start,
                                        ),
                                        onPressed: () {
                                          print('Clicked');
                                          Navigator.push(
                                              context,
                                              PageTransition(
                                                  type: PageTransitionType
                                                      .topToBottom,
                                                  child: PatientDetails(
                                                    allOpinionPool[index]
                                                        ['patient_id'],
                                                    patientProfile,
                                                  )));
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 100,
                                  left: 0,
                                  right: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      allOpinionPool[index]['question'],
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ),
                                Positioned(
                                    bottom: 30,
                                    child: Container(
                                      height: 50,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          color: const Color(0xff4f4f4f),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Center(
                                        child: Text(
                                          allOpinionPool[index]['options'][0]
                                              ['options'],
                                          style: const TextStyle(
                                            color: Color(0xffff86b7),
                                          ),
                                        ),
                                      ),
                                    )),
                                Positioned(
                                    top: 30,
                                    child: Container(
                                      height: 50,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          color: const Color(0xff4f4f4f),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Center(
                                        child: Text(
                                          allOpinionPool[index]['options'][1]
                                              ['options'],
                                          style: const TextStyle(
                                            color: Color(0xffff86b7),
                                          ),
                                        ),
                                      ),
                                    )),
                                Positioned(
                                    left: 30,
                                    child: Container(
                                      height: 50,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          color: const Color(0xff4f4f4f),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Center(
                                        child: Text(
                                          allOpinionPool[index]['options'][2]
                                              ['options'],
                                          style: const TextStyle(
                                            color: Color(0xffff86b7),
                                          ),
                                        ),
                                      ),
                                    )),
                                Positioned(
                                    right: 30,
                                    child: Container(
                                      height: 50,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          color: const Color(0xff4f4f4f),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Center(
                                        child: Text(
                                          allOpinionPool[index]['options'][3]
                                              ['options'],
                                          style: const TextStyle(
                                            color: Color(0xffff86b7),
                                          ),
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
    );
  }

  void _swipe(int index, AppinioSwiperDirection direction) {
    print("${index}__${allOpinionPool.length}");
    if (allOpinionPool.length <= index) {
      setState(() {
        _isLeftCard = false;
      });
    } else {
      switch (direction) {
        case AppinioSwiperDirection.none:
          break;
        case AppinioSwiperDirection.left:
          _updateVote(allOpinionPool[index]['options'][2]['id']);

          break;
        case AppinioSwiperDirection.right:
          _updateVote(allOpinionPool[index]['options'][3]['id']);

          break;
        case AppinioSwiperDirection.top:
          _updateVote(allOpinionPool[index]['options'][1]['id']);

          break;
        case AppinioSwiperDirection.bottom:
          _updateVote(allOpinionPool[index]['options'][0]['id']);

          break;
      }
    }
    print("the card was swiped to the: $direction");
  }

  _updateVote(id) {
    setState(() {
      totalSwipe += 1;
    });
    ApiService.updatevote(id).then((value) {});
  }

  void _unswipe(bool unswiped) {
    if (unswiped) {
      log("SUCCESS: card was unswiped");
    } else {
      log("FAIL: no card left to unswipe");
    }
  }

  void _onEnd() {
    log("${totalSwipe}_end reached!");
  }
}
