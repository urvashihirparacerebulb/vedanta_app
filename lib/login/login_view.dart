import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vedanta_app/utility/common_widgets.dart';

import '../utility/colors_utility.dart';
import '../common_method/common_methods.dart';
import '../constant/constants.dart';
import '../view/sector_detail_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _loginScreenForm = GlobalKey<FormState>();
  final TextEditingController employeeId = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool isRemember = true;

  @override
  void initState() {
    super.initState();
    if(getIsRememberMe()){
      setState(() {
        employeeId.text = getRememberedEmail();
        password.text = getRememberedPassword();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: appColor,
        body: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  children: [
                    Image.asset('assets/images/app_logo.png',height: 100),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Sign in to Your Account',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: whiteColor,
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Form(
                    key: _loginScreenForm,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Employee Id',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: bgColor,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: employeeId,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: whiteColor,
                            hintText: 'Employee Id',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 20,
                            ),
                          ),
                          onChanged: (String text){
                            if(getIsRememberMe()){
                              setRememberedEmail(email: text);
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Password',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: bgColor,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: password,
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: whiteColor,
                            hintText: '* * * * * *',
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 20,
                            ),
                          ),
                          onChanged: (String value){
                            if(getIsRememberMe()){
                              setRememberedPassword(password: value);
                            }
                          },
                        ),
                        commonVerticalSpacing(spacing: 10),

                        StatefulBuilder(builder: (context, newSetState) => Row(
                          children: [
                            InkWell(
                                onTap: (){
                                  newSetState((){
                                    isRemember = !isRemember;
                                    setIsRememberMe(isRemember: isRemember);
                                    if(isRemember){
                                      if(employeeId.text.isNotEmpty && password.text.isNotEmpty){
                                        setRememberedEmail(email: employeeId.text);
                                        setRememberedPassword(password: password.text);
                                      }
                                    }
                                  });
                                },
                                child: Image.asset(getIsRememberMe() ? "assets/images/remember_checked.png" : "assets/images/remember_unchecked.png",
                                    width: 20,height: 20,
                                    color: whiteColor)
                            ),
                            commonHorizontalSpacing(spacing: 6),
                            const Text("Remember Me",style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.normal,color: whiteColor
                            )),
                          ],
                        )),
                        commonVerticalSpacing(spacing: 30),
                        Container(
                          decoration: BoxDecoration(
                            color: bgColor,
                              borderRadius: BorderRadius.circular(4)
                          ),
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextButton(
                            onPressed: () {
                              if(kDebugMode){
                                setIsLogin(isLogin: true);
                                Get.offAll(() => const SectorDetailPage());
                              }else {
                                if (employeeId.text.isNotEmpty) {
                                  if (password.text.isNotEmpty) {
                                    if (employeeId.text == loginEmpId &&
                                        password.text == loginPass) {
                                      setIsLogin(isLogin: true);
                                      setLoginTime(time: DateTime.now().toString());
                                      Get.offAll(() => const SectorDetailPage());
                                    } else {
                                      showSnackBar(
                                          message: "Wrong credentials");
                                    }
                                  } else {
                                    showSnackBar(
                                        message: "Password must not be empty");
                                  }
                                } else {
                                  showSnackBar(
                                      message: "Employee id must not be empty");
                                }
                              }
                            },
                            style: ButtonStyle(
                              side: MaterialStateProperty.all(
                                  BorderSide.none),
                              shadowColor: MaterialStateProperty.all(
                                  Colors.transparent),
                              overlayColor: MaterialStateProperty.all(
                                  Colors.transparent),
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(vertical: 22),
                              ),
                            ),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                  color: appColor
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
