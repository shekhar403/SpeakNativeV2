//
//  LoginHandler.swift
//  SpeakNative
//
//  Created by Kavya Rao on 12/09/2023.
//

import Foundation

class LoginHandler {
    var username: String
    var password: String
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    func retrievePasswordFromKeychain() -> (Bool, String, String, Bool) {
        var shouldEnableLinks = false
        var alertTitle = ""
        var alertMessage = ""
        var showingAlert = false
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "kcPassword",
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? Data,
               let password = String(data: retrievedData, encoding: .utf8) {
                if password == self.password, self.username == UserDefaults.standard.string(forKey: "username") ?? "" {
                    _ = SwiftGoogleTranslate.shared
                    
                    shouldEnableLinks = true
                }
                else {
                    alertTitle = "Some error occurred!"
                    alertMessage = "Please enter correct credentials"
                    showingAlert = true
                }
            } else {
                alertTitle = "Some error occurred!"
                alertMessage = "Unable to retrieve credentials"
                showingAlert = true
            }
        } else {
            alertTitle = "Some error occurred!"
            alertMessage = "Unable to retrieve credentials"
            showingAlert = true
            print("Failed to retrieve password from Keychain")
        }
        
        return (shouldEnableLinks, alertTitle, alertMessage, showingAlert)
    }
    
    func savePasswordToKeychain() -> (Bool, String, String, Bool) {
        var shouldEnableLinks = false
        var alertTitle = ""
        var alertMessage = ""
        var showingAlert = false
        
        let passwordData = password.data(using: .utf8)!
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: "kcPassword",
            kSecValueData as String: passwordData
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        if status == errSecSuccess {
            print("Password saved to Keychain")
            
            // save username to userdefaults
            UserDefaults.standard.set(username, forKey: "username")
            
            _ = SwiftGoogleTranslate.shared
            
            shouldEnableLinks = true
        } else {
            alertTitle = "Some error occurred!"
            alertMessage = "Failed to save credentials"
            showingAlert = true
        }
        
        return (shouldEnableLinks, alertTitle, alertMessage, showingAlert)
    }
}
