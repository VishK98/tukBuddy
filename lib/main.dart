import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_windowmanager/flutter_windowmanager.dart';

import 'package:tuk_boddy/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  void initState() {
    // disableCapture();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // initialRoute: 'SplashScreen',
      initialRoute: 'WelComeScreen',

      routes: route,
    );
  }

  // Future<void> disableCapture() async {
  //   //disable screenshots and record screen in current screen
  //   await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  // }
}
