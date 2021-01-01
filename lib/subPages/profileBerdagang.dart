import 'dart:io';

import 'package:aplikasi_pertama/network/getResponse/GetBerdagang.dart';
import 'package:aplikasi_pertama/network/postResponse/PostSellerBody.dart';
import 'package:aplikasi_pertama/subPages/maps.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:place_picker/entities/entities.dart';
import 'package:place_picker/place_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileBerdagang extends StatefulWidget {
  @override
  _ProfileBerdagangState createState() => _ProfileBerdagangState();
}

class _ProfileBerdagangState extends State<ProfileBerdagang> {
  final _formKey = GlobalKey<FormState>();
  var nama,
      email,
      no_hp,
      password,
      tgl_lahir,
      alamat,
      provinsi,
      lat,
      long,
      token;
  var kategori = '', nama_seller = '', deskripsi = '', favorite = '', post = '';

  GetBerdagang getBerdagang = null;

  void initState() {
    print('jalan');
    getTokenLogin();
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
                        // Center(
                        //   child: GestureDetector(
                        //     onTap: () {
                        //       _showPicker(context);
                        //     },
                        //     child: Container(
                        //       width: 100,
                        //       child: selectedImage != null
                        //           ? ClipRRect(
                        //               // borderRadius: BorderRadius.circular(50),
                        //               child: Image.file(
                        //                 selectedImage,
                        //                 fit: BoxFit.fitHeight,
                        //               ),
                        //             )
                        //           : Container(
                        //               height: 100,
                        //               decoration: BoxDecoration(
                        //                 color: Colors.grey[200],
                        //                 // borderRadius: BorderRadius.circular(50)
                        //               ),
                        //               child: Card(
                        //                 child: Image.asset(
                        //                   'images/add-image.png',
                        //                   fit: BoxFit.fill,
                        //                   height: 100.0,
                        //                 ),
                        //               ),
                        //             ),
                        //     ),
                        //   ),
                        // ),
                        new Container(
                            width: MediaQuery.of(context).size.width * 0.90,
                            child: TextFormField(
                              textAlign: TextAlign.left,
                              controller: TextEditingController(
                                  text: nama_seller ?? ''),
                              style: TextStyle(
                                  color: Colors.blue[900],
                                  fontSize: 16.0,
                                  fontFamily: 'roboto'),
                              decoration: InputDecoration(
                                hintText: 'Nama Toko',
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blue[900]),
                                ),
                              ),
                              validator: (namaValue) {
                                if (namaValue.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: 'Masukkan Nama Toko Anda',
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
                              maxLines: 4,
                              controller:
                                  TextEditingController(text: deskripsi),
                              keyboardType: TextInputType.text,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Colors.blue[900],
                                  fontSize: 16.0,
                                  fontFamily: 'roboto'),
                              decoration: InputDecoration(
                                hintText: 'Deskripsi',
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blue[900]),
                                ),
                              ),
                              validator: (passwordValue) {
                                if (passwordValue.isEmpty) {
                                  Fluttertoast.showToast(
                                      msg: 'Masukkan Deskripsi Anda',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.blue[900],
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                }
                                deskripsi = passwordValue;
                                return null;
                              },
                            )),
                        FlatButton(
                          child: Text("Lokasi Anda Sementara"),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Maps(
                                      // data: navigasi,
                                      lat: lat,
                                      lng: long)),
                            );
                          },
                        ),
                        FlatButton(
                          child: Text("Ganti Lokasi Anda"),
                          onPressed: () {
                            showPlacePicker();
                          },
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(height: 10.0),
                            MaterialButton(
                              minWidth: 200.0,
                              height: 42.0,
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  print(nama);
                                  PostSellerBody.postSellerBody(
                                          nama, deskripsi, lat, long, token)
                                      .then((value) {
                                    print(value);
                                  });
                                }
                              },
                              color: Colors.blue,
                              child: Text(
                                'Simpan',
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.left,
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
        ));
  }

  void showPlacePicker() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            PlacePicker("AIzaSyBso351fPFMCdabJT4Kk6Vo3sBvTH2zuBQ")));

    // Handle the result in your way
    print(result.formattedAddress);
    setState(() {
      alamat = result.formattedAddress;
      lat = result.latLng.latitude;
      long = result.latLng.longitude;
    });
    print(result.latLng.latitude);
  }

  void getUserStatus() {
    if (getBerdagang.data != null) {
      if (getBerdagang.status == 200) {
        nama_seller = getBerdagang.data.seller.namaSeller;
        kategori = getBerdagang.data.seller.kategori;
        deskripsi = getBerdagang.data.seller.deskripsi;
        lat = getBerdagang.data.seller.latitude;
        long = getBerdagang.data.seller.longitude;
        favorite = getBerdagang.data.favorite.toString();
        post = getBerdagang.data.post.toString();
        print(nama_seller);
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
