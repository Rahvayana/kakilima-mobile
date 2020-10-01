import 'dart:convert';
import 'package:aplikasi_pertama/login.dart';
import 'package:aplikasi_pertama/network/api_login.dart';
import 'package:aplikasi_pertama/network/getResponse/ProfilePageUser.dart';
import 'package:aplikasi_pertama/subPages/berdagang.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String token;
  ProfilePageUser profilePageUser = null;
  var urlFoto =
      'https://cdn2.iconfinder.com/data/icons/green-2/32/expand-color-web2-23-512.png';
  var namaProfil = ' ', statusProfile = '';
  @override
  void initState() {
    getTokenLogin();
    super.initState();
  }

  getTokenLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    token = stringValue;
    setState(() {
      ProfilePageUser.getStatusUser(token).then((value) {
        profilePageUser = value;
        setState(() {
          getUserStatus();
        });
      });
    });
  }

  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 3.0,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircularProfileAvatar(
                          urlFoto,
                          radius: 40,
                        ),
                        Container(
                          margin: EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                namaProfil,
                                style: GoogleFonts.lato(fontSize: 24.0),
                              ),
                              Text(
                                statusProfile,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.greenAccent),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.shopping_cart),
                          title: Text('Berdagang'),
                          onTap: () {
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => Berdagang()),
                            );
                          },
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                        ListTile(
                          leading: Icon(Icons.favorite),
                          title: Text('Favorite'),
                          onTap: () {
                            Fluttertoast.showToast(
                                msg: 'Menu Favorite',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.greenAccent,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          },
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.person),
                          title: Text('Profile'),
                          onTap: () {
                            Fluttertoast.showToast(
                                msg: 'Menu Profile',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.greenAccent,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          },
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                        ListTile(
                          leading: Icon(Icons.remove_red_eye),
                          title: Text('Dark Mode'),
                          trailing: Switch(
                            value: isSwitched,
                            onChanged: (value) {
                              setState(() {
                                isSwitched = value;
                                // print(isSwitched);
                              });
                            },
                            activeTrackColor: Colors.lightGreenAccent,
                            activeColor: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.question_answer),
                          title: Text("FAQ"),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            Fluttertoast.showToast(
                                msg: 'Menu FAQ',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.greenAccent,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.star),
                          title: Text("Nilai Kami"),
                          trailing: Text('v.1.0.0'),
                          onTap: () {
                            Fluttertoast.showToast(
                                msg: 'Versi 1.0.0',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.greenAccent,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.highlight_off),
                          title: Text("Logout"),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // return object of type Dialog
                                return AlertDialog(
                                  title: new Text("Apakah Anda Yakin?"),
                                  content: new Text(
                                      "Setelah Log Out Anda Akan diarahkan Ke Form Login"),
                                  actions: <Widget>[
                                    // usually buttons at the bottom of the dialog
                                    new FlatButton(
                                      child: new Text("Close"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    new FlatButton(
                                      child: new Text("Log Out"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        logout();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void logout() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('token');
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }

  void getUserStatus() {
    if (profilePageUser != null) {
      if (profilePageUser.status == 200) {
        urlFoto = profilePageUser.data.foto;
        namaProfil = profilePageUser.data.name;
        if (profilePageUser.data.status == null) {
          statusProfile = 'Pembeli';
        } else {
          statusProfile = 'Pedagang';
        }
      } else {
        Fluttertoast.showToast(
            msg: profilePageUser.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.greenAccent,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      print("null");
    }
  }
}
