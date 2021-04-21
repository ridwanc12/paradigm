//
//  TouchIDAuthentication.swift
//  Paradigm
//
//  Created by Domenic Conversa on 4/14/21.
//  Copyright © 2021 team5. All rights reserved.
//

import Foundation
import LocalAuthentication

enum BiometricType {
  case none
  case touchID
  case faceID
}

class BiometricIDAuth {
    let context = LAContext()
    var loginReason = "Logging in with Touch ID"
    
    //check if device is biometric compatible
    func canEvaluatePolicy() -> Bool {
      return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    
    //check which type of biometric available
    func biometricType() -> BiometricType {
      let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
      switch context.biometryType {
      case .none:
        return .none
      case .touchID:
        return .touchID
      case .faceID:
        return .faceID
      @unknown default:
        print("Fatal error in detecting biometric type.")
        return .none
      }
    }
    
    //check if user is authenticated
    func authenticateUser(completion: @escaping () -> Void) {
      guard canEvaluatePolicy() else {
        return
      }

      context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
        localizedReason: loginReason) { (success, evaluateError) in
          if success {
            DispatchQueue.main.async {
              // User authenticated successfully, take appropriate action
              completion()
            }
          } else {
            // TODO: deal with LAError cases
          }
      }
    }


}

