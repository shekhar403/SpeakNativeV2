//
//  LoginForm.swift
//  SpeakNative
//
//  Created by Shekhar.Dora on 05/09/23.
//

import SwiftUI

struct LoginForm: View {
    @Binding var username: String
    @Binding var password: String
    @Binding var showingAlert: Bool
    @Binding var alertMessage: String
    @Binding var alertTitle: String
    @Binding var shouldEnableLinks: Bool
    @Binding var isSignedIn: Bool
    
    var body: some View {
        Form {
            Group {
                TextField("Username ", text: $username)
                    .textFieldStyle(CustomTextFieldStyle())
                    .padding()
                    .padding(.top, 0)
                    .accessibilityInputLabels(["username"])
                    .dynamicTypeSize(.small ... .accessibility2)
                SecureField("Password ", text: $password)
                    .textFieldStyle(CustomTextFieldStyle())
                    .padding()
                    .padding(.top, 0)
                    .accessibilityInputLabels(["password"])
                    .dynamicTypeSize(.small ... .accessibility2)
            }
            Group {
                Button {
                    _ = SwiftGoogleTranslate.shared
                    
                    if username.isEmpty {
                        alertTitle = "Invalid Username!"
                        alertMessage = "Please enter valid username to proceed."
                        showingAlert = true
                    }
                    else {
                        if isSignedIn {
                            // go ahead with password validation
                            let loginHandler = LoginHandler(username: self.username, password: self.password)
                      (shouldEnableLinks, alertTitle, alertMessage, showingAlert) = loginHandler.retrievePasswordFromKeychain()
                        }
                        else {
                            // save password in keychain
                            let loginHandler = LoginHandler(username: self.username, password: self.password)
                            (shouldEnableLinks, alertTitle, alertMessage, showingAlert) = loginHandler.savePasswordToKeychain()
                        }
                    }
                } label: {
                    ZStack {
                        Color.clear
                            .frame(height: 35)
                        HStack {
                            Spacer()
                            Image(systemName: "rectangle.portrait.and.arrow.forward")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 35, height: 35, alignment: .leading)
                                .padding(10)
                                .colorMultiply(.white)
                                .dynamicTypeSize(.small ... .accessibility2)
                            Text("Enter")
                                .font(.custom("Arial Rounded MT bold", size: 20).bold())
                                .dynamicTypeSize(.small ... .accessibility2)
                                .padding(10)
                            Spacer()
                        }
                        .tint(Color("darkWhite"))
                        .padding(.vertical, 5)
                    }
                }
                .buttonStyle(.borderless)
            }
        }
        .formStyle(.grouped)
        .scrollContentBackground(.hidden)
        .frame(width: 500, height:400, alignment: .center)
        .listRowInsets(.none)
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 10)
            .cornerRadius(5)
            .font(.subheadline)
    }
}

//#Preview {
//    LoginForm()
//}
