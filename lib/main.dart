import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:vedanta_app/view/splash_screen.dart';

import 'common_method/common_methods.dart';
import 'login/login_view.dart';

final getPreferences = GetStorage();

pref() async {
  await GetStorage.init();
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await pref();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Vedanta App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Timer timer;

  @override
  void initState() {
    setLoginTime(time: DateTime.now().toString());
    timerSetting();
    super.initState();
  }

  timerSetting(){
    timer = Timer.periodic(const Duration(minutes: 4), (timer) {
      if(getLoginTime() != "") {
        var loginDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(getLoginTime());
        var currentDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(
            DateTime.now().toString());
        if (currentDate
            .difference(loginDate)
            .inMinutes > 5) {
          setIsLogin(isLogin: false);
          setLoginTime();
          Get.offAll(() => const LoginView());
        }
      }
    });
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _timer.cancel();
  // }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
