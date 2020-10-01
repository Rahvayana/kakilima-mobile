import 'dart:convert';

import 'package:http/http.dart' as http;

class CekOtpResponse {
  String data;
  String message;
  int status;

  CekOtpResponse({this.data, this.message, this.status});

  factory CekOtpResponse.cekOtpResponse(Map<String, dynamic> object) {
    return CekOtpResponse(
      data: object['data'],
      message: object['message'],
      status: object['status']

    );
  }
  static Future<CekOtpResponse> cekOtp(String no_hp , String otp) async {
    String url = "https://api-kakilima.herokuapp.com/api/register/cekotp";
    var apiResult = await http.post(url, body: {
      "no_hp": no_hp,
      "otp":otp
      });
    var jsonObject = json.decode(apiResult.body);
    return CekOtpResponse.cekOtpResponse(jsonObject);
  }
}
