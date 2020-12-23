import 'package:aplikasi_pertama/pages/ChatPage.dart';
import 'package:aplikasi_pertama/pages/HomePage.dart';
import 'package:aplikasi_pertama/pages/MapsPage.dart';
import 'package:aplikasi_pertama/pages/ProfilePage.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  Widget callPage(int value) {
    switch (value) {
      case 0:
        return HomePage();
      case 1:
        return MapsPage();
      case 2:
        return LoginScreen();
      case 3:
        return ProfilePage();
        break;
      default:
        return HomePage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: callPage(_currentIndex),
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (value) {
              setState(() {
                _currentIndex = value;
              });
            },
            items: [
              BottomNavigationBarItem(
                  backgroundColor: Colors.blue,
                  icon: Icon(Icons.home),
                  title: Text("Home")),
              BottomNavigationBarItem(
                  backgroundColor: Colors.red,
                  icon: Icon(Icons.map),
                  title: Text("Maps")),
              BottomNavigationBarItem(
                  backgroundColor: Colors.purple,
                  icon: Icon(Icons.chat),
                  title: Text("Chat")),
              BottomNavigationBarItem(
                  backgroundColor: Colors.green,
                  icon: Icon(Icons.person),
                  title: Text("Profile")),
            ]),
      ),
    );
  }
}
