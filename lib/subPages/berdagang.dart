import 'package:aplikasi_pertama/network/getResponse/GetBerdagang.dart';
import 'package:aplikasi_pertama/network/postResponse/postStatus.dart';
import 'package:aplikasi_pertama/subPages/Posts.dart';
import 'package:aplikasi_pertama/subPages/profile_berdagang.dart';
import 'package:aplikasi_pertama/widgets/common_scaffold.dart';
import 'package:aplikasi_pertama/widgets/profile_tile.dart';
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
  Widget imagesCard() => Container(
        height: deviceSize.height / 6,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Followers",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
                ),
              ),
              Expanded(
                child: Card(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, i) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(
                          "https://cdn.pixabay.com/photo/2016/10/31/18/14/ice-1786311_960_720.jpg"),
                    ),
                  ),
                ),
              ),
            ],
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

  Widget postCard(String urlImage) => Container(
        width: double.infinity,
        height: deviceSize.height / 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Post",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18.0),
                ),
              ),
              profileColumn(),
              Expanded(
                child: Card(
                  elevation: 2.0,
                  child: Image.network(
                    urlImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
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
  Widget bodyData() => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            profileHeader(),
            followColumn(deviceSize),
            imagesCard(),
            postCard(
                'https://www.foodsafetynews.com/files/2020/05/World-Food-Safety-1.jpg'),
            postCard(
                'https://www.reachsummit.co.za/wp-content/uploads/2020/03/Summit_CheckingItsSafe.jpg')
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    return CommonScaffold(
      bodyData: bodyData(),
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
}
