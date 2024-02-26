
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constant/constants.dart';
import '../main.dart';
import '../utility/colors_utility.dart';

setIsLogin({required bool isLogin}) {
  getPreferences.write('isLogin', isLogin);
}

bool getIsLogin() {
  return (getPreferences.read('isLogin') ?? false);
}

setRememberedEmail({required String email}) {
  getPreferences.write('email', email);
}

String getRememberedEmail() {
  return (getPreferences.read('email') ?? "");
}

setRememberedPassword({required String password}) {
  getPreferences.write('password', password);
}

String getRememberedPassword() {
  return (getPreferences.read('password') ?? "");
}

setIsRememberMe({required bool isRemember}) {
  getPreferences.write('isRememberMe', isRemember);
}

bool getIsRememberMe() {
  return (getPreferences.read('isRememberMe') ?? false);
}

setLoginTime({String time = ""}) {
  getPreferences.write('loginTime',time);
}

String getLoginTime() {
  return (getPreferences.read('loginTime') ?? "");
}


showSnackBar({String title = "", required String message}) {
  return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: title.isEmpty || title == warning
          ? const Color(0xffFFCC00)
          : title == success
          ? Colors.green
          : Colors.red,
      textColor: whiteColor,
      fontSize: 12.0);
}
 class AwesomeExtensions {
  bool isPositive(num number) {
    return number > 0;
  }

  bool isNegative(num number) {
    return number < 0;
  }

}