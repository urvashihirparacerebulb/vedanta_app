import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import '../model/boolean_response_model.dart';

const String somethingWrong = "Something Went Wrong";
const String responseMessage = "NO RESPONSE DATA FOUND";
const String interNetMessage =
    "NO INTERNET CONNECTION, PLEASE CHECK YOUR INTERNET CONNECTION AND TRY AGAIN LATTER.";
const String connectionTimeOutMessage =
    "Opps.. Server not working or might be in maintenance .Please Try Again Later";
const String authenticationMessage =
    "The session has been Expired. Please log in again.";
const String tryAgain = "Try Again";

Map<String, dynamic>? tempParams;
String? tempServiceUrl;
Function? tempSuccess;
Function? tempError;
bool? tempIsProgressShow;
bool? isTempFormData;
bool? tempIsLoading;
bool? tempIsFromLogout;
bool? tempIsHideLoader;
bool? tempIsHandleResponse;
String? tempMethodType;

///Status Code with message type array or string
// 501 : sql related error
// 401: validation array
// 201 : string error
// 400 : string error
// 200: response, string/null
// 422: array
isNotEmptyString(String? string) {
  return string != null && string.isNotEmpty;
}

linkWiseAPICall(String url) async {
  try {
    var headers = {
      'Authorization': 'Basic T1NJUElzdXBwb3J0MTpwb2l1QDA5ODc='
    };
    var dio = Dio();
    var response = await dio.request(
      url,
      options: Options(
        method: 'GET',
        headers: headers,
      ),
    );

    if (response.statusCode == 200) {
      ValueResponse? responseData;
      responseData = ValueResponse.fromJson(
          response.data
      );
      return '${responseData.value}';
    } else {
      BooleanResponseModel? responseData;
      responseData = BooleanResponseModel.fromJson(
          response.data
      );
      return responseData.errors.first;
    }
  }catch(e){
    return "Error";
  }
}

Future<bool> checkInternet() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}