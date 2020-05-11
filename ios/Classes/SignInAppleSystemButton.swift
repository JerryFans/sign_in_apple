//
//  SignInAppleSystemButton.swift
//  flutter_test_plugin
//
//  Created by 逸风 on 2020/4/11.
//

import Foundation
import Flutter
import AuthenticationServices

class SafeView: NSObject,FlutterPlatformView {
    
    override init() {
       
    }
    
    func view() -> UIView {
        return UIView()
    }
}

@available(iOS 13.0, *)
class SignInAppleSystemButton: NSObject,FlutterPlatformView {
    
    var _signInSystemButton: ASAuthorizationAppleIDButton!
    var _view : UIView?
    var _viewId : Int64?
    var _signInServices: SignInAppleServices?
    
    func view() -> UIView {
        return _signInSystemButton
    }
    
    @objc func clickSignInAction() {
        _signInServices?.appleSignInRequest()
    }
    
    convenience init(withframe: CGRect, viewIdentifier: Int64, arguments: Any? ,binaryMessenger: FlutterBinaryMessenger!, signInServices: SignInAppleServices!) {
        self.init()
        let params = arguments as? [String:Any]
        
        let width: Double = params?["width"] as? Double ?? 200.0
        let height: Double = params?["height"] as? Double ?? 44.0
        let cornerRadius: CGFloat = params?["cornerRadius"] as? CGFloat ?? 0.0
        let isBlackStyle: Bool = params?["isBlackStyle"] as? Bool ?? true
        
        _signInServices = signInServices
        _viewId = viewIdentifier
        _signInSystemButton = ASAuthorizationAppleIDButton.init(type: .default, style: isBlackStyle ? .black : .white)
        _signInSystemButton.addTarget(self, action: #selector(clickSignInAction), for: .touchUpInside)
        _signInSystemButton.frame = CGRect.init(x: 0, y: 0, width: width, height: height)
        _signInSystemButton.cornerRadius = cornerRadius as CGFloat
    }
    
    deinit {
        print("dealloc");
    }
}

class SignInAppleServicesFactory: NSObject,FlutterPlatformViewFactory {
    
    var _messenger: FlutterBinaryMessenger?
    var _signInServices: SignInAppleServices?
    
    convenience init(binaryMessenger: FlutterBinaryMessenger, signInServices: SignInAppleServices) {
        self.init()
        _messenger = binaryMessenger
        _signInServices = signInServices
    }
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        if #available(iOS 13.0, *) {
            return SignInAppleSystemButton.init(withframe: frame, viewIdentifier: viewId, arguments: args, binaryMessenger: _messenger, signInServices: _signInServices)
        } else {
            return SafeView.init()
        }
    }
    
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
    
}
