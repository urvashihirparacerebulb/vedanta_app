import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vedanta_app/utility/colors_utility.dart';
import 'package:vedanta_app/view/sector_detail_view.dart';
import '../../login/login_view.dart';
import '../common_method/common_methods.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Timer(const Duration(seconds: 2), () {
      if (getIsLogin()) {
        Get.off(() => const SectorDetailPage());
      } else {
        Get.off(() => const LoginView());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: Get.height,
          width: Get.width,
          decoration: const BoxDecoration(
            color: appColor,
          ),
          child: Center(
            child: Image.asset('assets/images/app_logo.png',height: 100),
          ),
        ),
      ),
    );
  }
}
