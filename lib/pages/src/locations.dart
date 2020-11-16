import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

part 'locations.g.dart';

@JsonSerializable()
class LatLng {
  LatLng({
    this.lat,
    this.lng,
  });

  factory LatLng.fromJson(Map<String, dynamic> json) => _$LatLngFromJson(json);
  Map<String, dynamic> toJson() => _$LatLngToJson(this);

  double lat;
  double lng;
}

@JsonSerializable()
// class Region {
//   Region({
//     this.coords,
//     this.id,
//     this.name,
//     this.zoom,
//   });

//   factory Region.fromJson(Map<String, dynamic> json) => _$RegionFromJson(json);
//   Map<String, dynamic> toJson() => _$RegionToJson(this);

//   final LatLng coords;
//   final String id;
//   final String name;
//   final double zoom;
// }

@JsonSerializable()
class Office {
  Office({
    this.id,
    this.image,
    this.lat,
    this.lng,
    this.name,
    this.rating,
    this.deskripsi,
    this.my_rating,
    this.my_review,
  });

  factory Office.fromJson(Map<String, dynamic> json) => _$OfficeFromJson(json);
  Map<String, dynamic> toJson() => _$OfficeToJson(this);

  final int id;
  final String image;
  final double lat;
  final double lng;
  final String name;
  final double rating;
  final double my_rating;
  final String deskripsi;
  final String my_review;
}

@JsonSerializable()
class Locations {
  Locations({
    this.offices,
    // this.regions,
  });

  factory Locations.fromJson(Map<String, dynamic> json) =>
      _$LocationsFromJson(json);
  Map<String, dynamic> toJson() => _$LocationsToJson(this);

  final List<Office> offices;
  // final List<Region> regions;
}

Future<Locations> getGoogleOffices(String token) async {
  const googleLocationsURL =
      'https://api-kakilima.herokuapp.com/api/apps/home/maps';
  String _token = token.replaceAll(new RegExp('"'), '');

  // Retrieve the locations of Google offices
  final response = await http.get(googleLocationsURL, headers: {
    HttpHeaders.authorizationHeader: "Bearer $_token".toString(),
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.acceptHeader: "application/json"
  });
  if (response.statusCode == 200) {
    print(response.body);
    return Locations.fromJson(json.decode(response.body));
  } else {
    throw HttpException(
        'Unexpected status code ${response.statusCode}:'
        ' ${response.reasonPhrase}',
        uri: Uri.parse(googleLocationsURL));
  }
}
