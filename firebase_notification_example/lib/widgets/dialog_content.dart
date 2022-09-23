import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_notification_example/constants/firestore_constant.dart';
import 'package:firebase_notification_example/models/chat_user.dart';
import 'package:firebase_notification_example/models/group_profile.dart';
import 'package:firebase_notification_example/pages/home_page.dart';
import 'package:firebase_notification_example/providers/group_chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DialogContent extends StatefulWidget {
  final GroupData groupData;
  final String currentUserId;
  const DialogContent(
      {super.key, required this.groupData, required this.currentUserId});

  @override
  State<DialogContent> createState() => _DialogContentState();
}

class _DialogContentState extends State<DialogContent> {
  List<num> radioCheckList = [];
  List<String> internalMembers = [];
  int _limit = 20;
  final int _limitIncrement = 20;

  late GroupChatProvider groupChatProvider;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    groupChatProvider = context.read<GroupChatProvider>();
    scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          const Center(
            child: Text(
              'Thêm thành viên',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: groupChatProvider.getFirestoreData(
                FirestoreConstants.pathUserCollection, _limit),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                if ((snapshot.data?.docs.length ?? 0) > 0) {
                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      if (snapshot.data?.docs[index] != null) {
                        DocumentSnapshot documentSnapshot =
                            snapshot.data!.docs[index];

                        ChatUser userChat =
                            ChatUser.fromDocument(documentSnapshot);
                        final List<String> members = widget.groupData.members
                            .map((e) => e.toString())
                            .toList();
                        if (userChat.id == widget.currentUserId ||
                            members.contains(userChat.id)) {
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
                                      loadingBuilder: (BuildContext ctx,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return SizedBox(
                                            width: 50,
                                            height: 50,
                                            child: CircularProgressIndicator(
                                                color: Colors.grey,
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null),
                                          );
                                        }
                                      },
                                      errorBuilder:
                                          (context, object, stackTrace) {
                                        return const Icon(Icons.account_circle,
                                            size: 50);
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
                                  if (internalMembers.contains(userChat.id)) {
                                    internalMembers.removeWhere(
                                        (element) => element == userChat.id);
                                  } else {
                                    internalMembers.add(userChat.id);
                                  }

                                  setState(() {
                                    radioCheckList = radioCheckList;
                                    internalMembers = internalMembers;
                                  });
                                }),
                          );
                        }
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
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
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Hủy'),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    groupChatProvider.addGroup(
                        widget.groupData, internalMembers);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()));
                  },
                  child: const Text('Thêm'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
