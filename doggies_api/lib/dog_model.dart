class Dog {
  String? bredFor;
  String? breedGroup;
  Height? height;
  int? id;
  String? lifeSpan;
  String? name;
  String? origin;
  String? temperament;
  Weight? weight;
  String? url;

  Dog(
      {this.bredFor,
      this.breedGroup,
      this.height,
      this.id,
      this.lifeSpan,
      this.name,
      this.origin,
      this.temperament,
      this.weight,
      this.url});

  Dog.fromJson(Map<String, dynamic> json) {
    bredFor = json["bred_for"];
    breedGroup = json["breed_group"];
    height = json["height"] == null ? null : Height.fromJson(json["height"]);
    id = json["id"];
    lifeSpan = json["life_span"];
    name = json["name"];
    origin = json["origin"];
    temperament = json["temperament"];
    weight = json["weight"] == null ? null : Weight.fromJson(json["weight"]);
    url = json["url"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["bred_for"] = bredFor;
    data["breed_group"] = breedGroup;
    if (height != null) {
      data["height"] = height?.toJson();
    }
    data["id"] = id;
    data["life_span"] = lifeSpan;
    data["name"] = name;
    data["origin"] = origin;
    data["temperament"] = temperament;
    if (weight != null) {
      data["weight"] = weight?.toJson();
    }
    data["url"] = url;
    return data;
  }
}

class Weight {
  String? imperial;
  String? metric;

  Weight({this.imperial, this.metric});

  Weight.fromJson(Map<String, dynamic> json) {
    imperial = json["imperial"];
    metric = json["metric"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["imperial"] = imperial;
    data["metric"] = metric;
    return data;
  }
}

class Height {
  String? imperial;
  String? metric;

  Height({this.imperial, this.metric});

  Height.fromJson(Map<String, dynamic> json) {
    imperial = json["imperial"];
    metric = json["metric"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["imperial"] = imperial;
    data["metric"] = metric;
    return data;
  }
}
