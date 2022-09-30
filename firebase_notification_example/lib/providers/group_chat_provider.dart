import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_notification_example/constants/firestore_constant.dart';
import 'package:firebase_notification_example/models/chat_messages.dart';
import 'package:firebase_notification_example/models/group_profile.dart';
import 'package:firebase_notification_example/widgets/app_toast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupChatProvider {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;

  GroupChatProvider(
      {required this.prefs,
      required this.firebaseStorage,
      required this.firebaseFirestore});

  Future<bool> setPrefs(String key, String value) async {
    return await prefs.setString(key, value);
  }

  UploadTask uploadImageFile(File image, String filename) {
    Reference reference = firebaseStorage.ref().child(filename);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }

  Future<void> updateFirestoreData(
      String collectionPath, String docPath, Map<String, dynamic> dataUpdate) {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(docPath)
        .update(dataUpdate);
  }

  Stream<QuerySnapshot> getChatMessage(String groupChatId, int limit) {
    return firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .limit(limit)
        .snapshots();
  }

  void sendChatMessage(String content, String replyContent, int type,
      String groupChatId, String currentUserId, bool isPin) {
    DocumentReference documentReference = firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());
    ChatMessages chatMessages = ChatMessages(
        idFrom: currentUserId,
        idTo: groupChatId,
        timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        replyContent: replyContent,
        type: type,
        isPin: isPin);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(documentReference, chatMessages.toJson());
    });
  }

  Stream<QuerySnapshot> getFirestoreData(String collectionPath, int limit) {
    return firebaseFirestore
        .collection(collectionPath)
        .limit(limit)
        .snapshots();
  }

  void createGroup(GroupData groupData) {
    firebaseFirestore
        .collection(FirestoreConstants.pathGroupCollection)
        .doc(groupData.groupId)
        .set({
      FirestoreConstants.groupId: groupData.groupId,
      FirestoreConstants.groupName: groupData.groupName,
      FirestoreConstants.adminName: groupData.adminName,
      FirestoreConstants.adminId: groupData.adminId,
      FirestoreConstants.photoUrl: groupData.photoUrl,
      FirestoreConstants.members: groupData.members,
      "createdAt: ": DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  Future<void> leaveGroup(GroupData groupData, String userId) async {
    if (userId == groupData.adminId) {
      print('GROUP ID: ${groupData.groupId}');
      await firebaseFirestore
          .collection(FirestoreConstants.pathMessageCollection)
          .doc(groupData.groupId)
          .delete();
      await firebaseFirestore
          .collection(FirestoreConstants.pathGroupCollection)
          .doc(groupData.groupId)
          .delete();
      AppToast.showSuccess('Xóa nhóm thành công');
    } else {
      final List<String> members =
          groupData.members.map((e) => e.toString()).toList();
      members.remove(userId);
      GroupData newGroupData = groupData.copyWith(members: members);

      await firebaseFirestore
          .collection(FirestoreConstants.pathGroupCollection)
          .doc(groupData.groupId)
          .update(newGroupData.toJson());
      AppToast.showSuccess('Rời nhóm thành công');
    }
  }

  void addGroup(GroupData groupData, List<String> listUsers) {
    final List<String> members =
        groupData.members.map((e) => e.toString()).toList();
    members.addAll(listUsers);
    GroupData newGroupData = groupData.copyWith(members: members);

    firebaseFirestore
        .collection(FirestoreConstants.pathGroupCollection)
        .doc(groupData.groupId)
        .update(newGroupData.toJson());
    AppToast.showSuccess('Thêm thành viên thành công');
  }

  Future<void> updateChatMessage(
      String groupChatId, ChatMessages chatMessages) async {
    await firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(chatMessages.timestamp)
        .update(chatMessages.toJson());
  }
}

class MessageType {
  static const text = 0;
  static const image = 1;
  static const sticker = 2;
}
