import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:s_camera/pages/home_page.dart';
import 'package:s_camera/utils/models/user.dart' as prefix;

import '../common/theme_helper.dart';
import '../widgets/header_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum Status { Waiting, Error }

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final double _headerHeight = 250;
  final Key _formKey = GlobalKey<FormState>();
  var _status = Status.Waiting;
  TextEditingController phoneController = TextEditingController(text: '');
  TextEditingController otpController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  String verificationIDReceived = "";

  bool otpCodeVisible = false;
  bool emptyNumber = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight, true, Icons.login_rounded),
            ),
            SafeArea(
              child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  margin: const EdgeInsets.fromLTRB(
                      20, 10, 20, 10), // This will be the login form
                  child: Column(
                    children: [
                      const Text(
                        'Sign in',
                        style: TextStyle(
                            fontSize: 60, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Signin into your account',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 30.0),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                child: TextField(
                                  controller: phoneController,
                                  decoration: ThemeHelper().textInputDecoration(
                                      'Phone Number',
                                      'Enter your phone number'),
                                  keyboardType: TextInputType.phone,
                                ),
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              const SizedBox(
                                height: 30.0,
                              ),
                              Column(
                                children: [
                                  Container(
                                    child: Visibility(
                                      visible: otpCodeVisible,
                                      child: TextField(
                                        controller: otpController,
                                        decoration: ThemeHelper()
                                            .textInputDecoration(
                                                'Code', 'Enter your code'),
                                        keyboardType: TextInputType.phone,
                                      ),
                                    ),
                                    decoration: ThemeHelper()
                                        .inputBoxDecorationShaddow(),
                                  ),
                                  const SizedBox(
                                    height: 30.0,
                                  ),
                                  Visibility(
                                    visible: emptyNumber,
                                    child: const Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                      child: Text(
                                        'Phone number can\'t be empty',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: otpCodeVisible,
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 10),
                                      child: Text.rich(TextSpan(children: [
                                        const TextSpan(
                                            text: "Don't receive code? "),
                                        TextSpan(
                                          text: 'ResendCode',
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              setState(() {
                                                _status = Status.Waiting;
                                              });
                                              verifyNumber();
                                            },
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                        ),
                                      ])),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                decoration:
                                    ThemeHelper().buttonBoxDecoration(context),
                                child: ElevatedButton(
                                  style: ThemeHelper().buttonStyle(),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        40, 10, 40, 10),
                                    child: Text(
                                      otpCodeVisible ? "Sign In" : "Verify",
                                      // 'Sign In'.toUpperCase(),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (phoneController.text == '') {
                                      setState(() {
                                        emptyNumber = true;
                                      });
                                    } else if (otpCodeVisible) {
                                      verifyCode();
                                    } else {
                                      verifyNumber();
                                    }
                                    // Navigator.pushReplacement(
                                    //     context, MaterialPageRoute(builder: (context) => const MyHomePage()));
                                  },
                                ),
                              ),
                            ],
                          )),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void verifyNumber() {
    auth.verifyPhoneNumber(
        phoneNumber: phoneController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential).then((value) {
            print("You are logged in successfully");
          });
        },
        verificationFailed: (FirebaseAuthException exception) {
          print(exception.message);
        },
        codeSent: (String verificationID, int? resendToken) {
          verificationIDReceived = verificationID;
          otpCodeVisible = true;
          setState(() {});
        },
        codeAutoRetrievalTimeout: (String verificationID) {});
  }

  void verifyCode() async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationIDReceived, smsCode: otpController.text);
    bool _isPatron = false;
    await FirebaseFirestore.instance
        .collection('control')
        .get()
        .then((value) => {
              if (value == phoneController.text) {_isPatron = true}
            });
    if (_isPatron == false) {
      final docUser = FirebaseFirestore.instance
          .collection('control')
          .doc(phoneController.text);
      final user = prefix.User(buzzer: false, light: false);
      final json = user.toJson();
      await docUser.set(json);
    }

    await auth.signInWithCredential(credential).then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(
            phoneNumber: phoneController.text,
          ),
        ),
      );
    });
  }
}
