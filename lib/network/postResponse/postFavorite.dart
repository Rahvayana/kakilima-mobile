import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

class PostFavorite {
  String message;
  int status;

  PostFavorite({this.message, this.status});
  factory PostFavorite.postStatus(Map<String, dynamic> object) {
    return PostFavorite(
      status: object['status'],
      message: object['message'],
    );
  }

  static Future<PostFavorite> postStatusSeller(
      int id_seller, String token) async {
    String _token = token.replaceAll(new RegExp('"'), '');
    print("Bearer $_token".toString());
    String url =
        "https://api-kakilima.herokuapp.com/api/apps/profil/addfavorite";
    var apiResult = await http.post(url,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $_token".toString(),
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json"
        },
        body: jsonEncode({
          "id_seller": id_seller,
        }));
    var jsonObject = json.decode(apiResult.body);
    return PostFavorite.postStatus(jsonObject);
  }
}
