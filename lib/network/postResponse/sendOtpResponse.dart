import 'dart:convert';

import 'package:http/http.dart' as http;

class SendOtpResponse {
  Data data;
  int status;
  String message;

  SendOtpResponse({this.data, this.status, this.message});

  factory SendOtpResponse.sendOtpResponse(Map<String, dynamic> object) {
    return SendOtpResponse(
      data : object['data'] != null ? new Data.fromJson(object['data']) : null,
      status: object['status'],
      message: object['message'],
    );
  }
  static Future<SendOtpResponse> sendOtpApi(String no_hp) async {
    String url = "https://api-kakilima.herokuapp.com/api/register/sendotp";
    var apiResult = await http.post(url, body: {"no_hp": no_hp});
    var jsonObject = json.decode(apiResult.body);
    return SendOtpResponse.sendOtpResponse(jsonObject);
  }
}
class Data {
  String otp;
  String noHp;

  Data({this.otp, this.noHp});

  Data.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
    noHp = json['no_hp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otp'] = this.otp;
    data['no_hp'] = this.noHp;
    return data;
  }
}