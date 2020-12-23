import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:math' show cos, sqrt, asin;

class MapView extends StatefulWidget {
  MapView({this.lat, this.lng});
  final double lat;
  final double lng;
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Completer<GoogleMapController> _mapController = Completer();
  final Set<Marker> _markers = Set();
  Position _currentPosition;
  String _currentAddress;
  LatLng destinationLatLong;

  final LatLng sourceLatLong = LatLng(-7.111284, 112.409118);
  final Set<Polyline> _polyline = {};
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  // Method for retrieving the current location
  _getCurrentLocation() async {
    destinationLatLong = LatLng(widget.lat, widget.lng);
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
        _markers.add(Marker(
            markerId: MarkerId("1"),
            position:
                LatLng(_currentPosition.latitude, _currentPosition.longitude),
            infoWindow: InfoWindow(
              title: "Lokasi Saya",
            ),
            icon: BitmapDescriptor.defaultMarker,
            visible: true));

        _markers.add(Marker(
            markerId: MarkerId("2"),
            position: destinationLatLong,
            infoWindow: InfoWindow(
              title: "Tujuan",
            ),
            icon: BitmapDescriptor.defaultMarker,
            visible: true));
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: GoogleMap(
        mapType: MapType.normal,
        polylines: _polyline,
        myLocationEnabled: true,
        onCameraIdle: () {
          print('camera stop');
        },
        initialCameraPosition: CameraPosition(
            target:
                LatLng(_currentPosition.latitude, _currentPosition.longitude),
            zoom: 14),
        onMapCreated: (GoogleMapController controller) {
          _mapController.complete(controller);
          _getPoliLine();
        },
        markers: _markers,
      ),
    );
  }

  Future<dynamic> _getPoliLine() {
    final JsonDecoder _decoder = JsonDecoder();

    final BASE_URL = "https://maps.googleapis.com/maps/api/directions/json?" +
        "origin=" +
        _currentPosition.latitude.toString() +
        "," +
        _currentPosition.longitude.toString() +
        "&destination=" +
        destinationLatLong.latitude.toString() +
        "," +
        destinationLatLong.longitude.toString() +
        "&key=AIzaSyBso351fPFMCdabJT4Kk6Vo3sBvTH2zuBQ";

    print(BASE_URL);
    return http.get(BASE_URL).then((http.Response response) {
      String res = response.body;
      int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        res = "{\"status\":" +
            statusCode.toString() +
            ",\"message\":\"error\",\"response\":" +
            res +
            "}";
        throw new Exception(res);
      }

      try {
        String _distance = _decoder
                .convert(res)["routes"][0]["legs"][0]["distance"]['text']
                .toString() ??
            'No Dispaly';
      } catch (e) {
        throw new Exception(res);
      }

      List<Steps> steps;
      try {
        steps =
            parseSteps(_decoder.convert(res)["routes"][0]["legs"][0]["steps"]);

        List<LatLng> _listOfLatLongs = [];

        for (final i in steps) {
          _listOfLatLongs.add(i.startLocation);
          _listOfLatLongs.add(i.endLocation);
        }

        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            _polyline.add(Polyline(
              polylineId: PolylineId("2"),
              visible: true,
              width: 8,
              points: _listOfLatLongs,
              color: Colors.blue,
            ));
          });
        });
      } catch (e) {
        throw new Exception(res);
      }

      return steps;
    });
  }

  List<Steps> parseSteps(final responseBody) {
    var list =
        responseBody.map<Steps>((json) => new Steps.fromJson(json)).toList();
    return list;
  }
}

class Steps {
  LatLng startLocation;
  LatLng endLocation;
  Steps({this.startLocation, this.endLocation});
  factory Steps.fromJson(Map<String, dynamic> json) {
    return new Steps(
        startLocation: new LatLng(
            json["start_location"]["lat"], json["start_location"]["lng"]),
        endLocation: new LatLng(
            json["end_location"]["lat"], json["end_location"]["lng"]));
  }
}
