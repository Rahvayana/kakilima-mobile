import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GetBerdagang {
  Data data;
  String message;
  int status;
  String _token;

  GetBerdagang({this.data, this.message, this.status});

  factory GetBerdagang.getBerdagang(Map<String, dynamic> object) {
    return GetBerdagang(
      data: object['data'] != null ? new Data.fromJson(object['data']) : null,
      status: object['status'],
      message: object['message'],
    );
  }
  static Future<GetBerdagang> getStatusUser(String token) async {
    String url = "https://api-kakilima.herokuapp.com/api/apps/seller/index";
    String _token = token.replaceAll(new RegExp('"'), '');
    print("Bearer $_token".toString());
    var apiResult = await http.get(url, headers: {
      HttpHeaders.authorizationHeader: "Bearer $_token".toString(),
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json"
    });
    var jsonObject = json.decode(apiResult.body);
    print(jsonObject);
    return GetBerdagang.getBerdagang(jsonObject);
  }
}

class Data {
  Seller seller;
  int favorite;
  int post;

  Data({this.seller, this.favorite, this.post});

  Data.fromJson(Map<String, dynamic> json) {
    seller =
        json['seller'] != null ? new Seller.fromJson(json['seller']) : null;
    favorite = json['favorite'];
    post = json['post'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.seller != null) {
      data['seller'] = this.seller.toJson();
    }
    data['favorite'] = this.favorite;
    data['post'] = this.post;
    return data;
  }
}

class Seller {
  int id;
  String idUser;
  String kategori;
  String namaSeller;
  double longitude;
  double latitude;
  String deskripsi;
  String status;
  String createdAt;
  String updatedAt;
  String name;

  Seller(
      {this.id,
      this.idUser,
      this.kategori,
      this.namaSeller,
      this.longitude,
      this.latitude,
      this.deskripsi,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.name});

  Seller.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    idUser = json['id_user'];
    kategori = json['kategori'];
    namaSeller = json['nama_seller'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    deskripsi = json['deskripsi'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_user'] = this.idUser;
    data['kategori'] = this.kategori;
    data['nama_seller'] = this.namaSeller;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['deskripsi'] = this.deskripsi;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['name'] = this.name;
    return data;
  }
}
