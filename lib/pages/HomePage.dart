import 'package:aplikasi_pertama/network/Navigasi.dart';
import 'package:aplikasi_pertama/network/getResponse/getHome.dart';
import 'package:aplikasi_pertama/subPages/RuteNavigasi.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name, token;
  var imgUrl =
      'https://media.tabloidbintang.com/files/thumb/92bc280c3b0a6e1f22a2ba3cccdc82d7.jpg';
  var title = 'Pedagang Bakso';
  var desc =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Consectetur a erat nam at.';
  final navigasi =
      Navigasi(name: "Pedagang Bakso", lat: -7.052299, lng: 112.425674);
  GetHome getHome;
  @override
  void initState() {
    getTokenLogin();
    getHome = GetHome();
    super.initState();
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
                                            height: 200,
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
                                                builder: (context) => MapScreen(
                                                    // data: navigasi,
                                                    )),
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
