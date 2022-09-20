import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_notification_example/firebase_options.dart';
import 'package:firebase_notification_example/providers/auth_provider.dart';
import 'package:firebase_notification_example/providers/chat_provider.dart';
import 'package:firebase_notification_example/providers/group_chat_provider.dart';
import 'package:firebase_notification_example/providers/home_provider.dart';
import 'package:firebase_notification_example/providers/profile_provider.dart';
import 'package:firebase_notification_example/splash/splash_screen.dart';
import 'package:firebase_notification_example/utilities/theme.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(
              googleSignIn: GoogleSignIn(),
              firebaseAuth: FirebaseAuth.instance,
              firebaseFirestore: firebaseFirestore,
              prefs: prefs),
        ),
        Provider<ProfileProvider>(
            create: ((context) => ProfileProvider(
                prefs: prefs,
                firebaseStorage: firebaseStorage,
                firebaseFirestore: firebaseFirestore))),
        Provider<HomeProvider>(
          create: (context) =>
              HomeProvider(firebaseFirestore: firebaseFirestore),
        ),
        Provider<ChatProvider>(
            create: (_) => ChatProvider(
                prefs: prefs,
                firebaseStorage: firebaseStorage,
                firebaseFirestore: firebaseFirestore)),
        Provider<GroupChatProvider>(
            create: (_) => GroupChatProvider(
                prefs: prefs,
                firebaseStorage: firebaseStorage,
                firebaseFirestore: firebaseFirestore))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Meline',
        theme: appTheme,
        home: const SplashPage(),
      ),
    );
  }
}
