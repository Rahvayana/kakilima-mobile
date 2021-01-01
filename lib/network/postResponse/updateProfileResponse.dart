import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class UpdateProfileResponse {
  String message;
  int status;

  UpdateProfileResponse({this.message, this.status});
  factory UpdateProfileResponse.submitProfileUser(Map<String, dynamic> object) {
    return UpdateProfileResponse(
      status: object['status'],
      message: object['message'],
    );
  }
  static Future<UpdateProfileResponse> submitProfile(
      String name,
      String email,
      String tgl_lahir,
      String alamat,
      String provinsi,
      String kota,
      String kecamatan,
      String password,
      String no_hp) async {
    String url = "https://api-kakilima.herokuapp.com/api/register/updateprofil";
    var apiResult = await http.post(url, body: {
      "name": name,
      "tgl_lahir": tgl_lahir,
      "alamat": alamat,
      "provinsi": provinsi,
      "kota": kota,
      "kecamatan": kecamatan,
    });
    var jsonObject = json.decode(apiResult.body);
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: jsonObject['data']['id'])
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    if (documents.length == 0) {
      // Update data to server if new user
      FirebaseFirestore.instance
          .collection('users')
          .doc(jsonObject['data']['id'].toString())
          .set({
        'nickname': name,
        'photoUrl': jsonObject['data']['foto'] ??
            'https://fiverr-res.cloudinary.com/images/q_auto,f_auto/gigs/136697800/original/ad0b0ec86b4d6cc39a8f2350c1979d0be2182691/do-youtube-banner-watermark-avatar-logo-for-your-channel.png',
        'id': jsonObject['data']['id'].toString(),
        'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
        'chattingWith': null
      });
      return UpdateProfileResponse.submitProfileUser(jsonObject);
    }
  }
}

class UpdateProfile {
  List data;
  Future<int> submitSubscription({
    File file,
    Uri filename,
    String name,
    String tgl_lahir,
    String alamat,
    String provinsi,
    String kota,
    String kecamatan,
  }) async {
    final StringBuffer url = new StringBuffer(
        "https://api-kakilima.herokuapp.com/api/register/updateprofil");

    Dio dio = new Dio();
    try {
      FormData formData = FormData.fromMap(
        {
          "foto": await MultipartFile.fromFile(file.path),
          "name": name,
          "tgl_lahir": tgl_lahir,
          "alamat": alamat,
          "provinsi": provinsi,
          "kota": kota,
          "kecamatan": kecamatan,
        },
      );
      print(url);
      var response = await dio.post(
        url.toString(),
        data: formData,
      );
      print(response.statusMessage);
      return 1;
    } on DioError catch (e) {
      print(e);
    }
  }
}
