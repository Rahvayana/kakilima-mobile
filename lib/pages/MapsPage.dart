import 'dart:async';

import 'package:aplikasi_pertama/network/postResponse/postRating.dart';
import 'package:aplikasi_pertama/network/postResponse/postReview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/locations.dart' as locations;

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  var curLat = -7.113943, curLong = 112.408368;
  var ulasan = TextEditingController();
  String token;
  // var curLat, curLong;
  Completer<GoogleMapController> _controller = Completer();
  @override
  void initState() {
    getTokenLogin();
    getCurrentLocation();
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.5), 'images/marker.png')
        .then((onValue) {
      pinLocationIcon = onValue;
    });
  }

  getTokenLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = prefs.getString('token');
    token = stringValue;
  }

  BitmapDescriptor pinLocationIcon;
  var id, lat, long, img, name, rating, deskripsi, my_rating, my_review;
  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await locations.getGoogleOffices(token);
    setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
            icon: pinLocationIcon,
            markerId: MarkerId(office.name),
            position: LatLng(office.lat, office.lng),
            onTap: () {
              setState(() {
                id = office.id;
                lat = office.lat;
                long = office.lng;
                img = office.image;
                name = office.name;
                rating = office.rating != null ? office.rating : 0.0;
                deskripsi = office.deskripsi;
                my_rating = office.my_rating != null ? office.rating : 0.0;
                my_review = office.my_review != null ? office.my_review : '';
                ulasan.value = TextEditingValue(text: my_review);
                showMaterialModalBottomSheet(
                  context: context,
                  builder: (context, scrollController) => Container(
                    child: ListView(
                      children: [
                        Image.network(
                          img,
                          width: 600,
                          height: 240,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20.0, left: 20.0),
                          child: Text(
                            name,
                            style: GoogleFonts.openSans(fontSize: 32.0),
                          ),
                        ),
                        Row(
                          children: [
                            new Container(
                              margin: EdgeInsets.only(top: 10.0, left: 20.0),
                              child: Text(rating.toString()),
                            ),
                            new Container(
                              margin: EdgeInsets.only(top: 10.0, left: 5.0),
                              child: RatingBarIndicator(
                                rating: rating,
                                itemBuilder: (context, index) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 20.0,
                                direction: Axis.horizontal,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buttonCircle(Icons.near_me, 'RUTE'),
                              buttonCircle(Icons.favorite, 'FAVORITE'),
                            ],
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 10.0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [Text('Nilai Kami')])),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RatingBar(
                                  initialRating: my_rating,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (myrating) {
                                    PostRating.postRatingSeller(
                                            myrating, id, token)
                                        .then((value) {
                                      print(value);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        new Container(
                            margin: EdgeInsets.all(10),
                            child: TextField(
                              controller: ulasan,
                              decoration: InputDecoration(
                                hintText: "Reviewnya Dong KK :)",
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    PostReview.PostReviewSeller(
                                            ulasan.text, id, token)
                                        .then((value) {
                                      print(value);
                                    });
                                  },
                                  icon: Icon(Icons.send),
                                ),
                              ),
                            )),
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
                                        Icons.description,
                                        color: Colors.blueAccent,
                                      ),
                                      child: Text(
                                        'Deskripsi',
                                        style:
                                            TextStyle(color: Colors.blueAccent),
                                      ),
                                    ),
                                    Tab(
                                      icon: Icon(
                                        Icons.star,
                                        color: Colors.blueAccent,
                                      ),
                                      child: Text(
                                        'Ulasan',
                                        style:
                                            TextStyle(color: Colors.blueAccent),
                                      ),
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: TabBarView(
                                    children: <Widget>[
                                      Container(
                                          margin: EdgeInsets.all(10.0),
                                          child: Text(
                                            deskripsi,
                                            style: GoogleFonts.openSans(
                                                fontSize: 16.0),
                                          )),
                                      ListView(
                                        children: [
                                          ListTile(
                                            leading: Icon(
                                                Icons.sentiment_satisfied,
                                                color: Colors.greenAccent),
                                            title: Text(
                                                'Makananya enak banget, rasanya pas'),
                                            subtitle: Text('Maniak Jajan'),
                                            onTap: () {
                                              //TO DO SomeThin
                                            },
                                            trailing:
                                                Icon(Icons.arrow_forward_ios),
                                          ),
                                          ListTile(
                                            leading: Icon(
                                                Icons.sentiment_very_satisfied,
                                                color: Colors.blueAccent),
                                            title: Text(
                                                'Es Legen nya segar!!!, recomended banget'),
                                            subtitle: Text('V for V'),
                                            onTap: () {
                                              //TO DO SomeThin
                                            },
                                            trailing:
                                                Icon(Icons.arrow_forward_ios),
                                          ),
                                          ListTile(
                                            leading: Icon(
                                                Icons
                                                    .sentiment_very_dissatisfied,
                                                color: Colors.redAccent),
                                            title: Text(
                                                'Penjualnya cuek, apalagi ketika hujan'),
                                            subtitle: Text('Budi S'),
                                            onTap: () {
                                              //TO DO SomeThin
                                            },
                                            trailing:
                                                Icon(Icons.arrow_forward_ios),
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
                );
              });
            });
        _markers[office.name] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: curLat == null || curLong == null
            ? Container()
            : GoogleMap(
                mapType: MapType.normal,
                onMapCreated: _onMapCreated,
                myLocationButtonEnabled: true,
                myLocationEnabled: true,
                initialCameraPosition: CameraPosition(
                  target: LatLng(curLat, curLong),
                  zoom: 15.0,
                ),
                markers: _markers.values.toSet(),
              ),
      ),
    );
  }

  getCurrentLocation() async {
    final GoogleMapController controller = await _controller.future;
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      curLat = position.latitude.toDouble();
      curLong = position.longitude.toDouble();
    });
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(curLat, curLong),
        zoom: 17.0,
      ),
    ));
  }
}

Column buttonCircle(IconData icon, String label) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      MaterialButton(
        onPressed: () {},
        color: Colors.blue,
        textColor: Colors.white,
        child: Icon(
          icon,
          size: 15,
        ),
        padding: EdgeInsets.all(16),
        shape: CircleBorder(),
      ),
      Container(
        margin: EdgeInsets.only(top: 5.0),
        child: Text(
          label,
          style: GoogleFonts.openSans(fontSize: 12.0),
        ),
      ),
    ],
  );
}
