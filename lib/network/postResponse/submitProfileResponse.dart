import 'dart:convert';

import 'package:http/http.dart' as http;

class SubmitProfileResponse {
  String message;
  int status;

  SubmitProfileResponse({this.message, this.status});
  factory SubmitProfileResponse.submitProfileUser(Map<String, dynamic> object) {
    return SubmitProfileResponse(
      status: object['status'],
      message: object['message'],
    );
  }
  static Future<SubmitProfileResponse> submitProfile(
      String name,
      String email,
      String tgl_lahir,
      String alamat,
      String provinsi,
      String kota,
      String kecamatan,
      String password,
      String no_hp) async {
    String url = "https://api-kakilima.herokuapp.com/api/register/addprofil";
    var apiResult = await http.post(url, body: {
      "name": name,
      "email": email,
      "tgl_lahir": tgl_lahir,
      "alamat": alamat,
      "provinsi": provinsi,
      "kota": kota,
      "kecamatan": kecamatan,
      "password": password,
      "no_hp": no_hp,
    });
    var jsonObject = json.decode(apiResult.body);
    return SubmitProfileResponse.submitProfileUser(jsonObject);
  }
}
