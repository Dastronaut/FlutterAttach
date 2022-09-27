class PinChat {
  int id;
  String msg;
  String user;
  String time;

  PinChat(
      {required this.id,
      required this.msg,
      required this.user,
      required this.time});

  @override
  String toString() {
    return 'id: $id\nmsg: $msg\nuser: $user\ntime: $time';
  }
}
