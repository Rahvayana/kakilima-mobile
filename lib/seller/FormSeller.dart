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

class FormSeller extends StatefulWidget {
  @override
  _FormSellerState createState() => _FormSellerState();
}

class _FormSellerState extends State<FormSeller> {
  final _formKey = GlobalKey<FormState>();

  Future<File> file;
  String status = '';
  String something;
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
      body: SafeArea(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      new Container(
                        margin: EdgeInsets.only(top: 30.0, bottom: 10.0),
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
                              hintText: 'Nama Seller',
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
                          child: TextFormField(
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.blue[900],
                                fontSize: 16.0,
                                fontFamily: 'roboto'),
                            decoration: InputDecoration(
                              hintText: 'Kategori Seller',
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
                            maxLines: 3,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.blue[900],
                                fontSize: 16.0,
                                fontFamily: 'roboto'),
                            decoration: InputDecoration(
                              hintText: 'Deskripsi',
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_forward_ios),
                            iconSize: 50,
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                // submitProfile();
                                // SubmitProfileResponse.submitProfile(nama, email, formatter.format(tgl_lahir),alamat, provinsi, kota, kecamatan, password, no_hp).then((value){
                                //   setState(() {
                                //     submitProfileResponse=value;
                                //     checkResponse();
                                //   });
                                // });
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
      ),
    ));
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
              borderRadius: BorderRadius.circular(10.0),
              child: Image.file(
                snapshot.data,
                fit: BoxFit.fill,
                width: 100.0,
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
