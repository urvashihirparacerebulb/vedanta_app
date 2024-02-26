import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:vedanta_app/configuration/api_service.dart';
import 'package:vedanta_app/view/power_balance_view.dart';
import '../common_method/common_methods.dart';
import '../constant/constants.dart';
import '../login/login_view.dart';
import '../utility/colors_utility.dart';
import '../utility/common_widgets.dart';

class SectorDetailPage extends StatefulWidget {
  const SectorDetailPage({Key? key}) : super(key: key);

  @override
  State<SectorDetailPage> createState() => _SectorDetailPageState();
}

class _SectorDetailPageState extends State<SectorDetailPage> {

  DateTime time = DateTime.now();
  Timer? timer;

  @override
  void initState() {
    callRefresh();
    super.initState();
  }

  callRefresh(){
    timer = Timer.periodic(const Duration(seconds: 30), (Timer t) {
      setState(() {
        time = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }


  totalProgress({String link1 = "", bool isGrossGeneration = false}){
    return Expanded(
        child: FutureBuilder(
            future: linkWiseAPICall(link1),
            builder: (context, data1) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                height: 175,
                decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        whiteColor,
                        Color(0xFFF1F7EA),
                      ],
                    )
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    commonVerticalSpacing(spacing: 8),
                    SizedBox(
                      height: 100,
                      child: SfRadialGauge(
                        axes: <RadialAxis>[
                          RadialAxis(
                              pointers: <GaugePointer>[
                                RangePointer(
                                  width: 10,
                                  value: data1.data == null || data1.data == "Error" ? 0 : double.parse(data1.data.toString()) * 100 / 3015,
                                  gradient: const SweepGradient(
                                      colors: <Color>[appColor, borderColor],
                                      stops: <double>[0.25, 0.75]
                                  ),
                                ),
                              ],endAngle: 90,
                              startAngle: 90,
                              showLabels: false,
                              showTicks: false,
                              annotations: <GaugeAnnotation>[
                                GaugeAnnotation(widget: Text('${data1.data == null || data1.data == "Error" ? 0 : double.parse(data1.data.toString()).round()}\n MW',style: const TextStyle(fontSize: 13,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                                    angle: 90, positionFactor: 0.2
                                )]
                          )],
                      ),
                    ),
                    commonVerticalSpacing(),
                    Text(isGrossGeneration ? "Gross\nGeneration" : "Net\nGeneration",style: const TextStyle(
                        color: blackColor,fontSize: 15, fontWeight: FontWeight.w500
                    ),textAlign: TextAlign.center,),
                  ],
                ),
              );
            },
        )
    );
  }

