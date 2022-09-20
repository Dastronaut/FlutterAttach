import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_notification_example/constants/firestore_constant.dart';
import 'package:firebase_notification_example/models/chat_messages.dart';
import 'package:firebase_notification_example/models/group_profile.dart';
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
    print('GROUP CHAT ID FROM PROVIDER: $groupChatId');
    return firebaseFirestore
        .collection(FirestoreConstants.pathMessageCollection)
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy(FirestoreConstants.timestamp, descending: true)
        .limit(limit)
        .snapshots();
  }

  void sendChatMessage(
      String content, int type, String groupChatId, String currentUserId) {
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
        type: type);

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
}

class MessageType {
  static const text = 0;
  static const image = 1;
  static const sticker = 2;
}
