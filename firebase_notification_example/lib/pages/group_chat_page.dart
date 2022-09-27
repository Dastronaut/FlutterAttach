import 'dart:io';
import 'package:firebase_notification_example/constants/firestore_constant.dart';
import 'package:firebase_notification_example/constants/text_field_constants.dart';
import 'package:firebase_notification_example/models/chat_messages.dart';
import 'package:firebase_notification_example/models/group_profile.dart';
import 'package:firebase_notification_example/models/pin_chat.dart';
import 'package:firebase_notification_example/pages/home_page.dart';
import 'package:firebase_notification_example/providers/auth_provider.dart';
import 'package:firebase_notification_example/providers/group_chat_provider.dart';
import 'package:firebase_notification_example/providers/profile_provider.dart';
import 'package:firebase_notification_example/widgets/common_widget.dart';
import 'package:firebase_notification_example/widgets/dialog_content.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupChatPage extends StatefulWidget {
  final String currentUserId;
  final bool isCreate;
  final GroupData groupData;

  const GroupChatPage({
    Key? key,
    required this.isCreate,
    required this.groupData,
    required this.currentUserId,
  }) : super(key: key);

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  List<QueryDocumentSnapshot> listMessages = [];
  bool isPin = false;
  PinChat? pinChat;

  int _limit = 20;
  final int _limitIncrement = 20;

  File? imageFile;
  bool isLoading = false;
  bool isShowSticker = false;
  String imageUrl = '';

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  late GroupChatProvider groupChatProvider;
  late AuthProvider authProvider;
  late ProfileProvider profileProvider;

  @override
  void initState() {
    super.initState();
    groupChatProvider = context.read<GroupChatProvider>();
    authProvider = context.read<AuthProvider>();
    profileProvider = context.read<ProfileProvider>();

    focusNode.addListener(onFocusChanged);
    scrollController.addListener(_scrollListener);
    readLocal();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    focusNode.dispose();
  }

  _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void onFocusChanged() {
    if (focusNode.hasFocus) {
      setState(() {
        isShowSticker = false;
      });
    }
  }

  void readLocal() {
    groupChatProvider.updateFirestoreData(
        FirestoreConstants.pathUserCollection,
        widget.currentUserId,
        {FirestoreConstants.chattingWith: widget.groupData.groupId});
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;
    pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });
        uploadImageFile();
      }
    }
  }

  void getSticker() {
    focusNode.unfocus();
    setState(() {
      isShowSticker = !isShowSticker;
    });
  }

  Future<bool> onBackPressed() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      groupChatProvider.updateFirestoreData(
          FirestoreConstants.pathUserCollection,
          widget.currentUserId,
          {FirestoreConstants.chattingWith: null});
    }
    return Future.value(false);
  }

  void uploadImageFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask =
        groupChatProvider.uploadImageFile(imageFile!, fileName);
    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, MessageType.image);
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  void onSendMessage(String content, int type) {
    if (content.trim().isNotEmpty) {
      textEditingController.clear();
      groupChatProvider.sendChatMessage(
          content, type, widget.groupData.groupId, widget.currentUserId, false);
      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send', backgroundColor: Colors.grey);
    }
  }

  // checking if received message
  bool isMessageReceived(int index) {
    if ((index > 0 &&
            listMessages[index - 1].get(FirestoreConstants.idFrom) ==
                widget.currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  // checking if sent message
  bool isMessageSent(int index) {
    if ((index > 0 &&
            listMessages[index - 1].get(FirestoreConstants.idFrom) !=
                widget.currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage())),
        ),
        centerTitle: true,
        title: Text(widget.groupData.groupName.isNotEmpty
            ? widget.groupData.groupName
            : 'Group chat'),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => DialogContent(
                        currentUserId: widget.currentUserId,
                        groupData: widget.groupData,
                      ));
            },
            icon: const Icon(Icons.group_add_outlined),
          ),
          IconButton(
            onPressed: () {
              groupChatProvider.leaveGroup(
                  widget.groupData, widget.currentUserId);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            },
            icon: const Icon(Icons.output),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              _buildPinMessage(),
              buildListMessage(),
              buildMessageInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPinMessage() {
    return Visibility(
      visible: isPin,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.green[700],
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        width: double.infinity,
        height: 70,
        child: pinChat != null
            ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 50,
                        child: Padding(
                            padding: const EdgeInsets.only(left: 12, top: 12),
                            child: Text(pinChat!.msg)),
                      ),
                      const Icon(Icons.push_pin_outlined),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Pinned by ${pinChat!.user}'),
                      Text(pinChat!.time),
                    ],
                  ),
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget buildMessageInput() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
              onPressed: getImage,
              icon: const Icon(
                Icons.camera_alt,
                size: 28,
              ),
              color: Colors.white,
            ),
          ),
          Flexible(
              child: TextField(
            focusNode: focusNode,
            textInputAction: TextInputAction.send,
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.sentences,
            controller: textEditingController,
            decoration:
                kTextInputDecoration.copyWith(hintText: 'write here...'),
            onSubmitted: (value) {
              onSendMessage(textEditingController.text, MessageType.text);
            },
          )),
          Container(
            margin: const EdgeInsets.only(left: 4),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
              onPressed: () {
                onSendMessage(textEditingController.text, MessageType.text);
              },
              icon: const Icon(Icons.send_rounded),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(int index, DocumentSnapshot? documentSnapshot) {
    if (documentSnapshot != null) {
      ChatMessages chatMessages = ChatMessages.fromDocument(documentSnapshot);
      if (chatMessages.idFrom == widget.currentUserId) {
        // right side (my message)
        return InkWell(
          onLongPress: () => pinMessage(chatMessages, index),
          onDoubleTap: () => unsendMessage(chatMessages),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  chatMessages.type == MessageType.text
                      ? chatMessages.content != 'Bạn đã thu hồi một tin nhắn'
                          ? messageBubble(
                              chatContent: chatMessages.content,
                              color: Colors.lightBlue,
                              textColor: Colors.white,
                              margin:
                                  const EdgeInsets.only(right: 10, bottom: 5),
                            )
                          : messageBubble(
                              chatContent: chatMessages.content,
                              color: Colors.white70,
                              textColor: Colors.black54,
                              margin:
                                  const EdgeInsets.only(right: 10, bottom: 5),
                            )
                      : chatMessages.type == MessageType.image
                          ? Container(
                              margin: const EdgeInsets.only(right: 10, top: 10),
                              child: chatImage(
                                  imageSrc: chatMessages.content, onTap: () {}),
                            )
                          : const SizedBox.shrink(),
                  isMessageSent(index)
                      ? Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.account_circle,
                            size: 35,
                            color: Colors.grey,
                          ),
                        )
                      : Container(
                          width: 35,
                        ),
                ],
              ),
              isMessageSent(index)
                  ? Container(
                      margin:
                          const EdgeInsets.only(right: 50, top: 6, bottom: 8),
                      child: Text(
                        DateFormat('dd MMM yyyy, hh:mm a').format(
                          DateTime.fromMillisecondsSinceEpoch(
                            int.parse(chatMessages.timestamp),
                          ),
                        ),
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontStyle: FontStyle.italic),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        );
      } else {
        return InkWell(
          onLongPress: () => pinMessage(chatMessages, index),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  isMessageReceived(index)
                      // left side (received message)
                      ? Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.account_circle,
                            size: 35,
                            color: Colors.grey,
                          ),
                        )
                      : Container(
                          width: 35,
                        ),
                  chatMessages.type == MessageType.text
                      ? messageBubble(
                          color: Colors.blue,
                          textColor: Colors.white,
                          chatContent: chatMessages.content,
                          margin: const EdgeInsets.only(left: 10),
                        )
                      : chatMessages.type == MessageType.image
                          ? Container(
                              margin: const EdgeInsets.only(left: 10, top: 10),
                              child: chatImage(
                                  imageSrc: chatMessages.content, onTap: () {}),
                            )
                          : const SizedBox.shrink(),
                ],
              ),
              isMessageReceived(index)
                  ? Container(
                      margin:
                          const EdgeInsets.only(left: 50, top: 6, bottom: 8),
                      child: Text(
                        DateFormat('dd MMM yyyy, hh:mm a').format(
                          DateTime.fromMillisecondsSinceEpoch(
                            int.parse(chatMessages.timestamp),
                          ),
                        ),
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontStyle: FontStyle.italic),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget buildListMessage() {
    return Flexible(
      child: StreamBuilder<QuerySnapshot>(
        stream:
            groupChatProvider.getChatMessage(widget.groupData.groupId, _limit),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            listMessages = snapshot.data!.docs;
            if (listMessages.isNotEmpty) {
              return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: snapshot.data?.docs.length,
                  reverse: true,
                  controller: scrollController,
                  itemBuilder: (context, index) =>
                      buildItem(index, snapshot.data?.docs[index]));
            } else {
              return const Center(
                child: Text('No messages...'),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          }
        },
      ),
    );
  }

  void pinMessage(ChatMessages chatMessages, int index) {
    String time = DateFormat('hh:mm a').format(
      DateTime.fromMillisecondsSinceEpoch(
        int.parse(chatMessages.timestamp),
      ),
    );
    String? user =
        profileProvider.getPrefs(FirestoreConstants.displayName) ?? "";
    setState(() {
      isPin = true;
      pinChat =
          PinChat(id: index, msg: chatMessages.content, user: user, time: time);
    });
    ChatMessages messagesUpdate = chatMessages.copyWith(isPin: true);
    groupChatProvider.updateChatMessage(
        widget.groupData.groupId, messagesUpdate);
  }

  void unsendMessage(ChatMessages chatMessages) {
    ChatMessages messagesUpdate =
        chatMessages.copyWith(content: 'Bạn đã thu hồi một tin nhắn');
    groupChatProvider.updateChatMessage(
        widget.groupData.groupId, messagesUpdate);
  }
}
