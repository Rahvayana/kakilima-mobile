import 'dart:convert';

import 'package:aplikasi_pertama/network/Navigasi.dart';
import 'package:aplikasi_pertama/network/api_login.dart';
import 'package:aplikasi_pertama/network/getResponse/getHome.dart';
import 'package:aplikasi_pertama/subPages/RuteNavigasi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String token, currentUserId;
  double lat, lng;
  var imgUrl =
      'https://media.tabloidbintang.com/files/thumb/92bc280c3b0a6e1f22a2ba3cccdc82d7.jpg';
  var title = 'Pedagang Bakso';
  var desc =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Consectetur a erat nam at.';
  final navigasi =
      Navigasi(name: "Pedagang Bakso", lat: -7.052299, lng: 112.425674);
  GetHome getHome;
  var id, name, foto;
  SharedPreferences prefs;
  @override
  void initState() {
    getTokenLogin();
    handleSignIn();
    getHome = GetHome();
    super.initState();
  }

  Future<Null> handleSignIn() async {
    print('Jalankok');
    prefs = await SharedPreferences.getInstance();
    var res = await Network().getData('api/apps/user');
    var body = json.decode(res.body);

    if (body['status'] == 200) {
      // print();
      setState(() {
        id = json.encode(body['data']['user']['id']);
        currentUserId = json.encode(body['data']['user']['id']);
        name = json.encode(body['data']['user']['name']);
        foto = json.encode(body['data']['user']['foto']);
      });
      print(currentUserId);
    } else {
      Fluttertoast.showToast(
          msg: body['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.greenAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    if (id != null) {
      // Check is already sign up
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('id', isEqualTo: id)
          .get();
      final List<DocumentSnapshot> documents = result.docs;
      if (documents.length == 0) {
        // Update data to server if new user
        String fotoku = foto.replaceAll(new RegExp('"'), '');

        FirebaseFirestore.instance.collection('users').doc(id).set({
          'nickname': name,
          'photoUrl': fotoku,
          'id': id,
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          'chattingWith': null
        });
        await prefs.setString('id', id);
        await prefs.setString('nickname', name);
        await prefs.setString('photoUrl', fotoku);
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => HomeScreen(currentUserId: id)));
      }
      await prefs.setString('id', id);
      await prefs.setString('nickname', name);
      String fotoku = foto.replaceAll(new RegExp('"'), '');
      await prefs.setString('photoUrl', fotoku);
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => HomeScreen(currentUserId: id)));
    } else {
      Fluttertoast.showToast(msg: "Sign in fail");
    }
  }

  getTokenLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    token = stringValue;
  }

  @override
  Widget build(BuildContext context) {
    GetHome().getProfiles(token).then((value) => print("value: $value"));
    return SafeArea(
      child: FutureBuilder(
        future: getHome.getProfiles(token),
        builder: (BuildContext context, AsyncSnapshot<List<Data>> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                  "Something wrong with message: ${snapshot.error.toString()}"),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            List<Data> profiles = snapshot.data;
            return _buildListView(profiles);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildListView(List<Data> profiles) {
    return profiles.length != 0
        ? RefreshIndicator(
            child: ListView.builder(
              itemBuilder: (context, index) {
                Data profile = profiles[index];
                return Container(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Card(
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Container(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16),
                                  alignment: Alignment.bottomCenter,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(6),
                                          bottomLeft: Radius.circular(6))),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Image.network(
                                            profile.foto,
                                            height: 250,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            fit: BoxFit.cover,
                                          )),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      ExpandablePanel(
                                        header: Text(profile.judul),
                                        collapsed: Text(
                                          profile.deskripsi,
                                          softWrap: true,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        expanded: Text(
                                          profile.deskripsi,
                                          textAlign: TextAlign.justify,
                                          softWrap: true,
                                        ),
                                      ),
                                      FlatButton(
                                        onPressed: () => {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => MapView(
                                                    // data: navigasi,
                                                    lat: profile.lat,
                                                    lng: profile.lng)),
                                          )
                                        },
                                        color: Colors.white,
                                        padding: EdgeInsets.all(5.0),
                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              Icons.navigation,
                                              color: Colors.blueAccent,
                                            ),
                                            Text(
                                              "Rute",
                                              style: TextStyle(
                                                  color: Colors.blueAccent),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: profiles.length,
            ),
            onRefresh: () => getHome.getProfiles(token),
          )
        : Center(child: CircularProgressIndicator());
  }
}
