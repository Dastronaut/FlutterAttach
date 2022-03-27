class Contact {
  final int? id;
  final String name;
  final String numphone;
  final String? mail;

  bool isNull() {
    if (name.isEmpty && numphone.isEmpty) return true;
    return false;
  }

  Contact({
    this.id,
    required this.name,
    required this.numphone,
    this.mail,
  });

  Contact.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        numphone = res["numphone"],
        mail = res["mail"];
  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'numphone': numphone, 'mail': mail};
  }
}
