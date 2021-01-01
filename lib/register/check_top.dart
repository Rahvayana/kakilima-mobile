import 'package:aplikasi_pertama/network/postResponse/cekOtpResponse.dart';
import 'package:aplikasi_pertama/register/profile_register.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pin_view/pin_view.dart';

class CheckOtp extends StatefulWidget {
  String something;
  CheckOtp(this.something);
  @override
  State<StatefulWidget> createState() {
    return _CheckOtpState(this.something);
  }
  // @override
  // _CheckOtpState createState() => _CheckOtpState();
}

class _CheckOtpState extends State<CheckOtp> {
  String something;
  _CheckOtpState(this.something);
  String noTelp;
  CekOtpResponse cekOtpResponse = null;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: SingleChildScrollView(
              child: SafeArea(
                  child: Container(
                      padding: EdgeInsets.all(15.0),
                      child: Column(children: <Widget>[
                        new Container(
                          margin: EdgeInsets.only(top: 120.0),
                          child: new Image.asset(
                            'images/otp_cek.png',
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
                          margin: EdgeInsets.only(top: 40.0, bottom: 20.0),
                          child: Text(
                            'Masukan kode verifikasi yang telah dikirimkan ke ' +
                                something,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.greenAccent),
                          ),
                        ),
                        PinView(
                            count: 5, // describes the field number
                            autoFocusFirstField: false, // defaults to true
                            margin: EdgeInsets.all(
                                2.5), // margin between the fields
                            obscureText: false,
                            style: TextStyle(
                                // style for the fields
                                fontSize: 19.0,
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.w500),
                            submit: (String pin) {
                              CekOtpResponse.cekOtp(something, pin)
                                  .then((value) {
                                cekOtpResponse = value;
                                setState(() {
                                  checkResponse();
                                });
                              });
                            }),
                        Container(
                          margin: EdgeInsets.only(top: 40.0),
                          child: Image.asset('images/city_image.png'),
                        )
                      ]))),
            )));
  }

  checkResponse() {
    // showAlertDialog(context);
    if (cekOtpResponse != null) {
      if (cekOtpResponse.status == 200) {
        print(cekOtpResponse.message + " " + cekOtpResponse.data);
        Navigator.pop(context);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                RegisterProfile(cekOtpResponse.data.toString())));
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: cekOtpResponse.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.greenAccent,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
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
