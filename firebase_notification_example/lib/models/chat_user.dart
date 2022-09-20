import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_notification_example/constants/firestore_constant.dart';
import 'package:flutter/foundation.dart';

class ChatUser extends Equatable {
  final String id;
  final String photoUrl;
  final String displayName;
  final String phoneNumber;
  final String aboutMe;
  final String groupId;

  const ChatUser(
      {required this.id,
      required this.photoUrl,
      required this.displayName,
      required this.phoneNumber,
      required this.aboutMe,
      required this.groupId});

  ChatUser copyWith(
          {String? id,
          String? photoUrl,
          String? displayName,
          String? phoneNumber,
          String? aboutMe,
          String? groupId}) =>
      ChatUser(
          id: id ?? this.id,
          photoUrl: photoUrl ?? this.photoUrl,
          displayName: displayName ?? this.displayName,
          phoneNumber: phoneNumber ?? this.phoneNumber,
          aboutMe: aboutMe ?? this.aboutMe,
          groupId: groupId ?? this.groupId);

  Map<String, dynamic> toJson() => {
        FirestoreConstants.displayName: displayName,
        FirestoreConstants.photoUrl: photoUrl,
        FirestoreConstants.phoneNumber: phoneNumber,
        FirestoreConstants.aboutMe: aboutMe,
        FirestoreConstants.groupId: groupId
      };

  factory ChatUser.fromDocument(DocumentSnapshot snapshot) {
    String photoUrl = "";
    String nickname = "";
    String phoneNumber = "";
    String aboutMe = "";
    String groupId = "";

    try {
      photoUrl = snapshot.get(FirestoreConstants.photoUrl);
      nickname = snapshot.get(FirestoreConstants.displayName);
      phoneNumber = snapshot.get(FirestoreConstants.phoneNumber);
      aboutMe = snapshot.get(FirestoreConstants.aboutMe);
      groupId = snapshot.get(FirestoreConstants.groupId);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return ChatUser(
        id: snapshot.id,
        photoUrl: photoUrl,
        displayName: nickname,
        phoneNumber: phoneNumber,
        aboutMe: aboutMe,
        groupId: groupId);
  }
  @override
  List<Object?> get props =>
      [id, photoUrl, displayName, phoneNumber, aboutMe, groupId];
}
