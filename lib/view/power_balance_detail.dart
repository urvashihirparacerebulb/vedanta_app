import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../configuration/api_service.dart';
import '../utility/colors_utility.dart';
import '../common_method/common_methods.dart';
import '../utility/common_widgets.dart';

class PowerBalanceDetail extends StatefulWidget {
  final String title;
  final List<String> grossNetGens;
  final List<String> grossNetTitles;

  const PowerBalanceDetail({Key? key, required this.title, required this.grossNetGens, required this.grossNetTitles, }) : super(key: key);

  @override
  State<PowerBalanceDetail> createState() => _PowerBalanceDetailState();
}

class _PowerBalanceDetailState extends State<PowerBalanceDetail> {

  DateTime time = DateTime.now();

  commonView({String title = "", link = ""}){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 15,
              fontWeight: FontWeight.w500)),
          FutureBuilder(
              future: linkWiseAPICall(link),
              builder: (context, data) {
                return Text("${data.data == null || data.data == "Error" ? "0" : double.parse(data.data.toString()).round().toString()} MW",
                    style: TextStyle(color: AwesomeExtensions().isNegative(data.data == null || data.data == "Error" ? 0 : double.parse(data.data.toString()).round()) ? Colors.red : appColor,
                        fontSize: 15, fontWeight: FontWeight.w700));
              }
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: ListView(
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
              // Positioned(
              //     top: 20,left: 5,child: Padding(
              //   padding: const EdgeInsets.only(left: 18.0),
              //   child:  InkWell(
              //       onTap: (){
              //         Get.back();
              //       },
              //       child: const Icon(Icons.arrow_back_ios,color: whiteColor,)),
              // )),
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


              Positioned(top: 50,
                  left: 15,child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(Icons.arrow_back_sharp, color: whiteColor))),

              Positioned(
                  top: 50,
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                        color: whiteColor,
                        fontWeight: FontWeight.w500,fontSize: 20
                    ),
                    textAlign: TextAlign.center,
                  )
              ),
            ],
          ),
          commonVerticalSpacing(spacing: 40),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey)
            ),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 6),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
            itemBuilder: (context, index) {
              return commonView(title: widget.grossNetTitles[index],link: widget.grossNetGens[index]);
            }, separatorBuilder: (context, index) {
              return Divider(thickness: 0.2,color: Colors.grey.shade700);
            }, itemCount: widget.grossNetGens.length)
          )

        ],
      ),
    );
  }
}
