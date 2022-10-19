import 'dart:io';
import 'package:clipboard/clipboard.dart';
import 'package:firebase_notification_example/constants/firestore_constant.dart';
import 'package:firebase_notification_example/constants/text_field_constants.dart';
import 'package:firebase_notification_example/models/chat_messages.dart';
import 'package:firebase_notification_example/pages/login_page.dart';
import 'package:firebase_notification_example/providers/auth_provider.dart';
import 'package:firebase_notification_example/providers/chat_provider.dart';
import 'package:firebase_notification_example/providers/profile_provider.dart';
import 'package:firebase_notification_example/widgets/common_widget.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ChatPage extends StatefulWidget {
  final String peerId;
  final String peerAvatar;
  final String peerNickname;
  final String userAvatar;

  const ChatPage(
      {Key? key,
      required this.peerNickname,
      required this.peerAvatar,
      required this.peerId,
      required this.userAvatar})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late String currentUserId;
  bool isPin = false;
  bool isReply = false;
  String replyContent = '';
  ChatMessages? pinChatMessage;

  List<QueryDocumentSnapshot> listMessages = [];

  int _limit = 20;
  final int _limitIncrement = 20;
  String groupChatId = '';

  File? imageFile;
  bool isLoading = false;
  bool isShowSticker = false;
  String imageUrl = '';

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  late ChatProvider chatProvider;
  late AuthProvider authProvider;
  late ProfileProvider profileProvider;

  @override
  void initState() {
    super.initState();
    chatProvider = context.read<ChatProvider>();
    authProvider = context.read<AuthProvider>();
    profileProvider = context.read<ProfileProvider>();

    focusNode.addListener(onFocusChanged);
    scrollController.addListener(_scrollListener);
    readLocal();
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
    if (authProvider.getFirebaseUserId()?.isNotEmpty == true) {
      currentUserId = authProvider.getFirebaseUserId()!;
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false);
    }
    if (currentUserId.compareTo(widget.peerId) > 0) {
      groupChatId = '$currentUserId - ${widget.peerId}';
    } else {
      groupChatId = '${widget.peerId} - $currentUserId';
    }
    chatProvider.updateFirestoreData(FirestoreConstants.pathUserCollection,
        currentUserId, {FirestoreConstants.chattingWith: widget.peerId});
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
      chatProvider.updateFirestoreData(FirestoreConstants.pathUserCollection,
          currentUserId, {FirestoreConstants.chattingWith: null});
    }
    return Future.value(false);
  }

  void _callPhoneNumber(String phoneNumber) async {
    String url = 'tel://$phoneNumber';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Error Occurred';
    }
  }

  void uploadImageFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask = chatProvider.uploadImageFile(imageFile!, fileName);
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
      chatProvider.sendChatMessage(content, replyContent, type, groupChatId,
          currentUserId, widget.peerId, false);
      scrollController.animateTo(0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      if (isReply == true) {
        setState(() {
          isReply = false;
          replyContent = '';
        });
      }
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send', backgroundColor: Colors.grey);
    }
  }

  // checking if received message
  bool isMessageReceived(int index) {
    if ((index > 0 &&
            listMessages[index - 1].get(FirestoreConstants.idFrom) ==
                currentUserId) ||
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
                currentUserId) ||
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
        centerTitle: true,
        title: Text(widget.peerNickname),
        actions: [
          IconButton(
            onPressed: () {
              ProfileProvider profileProvider;
              profileProvider = context.read<ProfileProvider>();
              String callPhoneNumber =
                  profileProvider.getPrefs(FirestoreConstants.phoneNumber) ??
                      "";
              _callPhoneNumber(callPhoneNumber);
            },
            icon: const Icon(Icons.phone),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              _buildPinMessage(),
              _buildListMessage(),
              _buildMessageInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPinMessage() {
    String? user =
        profileProvider.getPrefs(FirestoreConstants.displayName) ?? "";
    String time = '';
    if (pinChatMessage != null) {
      time = DateFormat('hh:mm a').format(
        DateTime.fromMillisecondsSinceEpoch(
          int.parse(pinChatMessage!.timestamp),
        ),
      );
    }

    return Visibility(
      visible: isPin,
      child: Container(
        padding: const EdgeInsets.all(12),
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
        constraints: const BoxConstraints(maxHeight: 100, minHeight: 40),
        child: pinChatMessage != null
            ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        constraints: const BoxConstraints(
                            minHeight: 20, maxHeight: 100, maxWidth: 250),
                        child: Text(
                          pinChatMessage!.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          unpinMessage(pinChatMessage!);
                        },
                        icon: const Icon(Icons.push_pin_outlined),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Pinned by $user'),
                      Text(time),
                    ],
                  ),
                ],
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildMessageInput() {
    return SizedBox(
      width: double.infinity,
      height: isReply ? 125 : 70,
      child: Column(
        children: [
          isReply
              ? const Divider(
                  height: 1.5,
                  color: Colors.black45,
                )
              : const SizedBox.shrink(),
          isReply
              ? SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                    style: const TextStyle(
                                        fontSize: 14, color: Colors.black),
                                    children: [
                                      const TextSpan(text: 'Đang trả lời '),
                                      TextSpan(
                                          text: widget.peerNickname,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ]),
                              ),
                            ),
                            Text(
                              replyContent,
                              style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed: () => setState(() {
                                isReply = !isReply;
                              }),
                          icon: const Icon(Icons.close)),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
          const Divider(
            height: 1.5,
            color: Colors.black45,
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
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
        ],
      ),
    );
  }

  Widget buildItem(int index, DocumentSnapshot? documentSnapshot) {
    if (documentSnapshot != null) {
      ChatMessages chatMessages = ChatMessages.fromDocument(documentSnapshot);
      if (chatMessages.idFrom == currentUserId) {
        // right side (my message)
        return GestureDetector(
          onLongPress: () => showModalBottomSheet(
              context: context,
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          unsendMessage(chatMessages);
                        },
                        child: const Text(
                          'Thu hồi',
                          style: TextStyle(color: Colors.red),
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          deleteMessage(chatMessages);
                        },
                        child: const Text(
                          'Xóa, gỡ bỏ',
                          style: TextStyle(color: Colors.red),
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          pinMessage(chatMessages, index);
                        },
                        child: const Text('Ghim tin nhắn')),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          FlutterClipboard.copy(chatMessages.content);
                        },
                        child: const Text('Sao chép')),
                  ],
                );
              }),
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
                              replyContent: chatMessages.replyContent,
                              color: Colors.lightBlue,
                              textColor: Colors.white,
                              margin:
                                  const EdgeInsets.only(right: 10, bottom: 5),
                            )
                          : messageBubble(
                              chatContent: chatMessages.content,
                              replyContent: chatMessages.replyContent,
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
                  const SizedBox(
                    height: 8,
                  ),
                  isMessageSent(index)
                      ? Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Image.network(
                            widget.userAvatar,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext ctx, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.blue,
                                  value: loadingProgress.expectedTotalBytes !=
                                              null &&
                                          loadingProgress.expectedTotalBytes !=
                                              null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, object, stackTrace) {
                              return const Icon(
                                Icons.account_circle,
                                size: 35,
                                color: Colors.grey,
                              );
                            },
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
        return GestureDetector(
          onLongPress: () => showModalBottomSheet(
              context: context,
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          pinMessage(chatMessages, index);
                        },
                        child: const Text('Ghim tin nhắn')),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          replyContent = chatMessages.content;
                          setState(() {
                            isReply = !isReply;
                          });
                        },
                        child: const Text('Trả lời')),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Sao chép')),
                  ],
                );
              }),
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
                          child: Image.network(
                            widget.peerAvatar,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext ctx, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.blue,
                                  value: loadingProgress.expectedTotalBytes !=
                                              null &&
                                          loadingProgress.expectedTotalBytes !=
                                              null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, object, stackTrace) {
                              return const Icon(
                                Icons.account_circle,
                                size: 35,
                                color: Colors.grey,
                              );
                            },
                          ),
                        )
                      : Container(
                          width: 35,
                        ),
                  chatMessages.type == MessageType.text
                      ? messageBubble(
                          color: Colors.black12,
                          textColor: Colors.black,
                          chatContent: chatMessages.content,
                          replyContent: chatMessages.replyContent,
                          isCurrentUser: false,
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

  Widget _buildListMessage() {
    return Flexible(
      child: groupChatId.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
              stream: chatProvider.getChatMessage(groupChatId, _limit),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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
              })
          : const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            ),
    );
  }

  void pinMessage(ChatMessages chatMessages, int index) {
    pinChatMessage = chatMessages;
    setState(() {
      isPin = true;
    });
    ChatMessages messagesUpdate = chatMessages.copyWith(isPin: true);
    chatProvider.updateChatMessage(groupChatId, messagesUpdate);
  }

  void unpinMessage(ChatMessages chatMessages) {
    setState(() {
      isPin = false;
      pinChatMessage = null;
    });
    ChatMessages messagesUpdate = chatMessages.copyWith(isPin: false);
    chatProvider.updateChatMessage(groupChatId, messagesUpdate);
  }

  void unsendMessage(ChatMessages chatMessages) {
    ChatMessages messagesUpdate =
        chatMessages.copyWith(content: 'Bạn đã thu hồi một tin nhắn');
    chatProvider.updateChatMessage(groupChatId, messagesUpdate);
  }

  void deleteMessage(ChatMessages chatMessages) {
    chatProvider.deleteChatMessage(groupChatId, chatMessages);
  }
}
