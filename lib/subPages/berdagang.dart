import 'package:aplikasi_pertama/home.dart';
import 'package:aplikasi_pertama/pages/ProfilePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Berdagang extends StatefulWidget {
  @override
  _BerdagangState createState() => _BerdagangState();
}

class _BerdagangState extends State<Berdagang> {
  var urlFoto =
      'https://cdn2.iconfinder.com/data/icons/green-2/32/expand-color-web2-23-512.png';
  final _formKey = GlobalKey<FormState>();
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        centerTitle: true,
        leading: new IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => MyApp()),
              );
            }),
        title: Text('Berdagang'),
      ),
      body: new Center(
        child: SingleChildScrollView(
          child: new Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 5),
                child: Card(
                  child: Image.network(
                    'https://pngriver.com/wp-content/uploads/2018/04/Download-Food-PNG.png',
                    height: 100,
                  ),
                ),
              ),
              RatingBarIndicator(
                rating: 2.75,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 20.0,
                direction: Axis.horizontal,
              ),
              Form(
                  key: _formKey,
                  child: Column(children: [
                    new Container(
                        width: MediaQuery.of(context).size.width * 0.90,
                        child: TextFormField(
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.blue[900],
                              fontSize: 16.0,
                              fontFamily: 'roboto'),
                          decoration: InputDecoration(
                            hintText: 'Nama Toko',
                            prefixIcon: Icon(
                              Icons.store,
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
                            // nama = namaValue;
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
                            hintText: 'Kategori',
                            prefixIcon: Icon(
                              Icons.category,
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
                            // nama = namaValue;
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
                            hintText: 'Deskripsi',
                            prefixIcon: Icon(
                              Icons.description,
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
                            // nama = namaValue;
                            return null;
                          },
                        )),
                    new Container(
                        width: MediaQuery.of(context).size.width * 0.90,
                        child: TextFormField(
                          readOnly: true,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.blue[900],
                              fontSize: 16.0,
                              fontFamily: 'roboto'),
                          decoration: InputDecoration(
                            hintText: 'Nyalakan Pelacak',
                            prefixIcon: Icon(
                              Icons.map,
                              color: Colors.blue[900],
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue[900]),
                            ),
                            suffixIcon: Switch(
                              value: isSwitched,
                              onChanged: (value) {
                                setState(() {
                                  isSwitched = value;
                                  print(isSwitched);
                                });
                              },
                              activeTrackColor: Colors.lightGreenAccent,
                              activeColor: Colors.green,
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
                            // nama = namaValue;
                            return null;
                          },
                        )),
                  ])),
              DefaultTabController(
                length: 2,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: Column(
                    children: <Widget>[
                      TabBar(
                        tabs: <Widget>[
                          Tab(
                            icon: Icon(
                              Icons.dashboard,
                              color: Colors.blueAccent,
                            ),
                            child: Text(
                              'Postingan',
                              style: TextStyle(color: Colors.blueAccent),
                            ),
                          ),
                          Tab(
                            icon: Icon(
                              Icons.star,
                              color: Colors.blueAccent,
                            ),
                            child: Text(
                              'Ulasan',
                              style: TextStyle(color: Colors.blueAccent),
                            ),
                          )
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: <Widget>[
                            new StaggeredGridView.countBuilder(
                              crossAxisCount: 4,
                              itemCount: 8,
                              itemBuilder: (BuildContext context, int index) =>
                                  new Container(
                                      color: Colors.greenAccent,
                                      child: new Center(
                                        child: new CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: new Text('$index'),
                                        ),
                                      )),
                              staggeredTileBuilder: (int index) =>
                                  new StaggeredTile.count(
                                      2, index.isEven ? 2 : 1),
                              mainAxisSpacing: 4.0,
                              crossAxisSpacing: 4.0,
                            ),
                            ListView(
                              children: [
                                ListTile(
                                  leading: Icon(Icons.sentiment_satisfied,
                                      color: Colors.greenAccent),
                                  title: Text(
                                      'Makananya enak banget, rasanya pas'),
                                  subtitle: Text('Maniak Jajan'),
                                  onTap: () {
                                    //TO DO SomeThin
                                  },
                                  trailing: Icon(Icons.arrow_forward_ios),
                                ),
                                ListTile(
                                  leading: Icon(Icons.sentiment_very_satisfied,
                                      color: Colors.blueAccent),
                                  title: Text(
                                      'Es Legen nya segar!!!, recomended banget'),
                                  subtitle: Text('V for V'),
                                  onTap: () {
                                    //TO DO SomeThin
                                  },
                                  trailing: Icon(Icons.arrow_forward_ios),
                                ),
                                ListTile(
                                  leading: Icon(
                                      Icons.sentiment_very_dissatisfied,
                                      color: Colors.redAccent),
                                  title: Text(
                                      'Penjualnya cuek, apalagi ketika hujan'),
                                  subtitle: Text('Budi S'),
                                  onTap: () {
                                    //TO DO SomeThin
                                  },
                                  trailing: Icon(Icons.arrow_forward_ios),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
