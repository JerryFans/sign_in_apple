//
//  SignInAppleServices.swift
//  flutter_test_plugin
//
//  Created by wecutofs on 2020/4/10.
//

import Foundation
import AuthenticationServices

protocol SignInAppleServicesDelegate: NSObjectProtocol {
    @available(iOS 13.0, *)
    func didCompleteWithAuthorization(authorization: ASAuthorization);
    @available(iOS 13.0, *)
    func didCompleteWithError(error: ASAuthorizationError);
}


class SignInAppleServices: NSObject {
    
    weak var delegate:SignInAppleServicesDelegate?
    
    @available(iOS 13.0, *)
    func appleSignInRequest() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    deinit {
        print("dealloc")
    }
}

extension SignInAppleServices: ASAuthorizationControllerDelegate {
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        self.delegate?.didCompleteWithAuthorization(authorization: authorization)
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let authorArror: ASAuthorizationError = ASAuthorizationError(_nsError: error as NSError)
        self.delegate?.didCompleteWithError(error: authorArror)
    }
}

extension SignInAppleServices: ASAuthorizationControllerPresentationContextProviding {
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.last!
    }
}

