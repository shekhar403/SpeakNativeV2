//
//  MainFeaturesView.swift
//  SpeakNative
//
//  Created by Shekhar.Dora on 13/08/23.
//

import SwiftUI

enum Categories: String {
    case numbers = "Number"
    case days = "Day"
    case colors = "Color"
    case months = "Month"
    case greetings = "Greeting"
}

struct MainFeaturesView: View {
    // Basic Vocabulary
    let vocabImages = ["vocab-numbers", "vocab-days", "vocab-colors", "vocab-month", "vocab-expressions"]
    let vocabNames = ["Numbers", "Days", "Colors", "Months", "Greetings"]
    let vocabCategory = [Categories.numbers, Categories.days, Categories.colors, Categories.months, Categories.greetings]
    @State var isLoggedIn = !(UserDefaults.standard.string(forKey: "username") ?? "").isEmpty
    @Environment(\.dismiss) private var dismiss
    @State var resetCredentials: (()->Void)?
    
    var body: some View {
        ZStack {
            Color("darkBlack").ignoresSafeArea()
            GeometryReader{ p in
                ScrollView {
                    VStack (alignment: .leading, spacing: 0) {
                        Text("Language translator")
                            .font(.system(size:60).bold())
                            .padding(30)
                            .dynamicTypeSize(.small ... .accessibility2)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 40) {
                                NavigationLink(destination: SimpleTranslatorView()) {
                                    VStack(spacing: 10) {
                                        Image("simple-translator-image")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxHeight: 200, alignment: .center)
                                            .clipShape(RoundedRectangle(cornerSize: CGSizeMake(10, 10)))
                                            .shadow(color: .blue, radius: 10, x: 0, y: 0)
                                        Text("Simple Translator")
                                            .dynamicTypeSize(.small ... .accessibility2)
                                            .font(.custom("San Francisco", size: 30))
                                            .shadow(color: .cyan, radius: 20, x: 0, y: 0)
                                    }
                                }
                                .disabled(!isLoggedIn)
                                .buttonStyle(PlainButtonStyle())
#if os(iOS)
                                NavigationLink(destination: TranslatorView()) {
                                    VStack(spacing: 10) {
                                        Image("camera-translator")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxHeight: 200, alignment: .center)
                                            .clipShape(RoundedRectangle(cornerSize: CGSizeMake(10, 10)))
                                            .shadow(color: .blue, radius: 10, x: 0, y: 0)
                                        Text("Image Translator")
                                            .dynamicTypeSize(.small ... .accessibility2)
                                            .font(.custom("San Francisco", size: 30))
                                            .shadow(color: .cyan, radius: 20, x: 0, y: 0)
                                    }
                                }
                                .disabled(!isLoggedIn)
                                .buttonStyle(PlainButtonStyle())
#endif
                                NavigationLink(destination: ConversationTranslatorView()) {
                                    VStack(spacing: 10) {
                                        Image("conversation-translation")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxHeight: 200, alignment: .center)
                                            .clipShape(RoundedRectangle(cornerSize: CGSizeMake(10, 10)))
                                            .shadow(color: .blue, radius: 10, x: 0, y: 0)
                                        Text("Conversation Translator")
                                            .dynamicTypeSize(.small ... .accessibility2)
                                            .font(.custom("San Francisco", size: 30))
                                            .shadow(color: .cyan, radius: 20, x: 0, y: 0)
                                    }
                                }
                                .disabled(!isLoggedIn)
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(50)
                        }
                        .padding()
                        
                        Text("Language Learning")
                            .font(.system(size:60).bold())
                            .padding(30)
                            .dynamicTypeSize(.small ... .accessibility2)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 40) {
                                ForEach(vocabImages.indices, id:\.self) { index in
                                    let image = vocabImages[index]
                                    let category = vocabCategory[index]
                                    
                                    NavigationLink(destination: FlashCardsView(category)) {
                                        VStack(spacing: 10) {
                                            Image(image)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(maxHeight: 200, alignment: .center)
                                                .clipShape(RoundedRectangle(cornerSize: CGSizeMake(10, 10)))
                                                .shadow(color: .green, radius: 10, x: 0, y: 0)
                                            Text(vocabNames[index])
                                                .dynamicTypeSize(.small ... .accessibility2)
                                                .font(.custom("San Francisco", size: 30))
                                                .shadow(color: .cyan, radius: 20, x: 0, y: 0)
                                        }
                                    }
                                    .disabled(!isLoggedIn)
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(50)
                        }
                        .padding()
                        
                        Text("Language Quiz")
                            .font(.system(size:60).bold())
                            .padding(30)
                            .dynamicTypeSize(.small ... .accessibility2)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 40) {
                                ForEach(vocabImages.indices, id:\.self) { index in
                                    let image = vocabImages[index]
                                    let category = vocabCategory[index]
                                    
                                    NavigationLink(destination: FlashCardsQuizView(category)) {
                                        VStack(spacing: 10) {
                                            Image(image)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(maxHeight: 200, alignment: .center)
                                                .clipShape(RoundedRectangle(cornerSize: CGSizeMake(10, 10)))
                                                .shadow(color: .green, radius: 10, x: 0, y: 0)
                                            Text(vocabNames[index])
                                                .dynamicTypeSize(.small ... .accessibility2)
                                                .font(.custom("San Francisco", size: 30))
                                                .shadow(color: .cyan, radius: 20, x: 0, y: 0)
                                        }
                                    }
                                    .disabled(!isLoggedIn)
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(50)
                        }
                        .padding()
                    }
                }
            }
        }
        .onAppear(perform: {
            isLoggedIn = !(UserDefaults.standard.string(forKey: "username") ?? "").isEmpty
        })
#if os(iOS)
        .toolbarBackground(Color("darkBlack"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
#endif
        .navigationTitle("Features")
        .toolbar(content: {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    // Add logout action here
                    removePasswordFromKeychain()
                }, label: {
                    HStack {
                        Text("logout")
                            .foregroundStyle(Color.red)
                        
                        if let name = UserDefaults.standard.string(forKey: "username") {
                            Text(name.isEmpty ? "..." : name)
                        }
                        else {
                            Text("...")
                        }
                        
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20)
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Log out \(UserDefaults.standard.string(forKey: "username") ?? "")")
                })
                .buttonStyle(.borderless)
                .accessibilityLabel("Logout")
            }
        })
    }
    
    private func removePasswordFromKeychain() {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: "kcPassword"
            ]
            
            let status = SecItemDelete(query as CFDictionary)
            if status == errSecSuccess {
                print("Password removed from Keychain")
                UserDefaults.standard.removeObject(forKey: "username")
                resetCredentials?()
                dismiss()
            } else {
                print("Failed to remove password from Keychain")
            }
        }
}
