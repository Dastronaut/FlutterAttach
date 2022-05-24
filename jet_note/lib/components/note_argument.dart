class Note {
  final int? id;
  final String title;
  final String detail;
  final String datetime;

  Note({
    this.id,
    required this.title,
    required this.detail,
    required this.datetime,
  });

  Note.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        title = res["title"],
        detail = res["detail"],
        datetime = res["datetime"];
  Map<String, Object?> toMap() {
    return {'id': id, 'title': title, 'detail': detail, 'datetime': datetime};
  }
}
