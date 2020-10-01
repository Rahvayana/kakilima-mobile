import 'package:aplikasi_pertama/login.dart';
import 'package:aplikasi_pertama/network/postResponse/sendOtpResponse.dart';
import 'package:aplikasi_pertama/register/check_top.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final noHp = TextEditingController();
  String noTelp;
  SendOtpResponse sendOtpResponse = null;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          child: SingleChildScrollView(
            child: Form(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      new Container(
                        margin: EdgeInsets.only(top: 60.0),
                        child: new Image.asset(
                          'images/input_mobile.png',
                          height: 150.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      new Container(
                        margin: EdgeInsets.only(top: 40.0),
                        child: Text(
                          'Mobile Verification',
                          style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.greenAccent),
                        ),
                      ),
                      new Container(
                        width: 300,
                        margin: EdgeInsets.only(top: 40.0),
                        child: Text(
                          'Kami akan mengirim kode verifikasi pada nomor handphone yang anda masukan',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.greenAccent),
                        ),
                      ),
                      new Container(
                          width: 300,
                          margin: EdgeInsets.only(top: 40.0),
                          child: TextFormField(
                            controller: noHp,
                            keyboardType: TextInputType.phone,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 20.0,
                                fontFamily: 'roboto'),
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                            ),
                            validator: (phoneNumber) {
                              if (phoneNumber.isEmpty) {
                                print('Nomor Kosong');
                              }
                              noTelp = phoneNumber;
                              return null;
                            },
                          )),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Image.asset('images/go_button.png'),
                            iconSize: 50,
                            onPressed: () {
                              SendOtpResponse.sendOtpApi(noHp.text)
                                  .then((value) {
                                sendOtpResponse = value;
                                setState(() {
                                  checkResponse();
                                });
                              });
                            },
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Already have an account?'),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) => Login()),
                                    );
                                  },
                                  child: Text(
                                    '  Login',
                                    style: TextStyle(color: Colors.greenAccent),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                              child: Image.asset(
                            'images/city_image.png',
                            alignment: Alignment.bottomLeft,
                          )),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void checkResponse() {
    if (sendOtpResponse != null) {
      Navigator.pop(context);
      if (sendOtpResponse.status == 200) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                CheckOtp(sendOtpResponse.data.noHp.toString())));
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: sendOtpResponse.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.greenAccent,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }
}