  potsAndPlantsSum({String link1 = "", bool isPots = false}){
    return FutureBuilder(
        future: linkWiseAPICall(link1),
        builder: (context, data1) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(isPots ? "No. of Pots" : "Total Units Running",
                    style: const TextStyle(fontSize: 15,
                        fontWeight: FontWeight.w400
                    )),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text:'${data1.data == null || data1.data == "Error" ? 0 : double.parse(data1.data.toString()).round()}',style: const TextStyle(fontSize: 13,fontWeight: FontWeight.bold)),
                      const TextSpan(
                        text: ' / ',
                        style: TextStyle(color: blackColor,
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                      TextSpan(text: isPots ? "1930" : "22",style: const TextStyle(color: blackColor,
                          fontSize: 15, fontWeight: FontWeight.w500)),
                    ],
                  ),
                )
              ],
            ),
          );
        },
    );
  }

  smelterConsView({String link1 = ""}){
    return FutureBuilder(
      future: linkWiseAPICall(link1),
      builder: (context, data) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Smelter Cons",
                  style: TextStyle(fontSize: 15,
                      fontWeight: FontWeight.w400
                  )),
              Text(data.data == null || data.data == "Error" ? "0" : double.parse(data.data.toString()).round().toString(), style: TextStyle(color: AwesomeExtensions().isNegative(data.data == null || data.data == "Error" ? 0 : double.parse(data.data.toString()).round()) ? Colors.red : appColor,
                  fontSize: 15, fontWeight: FontWeight.w700)),
            ],
          ),
        );
      },
    );
  }

  importExportView({String link1 = "", link2}){
    return FutureBuilder(
        future: linkWiseAPICall(link1),
        builder: (context, data1) {
          return FutureBuilder(
              future: linkWiseAPICall(link2),
              builder: (context, data2) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Exp/Imp",
                          style: TextStyle(fontSize: 15,
                              fontWeight: FontWeight.w400
                          )),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(text: data1.data == null || data1.data == "Error" ? "0" : double.parse(data1.data.toString()).round().toString(),style: TextStyle(color: AwesomeExtensions().isNegative(data1.data == null || data1.data == "Error" ? 0 : double.parse(data1.data.toString())) ? Colors.red : appColor,
                                fontSize: 15, fontWeight: FontWeight.w700)),
                            const TextSpan(
                              text: ' / ',
                              style: TextStyle(color: appColor,
                                  fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                            TextSpan(text: data2.data == null || data2.data == "Error" ? "0" : double.parse(data2.data.toString()).round().toString(),style: TextStyle(color: AwesomeExtensions().isNegative(data2.data == null || data2.data == "Error" ? 0 : double.parse(data2.data.toString())) ? Colors.red : appColor,
                                fontSize: 15, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
          );
        },
    );
  }

  Future<void> refreshData() async {
    setState(() {
      time = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: ListView(
          shrinkWrap: true,
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: 150,
                  width: Get.width,
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage("assets/images/header_bg.png")
                      )
                  ),
                ),
                Positioned(
                    bottom: -20,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: whiteColor,
                          border: Border.all(
                              color: borderColor
                          )
                      ),
                      child: Row(
                        children: [
                          Image.asset('assets/images/calender.png'),
                          commonHorizontalSpacing(),
                          Column(
                            children: [
                              Text(
                                "${time.day}/${time.month}/${time.year}  •  ${time.hour}:${time.minute}:${time.second}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,fontSize: 15
                                ),
                              ),

                              const Text(
                                "(Data Auto Updating 30 Sec)",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,fontSize: 10
                                ),
                              ),
                            ],
                          )

                        ],
                      ),
                    )
                ),
                Positioned(
                    top: 20,right: 18,left: 18,child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Row(
                        children: [
                          Image.asset('assets/images/dummy_profile.png',height: 30),
                          commonHorizontalSpacing(),
                          const Text(
                            loginEmpId,
                            style: TextStyle(
                                color: whiteColor,
                                fontWeight: FontWeight.w500,fontSize: 15
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        setIsLogin(isLogin: false);
                        setLoginTime();
                        Get.offAll(() => const LoginView());
                      },
                      child: const Text(
                        "Logout",
                        style: TextStyle(
                            color: whiteColor,
                            fontWeight: FontWeight.w400,fontSize: 14
                        ),
                      ),
                    ),

                  ],
                )),
                Positioned(top: 70,
                    left: 15,child: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(Icons.arrow_back_sharp, color: whiteColor))),

                const Positioned(
                    top: 70,
                    child: Text(
                      "Aluminium Sector",
                      style: TextStyle(
                          color: whiteColor,
                          fontWeight: FontWeight.w500,fontSize: 20
                      ),
                      textAlign: TextAlign.center,
                    )
                ),
              ],
            ),
            commonVerticalSpacing(spacing: 40),
            const Text(
              "Total 4155 MW CPP",
              // : "STATION MW",
              style: TextStyle(
                  fontWeight: FontWeight.w500,fontSize: 20,color: appColor
              ),
              textAlign: TextAlign.center,
            ),
            commonVerticalSpacing(),
            Row(
              children: [
                totalProgress(
                    isGrossGeneration: true,
                  link1: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAApPSaWSP0vkaMsW3Uog3hVgT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xTRUNUT1JfVE9UQUxfTVdfR1JPU1NfR0VO/value"
                ),
                totalProgress(
                  link1: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAA4W2-DXsl5UqvIQyGh0jisgT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xTRUNUT1JfVE9UQUxfTVdfTkVUX0dFTg/value"
                ),
              ],
            ),
            commonVerticalSpacing(),
            smelterConsView(
              link1: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAkWnLd78NQUqtRqnZnO7KMQT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xTRUNUT1JfVE9UQUxfTVdfU01FTFRFUl9DT05TVU1QVElPTg/value"
            ),
            importExportView(
              link1: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAkeIJcExf0ESfVxbT2hwRAAT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xTRUNUT1JfVE9UQUxfTVdfRVhQ/value",
              link2: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAyXMJeYfxiU-mKDnu7hD_5wT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xTRUNUT1JfVE9UQUxfTVdfSU1Q/value"
            ),
            commonVerticalSpacing(),
            const Text(
              "Total 1200 MW IPP",
              // : "STATION MW",
              style: TextStyle(
                  fontWeight: FontWeight.w500,fontSize: 20,color: appColor
              ),
              textAlign: TextAlign.center,
            ),
            commonVerticalSpacing(),
            Row(
              children: [
                totalProgress(
                  isGrossGeneration: true,
                  link1: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAnXCWwyPnOkSkrSK_rfK92AT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xTRUNUT1JfVE9UQUxfSVBQX01XX0dST1NT/value"
                ),
                totalProgress(
                  link1: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAGhsWh9tKH0ys8HVvjfP6oAT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xTRUNUT1JfVE9UQUxfSVBQX05FVF9HRU4/value"
                ),
              ],
            ),
            commonVerticalSpacing(),
            potsAndPlantsSum(
              link1: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAxj77BpmwXUiNFPWQ6xOi1QT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xTRUNUT1JfVE9UQUxfSVBQX0FDVElWRVVOSVRT/value"
            ),
            potsAndPlantsSum(isPots: true,
              link1: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAA1LtIMHCx4EqGjU4NdoFTfAT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xTRUNUT1JfVE9UQUxfQUNUVUFMX1BPVFM/value"
            ),
            commonVerticalSpacing(spacing: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(child: InkWell(onTap: (){
                    Get.to(() => const PowerBalanceView());
                  },child: Image.asset('assets/images/jharsuguda.png'))),
                  commonHorizontalSpacing(),
                  Expanded(child: Image.asset('assets/images/balco.png')),
                  commonHorizontalSpacing(),
                  Expanded(child: Image.asset('assets/images/lanjigarh.png')),
                ],
              ),
            ),
            commonVerticalSpacing(spacing: 40),
          ],
        ),
      ),
    );
  }
}
