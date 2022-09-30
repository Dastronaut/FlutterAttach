import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_notification_example/constants/firestore_constant.dart';

class ChatMessages {
  String idFrom;
  String idTo;
  String timestamp;
  String content;
  String replyContent;
  int type;
  bool isPin = false;

  ChatMessages({
    required this.idFrom,
    required this.idTo,
    required this.timestamp,
    required this.content,
    required this.replyContent,
    required this.type,
    required this.isPin,
  });

  Map<String, dynamic> toJson() {
    return {
      FirestoreConstants.idFrom: idFrom,
      FirestoreConstants.idTo: idTo,
      FirestoreConstants.timestamp: timestamp,
      FirestoreConstants.content: content,
      FirestoreConstants.replyContent: replyContent,
      FirestoreConstants.type: type,
      FirestoreConstants.isPin: isPin,
    };
  }

  factory ChatMessages.fromDocument(DocumentSnapshot documentSnapshot) {
    String idFrom = documentSnapshot.get(FirestoreConstants.idFrom);
    String idTo = documentSnapshot.get(FirestoreConstants.idTo);
    String timestamp = documentSnapshot.get(FirestoreConstants.timestamp);
    String content = documentSnapshot.get(FirestoreConstants.content);
    String replyContent = documentSnapshot.get(FirestoreConstants.replyContent);
    int type = documentSnapshot.get(FirestoreConstants.type);
    bool isPin = documentSnapshot.get(FirestoreConstants.isPin);

    return ChatMessages(
        idFrom: idFrom,
        idTo: idTo,
        timestamp: timestamp,
        content: content,
        replyContent: replyContent,
        type: type,
        isPin: isPin);
  }

  ChatMessages copyWith({
    String? idFrom,
    String? idTo,
    String? timestamp,
    String? content,
    String? replyContent,
    int? type,
    bool? isPin,
  }) {
    return ChatMessages(
      idFrom: idFrom ?? this.idFrom,
      idTo: idTo ?? this.idTo,
      timestamp: timestamp ?? this.timestamp,
      content: content ?? this.content,
      replyContent: replyContent ?? this.replyContent,
      type: type ?? this.type,
      isPin: isPin ?? this.isPin,
    );
  }
}
