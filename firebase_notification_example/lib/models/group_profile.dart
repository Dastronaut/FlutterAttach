import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_notification_example/constants/firestore_constant.dart';
import 'package:flutter/foundation.dart';

class GroupData extends Equatable {
  final String groupId;
  final String photoUrl;
  final String groupName;
  final String adminName;
  final String adminId;
  final List<dynamic> members;

  const GroupData({
    required this.groupId,
    required this.photoUrl,
    required this.groupName,
    required this.adminName,
    required this.adminId,
    required this.members,
  });

  GroupData copyWith(
          {String? adminId,
          String? adminName,
          String? groupId,
          String? groupName,
          List<dynamic>? members,
          String? photoUrl}) =>
      GroupData(
          adminId: adminId ?? this.adminId,
          adminName: adminName ?? this.adminName,
          groupId: groupId ?? this.groupId,
          groupName: groupName ?? this.groupName,
          members: members ?? this.members,
          photoUrl: photoUrl ?? this.photoUrl);

  Map<String, dynamic> toJson() => {
        FirestoreConstants.adminId: adminId,
        FirestoreConstants.adminName: adminName,
        FirestoreConstants.groupId: groupId,
        FirestoreConstants.groupName: groupName,
        FirestoreConstants.photoUrl: photoUrl,
        FirestoreConstants.members: members
      };

  factory GroupData.fromDocument(DocumentSnapshot snapshot) {
    String adminId = "";
    String adminName = "";
    String groupId = "";
    String groupName = "";
    String photoUrl = "";
    List<dynamic> members = [];

    try {
      adminId = snapshot.get(FirestoreConstants.adminId);
      adminName = snapshot.get(FirestoreConstants.adminName);
      groupId = snapshot.get(FirestoreConstants.groupId);
      groupName = snapshot.get(FirestoreConstants.groupName);
      photoUrl = snapshot.get(FirestoreConstants.photoUrl);
      members = snapshot.get(FirestoreConstants.members);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return GroupData(
        adminId: adminId,
        adminName: adminName,
        groupId: groupId,
        groupName: groupName,
        members: members,
        photoUrl: photoUrl);
  }

  @override
  String toString() {
    return 'adminId: $adminId\nadminName: $adminName\ngroupId: $groupId\ngroupName: $groupName\nmembers: $members';
  }

  @override
  List<Object?> get props =>
      [adminId, photoUrl, adminName, groupId, groupName, groupId];
}
