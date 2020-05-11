import Flutter
import UIKit
import AuthenticationServices

public class SwiftSignInApplePlugin: NSObject, FlutterPlugin, SignInAppleServicesDelegate {
  @available(iOS 13.0, *)
    func didCompleteWithAuthorization(authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName?.nickname
            let email = appleIDCredential.email
            let authCode: Data? = appleIDCredential.authorizationCode
            let authCodeString = String.init(data: authCode!, encoding: .utf8)
            let identifyTokenString = String.init(data: appleIDCredential.identityToken!, encoding: .utf8)
            didCompleteWithSignIn(name: fullName ?? "", mail: email ?? "", userIdentifier: userIdentifier, authorizationCode: authCodeString ?? "", identifyToken: identifyTokenString ?? "")
            break
            
        case _ as ASPasswordCredential:
            break
            
        default:
            break
        }
    }
    
    @available(iOS 13.0, *)
    func didCompleteWithError(error: ASAuthorizationError) {
        didCompleteWithError(code: error.code.rawValue)
    }
    
    
    var channel:FlutterMethodChannel!
    var signInServices: SignInAppleServices!
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "sign_in_apple", binaryMessenger: registrar.messenger())
        let signInServices = SignInAppleServices()
        let instance = SwiftSignInApplePlugin()
        instance.channel = channel
        instance.signInServices = signInServices
        signInServices.delegate = instance
        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.register(SignInAppleServicesFactory.init(binaryMessenger: registrar.messenger(),signInServices: signInServices), withId: "apple_sign_in_button_identify")
    }
    
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "clickAppleSignIn" {
            if #available(iOS 13.0, *) {
                signInServices?.appleSignInRequest()
            }
        } else if (call.method == "canUseAppleSigin") {
            result(canUseAppleSigin())
        }
    }
    
    private func canUseAppleSigin() -> Bool {
        if #available(iOS 13.0, *) {
            return true;
        }
        return false;
    }
    
    public func didCompleteWithSignIn(name: String ,mail: String, userIdentifier: String, authorizationCode: String, identifyToken: String) {
        channel.invokeMethod("didCompleteWithSignIn",arguments:["name":name,"mail":mail,"userIdentifier":userIdentifier,"authorizationCode":authorizationCode,"identifyToken":identifyToken])
    }
    
    public func didCompleteWithError(code: Int) {
        channel.invokeMethod("didCompleteWithError", arguments: ["code":code])
    }
}
