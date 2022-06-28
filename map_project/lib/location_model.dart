class Location {
  final double lon;
  final double lat;

  Location({
    required this.lon,
    required this.lat,
  });

  Map<String, dynamic> toJson() => {'lon': lon, 'lat': lat};

  Location.fromJson(Map<String, dynamic> json)
      : lon = json['lon'],
        lat = json['lat'];
}
