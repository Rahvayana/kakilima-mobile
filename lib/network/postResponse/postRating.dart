import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

class PostRating {
  String message;
  int status;

  PostRating({this.message, this.status});
  factory PostRating.postRating(Map<String, dynamic> object) {
    return PostRating(
      status: object['status'],
      message: object['message'],
    );
  }

  static Future<PostRating> postRatingSeller(
      var rating, var id_seller, String token) async {
    String _token = token.replaceAll(new RegExp('"'), '');
    print("Bearer $_token".toString());
    print("Id Seller $id_seller");
    String url = "https://api-kakilima.herokuapp.com/api/apps/home/rating";
    var apiResult = await http.post(url,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $_token".toString(),
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json"
        },
        body: jsonEncode({
          "id_seller": id_seller,
          "rating": rating,
        }));
    var jsonObject = json.decode(apiResult.body);
    return PostRating.postRating(jsonObject);
  }
}
