import 'dart:async';
import 'dart:convert';

import 'package:aplikasi_pertama/network/api_login.dart';
import 'package:aplikasi_pertama/network/getResponse/ProfilePageUser.dart';
import 'package:aplikasi_pertama/utils/chat.dart';
import 'package:aplikasi_pertama/utils/const.dart';
import 'package:aplikasi_pertama/utils/home.dart';
import 'package:aplikasi_pertama/widgets/loading.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  var currentUserId;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  var id, name, foto;
  SharedPreferences prefs;

  bool isLoading = false;
  // List<Choice> choices = const <Choice>[
  //   const Choice(title: 'Settings', icon: Icons.settings),
  //   const Choice(title: 'Log out', icon: Icons.exit_to_app),
  // ];

  @override
  void initState() {
    handleSignIn();
    super.initState();
    // registerNotification();
    // configLocalNotification();
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

  // void registerNotification() {
  //   firebaseMessaging.requestNotificationPermissions();

  //   firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
  //     print('onMessage: $message');
  //     Platform.isAndroid
  //         ? showNotification(message['notification'])
  //         : showNotification(message['aps']['alert']);
  //     return;
  //   }, onResume: (Map<String, dynamic> message) {
  //     print('onResume: $message');
  //     return;
  //   }, onLaunch: (Map<String, dynamic> message) {
  //     print('onLaunch: $message');
  //     return;
  //   });

  //   firebaseMessaging.getToken().then((token) {
  //     print('token: $token');
  //     FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(currentUserId)
  //         .update({'pushToken': token});
  //   }).catchError((err) {
  //     Fluttertoast.showToast(msg: err.message.toString());
  //   });
  // }

  // void configLocalNotification() {
  //   var initializationSettingsAndroid =
  //       new AndroidInitializationSettings('ic_launcher');
  //   var initializationSettingsIOS = new IOSInitializationSettings();
  //   var initializationSettings = new InitializationSettings(
  //       initializationSettingsAndroid, initializationSettingsIOS);
  //   flutterLocalNotificationsPlugin.initialize(initializationSettings);
  // }

  // void onItemMenuPress(Choice choice) {
  //   if (choice.title == 'Log out') {
  //     handleSignOut();
  //   } else {
  //     Navigator.push(
  //         context, MaterialPageRoute(builder: (context) => ChatSettings()));
  //   }
  // }

//   void showNotification(message) async {
//     var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
//       Platform.isAndroid
//           ? 'com.example.aplikasi_pertama'
//           : 'com.example.aplikasi_pertama',
//       'Flutter chat demo',
//       'your channel description',
//       playSound: true,
//       enableVibration: true,
//       importance: Importance.Max,
//       priority: Priority.High,
//     );
//     var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
//     var platformChannelSpecifics = new NotificationDetails(
//         androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

//     print(message);
// //    print(message['body'].toString());
// //    print(json.encode(message));

//     await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
//         message['body'].toString(), platformChannelSpecifics,
//         payload: json.encode(message));

// //    await flutterLocalNotificationsPlugin.show(
// //        0, 'plain title', 'plain body', platformChannelSpecifics,
// //        payload: 'item x');
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: WillPopScope(
          child: Stack(
            children: <Widget>[
              // List
              Container(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: Text('No Message Yet'));
                    } else {
                      return ListView.builder(
                        padding: EdgeInsets.all(10.0),
                        itemBuilder: (context, index) =>
                            buildItem(context, snapshot.data.documents[index]),
                        itemCount: snapshot.data.documents.length,
                      );
                    }
                  },
                ),
              ),

              // Loading
              Positioned(
                child: isLoading ? const Loading() : Container(),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    print(document.data());
    if (document.data()['id'] == currentUserId) {
      return Container();
    } else {
      // print('idfirebase ${document.data()['id']}');
      // print('idku $currentUserId');
      String fotoku =
          document.data()['photoUrl'].replaceAll(new RegExp('"'), '');
      String namaku =
          document.data()['nickname'].replaceAll(new RegExp('"'), '');
      return Container(
        child: FlatButton(
          child: Row(
            children: <Widget>[
              Material(
                child: document.data()['photoUrl'] != null
                    ? CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(
                            strokeWidth: 1.0,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(themeColor),
                          ),
                          width: 50.0,
                          height: 50.0,
                          padding: EdgeInsets.all(15.0),
                        ),
                        imageUrl: fotoku,
                        width: 50.0,
                        height: 50.0,
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.account_circle,
                        size: 50.0,
                        color: greyColor,
                      ),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                clipBehavior: Clip.hardEdge,
              ),
              Flexible(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          '$namaku',
                          style: TextStyle(color: primaryColor),
                        ),
                        alignment: Alignment.centerLeft,
                        margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 5.0),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.only(left: 20.0),
                ),
              ),
            ],
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Chat(
                          peerId: document.id,
                          peerAvatar: document.data()['photoUrl'],
                        )));
          },
          color: greyColor2,
          padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        ),
        margin: EdgeInsets.only(bottom: 10.0, left: 5.0, right: 5.0),
      );
    }
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}
