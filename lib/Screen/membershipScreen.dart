// ignore_for_file: file_names, avoid_print

import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuk_boddy/Screen/doctorProfile.dart';
import 'package:tuk_boddy/api_service.dart';

class MembershipScreen extends StatefulWidget {
  const MembershipScreen({Key? key}) : super(key: key);

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  List<dynamic> data = [];
  String userName = '';
  String userID = '';
  @override
  void initState() {
    _getUserInfo();
    membership();
    super.initState();
  }

  _getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name')!;
      userID = prefs.getString('user_id')!;
      print('Name==>$userName');
      print('ID==>$userID');
    });
  }

  membership() {
    ApiService.membership().then((value) {
      setState(() {
        // print("member==>$value");
        data = value["data"];
      });
    });
  }

  _tapped(index) {
    print(index);
    if (index == 0) {
      ApiService.buyNow('1').then((value) {
        // print('Free User ==> $value');
        if (value['status']) {
          Navigator.pushNamed(context, 'DoctorInfo');
        }
      });
    } else if (index == 1) {
      ApiService.buyNow('2').then((value) {
        // print('Preferred Provider ==> $value');
        if (value['status']) {
          Navigator.pushNamed(context, 'DoctorInfo');
        }
      });
    } else {
      ApiService.buyNow('3').then((value) {
        // print('Pro Provider ==> $value');
        if (value['status']) {
          // Navigator.pushNamed(context, 'DoctorInfo');
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.leftToRightWithFade,
              isIos: true,
              child: const DoctorProfile(),
            ),
          );
        }
      });
    }
  }

  final GlobalKey<ExpansionTileCardState> cardA = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        const SizedBox(
          height: 30,
        ),
        const Text(
          'Choose membership ',
          style: TextStyle(
            fontSize: 25.0,
            color: Color(0xFF212121),
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          'Welcome $userName',
          style: const TextStyle(
            fontSize: 15.0,
            color: Color(0xFF212121),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Flexible(
          child: data.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20),
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: data.length,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              ExpansionTileCard(
                                initiallyExpanded: index == 0,

                                baseColor: Colors.cyan[50],
                                expandedColor: Colors.red[50],
                                // key: cardA,
                                // leading: CircleAvatar(
                                //     child: Image.asset(
                                //         '${membership.elementAt(index)['image']}')),
                                title: Text(
                                  '${data[(index)]['name']}',
                                  style: const TextStyle(fontSize: 15),
                                ),
                                subtitle: data[index]['name'] == 'Free User'
                                    ? const Text("This is unpaid membership")
                                    : const Text("This is Paid membership"),
                                children: <Widget>[
                                  const Divider(
                                    thickness: 1.0,
                                    height: 1.0,
                                  ),
                                  for (var i = 0;
                                      i < data[index]["items"].length;
                                      i++) ...[
                                    data[index]["items"][i]['description'] == ''
                                        ? Container()
                                        : Align(
                                            alignment: Alignment.centerLeft,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 16.0,
                                                vertical: 8.0,
                                              ),
                                              child: Text(
                                                "${data[index]["items"][i]['description']}",
                                                style: const TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.grey,
                                                    fontStyle:
                                                        FontStyle.italic),
                                              ),
                                            ),
                                          ),
                                  ],
                                  ButtonBar(
                                    alignment: MainAxisAlignment.spaceAround,
                                    buttonHeight: 52.0,
                                    buttonMinWidth: 90.0,
                                    children: <Widget>[
                                      index == 0
                                          ? FlatButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                              ),
                                              onPressed: () {
                                                print('Continue');
                                                _tapped(index);
                                              },
                                              child: const Text('Continue',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Color.fromARGB(
                                                          255, 231, 147, 147),
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            )
                                          : FlatButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4.0),
                                              ),
                                              onPressed: () {
                                                _tapped(index);
                                              },
                                              child: const Text('Buy Now',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Color.fromARGB(
                                                          255, 231, 147, 147),
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              )
                            ],
                          ),
                        );
                      }),
                ),
        )
      ],
    ));
  }
}
