import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

class PostReview {
  String message;
  int status;

  PostReview({this.message, this.status});
  factory PostReview.postReview(Map<String, dynamic> object) {
    return PostReview(
      status: object['status'],
      message: object['message'],
    );
  }

  static Future<PostReview> PostReviewSeller(
      var review, var id_seller, String token) async {
    String _token = token.replaceAll(new RegExp('"'), '');
    print("Bearer $_token".toString());
    print("Id Seller $id_seller");
    print("Ulasan $review");
    String url = "https://api-kakilima.herokuapp.com/api/apps/home/review";
    var apiResult = await http.post(url,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $_token".toString(),
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json"
        },
        body: jsonEncode({
          "id_seller": id_seller,
          "review": review,
        }));
    var jsonObject = json.decode(apiResult.body);
    print(jsonObject);
    return PostReview.postReview(jsonObject);
  }
}
