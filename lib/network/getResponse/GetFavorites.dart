import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';

class GetFavorite {
  List<Data> data;
  String message;
  int status;

  GetFavorite({this.data, this.message, this.status});

  GetFavorite.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Data {
  String namaSeller;

  Data({this.namaSeller});

  Data.fromJson(Map<String, dynamic> json) {
    namaSeller = json['nama_seller'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nama_seller'] = this.namaSeller;
    return data;
  }
}
