class User {
  final bool buzzer;
  final bool light;
  final bool safety;

  User({
    required this.buzzer,
    required this.light,
    required this.safety,
  });

  Map<String, dynamic> toJson() =>
      {'buzzer': buzzer, 'light': light, 'safety': safety};

  User.fromJson(Map<String, dynamic> json)
      : buzzer = json['buzzer'],
        light = json['light'],
        safety = json['safety'];
  @override
  String toString() {
    // TODO: implement toString
    return buzzer.toString();
  }
}
