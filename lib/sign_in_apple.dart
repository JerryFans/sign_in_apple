import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'apple_id_user.dart';

enum AppleSignInErrorCode {
  unknown,
  canceled,
  invalidResponse,
  notHandled,
  failed,
}

enum AppleSignInSystemButtonStyle {
  white,
  black,
}

typedef DidCompleteWithSignIn = Future Function(AppleIdUser user);
typedef DidCompleteWithError = Future Function(AppleSignInErrorCode code);

class SignInApple {
  static const MethodChannel _channel = const MethodChannel('sign_in_apple');

  static handleAppleSignInCallBack(
      {required DidCompleteWithSignIn onCompleteWithSignIn,
      required DidCompleteWithError onCompleteWithError}) {
    Future<dynamic> platformCallHandler(MethodCall call) async {
      switch (call.method) {
        case "didCompleteWithSignIn":
          var user = AppleIdUser.fromJson(call.arguments);
          await onCompleteWithSignIn(user);
          break;
        case "didCompleteWithError":
        {
          AppleSignInErrorCode errorCode = AppleSignInErrorCode.unknown;
            int code = call.arguments["code"] ?? 1000;
            switch (code) {
              case 1000:
                errorCode = AppleSignInErrorCode.unknown;
                break;
              case 1001:
                errorCode = AppleSignInErrorCode.canceled;
                break;
              case 1002:
                errorCode = AppleSignInErrorCode.invalidResponse;
                break;
              case 1003:
                errorCode = AppleSignInErrorCode.notHandled;
                break;
              case 1004:
                errorCode = AppleSignInErrorCode.failed;
                break;
            }
            await onCompleteWithError(errorCode);
        }
          break;
      }
    }

    _channel.setMethodCallHandler(platformCallHandler);
  }

  // click sign in button action
  static clickAppleSignIn() async {
    if (Platform.isIOS && await canUseAppleSigin() == true) {
      await _channel.invokeMethod('clickAppleSignIn');
    } else {
      print("only support in iOS Device");
    }
  }
  
  // check current device canUseAppleSigin, 
  // if not , you use hidden the apple sign in button
  static Future<bool> canUseAppleSigin() async {
    return await _channel.invokeMethod('canUseAppleSigin');
  }
}

class AppleSignInSystemButton extends StatelessWidget {
  final double width;
  final double height;
  final double cornerRadius;
  final AppleSignInSystemButtonStyle buttonStyle;

  AppleSignInSystemButton(
      {Key? key,
      required this.width,
      required this.height,
      this.cornerRadius = 0,
      this.buttonStyle = AppleSignInSystemButtonStyle.black})
      : assert((width > 0 && height > 0),
            "AppleSignInSystemButton param width and height must > 0"),
        super(key: key);

  Widget build(BuildContext context) {
    bool isBlack =
        (buttonStyle == AppleSignInSystemButtonStyle.black) ? true : false;
    return FutureBuilder(
      future: SignInApple.canUseAppleSigin(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.data != null) {
          if (snapshot.data == true) {
            return Container(
              alignment: Alignment.center,
              width: width,
              height: height,
              child: UiKitView(
                creationParams: <String, dynamic>{
                  "width": width,
                  "height": height,
                  "cornerRadius": cornerRadius,
                  "isBlackStyle": isBlack,
                },
                viewType: "apple_sign_in_button_identify",
                creationParamsCodec: new StandardMessageCodec(),
              ),
            );
          } else {
            return Text('Plugin only support in more than iOS13+ Platform');
          }
        } else {
          return Container();
        }
      },
    );
  }
}
