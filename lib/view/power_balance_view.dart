import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:vedanta_app/utility/colors_utility.dart';
import 'package:vedanta_app/view/power_balance_detail.dart';
import '../common_method/common_methods.dart';
import '../configuration/api_service.dart';
import '../utility/common_widgets.dart';
import '../constant/constants.dart';

class PowerBalanceView extends StatefulWidget {
  const PowerBalanceView({Key? key}) : super(key: key);

  @override
  State<PowerBalanceView> createState() => _PowerBalanceViewState();
}

class _PowerBalanceViewState extends State<PowerBalanceView> {

  num totalGross = 0.0;
  num totalNet = 0.0;
  num totalSmelter = 0.0;
  String totalExp = "0";

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


  commonView({String title = "", link = ""}){
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
          link == "" ? const Text("---", style: TextStyle(color: appColor,fontSize: 15, fontWeight: FontWeight.w400)) :
          FutureBuilder(
              future: linkWiseAPICall(link),
              builder: (context, data) {
                return Text(data.data == null || data.data == "Error" ? "0" : double.parse(data.data.toString()).round().toStringAsFixed(2), style: TextStyle(color: AwesomeExtensions().isNegative(data.data == null || data.data == "Error" ? 0 : double.parse(data.data.toString()).round()) ? Colors.red : appColor,
                    fontSize: 15, fontWeight: FontWeight.w700));
              }
          ),
        ],
      ),
    );
  }

  smelterAndExpSum({String link1 = "", link2, bool isExp = false}){
    return FutureBuilder(
        future: linkWiseAPICall(link1),
      builder: (context, data1) {
        return FutureBuilder(
          future: linkWiseAPICall(link2),
          builder: (context, data2) {
            if(isExp) {
              totalExp = "${(data1.data == null || data1.data == "Error" ? 0 : double.parse(data1.data.toString()).round())}/${(data2.data == null || data2.data == "Error" ? 0 : double.parse(data2.data.toString()).round())}";
            }else{
              totalSmelter =
                  (data1.data == null || data1.data == "Error" ? 0 : double
                      .parse(data1.data.toString()).round()) +
                      (data2.data == null || data2.data == "Error" ? 0 : double
                          .parse(data2.data.toString()).round());
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 6),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(isExp ? "Exp/Imp" : "Smelter Cons",
                      style: const TextStyle(fontSize: 15,
                          fontWeight: FontWeight.w400
                      )),
                  isExp ? Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: totalExp.split("/")[0],style: TextStyle(color: AwesomeExtensions().isNegative(num.parse(totalExp.split("/")[0])) ? Colors.red : appColor,
                            fontSize: 15, fontWeight: FontWeight.w700)),
                        const TextSpan(
                          text: ' / ',
                          style: TextStyle(color: appColor,
                            fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                        TextSpan(text: totalExp.split("/")[1],style: TextStyle(color: AwesomeExtensions().isNegative(num.parse(totalExp.split("/")[1])) ? Colors.red : appColor,
                            fontSize: 15, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ) :
                  Text((totalSmelter).toString(),
                      style: TextStyle(color: AwesomeExtensions().isNegative((totalSmelter)) ? Colors.red : appColor,
                          fontSize: 15, fontWeight: FontWeight.w700))
                ],
              ),
            );
          },
        );
    });
  }

  totalProgress({String link1 = "", link2, bool isGrossGeneration = false}){
    return Expanded(
      child: FutureBuilder(
          future: linkWiseAPICall(link1),
          builder: (context, data1) {
            return FutureBuilder(
                future: linkWiseAPICall(link2),
                builder: (context, data2) {
                  if(isGrossGeneration){
                    totalGross = (data1.data == null || data1.data == "Error" ? 0 : double.parse(data1.data.toString()).round()) + (data2.data == null || data2.data == "Error" ? 0 : double.parse(data2.data.toString()).round());
                  }else{
                    totalNet = (data1.data == null || data1.data == "Error" ? 0 : double.parse(data1.data.toString()).round()) + (data2.data == null || data2.data == "Error" ? 0 : double.parse(data2.data.toString()).round());
                  }
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
                                      value: (isGrossGeneration ? totalGross : totalNet) * 100 / 3015,
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
                                    GaugeAnnotation(widget: Text('${(isGrossGeneration ? totalGross : totalNet).toString()}\n MW',style: const TextStyle(fontSize: 13,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
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
                }
            );
          }
      )
    );
  }

  progressView({String link = "", int? index}) {
    return SizedBox(
      height: 100,
      child: FutureBuilder(
          future: linkWiseAPICall(link),
          builder: (context, data) {
            return SfRadialGauge(
              axes: <RadialAxis>[
                RadialAxis(
                    pointers: <GaugePointer>[
                      RangePointer(
                        width: 10,
                        value: (data.data == null || data.data == "Error" ? 0 : double.parse(data.data.toString())) * 100 / (index == 0 ? 1800 : index == 1 ? 1215 : 600),
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
                      GaugeAnnotation(widget: Text(data.data == null || data.data == "Error" ? "0" : double.parse(data.data.toString()).round().toString(),style: const TextStyle(fontSize: 13,fontWeight: FontWeight.bold),textAlign: TextAlign.center),
                          angle: 90, positionFactor: 0.2
                      )]
                )],
            );
          }
      ),
    );
  }

  generationView({String link1 = "", link2, int? index}){
    return Row(
      children: [
        Expanded(child: InkWell(
          onTap: (){
            if(index == 0 || index == 1){
              Get.to(() => PowerBalanceDetail(
                  title: index == 0 ? "CPP 1800 MW\nGross Generation" : "CPP 1215 MW\nGross Generation",
                grossNetTitles: index == 0 ? [
                  "Unit 01", "Unit 03", "Unit 04"
                ] : ["Unit 01", "Unit 02", "Unit 03", "Unit 04", "Unit 05", "Unit 06", "Unit 07", "Unit 08", "Unit 09"],
                grossNetGens: index == 0 ? [
                  "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAWCLn7nVpKEajT9j8I2w7AAT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xJUFAgR1JPU1MgR0VORVJBVElPTiBVMQ/value",
                  "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAA3uxnATIv4UW9T6m9BNrV1AT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xJUFAgR1JPU1MgR0VORVJBVElPTiBVMw/value",
                  "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAfTYVe9PPnkqQr4_FSnSRoAT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xJUFAgR1JPU1MgR0VORVJBVElPTiBVNA/value"
                ] : [
                  "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAALliIZNlPsEuz8Icz8S7JZwT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xDUFAgR1JPU1MgR0VORVJBVElPTiBVMQ/value",
                  "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAmyhtyVSuNU-BISwAtZrUZwT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xDUFAgR1JPU1MgR0VORVJBVElPTiBVMg/value",
                  "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAFu1qvMqh_0K81gpwBsoPOgT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xDUFAgR1JPU1MgR0VORVJBVElPTiBVMw/value",
                  "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAK7w8JtOtbEGHzvirzdWleQT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xDUFAgR1JPU1MgR0VORVJBVElPTiBVNA/value",
                  "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAN9la1gkl00u3hOE9Alvz1gT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xDUFAgR1JPU1MgR0VORVJBVElPTiBVNQ/value",
                  "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAA1NFKt0r530ykJtAr7qUhrQT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xDUFAgR1JPU1MgR0VORVJBVElPTiBVNg/value",
                  "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAA2gMLPbibU0iCpJw-XFm_AwT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xDUFAgR1JPU1MgR0VORVJBVElPTiBVNw/value",
                  "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAA44pPiBn0bEWW5taU3pRrgwT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xDUFAgR1JPU1MgR0VORVJBVElPTiBVOA/value",
                  "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAnh3ASliISU-tPOUpWq6MOwT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xDUFAgR1JPU1MgR0VORVJBVElPTiBVOQ/value"
                ],
              ));
            }
          },
          child: Container(
            height: 170,
            decoration: BoxDecoration(
                color: whiteColor,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                progressView(link: link1,index: index),
                commonVerticalSpacing(),
                const Text("Gross\nGeneration",style: TextStyle(
                    color: blackColor,fontSize: 15, fontWeight: FontWeight.w500
                ),textAlign: TextAlign.center,),
              ],
            ),
          ),
        )),
        commonHorizontalSpacing(spacing: 15),
        Expanded(child: InkWell(
          onTap: (){
            if(index == 0 || index == 1){
              Get.to(() => PowerBalanceDetail(
                title: index == 0 ? "CPP 1800 MW\nNet Generation" : "CPP 1215 MW\nNet Generation",
                grossNetGens: index == 0 ? [
                  "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAhxUcM5oXIE-myHS4HUbzNgT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xJUFAgTkVUIEdFTkVSQVRJT04gVTE/value",
                  "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAA4KrNZ9ubiUiiplXoQRlXswT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xJUFAgTkVUIEdFTkVSQVRJT04gVTM/value",
                  "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAApdv-mau5Ok6OJIIevrUnywT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xJUFAgTkVUIEdFTkVSQVRJT04gVTQ/value"
                ] : [
                  "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAosQaSve3oEWlWK0tAfMBEwT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xDUFAgTkVUIEdFTkVSQVRJT04gVTE/value",
                  "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAqlAZlNtWGkq3vAhw9gGHsQT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xDUFAgTkVUIEdFTkVSQVRJT04gVTI/value",
                  "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAUw9VhwR-y0qQb8BnCpIYkQT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xDUFAgTkVUIEdFTkVSQVRJT04gVTM/value",
                  "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAvBhVxQgW7ESKQAXH9gXb0AT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xDUFAgTkVUIEdFTkVSQVRJT04gVTQ/value",
                  "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAnal1BIROuEaal_QMBM_RlgT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xDUFAgTkVUIEdFTkVSQVRJT04gVTU/value",
                  "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAA2f9jbrrNoEGFBsQaoMLMkAT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xDUFAgTkVUIEdFTkVSQVRJT04gVTY/value",
                  "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAFLRk_4e4hk-k2bQ8CtAA3wT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xDUFAgTkVUIEdFTkVSQVRJT04gVTc/value",
                  "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAATLvuoGaAFkG8vKNepnGRQgT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xDUFAgTkVUIEdFTkVSQVRJT04gVTg/value",
                  "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAA6s6zMN6hCUSiRTm3NKaygwT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xDUFAgTkVUIEdFTkVSQVRJT04gVTk/value"
                ],
                grossNetTitles: index == 0 ? [
                  "Unit 01", "Unit 03", "Unit 04"
                ] : ["Unit 01", "Unit 02", "Unit 03", "Unit 04", "Unit 05", "Unit 06", "Unit 07", "Unit 08", "Unit 09"],
              ));
            }
          },
          child: Container(
            height: 170,
            decoration: BoxDecoration(
                color: whiteColor,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                progressView(link: link2,index: index),
                commonVerticalSpacing(),
                const Text("Net\nGeneration",style: TextStyle(
                    color: blackColor,fontSize: 15, fontWeight: FontWeight.w500
                ),textAlign: TextAlign.center,),
              ],
            ),
          ),
        )),
      ],
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
                    top: 20,left: 18,child: Row(
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
                      ],
                    )),
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
                    top: 70,
                    left: 15,child: InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(Icons.arrow_back_sharp, color: whiteColor))
                ),

                const Positioned(
                    top: 70,
                    child: Text(
                      "JSG Power Balance",
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
               "CPP 3015 MW",
              // : "STATION MW",
              style: TextStyle(
                  fontWeight: FontWeight.w500,fontSize: 18,color: appColor
              ),
              textAlign: TextAlign.center,
            ),
            commonVerticalSpacing(spacing: 20),
            Row(
              children: [
                totalProgress(
                  isGrossGeneration: true,
                  link1: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAA01e_F0jbOkmaBoCUfT9ftwT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xJUFAgMTgwMCBNVyBHUk9TUyBHRU4/value",
                  link2: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAANi7pu0zU2kak0Qb7odrJiAT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xDUFAgMTIxNSBNVyBHUk9TUyBHRU4/value"
                ),
                totalProgress(
                  link1: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAb3h5k1SJ9ESWihK0Qt-vswT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xJUFAgMTgwMCBNVyBORVQgR0VO/value",
                  link2: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAKpLrXHmtnUOpBkLFPy241AT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xDUFAgMTIxNSBNVyBORVQgR0VO/value"
                ),
              ],
            ),
            commonVerticalSpacing(spacing: 20),
            smelterAndExpSum(
              link1: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAApv2quVB8fkSGKiS6IAfaGgT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xJUFAgMTgwMCBNVyBTTUVMVEVSIENPTlNVTVBUSU9O/value",
              link2: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAkaqRNxVcu0K1X0Oo7xTVpwT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xDUFAgMTIxNSBNVyBTTUVMVEVSIENPTlNVTVBUSU9O/value"
            ),
            // smelterAndExpSum(isExp: true,
            //   link1: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAaxpspvo7S0WqrJIEtnyQ1AT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xJUFAgMTgwMCBNVyBJTVBPUlQ/value",
            //     link2: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAA72fU_rtLgkuDlVOhFRE1MAT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xDUFAgMTIxNSBNVyBFWFAvSU1Q/value"
            // ),
            smelterAndExpSum(isExp: true,
              link2: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAA72fU_rtLgkuDlVOhFRE1MAT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xDUFAgMTIxNSBNVyBFWFAvSU1Q/value",
                link1: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAaxpspvo7S0WqrJIEtnyQ1AT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xJUFAgMTgwMCBNVyBJTVBPUlQ/value"
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                commonVerticalSpacing(spacing: 20),
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: 3,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  separatorBuilder: (context, index) {
                    return const Divider(thickness: 0.2);
                  },
                  itemBuilder: (context, index) {
                    // final GlobalKey expansionTileKey = GlobalKey();
                    // double? previousOffset = 0;
                    return Container(
                      decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: ExpansionTile(
                          // key: expansionTileKey,
                          // onExpansionChanged: (isExpanded) {
                          //   _scrollController.jumpTo(index == 0 ? Get.height * 2.0 : index == 1 ? Get.height * 1.7 : Get.height * 1.9);
                          // },
                        tilePadding: const EdgeInsets.symmetric(horizontal: 10),
                        title: Text(
                           index == 0 ? "CPP 1800 MW" : index == 1 ? "CPP 1215 MW" : "TPP 600 MW",
                          // : "STATION MW",
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,fontSize: 16,color: appColor
                          ),
                        ),
                        children: index == 0 ? [
                          Container(
                            color: expansionBgColor,
                            child: ListView(
                              padding: const EdgeInsets.all(10),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                commonVerticalSpacing(spacing: 15),
                                generationView(
                                  index: index,
                                  link1: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAA01e_F0jbOkmaBoCUfT9ftwT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xJUFAgMTgwMCBNVyBHUk9TUyBHRU4/value",
                                  link2: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAb3h5k1SJ9ESWihK0Qt-vswT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xJUFAgMTgwMCBNVyBORVQgR0VO/value"
                                ),
                                commonVerticalSpacing(spacing: 20),
                                // commonView(title: "Gross Generation",link: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAA01e_F0jbOkmaBoCUfT9ftwT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xJUFAgMTgwMCBNVyBHUk9TUyBHRU4/value"),
                                // commonView(title: "Net Generation",link: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAb3h5k1SJ9ESWihK0Qt-vswT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xJUFAgMTgwMCBNVyBORVQgR0VO/value"),
                                commonView(title: "Smelter Cons",link: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAApv2quVB8fkSGKiS6IAfaGgT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xJUFAgMTgwMCBNVyBTTUVMVEVSIENPTlNVTVBUSU9O/value"),
                                // commonView(title: "ST Cons",link: ""),
                                commonView(title: "Exp/Imp",link: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAaxpspvo7S0WqrJIEtnyQ1AT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xJUFAgMTgwMCBNVyBJTVBPUlQ/value"),
                                // commonView(title: "Exp/Imp(Scheduled)",link: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAZTRLUDK8v0ylcBGdm0x7bwT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xJUFAgMTgwMCBNVyBTQ0hFRFVMRUQgRVhQL0lNUA/value"),
                              ],
                            ),
                          )
                        ] : index == 1 ? [
                          Container(
                              padding: const EdgeInsets.all(10),
                              color: expansionBgColor,
                              child: ListView(
                                padding: const EdgeInsets.all(10),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  commonVerticalSpacing(spacing: 15),
                                  generationView(
                                    index: index,
                                      link1: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAANi7pu0zU2kak0Qb7odrJiAT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xDUFAgMTIxNSBNVyBHUk9TUyBHRU4/value",
                                      link2: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAKpLrXHmtnUOpBkLFPy241AT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xDUFAgMTIxNSBNVyBORVQgR0VO/value"
                                  ),
                                  commonVerticalSpacing(spacing: 20),
                                  // commonView(title: "Gross Generation",link: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAANi7pu0zU2kak0Qb7odrJiAT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xDUFAgMTIxNSBNVyBHUk9TUyBHRU4/value"),
                                  // commonView(title: "Net Generation",link: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAKpLrXHmtnUOpBkLFPy241AT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xDUFAgMTIxNSBNVyBORVQgR0VO/value"),
                                  commonView(title: "Smelter Cons",link: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAkaqRNxVcu0K1X0Oo7xTVpwT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xDUFAgMTIxNSBNVyBTTUVMVEVSIENPTlNVTVBUSU9O/value"),
                                  // commonView(title: "ST Cons",link: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAo7lsbPqEAkWzUieVocVrwgT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xDUFAgMTIxNSBNVyBTVCBDT05TVU1QVElPTg/value"),
                                  commonView(title: "Exp/Imp",link: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAA72fU_rtLgkuDlVOhFRE1MAT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xDUFAgMTIxNSBNVyBFWFAvSU1Q/value"),
                                  // commonView(title: "Exp/Imp(Scheduled)",link: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAA4YqBbC3kXUWRGJsIh7VkzAT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xDUFAgMTIxNSBNVyBTQ0hFRFVMRUQgRVhQL0lNUA/value"),
                                ],
                              )
                          )
                        ] : [
                          Container(
                              padding: const EdgeInsets.all(10),
                              color: expansionBgColor,
                              child: ListView(
                                padding: const EdgeInsets.all(10),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  commonVerticalSpacing(spacing: 15),
                                  generationView(
                                      index: index,
                                      link1: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAVw0fyu62lUak6D8TJmB0bAT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xJUFAgNjAwIE1XIEdST1NTIEdFTg/value",
                                      link2: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAvAYsh1rxyE6iS0bytOqHaAT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xJUFAgTkVUIEdFTkVSQVRJT04gVTI/value"
                                  ),
                                  commonVerticalSpacing(spacing: 20),
                                  // commonView(title: "Gross Generation",link: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAVw0fyu62lUak6D8TJmB0bAT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xJUFAgNjAwIE1XIEdST1NTIEdFTg/value"),
                                  // commonView(title: "Net Generation",link: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAvAYsh1rxyE6iS0bytOqHaAT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xJUFAgTkVUIEdFTkVSQVRJT04gVTI/value"),
                                  // commonView(title: "Smelter Cons",link: ""),
                                  // commonView(title: "ST Cons",link: ""),
                                  commonView(title: "Export",link: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAA8GnEktPER0Wo3Afs80D3rAT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xJUFAgNjAwIE1XIEVYUE9SVA/value"),
                                  // commonView(title: "Import",link: ""),
                                  // commonView(title: "Exp/Imp(Scheduled)",link: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAJKGFma8rPEy3ogEXnfpwhwT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xJUFAgNjAwIE1XIFNDSEVEVUxFRCBFWFAvSU1Q/value"),
                                ],
                              )
                          )
                        ]
                        //     : [
                        //   Container(
                        //     padding: const EdgeInsets.all(10),
                        //     color: expansionBgColor,
                        //     child: ListView(
                        //       padding: const EdgeInsets.all(10),
                        //       shrinkWrap: true,
                        //       physics: const NeverScrollableScrollPhysics(),
                        //       children: [
                        //         commonVerticalSpacing(spacing: 15),
                        //         generationView(),
                        //         commonVerticalSpacing(spacing: 20),
                        //         // commonView(title: "Gross Generation",link: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAA30Ri-rd600Ki9nBbT3PPxQT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xTVEFUSU9OIDM2MTUgTVcgR1JPU1MgR0VO/value"),
                        //         // commonView(title: "Net Generation",link: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAAhqyWiLMzV0i9HUUbEZXHvAT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xTVEFUSU9OIDM2MTUgTVcgTkVUIEdFTg/value"),
                        //         commonView(title: "Smelter Cons",link: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAA5aH7qth-s0WsAnIAH21-IQT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xTVEFUSU9OIDM2MTUgTVcgU01FTFRFUiBDT05T/value"),
                        //         // commonView(title: "ST Cons",link: ""),
                        //         commonView(title: "Exp/Imp",link: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAADmOOSl8N0EuUiAdC-BeQXwT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xTVEFUSU9OIDM2MTUgTVcgRVhQL0lNUA/value"),
                        //         // commonView(title: "Exp/Imp(Scheduled)",link: ""),
                        //       ],
                        //     ),
                        //   )
                        // ],
                      ),
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
