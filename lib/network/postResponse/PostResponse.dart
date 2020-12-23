import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class Service {
  List data;
  Future<int> submitSubscription(
      {File file,
      Uri filename,
      String judul,
      String deskripsi,
      String token}) async {
    final StringBuffer url = new StringBuffer(
        "https://api-kakilima.herokuapp.com/api/apps/home/addPost");

    Dio dio = new Dio();
    try {
      FormData formData = FormData.fromMap(
        {
          "image": await MultipartFile.fromFile(file.path),
          "judul": judul,
          "deskripsi": deskripsi,
        },
      );
      print(url);
      if (token != null) {
        String _token = token.replaceAll(new RegExp('"'), '');
        dio.options.headers["Authorization"] = "Bearer $_token";

        print(dio.options.headers);
      }
      var response = await dio.post(
        url.toString(),
        data: formData,
      );
      print(response.statusMessage);
      return 1;
    } on DioError catch (e) {
      print(e);
    }
  }
}
