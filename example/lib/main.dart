import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:sign_in_apple/sign_in_apple.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _name = 'Unknown';
  String _mail = 'Unknown';
  String _userIdentify = 'Unknown';
  String _authorizationCode = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    SignInApple.handleAppleSignInCallBack(onCompleteWithSignIn: (String name,
        String mail,
        String userIdentifier,
        String authorizationCode,
        String identifyToken) async {
      print("flutter receiveCode: \n");
      print(authorizationCode);
      print("flutter receiveToken \n");
      print(identifyToken);
      setState(() {
        _name = name;
        _mail = mail;
        _userIdentify = userIdentifier;
        _authorizationCode = authorizationCode;
      });
    }, onCompleteWithError: (AppleSignInErrorCode code) async {
      var errorMsg = "unknown";
      switch (code) {
        case AppleSignInErrorCode.canceled:
          errorMsg = "user canceled request";
          break;
        case AppleSignInErrorCode.failed:
          errorMsg = "request fail";
          break;
        case AppleSignInErrorCode.invalidResponse:
          errorMsg = "request invalid response";
          break;
        case AppleSignInErrorCode.notHandled:
          errorMsg = "request not handled";
          break;
        case AppleSignInErrorCode.unknown:
          errorMsg = "request fail unknown";
          break;
      }
      print(errorMsg);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('userIdentify is: $_userIdentify'),
            SizedBox(
              height: 10,
            ),
            Text('name is: $_name'),
            SizedBox(
              height: 10,
            ),
            Text('mail is: $_mail'),
            SizedBox(
              height: 10,
            ),
            Text('auth code is: $_authorizationCode'),
            SizedBox(
              height: 10,
            ),
            Text('native system button:'),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 20,
            ),
            AppleSignInSystemButton(
              width: 250,
              height: 50,
              buttonStyle: AppleSignInSystemButtonStyle.black,
            ),
            SizedBox(
              height: 20,
            ),
            Text('custom flutter button：'),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                SignInApple.clickAppleSignIn();
              },
              child: Container(
                width: 56,
                height: 56,
                child: Image.asset(
                  "images/apple_logo.png",
                  width: 56,
                  height: 56,
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
