import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

class PostSellerBody {
  String message;
  int status;

  PostSellerBody({this.message, this.status});
  factory PostSellerBody.postSeller(Map<String, dynamic> object) {
    return PostSellerBody(
      status: object['status'],
      message: object['message'],
    );
  }

  static Future<PostSellerBody> postSellerBody(
      var nama_seller, var deskripsi, var lat, var long, String token) async {
    String _token = token.replaceAll(new RegExp('"'), '');
    String url = "https://api-kakilima.herokuapp.com/api/apps/seller/addSeller";
    var apiResult = await http.post(url,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $_token".toString(),
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json"
        },
        body: jsonEncode({
          "nama_seller": nama_seller,
          "latitude": lat,
          "longitude": long,
          "deskripsi": deskripsi
        }));
    var jsonObject = json.decode(apiResult.body);
    print(jsonObject);
    return PostSellerBody.postSeller(jsonObject);
  }
}
