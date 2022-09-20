import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_notification_example/constants/firestore_constant.dart';
import 'package:firebase_notification_example/models/chat_user.dart';
import 'package:firebase_notification_example/models/group_profile.dart';
import 'package:firebase_notification_example/pages/chat_page.dart';
import 'package:firebase_notification_example/pages/create_group_chat_page.dart';
import 'package:firebase_notification_example/pages/group_chat_page.dart';
import 'package:firebase_notification_example/pages/login_page.dart';
import 'package:firebase_notification_example/pages/profile_page.dart';
import 'package:firebase_notification_example/providers/auth_provider.dart';
import 'package:firebase_notification_example/providers/group_chat_provider.dart';
import 'package:firebase_notification_example/providers/home_provider.dart';
import 'package:firebase_notification_example/utilities/debouncer.dart';
import 'package:firebase_notification_example/utilities/keyboard_utils.dart';
import 'package:firebase_notification_example/widgets/loading_view.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final ScrollController scrollController = ScrollController();

  int _limit = 20;
  final int _limitIncrement = 20;
  String _textSearch = "";
  bool isLoading = false;

  late AuthProvider authProvider;
  late String currentUserId;
  late HomeProvider homeProvider;
  late GroupChatProvider groupChatProvider;
  String currentUserName = '';

  Debouncer searchDebouncer = Debouncer(milliseconds: 300);
  StreamController<bool> buttonClearController = StreamController<bool>();
  TextEditingController searchTextEditingController = TextEditingController();

  Future<void> googleSignOut() async {
    authProvider.googleSignOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  Future<bool> onBackPress() {
    openDialog();
    return Future.value(false);
  }

  Future<void> openDialog() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return SimpleDialog(
            backgroundColor: Colors.yellow,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Exit Application',
                  style: TextStyle(color: Colors.white),
                ),
                Icon(
                  Icons.exit_to_app,
                  size: 30,
                  color: Colors.white,
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            children: [
              const SizedBox(height: 10),
              const Text(
                'Are you sure?',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, 0);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, 1);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                      child: const Text(
                        'Yes',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  )
                ],
              )
            ],
          );
        })) {
      case 0:
        break;
      case 1:
        exit(0);
    }
  }

  void scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    buttonClearController.close();
  }

  @override
  void initState() {
    super.initState();
    authProvider = context.read<AuthProvider>();
    homeProvider = context.read<HomeProvider>();
    groupChatProvider = context.read<GroupChatProvider>();
    if (authProvider.getFirebaseUserId()?.isNotEmpty == true) {
      currentUserId = authProvider.getFirebaseUserId()!;
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false);
    }

    scrollController.addListener(scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Meline'), actions: [
        IconButton(
            onPressed: () => googleSignOut(), icon: const Icon(Icons.logout)),
        IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()));
            },
            icon: const Icon(Icons.person)),
      ]),
      body: WillPopScope(
        onWillPop: onBackPress,
        child: Stack(
          children: [
            Column(
              children: [
                _buildSearchBar(),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: homeProvider.getFirestoreData(
                        FirestoreConstants.pathUserCollection,
                        _limit,
                        _textSearch),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        if ((snapshot.data?.docs.length ?? 0) > 0) {
                          return ListView.separated(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) => _buildChatItem(
                                context, snapshot.data?.docs[index]),
                            controller: scrollController,
                            separatorBuilder:
                                (BuildContext context, int index) =>
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
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: homeProvider.getFirestoreData(
                        FirestoreConstants.pathGroupCollection,
                        _limit,
                        _textSearch),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        if ((snapshot.data?.docs.length ?? 0) > 0) {
                          return ListView.separated(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) =>
                                _buildGroupChatItem(
                                    context, snapshot.data?.docs[index]),
                            controller: scrollController,
                            separatorBuilder:
                                (BuildContext context, int index) =>
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
              ],
            ),
            Positioned(
              child: isLoading ? const LoadingView() : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CreateGroupChatPage(
                      currentUserId: currentUserId,
                      currentUserName: currentUserName,
                    ))),
        child: const Icon(
          Icons.add,
          color: Colors.purple,
          size: 50,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.blueAccent,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 10,
          ),
          const Icon(
            Icons.person_search,
            color: Colors.white,
            size: 24,
          ),
          const SizedBox(
            width: 5,
          ),
          Expanded(
            child: TextFormField(
              textInputAction: TextInputAction.search,
              controller: searchTextEditingController,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  buttonClearController.add(true);
                  setState(() {
                    _textSearch = value;
                  });
                } else {
                  buttonClearController.add(false);
                  setState(() {
                    _textSearch = "";
                  });
                }
              },
              decoration: const InputDecoration.collapsed(
                hintText: 'Search here...',
                hintStyle: TextStyle(color: Colors.white),
              ),
            ),
          ),
          StreamBuilder(
              stream: buttonClearController.stream,
              builder: (context, snapshot) {
                return snapshot.data == true
                    ? GestureDetector(
                        onTap: () {
                          searchTextEditingController.clear();
                          buttonClearController.add(false);
                          setState(() {
                            _textSearch = '';
                          });
                        },
                        child: const Icon(
                          Icons.clear_rounded,
                          color: Colors.grey,
                          size: 20,
                        ),
                      )
                    : const SizedBox.shrink();
              })
        ],
      ),
    );
  }

  Widget _buildChatItem(
      BuildContext context, DocumentSnapshot? documentSnapshot) {
    final firebaseAuth = FirebaseAuth.instance;
    if (documentSnapshot != null) {
      ChatUser userChat = ChatUser.fromDocument(documentSnapshot);
      if (userChat.id == currentUserId) {
        currentUserName = userChat.displayName;
        return const SizedBox.shrink();
      } else {
        return TextButton(
          onPressed: () {
            if (KeyboardUtils.isKeyboardShowing()) {
              KeyboardUtils.closeKeyboard(context);
            }
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatPage(
                          peerId: userChat.id,
                          peerAvatar: userChat.photoUrl,
                          peerNickname: userChat.displayName,
                          userAvatar: firebaseAuth.currentUser!.photoURL!,
                        )));
          },
          child: ListTile(
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
                                value: loadingProgress.expectedTotalBytes !=
                                        null
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
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildGroupChatItem(
      BuildContext context, DocumentSnapshot? documentSnapshot) {
    if (documentSnapshot != null) {
      GroupData groupChat = GroupData.fromDocument(documentSnapshot);
      return TextButton(
        onPressed: () {
          if (KeyboardUtils.isKeyboardShowing()) {
            KeyboardUtils.closeKeyboard(context);
          }
          final List<String> strs =
              groupChat.members.map((e) => e.toString()).toList();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GroupChatPage(
                        currentUserId: currentUserId,
                        members: strs,
                        groupChatName: groupChat.groupName,
                        isCreate: false,
                        groupChatId: groupChat.groupId,
                      )));
        },
        child: ListTile(
          leading: groupChat.photoUrl.isNotEmpty
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    groupChat.photoUrl,
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
            groupChat.groupName,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}