import 'dart:convert';
import 'dart:io';
import 'package:aplikasi_pertama/login.dart';
import 'package:aplikasi_pertama/network/postResponse/PostSellerBody.dart';
import 'package:aplikasi_pertama/network/postResponse/submitProfileResponse.dart';
import 'package:aplikasi_pertama/subPages/berdagang.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker/place_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FormBerdagang extends StatefulWidget {
  @override
  _FormBerdagangState createState() => _FormBerdagangState();
}

class _FormBerdagangState extends State<FormBerdagang> {
  final _formKey = GlobalKey<FormState>();
  var _controllertext = TextEditingController();
  File selectedImage;
  final _picker = ImagePicker();
  var nama, email, no_hp, password, tgl_lahir, alamat, provinsi, lat, long;
  TextEditingController nama_seller = TextEditingController();
  TextEditingController deskripsi = TextEditingController();
  String base64Image, token;
  File tmpFile;
  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  GoogleMapController _controller;
  Location _location = Location();
  @override
  void initState() {
    getTokenLogin();
    super.initState();
  }

  getTokenLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    token = stringValue;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: <Widget>[
                    // Center(
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       _showPicker(context);
                    //     },
                    //     child: CircleAvatar(
                    //       radius: 55,
                    //       backgroundColor: Color(0xffFDCF09),
                    //       child: selectedImage != null
                    //           ? ClipRRect(
                    //               borderRadius: BorderRadius.circular(50),
                    //               child: Image.file(
                    //                 selectedImage,
                    //                 width: 100,
                    //                 height: 100,
                    //                 fit: BoxFit.fitHeight,
                    //               ),
                    //             )
                    //           : Container(
                    //               decoration: BoxDecoration(
                    //                   color: Colors.grey[200],
                    //                   borderRadius: BorderRadius.circular(50)),
                    //               width: 100,
                    //               height: 100,
                    //               child: Icon(
                    //                 Icons.camera_alt,
                    //                 color: Colors.grey[800],
                    //               ),
                    //             ),
                    //     ),
                    //   ),
                    // ),
                    TextFormField(
                      controller: nama_seller,
                      decoration: InputDecoration(
                        labelText: 'Nama Toko',
                      ),
                    ),
                    TextFormField(
                      controller: deskripsi,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Deskripsi',
                      ),
                    ),
                    FlatButton(
                      child: Text("Pilih Lokasi Anda Sementara"),
                      onPressed: () {
                        showPlacePicker();
                      },
                    ),
                    Text(alamat ?? ''),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MaterialButton(
                          minWidth: 200.0,
                          height: 42.0,
                          onPressed: () {
                            PostSellerBody.postSellerBody(nama_seller.text,
                                    deskripsi.text, lat, long, token)
                                .then((value) {
                              print(value);
                              Navigator.pushReplacement(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => new Berdagang()));
                            });
                          },
                          color: Colors.blue,
                          child: Text(
                            'Register Berdagang',
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )),
      ),
    );
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
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
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

  _imgFromCamera() async {
    final image = await _picker.getImage(source: ImageSource.camera);
    setState(() {
      selectedImage = File(image.path != null ? image.path : '');
    });
  }
}
