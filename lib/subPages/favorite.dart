import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List data;
  String token;

  Future<String> getData(String _token) async {
    String _tokenku = _token.replaceAll(new RegExp('"'), '');
    var response = await http.get(
        Uri.encodeFull(
            "https://api-kakilima.herokuapp.com/api/apps/profil/myfavorite"),
        headers: {
          HttpHeaders.authorizationHeader: "Bearer $_tokenku".toString(),
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.acceptHeader: "application/json"
        });

    this.setState(() {
      data = json.decode(response.body);
    });

    print(data);

    return "Success!";
  }

  @override
  void initState() {
    getTokenLogin();
  }

  getTokenLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    token = stringValue;
    print(token);
    getData(token);
  }

  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text("Favorites"), backgroundColor: Colors.blue),
      body: new ListView.builder(
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            child: new Card(
              child: Container(
                margin: EdgeInsets.all(10.0),
                child: new Text(
                  data[index]["nama_seller"],
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
