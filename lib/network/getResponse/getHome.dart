import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';

class Data {
  int id;
  int idSeller;
  String foto;
  String deskripsi;
  String createdAt;
  String updatedAt;
  double lat;
  double lng;
  String judul;

  Data(
      {this.id,
      this.idSeller,
      this.foto,
      this.deskripsi,
      this.judul,
      this.lat,
      this.lng,
      this.createdAt,
      this.updatedAt});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        id: json['id'],
        idSeller: json['id_seller'],
        foto: json['foto'],
        deskripsi: json['deskripsi'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        lat: json['latitude'],
        lng: json['longitude'],
        judul: json['judul']);
    // id: map["id"], name: map["name"], email: map["email"], age: map["age"]
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "foto": foto,
      "deskripsi": deskripsi,
      "lat": lat,
      "lng": lng
    };
  }

  @override
  String toString() {
    return 'Data{id: $id, name: $foto, email: $deskripsi}';
  }
}

List<Data> profileFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Data>.from(data.map((item) => Data.fromJson(item)));
}

String profileToJson(Data data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}

class GetHome {
  Client client = Client();

  Future<List<Data>> getProfiles(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    print("tokenku: $stringValue");
    String _token = stringValue.replaceAll(new RegExp('"'), '');

    final response = await client
        .get("https://api-kakilima.herokuapp.com/api/apps/home/home", headers: {
      HttpHeaders.authorizationHeader: "Bearer $_token".toString(),
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json"
    });
    if (response.statusCode == 200) {
      print(response.body);
      return profileFromJson(response.body);
    } else {
      return null;
    }
  }
}
