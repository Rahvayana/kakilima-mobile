import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';

class Datapost {
  int id;
  int idSeller;
  String foto;
  String deskripsi;
  String createdAt;
  String updatedAt;
  double lat;
  double lng;
  String judul;

  Datapost(
      {this.id,
      this.idSeller,
      this.foto,
      this.deskripsi,
      this.judul,
      this.lat,
      this.lng,
      this.createdAt,
      this.updatedAt});

  factory Datapost.fromJson(Map<String, dynamic> json) {
    return Datapost(
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
    return 'Datapost{id: $id, name: $foto, email: $deskripsi}';
  }
}

List<Datapost> profileFromJson(String jsonDatapost) {
  final datapost = json.decode(jsonDatapost);
  return List<Datapost>.from(datapost.map((item) => Datapost.fromJson(item)));
}

String profileToJson(Datapost datapost) {
  final jsonDatapost = datapost.toJson();
  return json.encode(jsonDatapost);
}

class GetPost {
  Client client = Client();

  Future<List<Datapost>> getProfiles(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    print("tokenku: $stringValue");
    String _token = stringValue.replaceAll(new RegExp('"'), '');

    final response = await client.get(
        "https://api-kakilima.herokuapp.com/api/apps/seller/post",
        headers: {
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
