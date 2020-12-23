import 'dart:io';

import 'package:aplikasi_pertama/network/postResponse/PostResponse.dart';
import 'package:aplikasi_pertama/pages/HomePage.dart';
import 'package:aplikasi_pertama/subPages/berdagang.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Post extends StatefulWidget {
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  File selectedImage;
  Uri filename;
  String token;
  final _picker = ImagePicker();
  TextEditingController deskripsi = TextEditingController();
  TextEditingController judul = TextEditingController();

  void initState() {
    getTokenLogin();
    super.initState();
  }

  getTokenLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    token = stringValue;
    print(token);
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
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          _showPicker(context);
                        },
                        child: Container(
                          width: 200,
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
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.grey[800],
                                  ),
                                ),
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: judul,
                      decoration: InputDecoration(
                        labelText: 'Judul',
                      ),
                    ),
                    TextFormField(
                      controller: deskripsi,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Deskripsi',
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          iconSize: 50,
                          onPressed: () {
                            Service service = Service();
                            service.submitSubscription(
                              file: selectedImage,
                              filename: filename,
                              judul: judul.text,
                              deskripsi: deskripsi.text,
                              token: token,
                            );
                            Navigator.pushReplacement(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new Berdagang()),
                            );
                          },
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
