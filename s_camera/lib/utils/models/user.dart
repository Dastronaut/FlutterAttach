class User {
  final bool buzzer;
  final bool light;

  User({
    required this.buzzer,
    required this.light,
  });

  Map<String, dynamic> toJson() => {'buzzer': buzzer, 'light': light};

  User.fromJson(Map<String, dynamic> json)
      : buzzer = json['buzzer'],
        light = json['light'];
}
