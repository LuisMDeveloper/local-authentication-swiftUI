//
//  LocalAuthenticationService.swift
//  Local Authentication
//
//  Created by Luis Manuel Ramirez Vargas on 16/01/23.
//

import LocalAuthentication
import Foundation

class LocalAuthenticationService {
    class func authenticateWithBiometrics(_ completion: @escaping (Result<Void, Error>) -> Void) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock your data."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                if success {
                    completion(.success(()))
                } else {
                    completion(.failure(AppError.error(error?.localizedDescription ?? "Error Undefined")))
                }
            }
        } else {
            completion(.failure(AppError.error("No Biometrics Available")))
        }
    }
}
