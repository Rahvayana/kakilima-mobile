import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps extends StatefulWidget {
  Maps({this.lat, this.lng});
  final double lat;
  final double lng;
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.5), 'images/marker.png')
        .then((onValue) {
      pinLocationIcon = onValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    LatLng pinPosition = LatLng(widget.lat, widget.lng);

    // these are the minimum required values to set
    // the camera position
    CameraPosition initialLocation =
        CameraPosition(zoom: 16, bearing: 30, target: pinPosition);
    return GoogleMap(
        myLocationEnabled: true,
        markers: _markers,
        initialCameraPosition: initialLocation,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          setState(() {
            _markers.add(Marker(
                markerId: MarkerId('<MARKER_ID>'),
                position: pinPosition,
                icon: pinLocationIcon));
          });
        });
  }
}
