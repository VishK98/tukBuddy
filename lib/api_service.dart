// ignore_for_file: avoid_print, constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class URLS {
  static const String BASE_URL = 'http://165.22.215.103:4001';
  static const String IMAGE_URL = 'http://165.22.215.103:4001/uploads/';
}

class ApiService {
  static Future fetchData(BuildContext context) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  // The loading indicator
                  CircularProgressIndicator(
                    color: Color(0xffff86b7),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text(
                    'Loading....',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          );
        });
  }

  static Future register(
    userType,
    name,
    username,
    namePratice,
    password,
    email,
    mobile,
    licenseType,
    licenseNumber,
    country,
    state,
    profilePicture,
    iD,
    medicalLicense,
    drivingLicense,
    expirationDate,
  ) async {
    print('LicenseType==>$licenseType');
    print('LicenseType==>$name');

    var request = http.MultipartRequest(
        'POST', Uri.parse('${URLS.BASE_URL}/api/register'));

    request.fields.addAll({
      'user_type': userType,
      'name': name,
      'username': username,
      'password': password,
      'email': email,
      'mobile': mobile,
      'name_of_practice': namePratice,
      'type_of_license': licenseType,
      'license_number': licenseNumber,
      'country': '$country',
      'state': '$state',
      'license_expiration_date': expirationDate
    });
    request.files
        .add(await http.MultipartFile.fromPath('profile_pic', profilePicture));

    if (userType == 'Patient') {
      request.files.add(await http.MultipartFile.fromPath('patient_id', iD));
    }

    if (userType == 'Doctor') {
      request.files.add(
          await http.MultipartFile.fromPath('medical_license', medicalLicense));
    }

    if (userType == 'Doctor') {
      request.files.add(
          await http.MultipartFile.fromPath('drivers_license', drivingLicense));
    }

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(await response.stream.bytesToString());
      print("Deoced Response ==> $decodedResponse");
      return decodedResponse;
    } else {
      return response.reasonPhrase;
    }
  }

  static Future login(username, password, deviceID) async {
    var body = {
      'username': username,
      'password': password,
      'device_id': deviceID
    };

    final response =
        await http.post(Uri.parse('${URLS.BASE_URL}/api/login'), body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return response.statusCode;
    }
  }

  static Future postLogin(iD, name, email, photo, type) async {
    var body = {
      'login_type': '$type',
      'name': '$name',
      'email': '$email',
      'profile_pic': '$photo',
      'google_id': '$iD'
    };
    print('BODY==>$body');

    final response = await http.post(
        Uri.parse('${URLS.BASE_URL}/api/google_facebook_login'),
        body: body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson = jsonDecode(response.body);
      print(responseJson);
      print(response.statusCode);
      return responseJson;
    } else {
      return response.statusCode;
    }
  }

  static Future logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var body = {
      'id': prefs.getString('user_id'),
    };

    final response =
        await http.post(Uri.parse('${URLS.BASE_URL}/api/logout'), body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return response.statusCode;
    }
  }

  static Future sendOTP(email) async {
    var body = {
      'email': email,
    };

    final response = await http
        .post(Uri.parse('${URLS.BASE_URL}/api/forget-password'), body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return response.statusCode;
    }
  }

  static Future verifyOTP(email, otp) async {
    var body = {'email': email, 'otp': otp};

    final response = await http
        .post(Uri.parse('${URLS.BASE_URL}/api/verify-otp'), body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return response.statusCode;
    }
  }

  static Future resetPassword(email, password) async {
    var body = {'email': email, 'password': password};

    final response = await http
        .post(Uri.parse('${URLS.BASE_URL}/api/update-password'), body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return response.statusCode;
    }
  }

  static Future membership() async {
    final response =
        await http.get(Uri.parse('${URLS.BASE_URL}/api/membership'));
    // print("membership");
    // print(response.statusCode);
    if (response.statusCode == 200) {
      var responseJson = jsonDecode(response.body);
      return responseJson;
    } else {
      return response.statusCode;
    }
  }

  static Future buyNow(membership) async {
    print(membership);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var body = {
      'user_id': prefs.getString('user_id'),
      'membership': membership.toString()
    };

    print('buyNow ==>$body');
    final response = await http.post(
        Uri.parse('${URLS.BASE_URL}/api/purchase-membership'),
        body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {}
  }

  static Future membershipInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http.get(Uri.parse(
        '${URLS.BASE_URL}/api/membership/${prefs.getString('user_id')}'));

    if (response.statusCode == 200) {
      // print('${URLS.BASE_URL}/api/membership/${prefs.getString('user_id')}');

      var responseJson = jsonDecode(response.body);
      return responseJson;
    } else {
      return response.statusCode;
    }
  }

  static Future registrationStep() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http.get(Uri.parse(
        '${URLS.BASE_URL}/api/step_form/${prefs.getString('user_id')}'));

    if (response.statusCode == 200) {
      // print('${URLS.BASE_URL}/api/membership/${prefs.getString('user_id')}');

      var responseJson = jsonDecode(response.body);
      return responseJson;
    } else {
      return response.statusCode;
    }
  }

  static Future doctorInfo(
      instagram,
      titok,
      facebook,
      snapchat,
      twitter,
      pinterest,
      other,
      practiceinfo,
      facilityImage,
      beforeImage,
      afterImage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var request = http.MultipartRequest(
        'POST', Uri.parse('${URLS.BASE_URL}/api/doctor-one'));

    request.fields.addAll({
      'user_id': '${prefs.getString('user_id')}',
      'insta_profile': instagram,
      'tiktok_profile': titok,
      'facebook_profile': facebook,
      'snapchat_profile': snapchat,
      'twitter_profile': twitter,
      'pinterest_profile': pinterest,
      'other_profile': other,
      'practice_info': practiceinfo
    });
    final List<http.MultipartFile> facilityphoto = <http.MultipartFile>[];
    if (facilityImage != null && facilityImage.length > 0) {
      await Future.forEach(facilityImage!, (XFile file) async {
        var photo =
            await http.MultipartFile.fromPath("facility_pic", file.path);
        facilityphoto.add(photo);
      });
    }
    request.files.addAll(facilityphoto);

    // request.files
    //     .add(await http.MultipartFile.fromPath('facility_pic', facilityImage));

    final List<http.MultipartFile> photos1 = <http.MultipartFile>[];
    if (beforeImage != null && beforeImage.length > 0) {
      await Future.forEach(beforeImage!, (XFile file) async {
        var photo = await http.MultipartFile.fromPath("before_img", file.path);
        photos1.add(photo);
      });
    }
    request.files.addAll(photos1);

    final List<http.MultipartFile> photos = <http.MultipartFile>[];
    if (afterImage != null && afterImage.length > 0) {
      await Future.forEach(afterImage!, (XFile file) async {
        var photo = await http.MultipartFile.fromPath("after_img", file.path);
        photos.add(photo);
      });
    }
    request.files.addAll(photos);

    print(facilityImage);
    print(beforeImage);
    print(afterImage);

    // print('ID ==>$iD');
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(await response.stream.bytesToString());
      print("Deoced Response ==> $decodedResponse");
      return decodedResponse;
    } else {
      return response.reasonPhrase;
    }
  }

  static Future doctorDegree(degreeName, place, degreeImage, year) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var request = http.MultipartRequest(
        'POST', Uri.parse('${URLS.BASE_URL}/api/doctor-two-degree'));

    request.fields.addAll({
      'user_id': '${prefs.getString('user_id')}',
      'degree_name': degreeName,
      'year_completed': year,
      'place_of_completion': place
    });
    request.files
        .add(await http.MultipartFile.fromPath('degree_pic', degreeImage));

    print(degreeImage);
    print(degreeName);
    print(year);
    print(place);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(await response.stream.bytesToString());
      print("Deoced Response ==> $decodedResponse");
      return decodedResponse;
    } else {
      return response.reasonPhrase;
    }
  }

  static Future doctorPratice() async {
    final response = await http.get(Uri.parse('${URLS.BASE_URL}/api/master'));
    // print("membership");
    // print(response.statusCode);
    if (response.statusCode == 200) {
      var responseJson = jsonDecode(response.body);
      return responseJson;
    } else {
      return response.statusCode;
    }
  }

  static Future doctorPractice(practice, boardCertified) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var body = {
      'user_id': prefs.getString('user_id'),
      'primary_practice_focus': '$practice' == 'Yes' ? '1' : '0',
      'board_certified': '$boardCertified'
    };

    print('buyNow ==>$body');
    final response = await http
        .post(Uri.parse('${URLS.BASE_URL}/api/doctor-two'), body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return response.statusCode;
    }
  }

  static Future country() async {
    final response = await http.get(Uri.parse('${URLS.BASE_URL}/api/master'));
    // print("membership");
    // print(response.statusCode);
    if (response.statusCode == 200) {
      var responseJson = jsonDecode(response.body);
      return responseJson;
    } else {
      return response.statusCode;
    }
  }

  static Future state(countryID) async {
    // print('HERE==>$stateID');
    final response =
        await http.get(Uri.parse('${URLS.BASE_URL}/api/states/$countryID'));

    if (response.statusCode == 200) {
      var responseJson = jsonDecode(response.body);
      return responseJson;
    } else {
      return response.statusCode;
    }
  }

  static Future city(stateID) async {
    // print('HERE==>$stateID');
    final response =
        await http.get(Uri.parse('${URLS.BASE_URL}/api/cities/$stateID'));

    if (response.statusCode == 200) {
      var responseJson = jsonDecode(response.body);
      return responseJson;
    } else {
      return response.statusCode;
    }
  }

  static Future doctorOffice(address, country, state, city) async {
    //print(city);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var body = {
      'user_id': prefs.getString('user_id').toString(),
      //'user_id': '98',
      'address': '$address',
      'country': '$country',
      'state': '$state',
      'city': '$city'
    };

    print('OFFICE ==>$body');
    final response = await http.post(
        Uri.parse('${URLS.BASE_URL}/api/doctor-office-location'),
        body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return response.statusCode;
    }
  }

  static Future doctorContactInfo(consultationFee, email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var body = {
      'user_id': prefs.getString('user_id').toString(),
      //'user_id': '98',
      'consultation_fee': consultationFee,
      'contact_email': email
    };

    print('OFFICE ==>$body');
    final response = await http
        .post(Uri.parse('${URLS.BASE_URL}/api/doctor-fee-email'), body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return response.statusCode;
    }
  }

  static Future surgicalProcedures(
      bmi,
      tabaccoValue,
      tabacco,
      marijuanaValue,
      marijuana,
      birthPillsValue,
      birthPills,
      breastsurgeryValue,
      medicalclearanceValue,
      operationPlaceValue,
      facilityValue,
      facility,
      anesthesiaValue,
      anesthesia,
      garmentsValue,
      garments,
      massageValue,
      massage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var taboccoObj = {};
    print(tabaccoValue);
    if (tabaccoValue != 'No, but...') {
      taboccoObj = {
        'tobacco': tabaccoValue == "Yes"
            ? "1"
            : tabaccoValue == "No"
                ? "0"
                : "2"
                    '',
      };
    } else {
      taboccoObj = {
        'tobacco': tabaccoValue == "Yes"
            ? "1"
            : tabaccoValue == "No"
                ? "0"
                : "2"
                    '',
        'no_tobacco_days': tabacco,
      };
    }
    var marijuanaObj = {};
    if (marijuanaValue != 'No, but...') {
      marijuanaObj = {
        'marijuana': marijuanaValue == "Yes"
            ? "1"
            : marijuanaValue == "No"
                ? "0"
                : "2"
                    '',
      };
    } else {
      marijuanaObj = {
        'marijuana': marijuanaValue == "Yes"
            ? "1"
            : marijuanaValue == "No"
                ? "0"
                : "2"
                    '',
        'no_marijuana_days': marijuana,
      };
    }
    var facilityObj = {};
    if (facilityValue == 'Yes') {
      facilityObj = {
        'facility': facilityValue == "Yes" ? "1" : "0",
        'facility_fee': facility,
      };
    } else {
      facilityObj = {
        'facility': facilityValue == "Yes" ? "1" : "0",
      };
    }
    var anesthesiaObj = {};
    if (anesthesiaValue == 'Yes') {
      anesthesiaObj = {
        'anesthesia': anesthesiaValue == "Yes" ? "1" : "0",
        'anethesia_fee': anesthesia,
      };
    } else {
      anesthesiaObj = {
        'anesthesia': anesthesiaValue == "Yes" ? "1" : "0",
      };
    }
    var garmentsObj = {};
    if (garmentsValue == 'Yes') {
      garmentsObj = {
        'garments': garmentsValue == "Yes" ? "1" : "0",
        'garments_fee': garments,
      };
    } else {
      garmentsObj = {
        'garments': garmentsValue == "Yes" ? "1" : "0",
      };
    }
    var massageObj = {};
    if (massageValue == 'Yes') {
      massageObj = {
        'massage': massageValue == "Yes" ? "1" : "0",
        'massage_fee': massage
      };
    } else {
      massageObj = {
        'massage': massageValue == "Yes" ? "1" : "0",
      };
    }
    var body = {
      'user_id': prefs.getString('user_id').toString(),
      'bmi': bmi,
      ...taboccoObj,
      ...marijuanaObj,
      'birth_control_pills': birthPillsValue == "Yes" ? "1" : "0",
      'hemoglobin': birthPills,
      'ultrasound_before_breast_surgery':
          breastsurgeryValue == "Yes" ? "1" : "0",
      'medical_clearance': medicalclearanceValue == "Yes" ? "1" : "0",
      'operate_in': operationPlaceValue,
      ...facilityObj,
      ...anesthesiaObj,
      ...garmentsObj,
      ...massageObj
    };

    // print('OFFICE ==>$body');
    final response = await http
        .post(Uri.parse('${URLS.BASE_URL}/api/doctor-four'), body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return response.statusCode;
    }
  }

  static Future patientInfo(address, gender, dob) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var body = {
      'user_id': prefs.getString('user_id').toString(),
      'd_o_b': dob,
      'gender': gender,
      'address': address
    };

    // print('INFO ==>$body');
    final response = await http
        .post(Uri.parse('${URLS.BASE_URL}/api/patient-one'), body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return response.statusCode;
    }
  }

  static Future patienthealthInfo(
      height, weight, bmi, smoke, medicalHistory, medication, children) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var body = {
      'user_id': prefs.getString('user_id').toString(),
      'height': height,
      'weight': weight,
      'bmi': bmi,
      'smoker': smoke == 'Yes' ? '1' : ' 0',
      'medical_history': medicalHistory,
      'medications': medication,
      'children': children
    };

    print('HealthINFO ==>$body');
    final response = await http
        .post(Uri.parse('${URLS.BASE_URL}/api/patient-two'), body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return response.statusCode;
    }
  }

  static Future patienPriorSurgery(surgery, year) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var body = {
      'user_id': prefs.getString('user_id').toString(),
      'surgery_name': surgery,
      'year_done': year
    };

    print('PriorSurgeryINFO ==>$body');
    final response = await http.post(
        Uri.parse('${URLS.BASE_URL}/api/patient-two-prior-surgery'),
        body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return response.statusCode;
    }
  }
  /////////////////////////////////////////////////////////////////

  static Future patientTreatmentNeed(
      surgery, problem, outcomes, bodyPartImages) async {
    // print('here==>$bodyPartImages');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var request = http.MultipartRequest(
        'POST', Uri.parse('${URLS.BASE_URL}/api/patient-three'));

    request.fields.addAll({
      'user_id': prefs.getString('user_id').toString(),
      'to_be_improved': surgery,
      'problem': problem,
      'desired_outcome': outcomes,
    });
    final List<http.MultipartFile> photos1 = <http.MultipartFile>[];
    if (bodyPartImages != null && bodyPartImages.length > 0) {
      await Future.forEach(bodyPartImages!, (XFile file) async {
        var photo = await http.MultipartFile.fromPath("images", file.path);
        photos1.add(photo);
        // print(file.path);
      });
      print(photos1);
    }
    request.files.addAll(photos1);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(await response.stream.bytesToString());
      print("Deoced Response ==> $decodedResponse");
      return decodedResponse;
    } else {
      return response.reasonPhrase;
    }
  }

  // static Future patientTreatmentNeed(surgery, problem, outcomes,images) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var body = {
  //     'user_id': prefs.getString('user_id').toString(),
  //     'to_be_improved': surgery,
  //     'problem': problem,
  //     'desired_outcome': outcomes,
  //     'images' :  images
  //   };

  //   print('patientTreatmentNeedINFO ==>$body');
  //   final response = await http
  //       .post(Uri.parse('${URLS.BASE_URL}/api/patient-three'), body: body);

  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body);
  //   } else {
  //     return response.statusCode;
  //   }
  // }

  static Future dreamSurgeon(
      surgeryTime, willingToTravel, medicalClearance, opinionPool) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var body = {
      'user_id': prefs.getString('user_id').toString(),
      'time_of_surgery': surgeryTime,
      //'time_extra_info': 'sunday',
      'willing_to_travel': willingToTravel,
      'get_medical_clearance': medicalClearance,
      'submitted_to_doctor_opinion_pool': opinionPool == 'Yes' ? '1' : '0'
    };

    print('patientTreatmentNeedINFO ==>$body');
    final response = await http
        .post(Uri.parse('${URLS.BASE_URL}/api/patient-four'), body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return response.statusCode;
    }
  }

  static Future patientWishList(
      doctorName, doctorname, doctorId, doctorEmail, state, city) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var body = {
      'user_id': prefs.getString('user_id').toString(),
      'doctor_id': '$doctorId',
      'doctor_name': doctorname == 'None' ? doctorName : doctorname,
      'doctor_email': doctorEmail,
      'state': state,
      'city': city
    };

    print('patientTreatmentNeedINFO ==>$body');
    final response = await http
        .post(Uri.parse('${URLS.BASE_URL}/api/patient-wishlist'), body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return response.statusCode;
    }
  }

  static Future patientList() async {
    final response =
        await http.get(Uri.parse('${URLS.BASE_URL}/api/patients-list'));

    if (response.statusCode == 200) {
      var responseJson = jsonDecode(response.body);
      return responseJson;
    } else {
      return response.statusCode;
    }
  }

  static Future patientDetails(userId) async {
    // print('USERID==> $userId');
    final response = await http
        .get(Uri.parse('${URLS.BASE_URL}/api/patient-details/$userId'));

    if (response.statusCode == 200) {
      //print('${URLS.BASE_URL}/api/patient-details/$userId');
      var responseJson = jsonDecode(response.body);
      return responseJson;
    } else {
      return response.statusCode;
    }
  }

  static Future doctorDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // print('USERID==> $userId');
    final response = await http.get(Uri.parse(
        '${URLS.BASE_URL}/api/doctor-details/${prefs.getString('user_id')}'));

    if (response.statusCode == 200) {
      //print('${URLS.BASE_URL}/api/patient-details/$userId');
      var responseJson = jsonDecode(response.body);
      return responseJson;
    } else {
      return response.statusCode;
    }
  }

  static Future doctorDetailsSeenByPatient(doctorID) async {
    // print('USERID==> $doctorID');
    final response = await http
        .get(Uri.parse('${URLS.BASE_URL}/api/doctor-details/$doctorID'));

    if (response.statusCode == 200) {
      var responseJson = jsonDecode(response.body);
      return responseJson;
    } else {
      return response.statusCode;
    }
  }

  static Future patientProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(Uri.parse(
        '${URLS.BASE_URL}/api/patient-details/${prefs.getString('user_id').toString()}'));

    if (response.statusCode == 200) {
      //print('${URLS.BASE_URL}/api/patient-details/$userId');
      var responseJson = jsonDecode(response.body);
      return responseJson;
    } else {
      return response.statusCode;
    }
  }

  static Future doctorBidding(patientID, amount, video, date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var request = http.MultipartRequest(
        'POST', Uri.parse('${URLS.BASE_URL}/api/doctor-bid'));

    request.fields.addAll({
      'doctor_user_id': prefs.getString('user_id').toString(),
      'patient_user_id': patientID.toString(),
      'doctor_offer': amount,
      'doctor_offer_time': date
    });
    request.files.add(await http.MultipartFile.fromPath('doctor_video', video));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(await response.stream.bytesToString());
      print("Deoced Response ==> $decodedResponse");
      return decodedResponse;
    } else {
      return response.reasonPhrase;
    }
  }

  static Future patientBidList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http.get(Uri.parse(
        '${URLS.BASE_URL}/api/patient-bid-list/${prefs.getString('user_id').toString()}'));

    if (response.statusCode == 200) {
      var responseJson = jsonDecode(response.body);
      return responseJson;
    } else {
      return response.statusCode;
    }
  }

  static Future acceptBidOffer(notificationId, doctorID, status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var body = {
      'patient_user_id': prefs.getString('user_id').toString(),
      'doctor_user_id': '$doctorID',
      'is_offer_accepted': '$status',
      'id': '$notificationId'
    };

    print('doctorBidding ==>$body');
    final response = await http
        .post(Uri.parse('${URLS.BASE_URL}/api/patient-bid'), body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return response.statusCode;
    }
  }

  static Future counterBidOffer(
      notificationId, status, doctorID, counterOffer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var body = {
      'patient_user_id': prefs.getString('user_id').toString(),
      'doctor_user_id': '$doctorID',
      'is_offer_accepted': '$status',
      'counter_offer': '$counterOffer',
      'id': '$notificationId'
    };

    print('doctorBidding ==>$body');
    final response = await http
        .post(Uri.parse('${URLS.BASE_URL}/api/patient-bid'), body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return response.statusCode;
    }
  }

  static Future rejectBidOffer(notificationId, doctorID, status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var body = {
      'patient_user_id': prefs.getString('user_id').toString(),
      'doctor_user_id': '$doctorID',
      'is_offer_accepted': '$status',
      'id': '$notificationId'
    };

    print('doctorBidding ==>$body');
    final response = await http
        .post(Uri.parse('${URLS.BASE_URL}/api/patient-bid'), body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return response.statusCode;
    }
  }

  static Future doctorBidList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http.get(Uri.parse(
        '${URLS.BASE_URL}/api/doctor-bid-list/${prefs.getString('user_id').toString()}'));

    if (response.statusCode == 200) {
      var responseJson = jsonDecode(response.body);
      return responseJson;
    } else {
      return response.statusCode;
    }
  }

  static Future acceptCounterOfferByDoctor(notificationId, status) async {
    var body = {
      'id': '$notificationId',
      'is_offer_accepted': '$status',
    };

    print('doctorBidding ==>$body');
    final response = await http.post(
        Uri.parse('${URLS.BASE_URL}/api/doctor-bid-response'),
        body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return response.statusCode;
    }
  }

  static Future rejectCounterOfferByDoctor(notificationId, status) async {
    var body = {
      'id': '$notificationId',
      'is_offer_accepted': '$status',
    };

    print('doctorBidding ==>$body');
    final response = await http.post(
        Uri.parse('${URLS.BASE_URL}/api/doctor-bid-response'),
        body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return response.statusCode;
    }
  }

  static Future doctorMakePost(makePost, latitude, longitude) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var body = {
      'doctor_id': prefs.getString('user_id').toString(),
      'post': makePost,
      'latitude': '$latitude',
      'longitude': '$longitude'
    };

    print('MakePostBody ==>$body');
    final response = await http
        .post(Uri.parse('${URLS.BASE_URL}/api/make-post'), body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return response.statusCode;
    }
  }

  static Future doctorPost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http.get(Uri.parse(
        '${URLS.BASE_URL}/api/doctor-posts/${prefs.getString('user_id').toString()}'));

    if (response.statusCode == 200) {
      var responseJson = jsonDecode(response.body);
      return responseJson;
    } else {
      return response.statusCode;
    }
  }

  static Future postForPatient() async {
    final response =
        await http.get(Uri.parse('${URLS.BASE_URL}/api/get-posts'));

    if (response.statusCode == 200) {
      var responseJson = jsonDecode(response.body);
      return responseJson;
    } else {
      return response.statusCode;
    }
  }

  static Future doctorList() async {
    final response =
        await http.get(Uri.parse('${URLS.BASE_URL}/api/doctor-list'));

    if (response.statusCode == 200) {
      var responseJson = jsonDecode(response.body);
      return responseJson;
    } else {
      return response.statusCode;
    }
  }

  static Future patientOpinionPool(question, options, image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var request = http.MultipartRequest(
        'POST', Uri.parse('${URLS.BASE_URL}/api/opinion-pool'));

    request.fields.addAll({
      'patient_id': prefs.getString('user_id').toString(),
      'question': question,
      'options': options
    });
    print('question==> $question');
    print('options==> $options');
    print('image==> $image');

    request.files
        .add(await http.MultipartFile.fromPath('opinion_pool_pic', image));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var decodedResponse = jsonDecode(await response.stream.bytesToString());
      print("Deoced Response ==> $decodedResponse");
      return decodedResponse;
    } else {
      return response.reasonPhrase;
    }
  }

  static Future allOpinionPool() async {
    final response =
        await http.get(Uri.parse('${URLS.BASE_URL}/api/opinion-pool-list'));

    if (response.statusCode == 200) {
      var responseJson = jsonDecode(response.body);
      return responseJson;
    } else {
      return response.statusCode;
    }
  }

  static Future getNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http.get(Uri.parse(
        '${URLS.BASE_URL}/api/get-notifications/${prefs.getString('user_id').toString()}'));

    if (response.statusCode == 200) {
      var responseJson = jsonDecode(response.body);
      return responseJson;
    } else {
      return response.statusCode;
    }
  }

  static Future doctorOfficeTiming(selectedDay, selectedTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var body = {
      'user_id': prefs.getString('user_id').toString(),
      'open_days': selectedDay,
      'open_timings': selectedTime
    };

    print('timing ==>$body');
    final response = await http.post(
        Uri.parse('${URLS.BASE_URL}/api/doctor-office-timings'),
        body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return response.statusCode;
    }
  }

  static Future updatevote(opinionPoolId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var body = {
      'doctor_id': prefs.getString('user_id').toString(),
      'opinion_pool_id': opinionPoolId.toString()
    };

    // print('${URLS.BASE_URL}/api/doctor-vote-opinion-pool_timing ==>$body');
    final response = await http.post(
        Uri.parse('${URLS.BASE_URL}/api/doctor-vote-opinion-pool'),
        body: body);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return response.statusCode;
    }
  }

  static Future selectedItems(selectedItems) async {
    var url = 'https://qa.dznify.com/bestsellerproducts';
    // var url = 'https://jsonplaceholder.typicode.com/posts';

    final response = await http.get(
      Uri.parse(url),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return response.statusCode;
    }
  }
}
