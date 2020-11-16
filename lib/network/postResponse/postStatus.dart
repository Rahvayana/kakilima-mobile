import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

class PostStatus {
  String message;
  int status;

  PostStatus({this.message, this.status});
  factory PostStatus.postStatus(Map<String, dynamic> object) {
    return PostStatus(
      status: object['status'],
      message: object['message'],
    );
  }

  static Future<PostStatus> postStatusSeller(
      String statusSeller, String token) async {
    String _token = token.replaceAll(new RegExp('"'), '');
    print("Bearer $_token".toString());
    String url = "https://api-kakilima.herokuapp.com/api/apps/seller/status";
    var apiResult = await http.post(url,
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $_token".toString(),
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json"
        },
        body: jsonEncode({
          "status": statusSeller,
        }));
    var jsonObject = json.decode(apiResult.body);
    return PostStatus.postStatus(jsonObject);
  }
}
