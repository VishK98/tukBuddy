// ignore_for_file: must_be_immutable, avoid_print

import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tuk_boddy/api_service.dart';
import 'package:tuk_boddy/Screen/doctorDetails.dart';

class LoginUser {
  String amount = '';
}

class PatientOfferScreen extends StatefulWidget {
  PatientOfferScreen(this.notificationId, this.bidList, {Key? key})
      : super(key: key);
  int notificationId;
  Map bidList = {};

  @override
  State<PatientOfferScreen> createState() => _PatientOfferScreenState();
}

class _PatientOfferScreenState extends State<PatientOfferScreen> {
  final _formKey = GlobalKey<FormState>();
  final LoginUser _data = LoginUser();
  // final amountController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  _trySubmitForm() {
    final bool? isValid = _formKey.currentState?.validate();
    if (isValid == true) {
      // print(_data.password);
      debugPrint('Everything looks good!');
      _counterBidOffer();
    }
  }

  bool cbFlag = false;

  _acceptBidOffer() async {
    ApiService.fetchData(context);

    ApiService.acceptBidOffer(
            widget.notificationId, widget.bidList['doctor_user_id'], 2)
        .then((value) {
      print(value);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(value['message'])));
      if (value['status']) {
        Navigator.of(context).pop();
      }
    });
  }

  _counterBidOffer() async {
    ApiService.fetchData(context);
    ApiService.counterBidOffer(widget.notificationId, 3,
            widget.bidList['doctor_user_id'], _data.amount)
        .then((value) {
      print(value);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(value['message'])));
      if (value['status']) {
        Navigator.of(context).pop();
      }
    });
  }

  _rejectBidOffer() async {
    ApiService.fetchData(context);

    ApiService.rejectBidOffer(widget.notificationId,widget.bidList['doctor_user_id'], 1).then((value) {
      print(value);
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(value['message'])));
      if (value['status']) {
        Navigator.of(context).pop();
      }
    });
  }

  Widget userInput(
    TextEditingController userInput,
    String hintTitle,
    TextInputType keyboardType, {
    required Null Function(dynamic value) onChanged,
    required String? Function(dynamic value) validator,
    required bool readOnly,
  }) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.only(left: 10),
      child: Center(
        child: TextFormField(
          readOnly: readOnly,
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
              color: Colors.black54,
            ),
          ),
          keyboardType: keyboardType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('HEREEEE==> ${widget.bidList['doctor_user_id']}');
    // print(widget.notificationId);
    return Scaffold(
        body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text('NotifcationID ${widget.notificationId}'),
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
                      '${widget.bidList['name']}',
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
                      print('Clicked');
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.topToBottom,
                              child: DoctorDetails(
                                  widget.bidList['doctor_user_id'])));
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
                                '${URLS.IMAGE_URL}${widget.bidList['profile_pic']}',
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
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              '${widget.bidList['name']} gives you an offer of \$${widget.bidList['doctor_offer']} you can accept or reject this offer.  You can also give your counter offer to ${widget.bidList['name']} by just click on accept button.',
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
                'This offer valid upto : ${widget.bidList['doctor_offer_time']}'),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RaisedButton(
                color: const Color(0xff4f4f4f),
                onPressed: () {
                  showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30.0),
                              topRight: Radius.circular(30.0))),
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(// this is new
                            builder:
                                (BuildContext context, StateSetter setState) {
                          return Container(
                              margin: const EdgeInsets.only(
                                  top: 20, left: 20, right: 20),
                              height: MediaQuery.of(context).size.height * .6,
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          cbFlag == false
                                              ? 'Please accept this offer'
                                              : 'Please enter your counter offer',
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: const Icon(
                                              Icons.arrow_drop_down_sharp,
                                              size: 20,
                                            ))
                                      ],
                                    ),
                                    const Divider(),
                                    CheckboxListTile(
                                      title: const Text(
                                          'You can also give your counter offer by just select this option'),
                                      value: cbFlag,
                                      checkColor: const Color(0xffff86b7),
                                      activeColor: const Color(0xff4f4f4f),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          cbFlag = value!;
                                          print(cbFlag);
                                        });
                                      },
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    userInput(
                                      readOnly: !cbFlag,
                                      amountController,
                                      'Enter your amount',
                                      TextInputType.number,
                                      onChanged: ((value) {
                                        _data.amount = value;
                                      }),
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'This field is required';
                                        }
                                        return null;
                                      },
                                    ),
                                    const Spacer(),
                                    cbFlag == false
                                        ? Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: InkWell(
                                              onTap: () {
                                                _acceptBidOffer();
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color:
                                                      const Color(0xff4f4f4f),
                                                ),
                                                child: const Center(
                                                    child: Text(
                                                  "Accept",
                                                  style: TextStyle(
                                                      color: Color(0xffff86b7),
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                              ),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(20.0),
                                            child: InkWell(
                                              onTap: () {
                                                _trySubmitForm();
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color:
                                                      const Color(0xff4f4f4f),
                                                ),
                                                child: const Center(
                                                    child: Text(
                                                  "Counter Offer",
                                                  style: TextStyle(
                                                      color: Color(0xffff86b7),
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )),
                                              ),
                                            ),
                                          )
                                  ],
                                ),
                              ));
                        });
                      });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    SizedBox(
                      width: 20,
                    ),
                    Text('Accept ',
                        style: TextStyle(
                            color: Color(0xffff86b7),
                            fontSize: 17.0,
                            fontStyle: FontStyle.italic)),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
              RaisedButton(
                color: const Color(0xff4f4f4f),
                onPressed: () {
                  _rejectBidOffer();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    SizedBox(
                      width: 20,
                    ),
                    Text('Reject',
                        style: TextStyle(
                            color: Color(0xffff86b7),
                            fontSize: 17.0,
                            fontStyle: FontStyle.italic)),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              )
            ],
          ),
          // const Text('OR'),
        ],
      ),
    ));
  }
}
