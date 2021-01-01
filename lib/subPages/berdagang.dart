import 'package:aplikasi_pertama/network/getResponse/GetBerdagang.dart';
import 'package:aplikasi_pertama/network/getResponse/GetPost.dart';
import 'package:aplikasi_pertama/network/postResponse/postStatus.dart';
import 'package:aplikasi_pertama/subPages/Posts.dart';
import 'package:aplikasi_pertama/subPages/profileBerdagang.dart';
import 'package:aplikasi_pertama/widgets/common_scaffold.dart';
import 'package:aplikasi_pertama/widgets/profile_tile.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Berdagang extends StatefulWidget {
  @override
  _BerdagangState createState() => _BerdagangState();
}

class _BerdagangState extends State<Berdagang> {
  GetBerdagang getBerdagang = null;
  Size deviceSize;
  String token;
  var kategori = '', nama_seller = '', favorite = '', post = '';
  bool status = false;
  String statusSeller;
  GetPost getPost;

  @override
  void initState() {
    getTokenLogin();
    getPost = GetPost();
    super.initState();
  }

  getTokenLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    token = stringValue;
    setState(() {
      GetBerdagang.getStatusUser(token).then((value) {
        getBerdagang = value;
        setState(() {
          getUserStatus();
        });
      });
    });
  }

  Widget profileHeader() => Container(
        height: deviceSize.height / 4,
        width: double.infinity,
        child: Container(
          margin: EdgeInsets.only(top: 10.0),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Card(
              clipBehavior: Clip.antiAlias,
              color: Colors.blueAccent,
              child: Container(
                margin: EdgeInsets.all(8.0),
                child: FittedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            border:
                                Border.all(width: 2.0, color: Colors.white)),
                        child: CircleAvatar(
                          radius: 40.0,
                          backgroundImage: NetworkImage(
                              "https://i.ibb.co/jkDJfht/profile-jaya.jpg"),
                        ),
                      ),
                      Text(
                        nama_seller,
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                      // Text(
                      //   kategori,
                      //   style: TextStyle(color: Colors.white),
                      // ),
                      Row(
                        children: [
                          IconButton(
                              icon: Icon(Icons.add_a_photo),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) => new Post()));
                              }),
                          IconButton(
                            icon: Icon(Icons.person_add_alt_1),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) =>
                                          new ProfileBerdagang()));
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

  Widget profileColumn() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              backgroundImage:
                  NetworkImage("https://i.ibb.co/jkDJfht/profile-jaya.jpg"),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Fahrul Sanjaya Post",
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    "25 mins ago",
                  )
                ],
              ),
            ))
          ],
        ),
      );
  Widget followColumn(Size deviceSize) => Container(
        height: deviceSize.height * 0.13,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            ProfileTile(
              title: post,
              subtitle: "Posts",
            ),
            FlutterSwitch(
              width: 125.0,
              height: 55.0,
              valueFontSize: 25.0,
              toggleSize: 45.0,
              value: status,
              borderRadius: 30.0,
              padding: 8.0,
              activeColor: Colors.blueAccent,
              showOnOff: true,
              onToggle: (val) {
                setState(() {
                  status = val;
                  if (status == true) {
                    statusSeller = "1";
                  } else {
                    statusSeller = "0";
                  }
                  PostStatus.postStatusSeller(statusSeller, token)
                      .then((value) {
                    print(value);
                  });
                });
              },
            ),
            ProfileTile(
              title: favorite,
              subtitle: "Followers",
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    GetPost().getProfiles(token).then((value) => print("value: $value"));
    deviceSize = MediaQuery.of(context).size;
    return CommonScaffold(
      bodyData: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            profileHeader(),
            followColumn(deviceSize),
            SizedBox(
              width: double.infinity,
              child: Material(
                borderRadius: BorderRadius.circular(30.0),
                shadowColor: Colors.lightBlueAccent.shade100,
                elevation: 5.0,
                child: MaterialButton(
                  minWidth: 200.0,
                  height: 42.0,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProfileBerdagang(),
                    ));
                  },
                  color: Colors.blue,
                  child: Text(
                    'Ganti Profil Berdagang',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            FutureBuilder(
              future: getPost.getProfiles(token),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Datapost>> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                        "Something wrong with message: ${snapshot.error.toString()}"),
                  );
                } else if (snapshot.connectionState == ConnectionState.done) {
                  List<Datapost> profiles = snapshot.data;
                  return _buildListView(profiles);
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
      elevation: 0.0,
    );
  }

  void getUserStatus() {
    if (getBerdagang.data != null) {
      if (getBerdagang.status == 200) {
        nama_seller = getBerdagang.data.seller.namaSeller;
        kategori = getBerdagang.data.seller.kategori;
        if (getBerdagang.data.seller.status == '1') {
          status = true;
        } else {
          status = false;
        }
        favorite = getBerdagang.data.favorite.toString();
        post = getBerdagang.data.post.toString();
      } else {
        Fluttertoast.showToast(
            msg: getBerdagang.message,
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

  Widget _buildListView(List<Datapost> profiles) {
    return profiles.length != 0
        ? RefreshIndicator(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                Datapost profile = profiles[index];
                print(profile.foto);
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
                                      SizedBox(
                                        height: 10.0,
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
            onRefresh: () => getPost.getProfiles(token),
          )
        : Center(child: CircularProgressIndicator());
  }
}
