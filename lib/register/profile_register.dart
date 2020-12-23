import 'dart:convert';
import 'dart:io';
import 'package:aplikasi_pertama/login.dart';
import 'package:aplikasi_pertama/network/postResponse/submitProfileResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class RegisterProfile extends StatefulWidget {
  @override
  // _RegisterProfileState createState() => _RegisterProfileState(this.some);
  String something;
  RegisterProfile(this.something);
  @override
  State<StatefulWidget> createState() {
    return _RegisterProfileState(this.something);
  }
}

class _RegisterProfileState extends State<RegisterProfile> {
  String something;
  _RegisterProfileState(this.something);
  DateTime selectedDate = DateTime.now();
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  SubmitProfileResponse submitProfileResponse = null;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1950, 1),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  String _baseUrl = "https://ruangapi.com/api/v1/provinces";
  List _dataProvince;
  void getProvince() async {
    final respose = await http.get(_baseUrl, headers: {
      HttpHeaders.authorizationHeader:
          "DZoL7WiRMYODrQcDrq4Sbe6HFlml9V7veP2U5dSq",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.acceptHeader: "application/json"
    });
    var listData = jsonDecode(respose.body);

    print(listData['data']['results']);
    setState(() {
      _dataProvince = listData['data']['results'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProvince();
  }

  final _formKey = GlobalKey<FormState>();

  Future<File> file;
  String status = '';
  var nama,
      email,
      no_hp,
      password,
      tgl_lahir,
      alamat,
      provinsi,
      kota,
      kecamatan;
  String _valProvince;
  String namaProvince;
  String nomorHp = '082264046359';
  var urlImage = 'images/add-image.png';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
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
                      margin: EdgeInsets.only(top: 30.0),
                      child: FlatButton(
                        onPressed: chooseImage,
                        child: showImage(),
                      ),
                    ),
                    new Container(
                        width: MediaQuery.of(context).size.width * 0.90,
                        child: TextFormField(
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.blue[900],
                              fontSize: 16.0,
                              fontFamily: 'roboto'),
                          decoration: InputDecoration(
                            hintText: 'Nama',
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.blue[900],
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue[900]),
                            ),
                          ),
                          validator: (namaValue) {
                            if (namaValue.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'Masukkan Nama Anda',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.blue[900],
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                            nama = namaValue;
                            return null;
                          },
                        )),
                    new Container(
                        width: MediaQuery.of(context).size.width * 0.90,
                        margin: EdgeInsets.only(top: 10.0),
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
                        width: MediaQuery.of(context).size.width * 0.90,
                        margin: EdgeInsets.only(top: 10.0),
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
                    new Container(
                        width: MediaQuery.of(context).size.width * 0.90,
                        margin: EdgeInsets.only(top: 10.0),
                        child: TextFormField(
                          textAlign: TextAlign.left,
                          controller: TextEditingController(text: something),
                          readOnly: true,
                          style: TextStyle(
                              color: Colors.blue[900],
                              fontSize: 16.0,
                              fontFamily: 'roboto'),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.phone,
                              color: Colors.blue[900],
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue[900]),
                            ),
                          ),
                          validator: (noHpValue) {
                            no_hp = something;
                            return null;
                          },
                        )),
                    new Container(
                        width: MediaQuery.of(context).size.width * 0.90,
                        margin: EdgeInsets.only(top: 10.0),
                        child: TextFormField(
                          textAlign: TextAlign.left,
                          readOnly: true,
                          onTap: () => _selectDate(context),
                          controller: TextEditingController(
                              text: formatter.format(selectedDate)),
                          style: TextStyle(
                              color: Colors.blue[900],
                              fontSize: 16.0,
                              fontFamily: 'roboto'),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.date_range,
                              color: Colors.blue[900],
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue[900]),
                            ),
                          ),
                          validator: (tglValue) {
                            if (tglValue.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'Masukkan Tanggal Lahir Anda',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.blue[900],
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                            tgl_lahir = selectedDate;
                            return null;
                          },
                        )),
                    new Container(
                        width: MediaQuery.of(context).size.width * 0.90,
                        margin: EdgeInsets.only(top: 10.0),
                        child: TextFormField(
                          maxLines: 3,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.blue[900],
                              fontSize: 16.0,
                              fontFamily: 'roboto'),
                          decoration: InputDecoration(
                            hintText: 'Alamat',
                            prefixIcon: Icon(
                              Icons.home,
                              color: Colors.blue[900],
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue[900]),
                            ),
                          ),
                          validator: (alamatValue) {
                            if (alamatValue.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'Masukkan Alamat Anda',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.blue[900],
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                            alamat = alamatValue;
                            return null;
                          },
                        )),
                    new Container(
                        width: MediaQuery.of(context).size.width * 0.90,
                        margin: EdgeInsets.only(top: 10.0),
                        child: TextFormField(
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.blue[900],
                              fontSize: 16.0,
                              fontFamily: 'roboto'),
                          decoration: InputDecoration(
                            hintText: 'Provinsi',
                            prefixIcon: Icon(
                              Icons.assignment,
                              color: Colors.blue[900],
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue[900]),
                            ),
                          ),
                          validator: (provinsiValue) {
                            if (provinsiValue.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'Masukkan Provinsi Anda',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.blue[900],
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                            provinsi = provinsiValue;
                            return null;
                          },
                        )),
                    new Container(
                        width: MediaQuery.of(context).size.width * 0.90,
                        margin: EdgeInsets.only(top: 10.0),
                        child: TextFormField(
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.blue[900],
                              fontSize: 16.0,
                              fontFamily: 'roboto'),
                          decoration: InputDecoration(
                            hintText: 'Kabupaten',
                            prefixIcon: Icon(
                              Icons.apps,
                              color: Colors.blue[900],
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue[900]),
                            ),
                          ),
                          validator: (kabupatenValue) {
                            if (kabupatenValue.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'Masukkan Kota Anda',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.blue[900],
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                            kota = kabupatenValue;
                            return null;
                          },
                        )),
                    new Container(
                        width: MediaQuery.of(context).size.width * 0.90,
                        margin: EdgeInsets.only(top: 10.0),
                        child: TextFormField(
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.blue[900],
                              fontSize: 16.0,
                              fontFamily: 'roboto'),
                          decoration: InputDecoration(
                            hintText: 'Kecamatan',
                            prefixIcon: Icon(
                              Icons.account_balance,
                              color: Colors.blue[900],
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue[900]),
                            ),
                          ),
                          validator: (kecamatanValue) {
                            if (kecamatanValue.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'Masukkan Kecamatan Anda',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.blue[900],
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                            kecamatan = kecamatanValue;
                            return null;
                          },
                        )),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          iconSize: 50,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              // submitProfile();
                              SubmitProfileResponse.submitProfile(
                                      nama,
                                      email,
                                      formatter.format(tgl_lahir),
                                      alamat,
                                      provinsi,
                                      kota,
                                      kecamatan,
                                      password,
                                      no_hp)
                                  .then((value) {
                                setState(() {
                                  submitProfileResponse = value;
                                  checkResponse();
                                });
                              });
                            }
                          },
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
    ));
  }

  void checkResponse() {
    showAlertDialog(context);
    if (submitProfileResponse != null) {
      if (submitProfileResponse.status == 200) {
        Navigator.pop(context);
        print(submitProfileResponse.message +
            " - " +
            submitProfileResponse.status.toString());
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Login()));
      } else {
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: submitProfileResponse.message,
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

  chooseImage() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.gallery);
    });
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Flexible(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: Image.file(
                snapshot.data,
                fit: BoxFit.fill,
                height: 100.0,
              ),
            ),
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return Flexible(
            child: Card(
              child: Image.asset(
                'images/add-image.png',
                fit: BoxFit.fill,
                height: 100.0,
              ),
            ),
          );
        }
      },
    );
  }
}
