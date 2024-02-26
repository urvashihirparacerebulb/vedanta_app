import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:vedanta_app/utility/colors_utility.dart';
import 'package:vedanta_app/common_method/common_methods.dart';
import 'package:vedanta_app/utility/common_widgets.dart';
import 'package:vedanta_app/login/login_view.dart';
import '../configuration/api_service.dart';
import 'power_balance_view.dart';

class OperationOverview extends StatefulWidget {
  const OperationOverview({Key? key}) : super(key: key);

  @override
  State<OperationOverview> createState() => _OperationOverviewState();
}

class _OperationOverviewState extends State<OperationOverview> {

  commonView({String title = "", val1, val2, subTitle1, subTitle2}){
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: Get.width / 1.4,
        padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
        decoration: BoxDecoration(
          color: whiteColor,
            border: Border.all(color: appColor),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,style: const TextStyle(color: appColor,
                fontWeight: FontWeight.bold,fontSize: 16),),
            commonVerticalSpacing(spacing: 15),
            Row(
              children: [
                Expanded(child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(subTitle1,style: const TextStyle(
                          fontWeight: FontWeight.w700,color: appColor,
                          fontSize: 12),),
                      const SizedBox(height: 5,),
                      FutureBuilder(
                          future: linkWiseAPICall(val1),
                          builder: (context, data) {
                            return Text(data.data == null || data.data == "Error" ? "0" : double.parse(data.data.toString()).round().toStringAsFixed(2),style: const TextStyle(
                                fontWeight: FontWeight.w700,color: blackColor,fontSize: 20),);
                          }
                      ),
                    ])),

                Expanded(child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(subTitle2,style: const TextStyle(
                          fontWeight: FontWeight.w700,color: appColor,fontSize: 12),),
                      const SizedBox(height: 5,),
                      FutureBuilder(
                          future: linkWiseAPICall(val2),
                          builder: (context, data) {
                            return Text(data.data == null || data.data == "Error" ? "0" : double.parse(data.data.toString()).round().toStringAsFixed(2),style: const TextStyle(
                                fontWeight: FontWeight.w700,color: blackColor,fontSize: 20),);
                          }
                      ),
                    ]))
              ],
            ),
          ],
        ),
      ),
    );
  }

  singleCommonView({String title = "", val1}){
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
        decoration: BoxDecoration(
            border: Border.all(color: appColor),
            color: whiteColor,
            borderRadius: BorderRadius.circular(10)
        ),
        width: Get.width / 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,style: const TextStyle(color: appColor,
                fontWeight: FontWeight.bold,fontSize: 16),),
            commonVerticalSpacing(spacing: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                FutureBuilder(
                    future: linkWiseAPICall(val1),
                    builder: (context, data) {
                      return Text(data.data == null || data.data == "Error" ? "0" : double.parse(data.data.toString()).toStringAsFixed(2),style: const TextStyle(fontWeight: FontWeight.w700,color: blackColor,fontSize: 20),);
                    }
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // commonTitleView({String title = "", Widget? child, subChild}){
  //   return Padding(
  //     padding: const EdgeInsets.all(5.0),
  //     child: Stack(
  //       alignment: Alignment.topLeft,
  //       fit: StackFit.loose,
  //       textDirection: TextDirection.ltr,
  //       clipBehavior: Clip.none,
  //       children: [
  //         Positioned(
  //             left: 10,top: -10,
  //             child: Container(
  //               padding: const EdgeInsets.all(2),
  //               decoration: BoxDecoration(
  //                   color: Colors.blue,
  //                   border: Border.all(color: whiteColor)),
  //               child: Text(title,style: const TextStyle(color: whiteColor,fontWeight: FontWeight.bold),),
  //             )),
  //         Container(
  //           padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 10),
  //           decoration: BoxDecoration(
  //               border: Border.all(color: Colors.grey.shade300)
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               child ?? Container(),
  //               subChild ?? Container()
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  liquidIndicatorView({String link = "", title}){
    return FutureBuilder(
        future: linkWiseAPICall(link),
        builder: (context, data) {
          return Container(
            width: 155,
            padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
                border: Border.all(color: appColor),
                color: whiteColor,
                borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                  child: LiquidCircularProgressIndicator(
                    value: 0.6, // Defaults to 0.5.
                    valueColor: const AlwaysStoppedAnimation(appColor), // Defaults to the current Theme's accentColor.
                    backgroundColor: whiteColor, // Defaults to the current Theme's backgroundColor.
                    borderColor: appColor,
                    borderWidth: 8.0,
                    direction: Axis.vertical,
                    center: Text(data.data.toString(), style: const TextStyle(color: blackColor,fontSize: 18, fontWeight: FontWeight.bold),),
                  ),
                ),

                commonVerticalSpacing(),
                Text(title,style: const TextStyle(color: blackColor,
                    fontWeight: FontWeight.w500,fontSize: 14),textAlign: TextAlign.center,),
              ],
            ),
          );
        }
    );
  }

  radialGaugeProgress({String title = "", link=""}){
    return FutureBuilder(
        future: linkWiseAPICall(link),
        builder: (context, data) {
          return Container(
            width: Get.width / 1.6,
            padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
            decoration: BoxDecoration(
                border: Border.all(color: appColor),
                color: whiteColor,
                borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title,style: const TextStyle(color: appColor,
                        fontWeight: FontWeight.bold,fontSize: 16),),
                    Text(data.data == null || data.data == "Error" ? "0" : double.parse(data.data.toString()).toStringAsFixed(2),style: const TextStyle(
                        color: blackColor,
                        fontWeight: FontWeight.bold,fontSize: 16),),
                  ],
                ),
                commonVerticalSpacing(spacing: 15),
                SfLinearGauge(
                  // ranges: const [
                  //   LinearGaugeRange(startValue: 0,endValue: 10,color: Colors.grey)
                  // ],
                  showAxisTrack: true,
                  markerPointers: [
                    LinearShapePointer(
                        value: data.data == null || data.data == "Error" ? 0 : double.parse(data.data.toString()) * 10,
                        //Changes the value of shape pointer based on interaction
                        onChanged: (value) {
                          // setState(() {
                          //   shapePointerValue = value;
                          // });
                        },
                        color: Colors.blue[800]),
                  ],
                )
                // Expanded(
                //   child: SizedBox(
                //       height: 120,
                //       child: SfRadialGauge(
                //           axes: <RadialAxis>[
                //             RadialAxis(minimum: 0, maximum: 10,
                //                 ranges: <GaugeRange>[
                //                   // GaugeRange(startValue: 0, endValue: 3, color:Colors.red),
                //                   // GaugeRange(startValue: 3,endValue: 7,color: Colors.grey),
                //                   GaugeRange(startValue: 0,endValue: 10,color: Colors.grey)
                //                 ],
                //                 pointers: <GaugePointer>[
                //                   // NeedlePointer(
                //                   //     gradient: LinearGradient(colors: const <Color>[
                //                   //       Color.fromRGBO(203, 126, 223, 0.1),
                //                   //       Color(0xFFCB7EDF)
                //                   //     ], stops: const <double>[
                //                   //       0.25,
                //                   //       0.75
                //                   //     ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
                //                   //     value: 60)
                //                   RangePointer(
                //                     value: data.data == null || data.data == "Error" ? 0 : double.parse(data.data.toString()),
                //                     gradient: const SweepGradient(
                //                         colors: <Color>[Colors.blue, Colors.blue],
                //                         stops: <double>[0.25, 0.75]),
                //                   )
                //                 ],
                //                 annotations: <GaugeAnnotation>[
                //                 GaugeAnnotation(widget: Text(data.data == null || data.data == "Error" ? "0" :double.parse(data.data.toString()).toStringAsFixed(2),style: const TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
                //                 angle: 90, positionFactor: 0.7
                //             )]
                //       )]),
                // )),
              ],
            ),
          );
        }
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: const Text("Operation Overview",style: TextStyle(
            color: appColor,fontWeight: FontWeight.bold,fontSize: 20
        )),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Row(
              children: [
                InkWell(
                  onTap: (){
                    Get.to(() => const PowerBalanceView());
                  },
                    child: const Icon(Icons.more_vert)),
                const SizedBox(width: 20,),
                InkWell(
                  onTap: (){
                    setIsLogin(isLogin: false);
                    Get.offAll(() => const LoginView());
                  },
                    child: const Icon(Icons.logout)),
              ],
            ),
          )
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.only(left: 16),
          scrollDirection: Axis.vertical,
          children: <Widget>[

            const Text("Title of the component",style:  TextStyle(
                color: blackColor,fontWeight: FontWeight.bold,fontSize: 16),),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                height: 141.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    commonView(title: "PLF 3815 MW (%)",
                        val1: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQzFgBW_zl6hGFxAAVXY3lAAuRcOKIP1RkivB1oxNud53gT1NJUElERVZBUFBcREFUQUJBU0UxXENFTyBEQVNIQk9BUkR8UExBTlQgUExG/value",
                        val2: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQzFgBW_zl6hGFxAAVXY3lAAyNcBp467sEWkQPaZzHM3EwT1NJUElERVZBUFBcREFUQUJBU0UxXENFTyBEQVNIQk9BUkR8UExBTlQgUExGIE1URA/value",
                        subTitle1: "FTD",subTitle2: "MTD"),
                    commonView(title: "SCC 3815 MW (gms)",
                        val1: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQzFgBW_zl6hGFxAAVXY3lAAd919KTLjKkiS8uSA53CinAT1NJUElERVZBUFBcREFUQUJBU0UxXENFTyBEQVNIQk9BUkR8UExBTlQgU0NDIEZURA/value",
                        val2: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQzFgBW_zl6hGFxAAVXY3lAAeorE7_rIrU-xsIdHLgHIPAT1NJUElERVZBUFBcREFUQUJBU0UxXENFTyBEQVNIQk9BUkR8UExBTlQgU0NDIE1URA/value",
                        subTitle1: "FTD",subTitle2: "MTD"),
                    commonView(title: "APC 3815 MW (%)",
                        val1: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQzFgBW_zl6hGFxAAVXY3lAAX9zlVPFLgE-_iYGMLYq71AT1NJUElERVZBUFBcREFUQUJBU0UxXENFTyBEQVNIQk9BUkR8UExBTlQgQVBDIEZURA/value",
                        val2: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQzFgBW_zl6hGFxAAVXY3lAA2lv--L5vy0KgOQD428tITQT1NJUElERVZBUFBcREFUQUJBU0UxXENFTyBEQVNIQk9BUkR8UExBTlQgQVBDIE1URA/value",
                        subTitle1: "FTD",subTitle2: "MTD"),
                    commonView(title: "Metal Volume Plant 1(KT)",
                        val1: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQzFgBW_zl6hGFxAAVXY3lAAXKodLcJBSEmxgnIkOmZZDAT1NJUElERVZBUFBcREFUQUJBU0UxXENFTyBEQVNIQk9BUkR8TUVUQUwgVk9MVU1FIFBMQU5ULTEgRlREfE1FVEFMIFZPTFVNRSBQTEFOVC0xIEZURA/value",
                        val2: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQzFgBW_zl6hGFxAAVXY3lAA7j9dmgaJ10OtFOkqwwAwLAT1NJUElERVZBUFBcREFUQUJBU0UxXENFTyBEQVNIQk9BUkR8TUVUQUwgVk9MVU1FIFBMQU5ULTEgTVREfE1FVEFMIFZPTFVNRSBQTEFOVC0xIE1URA/value",
                        subTitle1: "FTD",subTitle2: "MTD"),
                    commonView(title: "Metal Volume Plant 2(KT)",
                        val1: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQzFgBW_zl6hGFxAAVXY3lAAZb-f74u8B0Sqo3Kbc3qoOgT1NJUElERVZBUFBcREFUQUJBU0UxXENFTyBEQVNIQk9BUkR8TUVUQUwgVk9MVU1FIFBMQU5ULTIgRlREfE1FVEFMIFZPTFVNRSBQTEFOVC0yIEZURA/value",
                        val2: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQzFgBW_zl6hGFxAAVXY3lAA32JNStktuUu_dEYOlBfrgQT1NJUElERVZBUFBcREFUQUJBU0UxXENFTyBEQVNIQk9BUkR8TUVUQUwgVk9MVU1FIFBMQU5ULTIgTVREfE1FVEFMIFZPTFVNRSBQTEFOVC0yIE1URA/value",
                        subTitle1: "FTD",subTitle2: "MTD"),
                    commonView(title: "Running Pots",
                        val1: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQzFgBW_zl6hGFxAAVXY3lAACs0xS05GaEu_5UobTDraGwT1NJUElERVZBUFBcREFUQUJBU0UxXENFTyBEQVNIQk9BUkR8UExBTlQtMSBSVU5OSU5HIFBPVHxQTEFOVC0xIFJVTk5JTkcgUE9UUw/value",
                        val2: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQzFgBW_zl6hGFxAAVXY3lAAlyGlHGpAU0aDhOkd5XMHYgT1NJUElERVZBUFBcREFUQUJBU0UxXENFTyBEQVNIQk9BUkR8UExBTlQtMiBSVU5OSU5HIFBPVFN8UExBTlQtMiBSVU5OSU5HIFBPVFM/value",
                        subTitle1: "Plant - 1",subTitle2: "Plant - 2"),
                  ],
                )
            ),

            commonVerticalSpacing(),
            const Text("Title of the component",style:  TextStyle(
                color: blackColor,fontWeight: FontWeight.bold,fontSize: 16),),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                height: 142.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    singleCommonView(title: "Gen. TPP 1800\nMW",val1: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQ_9_p1sTm6hGFxAAVXY3lAA-cAtvETKz0-Iif3YT3RoPgT1NJUElERVZBUFBcREFUQUJBU0UxXENFTyBEQVNIQk9BUkRcSVBQfElQUCAxODAwTVcgR0VORVJBVElPTnxJUFAgMTgwME1XIEdFTg/value"),
                    singleCommonView(title: "Gen. IPP 600\nMW",val1: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQ_9_p1sTm6hGFxAAVXY3lAAw4zZnNBHz0qwt1k0-sCTTwT1NJUElERVZBUFBcREFUQUJBU0UxXENFTyBEQVNIQk9BUkRcSVBQfElQUCA2MDBNVyBHRU5FUkFUSU9OfElQUCA2MDBNVyBHRU4/value"),

                    singleCommonView(title: "CPP 1215 MW",val1: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQEqC0Qvzo6hGFxAAVXY3lAANi7pu0zU2kak0Qb7odrJiAT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV3xDUFAgMTIxNSBNVyBHUk9TUyBHRU4/value"),
                     commonView(title: "Exp/lmp(MW)",
                    val1: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQ2r43j_MH6xGFxgAVXY3lAAZfOWKLKj6Um5d_XL3QjM2AT1NJUElERVZBUFBcVkVEQU5UQVxKU0dcUExBTlQgMzYxNSBNV1xJUFBcSVBQX0hFQURfREFTSEhCT0FSRHxJTVBPUlQ/value",
                    val2: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQioZ8yMTm6hGFxAAVXY3lAA9heYRh9_xEieDehfgxGxrwT1NJUElERVZBUFBcREFUQUJBU0UxXENFTyBEQVNIQk9BUkRcQ1BQfENQUCBFWFAvSU1Q/value",subTitle1: "1800 MW",subTitle2: "1216 MW"),

                    singleCommonView(title: "PLANT-1 CONS. (MW)",val1: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQioZ8yMTm6hGFxAAVXY3lAA2d5wScld3kOzqPAlexfOOwT1NJUElERVZBUFBcREFUQUJBU0UxXENFTyBEQVNIQk9BUkRcQ1BQfENQUCBQTEFOVC0xIExPQUQ/value"),
                    singleCommonView(title: "PLANT-2 CONS. (MW)",val1: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQ_9_p1sTm6hGFxAAVXY3lAAqOHHcwvhHEyyxhFNBlnNtAT1NJUElERVZBUFBcREFUQUJBU0UxXENFTyBEQVNIQk9BUkRcSVBQfElQUCBQTEFOVC0yIFNNRUxURVIgTE9BRA/value"),
                  ],
                )
            ),

            commonVerticalSpacing(),
            const Text("Coal Stock",style:  TextStyle(
                color: blackColor,fontWeight: FontWeight.bold,fontSize: 16),),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              height: 142.0,
              child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    radialGaugeProgress(title: "TPP 1800 MW (LMT)",link: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQzFgBW_zl6hGFxAAVXY3lAAnaQVnj5HuU2JNohDRpy_DwT1NJUElERVZBUFBcREFUQUJBU0UxXENFTyBEQVNIQk9BUkR8SVBQIENPQUwgU1RPQ0sgMTgwMCBNVw/value"),
                    const SizedBox(width: 10),
                    radialGaugeProgress(title: "IPP 600 MW (LMT)",link: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQzFgBW_zl6hGFxAAVXY3lAALHRA0Qbe-UmJ_-9xG0VDmgT1NJUElERVZBUFBcREFUQUJBU0UxXENFTyBEQVNIQk9BUkR8SVBQIENPQUwgU1RPQ0sgNjAwIE1X/value"),
                    const SizedBox(width: 10),
                    radialGaugeProgress(title: "CPP 1215 MW (LMT)",link: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQzFgBW_zl6hGFxAAVXY3lAAdUH4tsnGU0iTQobKRIt4LAT1NJUElERVZBUFBcREFUQUJBU0UxXENFTyBEQVNIQk9BUkR8Q1BQIENPQUwgU1RPQ0sgTE1U/value"),
                  ]
              )
            ),


            commonVerticalSpacing(),
            const Text("Water Level (M)",style:  TextStyle(
                color: blackColor,fontWeight: FontWeight.bold,fontSize: 16),),
            Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                height: 192.0,
                child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      liquidIndicatorView(
                          link: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQzFgBW_zl6hGFxAAVXY3lAAVE6Hqm4ypUmuWRAeQpjMygT1NJUElERVZBUFBcREFUQUJBU0UxXENFTyBEQVNIQk9BUkR8SVBQIDI0MDAgTVcgIFJFU0VSVklPUiBMRVZFTCBSMg/value",
                        title: "TPP 2400 MW\nR-1"
                      ),

                      liquidIndicatorView(
                          link: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQzFgBW_zl6hGFxAAVXY3lAAVE6Hqm4ypUmuWRAeQpjMygT1NJUElERVZBUFBcREFUQUJBU0UxXENFTyBEQVNIQk9BUkR8SVBQIDI0MDAgTVcgIFJFU0VSVklPUiBMRVZFTCBSMg/value",
                          title: "TPP 2400 MW\nR-2"
                      ),

                      liquidIndicatorView(
                          link: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQzFgBW_zl6hGFxAAVXY3lAAdPY5sjkKyU--zO0fckC77QT1NJUElERVZBUFBcREFUQUJBU0UxXENFTyBEQVNIQk9BUkR8Q1BQIDEyMTUgTVcgUkVTRVJWSU9SIExFVkVMIFIx/value",
                          title: "CPP 1215 MW\nR-1"
                      ),

                      liquidIndicatorView(
                          link: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQzFgBW_zl6hGFxAAVXY3lAALs4xLPIupkShQNbXxuqyZAT1NJUElERVZBUFBcREFUQUJBU0UxXENFTyBEQVNIQk9BUkR8Q1BQIDEyMTUgTVcgUkVTRVJWSU9SIExFVkVMIFIy/value",
                          title: "CPP 1215 MW\nR-2"
                      ),
                    ]
                )
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
    // return Scaffold(
    //   backgroundColor: bgColor,
    //   appBar: AppBar(
    //     backgroundColor: bgColor,
    //     title: const Text("Operation Overview",style: TextStyle(
    //       color: appColor,fontWeight: FontWeight.bold,fontSize: 20
    //     )),
    //     actions: [
    //       Padding(
    //         padding: const EdgeInsets.only(right: 18.0),
    //         child: InkWell(
    //           onTap: () {
    //             Get.to(() => const PowerBalanceView());
    //           },
    //           child: const Icon(Icons.home),
    //         ),
    //       )
    //     ],
    //     centerTitle: true,
    //     elevation: 0,
    //   ),
    //   body:
    //   Center(
    //     child: ListView(
    //       scrollDirection: Axis.vertical,
    //       // shrinkWrap: true,
    //       // padding: const EdgeInsets.all(16),
    //       children: [
    //         SizedBox(
    //           height: 200,
    //           child: ListView(
    //             // shrinkWrap: true,
    //             scrollDirection: Axis.horizontal,
    //
    //             ],
    //           ),
    //         ),
    //
    //         // ),subChild: const Row(
    //         //   children: [
    //         //     Expanded(child: Text("",style: TextStyle(fontWeight: FontWeight.w700),textAlign: TextAlign.center,)),
    //         //     Expanded(child: Text("",style: TextStyle(fontWeight: FontWeight.w700),textAlign: TextAlign.center)),
    //         //     Expanded(child: Text("",style: TextStyle(fontWeight: FontWeight.w700),textAlign: TextAlign.center)),
    //         //   ],
    //         // ),),
    //         // const SizedBox(height: 20),
    //         // commonTitleView(title: "Water Level(m)",
    //         //   child: Column(
    //         //     mainAxisSize: MainAxisSize.min,
    //         //     children: [
    //         //       const SizedBox(height: 10),
    //         //       const Text("TPP 2400 MW",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18)),
    //         //       const SizedBox(height: 10,),
    //         //       Container(
    //         //         padding: const EdgeInsets.symmetric(horizontal: 10),
    //         //         child: Row(
    //         //           children: [
    //         //             Expanded(child: Column(
    //         //               children: [
    //         //                 liquidIndicatorView(link: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQzFgBW_zl6hGFxAAVXY3lAANlC1JWkrvkmw5V7Ty6bt8wT1NJUElERVZBUFBcREFUQUJBU0UxXENFTyBEQVNIQk9BUkR8SVBQIDI0MDAgTVcgIFJFU0VSVklPUiBMRVZFTCBSMQ/value"),
    //         //                 const Text("R-1",style: TextStyle(fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
    //         //               ],
    //         //             )),
    //         //             const SizedBox(width: 30,),
    //         //             Expanded(child: Column(
    //         //               children: [
    //         //                 liquidIndicatorView(link: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQzFgBW_zl6hGFxAAVXY3lAAVE6Hqm4ypUmuWRAeQpjMygT1NJUElERVZBUFBcREFUQUJBU0UxXENFTyBEQVNIQk9BUkR8SVBQIDI0MDAgTVcgIFJFU0VSVklPUiBMRVZFTCBSMg/value"),
    //         //                 const Text("R-2",style: TextStyle(fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
    //         //               ],
    //         //             )),
    //         //           ],
    //         //         ),
    //         //       ),
    //         //       const SizedBox(height: 20),
    //         //       const Text("CPP 1215 MW",style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
    //         //       const SizedBox(height: 10,),
    //         //       Row(
    //         //         children: [
    //         //           Expanded(child: Column(
    //         //             children: [
    //         //               liquidIndicatorView(link: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQzFgBW_zl6hGFxAAVXY3lAAdPY5sjkKyU--zO0fckC77QT1NJUElERVZBUFBcREFUQUJBU0UxXENFTyBEQVNIQk9BUkR8Q1BQIDEyMTUgTVcgUkVTRVJWSU9SIExFVkVMIFIx/value"),
    //         //               const Text("R-1",style: TextStyle(fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
    //         //             ],
    //         //           )),
    //         //           const SizedBox(width: 30),
    //         //           Expanded(child: Column(
    //         //             children: [
    //         //               liquidIndicatorView(link: "https://osipidevapp.vedantaconnect.com/piwebapi/streams/F1AbEsqUWg0Xu_Eiggy-Hzwd_GQzFgBW_zl6hGFxAAVXY3lAALs4xLPIupkShQNbXxuqyZAT1NJUElERVZBUFBcREFUQUJBU0UxXENFTyBEQVNIQk9BUkR8Q1BQIDEyMTUgTVcgUkVTRVJWSU9SIExFVkVMIFIy/value"),
    //         //               const Text("R-2",style: TextStyle(fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
    //         //             ],
    //         //           )),
    //         //         ],
    //         //       ),
    //         //       const SizedBox(height: 20),
    //         //     ],
    //         //   )
    //         // )
    //       ],
    //     ),
    //   ),
    // );
  }
}
