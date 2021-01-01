import 'dart:convert';
import 'dart:io';

import 'package:aplikasi_pertama/network/api_login.dart';
import 'package:aplikasi_pertama/network/postResponse/updateProfileResponse.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileUser extends StatefulWidget {
  @override
  _ProfileUserState createState() => _ProfileUserState();
}

class _ProfileUserState extends State<ProfileUser> {
  final _formKey = GlobalKey<FormState>();
  String something;
  DateTime selectedDate = DateTime.now();
  DateFormat formatter = DateFormat('yyyy-MM-dd');

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

  File selectedImage;
  Uri filename;
  String token;
  final _picker = ImagePicker();

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
      foto,
      kecamatan;
  String _valProvince;
  String namaProvince;
  String nomorHp = '082264046359';
  var urlImage = 'images/add-image.png';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';
  getTokenLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    token = stringValue;
    var res = await Network().getData('api/apps/user');
    var body = json.decode(res.body);
    print(body['data']['user']['foto']);
    setState(() {
      nama = body['data']['user']['name'];
      email = body['data']['user']['email'];
      no_hp = body['data']['user']['no_hp'];
      tgl_lahir = body['data']['user']['tgl_lahir'];
      alamat = body['data']['user']['alamat'];
      provinsi = body['data']['user']['provinsi'];
      kota = body['data']['user']['kota'];
      foto = body['data']['user']['foto'];
      kecamatan = body['data']['user']['kecamatan'];
    });
  }

  @override
  void initState() {
    getTokenLogin();
    super.initState();
    // registerNotification();
    // configLocalNotification();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
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
                        SizedBox(height: 10.0),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              _showPicker(context);
                            },
                            child: Container(
                              width: 100,
                              child: selectedImage != null
                                  ? ClipRRect(
                                      // borderRadius: BorderRadius.circular(50),
                                      child: Image.file(
                                        selectedImage,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    )
                                  : Container(
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        // borderRadius: BorderRadius.circular(50)
                                      ),
                                      child: Card(
                                        child: foto != null
                                            ? Image.network(
                                                foto,
                                                fit: BoxFit.fill,
                                                height: 100.0,
                                              )
                                            : Image.asset(
                                                urlImage,
                                                fit: BoxFit.fitHeight,
                                              ),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        new Container(
                            width: MediaQuery.of(context).size.width * 0.90,
                            child: TextFormField(
                              textAlign: TextAlign.left,
                              controller: TextEditingController(text: nama),
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
                                  borderSide:
                                      BorderSide(color: Colors.blue[900]),
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
                              controller: TextEditingController(text: email),
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
                                  borderSide:
                                      BorderSide(color: Colors.blue[900]),
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
                              textAlign: TextAlign.left,
                              controller: TextEditingController(text: no_hp),
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
                                  borderSide:
                                      BorderSide(color: Colors.blue[900]),
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
                                  text: tgl_lahir == null
                                      ? formatter.format(selectedDate)
                                      : tgl_lahir),
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
                                  borderSide:
                                      BorderSide(color: Colors.blue[900]),
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
                              controller: TextEditingController(text: alamat),
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
                                  borderSide:
                                      BorderSide(color: Colors.blue[900]),
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
                              controller: TextEditingController(text: provinsi),
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
                                  borderSide:
                                      BorderSide(color: Colors.blue[900]),
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
                              controller: TextEditingController(text: kota),
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
                                  borderSide:
                                      BorderSide(color: Colors.blue[900]),
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
                              controller:
                                  TextEditingController(text: kecamatan),
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
                                  borderSide:
                                      BorderSide(color: Colors.blue[900]),
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
                        // Column(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   children: [
                        //     SizedBox(height: 10.0),
                        //     MaterialButton(
                        //       minWidth: 200.0,
                        //       height: 42.0,
                        //       onPressed: () {
                        //         if (_formKey.currentState.validate()) {
                        //           // submitProfile();
                        //           UpdateProfile service = UpdateProfile();
                        //           service
                        //               .submitSubscription(
                        //                 file: selectedImage,
                        //                 filename: filename,
                        //                 name: nama,
                        //                 tgl_lahir: formatter.format(tgl_lahir),
                        //                 alamat: alamat,
                        //                 provinsi: provinsi,
                        //                 kota: kota,
                        //                 kecamatan: kecamatan,
                        //               )
                        //               .then((value) {});
                        //         }
                        //       },
                        //       color: Colors.blue,
                        //       child: Text(
                        //         'Simpan',
                        //         style: TextStyle(color: Colors.white),
                        //         textAlign: TextAlign.left,
                        //       ),
                        //     ),
                        //   ],
                        // )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  // new ListTile(
                  //   leading: new Icon(Icons.photo_camera),
                  //   title: new Text('Camera'),
                  //   onTap: () {
                  //     _imgFromCamera();
                  //     Navigator.of(context).pop();
                  //   },
                  // ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromGallery() async {
    PickedFile image =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    if (image.path != null) {
      setState(() {
        selectedImage = File(image.path != null ? image.path : '');
      });
    }
  }
}
