# sign_in_apple

A new flutter plugin project.

## Usage

The System Button Style Use Platform View to Show in Flutter.

Please set io.flutter.embedded_views_preview = true in Info.plist in your project.

CallBack:

```
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
```

UI:

CustomWidget:

```
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
```

SystemButton:

```
AppleSignInSystemButton(
              width: 250,
              height: 50,
              buttonStyle: AppleSignInSystemButtonStyle.black,
            ),
```


## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
