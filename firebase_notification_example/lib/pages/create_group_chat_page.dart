import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_notification_example/constants/firestore_constant.dart';
import 'package:firebase_notification_example/constants/text_field_constants.dart';
import 'package:firebase_notification_example/models/chat_user.dart';
import 'package:firebase_notification_example/models/group_profile.dart';
import 'package:firebase_notification_example/pages/group_chat_page.dart';
import 'package:firebase_notification_example/providers/auth_provider.dart';
import 'package:firebase_notification_example/providers/group_chat_provider.dart';
import 'package:firebase_notification_example/utilities/keyboard_utils.dart';
import 'package:firebase_notification_example/widgets/loading_view.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreateGroupChatPage extends StatefulWidget {
  const CreateGroupChatPage(
      {super.key, required this.currentUserId, required this.currentUserName});
  final String currentUserId;
  final String currentUserName;

  @override
  State<CreateGroupChatPage> createState() => _CreateGroupChatPageState();
}

class _CreateGroupChatPageState extends State<CreateGroupChatPage> {
  TextEditingController displayGrNameController =
      TextEditingController(text: '');
  String id = '';

  final ScrollController scrollController = ScrollController();
  List<String> members = [];
  List<num> checkboxList = [];

  File? avaGroupImageFile;
  int _limit = 20;
  final int _limitIncrement = 20;
  bool isLoading = false;
  late GroupChatProvider groupChatProvider;
  late AuthProvider authProvider;
  String photoUrl = '';
  String displayGrName = '';
  final FocusNode focusNodeNickname = FocusNode();

  @override
  void initState() {
    super.initState();
    groupChatProvider = context.read<GroupChatProvider>();
  }

  void scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile = await imagePicker
        .pickImage(source: ImageSource.gallery)
        .catchError((onError) {
      Fluttertoast.showToast(msg: onError.toString());
    });
    File? image;
    if (pickedFile != null) {
      image = File(pickedFile.path);
    }
    if (image != null) {
      setState(() {
        avaGroupImageFile = image;
        isLoading = true;
      });
      uploadFile();
    }
  }

  Future uploadFile() async {
    String fileName = id;
    UploadTask uploadTask =
        groupChatProvider.uploadImageFile(avaGroupImageFile!, fileName);
    try {
      TaskSnapshot snapshot = await uploadTask;
      photoUrl = await snapshot.ref.getDownloadURL();
      await groupChatProvider.setPrefs(FirestoreConstants.photoUrl, photoUrl);
      setState(() {
        isLoading = false;
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Create group chat"),
      ),
      body: SafeArea(
        child: Stack(children: [
          Column(
            children: [
              GestureDetector(
                onTap: getImage,
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(20),
                  child: avaGroupImageFile == null
                      ? const Icon(
                          Icons.account_circle,
                          size: 90,
                          color: Colors.grey,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.file(
                            avaGroupImageFile!,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              const Text(
                'Group Name',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              TextField(
                decoration: kTextInputDecoration.copyWith(
                    hintText: 'Write your group Name'),
                controller: displayGrNameController,
                onChanged: (value) {
                  displayGrName = value;
                },
                focusNode: focusNodeNickname,
              ),
              const SizedBox(height: 15),
              const Text(
                'Add Member',
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: groupChatProvider.getFirestoreData(
                      FirestoreConstants.pathUserCollection, _limit),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      if ((snapshot.data?.docs.length ?? 0) > 0) {
                        return ListView.separated(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) => _buildItem(context,
                              snapshot.data?.docs[index], index, checkboxList),
                          controller: scrollController,
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                        );
                      } else {
                        return const Center(
                          child: Text('No user found...'),
                        );
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    if (KeyboardUtils.isKeyboardShowing()) {
                      KeyboardUtils.closeKeyboard(context);
                    }

                    String groupChatId = widget.currentUserId;
                    for (int i = 0; i < members.length; i++) {
                      groupChatId = groupChatId + members[i];
                    }

                    GroupData groupData = GroupData(
                        groupId: groupChatId,
                        photoUrl: photoUrl,
                        groupName: displayGrName,
                        adminName: widget.currentUserName,
                        adminId: widget.currentUserId,
                        members: members);

                    groupChatProvider.createGroup(groupData);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GroupChatPage(
                                  isCreate: true,
                                  groupData: groupData,
                                  currentUserId: widget.currentUserId,
                                )));
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Create Group'),
                  )),
            ],
          ),
          Positioned(
              child: isLoading ? const LoadingView() : const SizedBox.shrink()),
        ]),
      ),
    );
  }

  Widget _buildItem(BuildContext context, DocumentSnapshot? documentSnapshot,
      int index, List<num> radioCheckList) {
    if (documentSnapshot != null) {
      ChatUser userChat = ChatUser.fromDocument(documentSnapshot);
      if (userChat.id == widget.currentUserId) {
        return const SizedBox.shrink();
      } else {
        return ListTile(
          leading: userChat.photoUrl.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    userChat.photoUrl,
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                    loadingBuilder: (BuildContext ctx, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return SizedBox(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                              color: Colors.grey,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null),
                        );
                      }
                    },
                    errorBuilder: (context, object, stackTrace) {
                      return const Icon(Icons.account_circle, size: 50);
                    },
                  ),
                )
              : const Icon(
                  Icons.account_circle,
                  size: 50,
                ),
          title: Text(
            userChat.displayName,
            style: const TextStyle(color: Colors.black),
          ),
          trailing: Checkbox(
              value: radioCheckList.contains(index),
              onChanged: (bool? value) {
                if (radioCheckList.contains(index)) {
                  radioCheckList.remove(index);
                } else {
                  radioCheckList.add(index);
                }
                if (members.contains(userChat.id)) {
                  members.removeWhere((element) => element == userChat.id);
                } else {
                  members.add(userChat.id);
                }

                setState(() {
                  radioCheckList = radioCheckList;
                  members = members;
                });
              }),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }
}
