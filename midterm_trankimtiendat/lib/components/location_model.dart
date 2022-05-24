import 'dart:convert';

Locations locationsFromJson(String str) => Locations.fromJson(json.decode(str));

class Locations {
  Locations({
    required this.lat,
    required this.lng,
    required this.desc,
    required this.zip,
    required this.title,
    required this.timeStamp,
    required this.twp,
    required this.addr,
    required this.e,
  });

  double lat;
  double lng;
  String desc;
  String zip;
  String title;
  String timeStamp;
  String twp;
  String addr;
  String e;
  factory Locations.fromJson(Map<String?, dynamic> json) => Locations(
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
        desc: json["desc"].toString(),
        zip: json["zip"].toString(),
        title: json["title"].toString(),
        timeStamp: json["timeStamp"].toString(),
        twp: json["twp"].toString(),
        addr: json["addr"].toString(),
        e: json["e"].toString(),
      );
}
