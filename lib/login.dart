import 'dart:convert';
import 'package:aplikasi_pertama/home.dart';
import 'package:aplikasi_pertama/register/register.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_pertama/network/api_login.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    getTokenLogin();
    super.initState();
  }

  getTokenLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    print(stringValue);
  }

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var email;
  var password;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return MaterialApp(
      key: _scaffoldKey,
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      new Container(
                        margin: EdgeInsets.only(top: 50.0),
                        child: new Image.asset(
                          'images/login_img.png',
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      new Container(
                        margin: EdgeInsets.only(top: 40.0),
                        child: Text(
                          'Login Form',
                          style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900]),
                        ),
                      ),
                      new Container(
                        width: 300,
                        margin: EdgeInsets.only(top: 40.0),
                        child: Text(
                          'Masukkan email serta password Anda bila belum mendaftar, silahkan register',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[900]),
                        ),
                      ),
                      new Container(
                          width: 300,
                          margin: EdgeInsets.only(top: 40.0),
                          child: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.blue[900],
                                fontSize: 16.0,
                                fontFamily: 'roboto'),
                            decoration: InputDecoration(
                              hintText: 'Email',
                              prefixIcon: Icon(
                                Icons.email,
                                color: Colors.blue[900],
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue[900]),
                              ),
                            ),
                            validator: (emailValue) {
                              if (emailValue.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: 'Masukkan Email Anda',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.blue[900],
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                              email = emailValue;
                              return null;
                            },
                          )),
                      new Container(
                          width: 300,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.blue[900],
                                fontSize: 16.0,
                                fontFamily: 'roboto'),
                            decoration: InputDecoration(
                              hintText: 'Password',
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.blue[900],
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue[900]),
                              ),
                            ),
                            validator: (passwordValue) {
                              if (passwordValue.isEmpty) {
                                Fluttertoast.showToast(
                                    msg: 'Masukkan Password Anda',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.blue[900],
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                              password = passwordValue;
                              return null;
                            },
                          )),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Image.asset('images/go_button_blue.png'),
                            iconSize: 50,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _login();
                              }
                            },
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Dont have an account?'),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) => Register()),
                                    );
                                  },
                                  child: Text(
                                    '  Register',
                                    style: TextStyle(color: Colors.blue[900]),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _login() async {
    showAlertDialog(context);
    setState(() {
      _isLoading = true;
    });
    var data = {'email': email, 'password': password};
    var res = await Network().authData(data, 'api/login');
    var body = json.decode(res.body);
    if (body['status'] == "200") {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', json.encode(body['token']));
      Navigator.pop(context);
      Navigator.pushAndRemoveUntil(
          context,
          new MaterialPageRoute(builder: (context) => MyApp()),
          (Route<dynamic> route) => false);
    } else {
      Navigator.pop(context);
      // _showMsg(body['message']);
      // print();
      Fluttertoast.showToast(
          msg: body['message'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.greenAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    setState(() {
      _isLoading = false;
    });
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5), child: Text("Loading")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
