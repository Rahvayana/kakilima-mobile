import 'package:aplikasi_pertama/network/getResponse/ProfilePageUser.dart';
import 'package:aplikasi_pertama/subPages/FormBerdagang.dart';
import 'package:aplikasi_pertama/subPages/berdagang.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckStatusBerdagang extends StatefulWidget {
  @override
  _CheckStatusBerdagangState createState() => _CheckStatusBerdagangState();
}

class _CheckStatusBerdagangState extends State<CheckStatusBerdagang> {
  ProfilePageUser profilePageUser = null;
  String token;
  bool seller = false;

  bool isAuth = false;
  @override
  void initState() {
    getTokenLogin();
    super.initState();
  }

  getTokenLogin() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    if (token != null) {
      setState(() {
        isAuth = true;
      });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    token = stringValue;
    ProfilePageUser.getStatusUser(token).then((value) {
      profilePageUser = value;
      print(profilePageUser);
      if (profilePageUser.data.status == 'Pembeli') {
        print(profilePageUser.data.status);
        setState(() {
          isAuth = false;
        });
      } else {
        setState(() {
          isAuth = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (isAuth) {
      child = Berdagang();
    } else {
      child = FormBerdagang();
    }
    return Scaffold(
      body: child,
    );
  }
}
