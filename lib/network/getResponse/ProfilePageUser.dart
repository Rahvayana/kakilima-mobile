import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePageUser {
  Data data;
  String message;
  int status;
  String _token;

  ProfilePageUser({this.data, this.message, this.status});

  factory ProfilePageUser.profilePageUser(Map<String, dynamic> object) {
    return ProfilePageUser(
      data: object['data'] != null ? new Data.fromJson(object['data']) : null,
      status: object['status'],
      message: object['message'],
    );
  }
  static Future<ProfilePageUser> getStatusUser(String token) async {
    String url = "https://api-kakilima.herokuapp.com/api/apps/profil/status";
    String _token = token.replaceAll(new RegExp('"'), '');
    print("Bearer $_token".toString());
    var apiResult = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer $_token".toString(),
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json"
    });
    var jsonObject = json.decode(apiResult.body);
    return ProfilePageUser.profilePageUser(jsonObject);
  }
}

class Data {
  String status;
  String name;
  String foto;

  Data({this.status, this.name, this.foto});

  Data.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    name = json['name'];
    foto = json['foto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['name'] = this.name;
    data['foto'] = this.foto;
    return data;
  }
}
