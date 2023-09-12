//
//  WelcomeView.swift
//  SpeakNative
//
//  Created by Shekhar.Dora on 05/09/23.
//

import SwiftUI
import Speech

struct WelcomeView: View {
    let welcomeMessage = "Hello, I am octo! I will help you to learn new languages of your choice using flash cards and voice pronunciation. Whenever you feel confident in any language you can attempt the quiz for the same, where you will given a word in the selected language and some options in english. You will have to choose the correct meaning in english. There are some inbuilt translator tool in the app, that you can user to translate from one language to another, have a conversation with another person speaking another language and also scan an image to detect the text in any language and transalate it to any other language. The best part of these tools is you can use the Speech Recognition feature and type any thing and in any language just using your voice. Also you can listen to the pronounciation of input as well as translated texts. Wishing you to enjoy this learning journey with us and find something new."
    @State var resetCredentials: (()->Void)?
    @State var shouldOpenFeatures: Bool = false
    
    var body: some View {
        RoundedRectangleTextView(text: welcomeMessage, shouldOpenFeatures: $shouldOpenFeatures)
            .font(.custom("Futura Medium Italic", size: 24))
            .navigationDestination(isPresented: $shouldOpenFeatures) {
                MainFeaturesView(resetCredentials: resetCredentials)
            }
    }
}

struct RoundedRectangleTextView: View {
    var text: String
    @Binding var shouldOpenFeatures: Bool

    var body: some View {
        ZStack {
            Color("darkBlack").ignoresSafeArea()
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("darkBlack"))
                    .frame(minHeight: 100)

                VStack(alignment: .leading, spacing: 10) {
                    
                    ScrollView(.vertical) {
                        VStack {
                            HStack {
                                Image("mr-octo")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                Text("Welcome to SpeakNative, \(UserDefaults.standard.string(forKey: "username") ?? "")")
                            }
                            .padding([.top, .horizontal], 10)
                            .padding(.bottom, 0)
                            
                            Text(text)
                                .padding(10)
                        }
                    }
                    
                    HStack {
                        VStack {
                            Text("Thank you!")
                            Text("Octo")
                        }
                        Spacer()
                        Button(action: {
                            if SpeechSynthesizerCommon.shared.speechSynthesizer?.isSpeaking == true {
                                SpeechSynthesizerCommon.shared.speechSynthesizer?.stopSpeaking(at: .word)
                            }
                            else {
                                let utterance = AVSpeechUtterance(string:text)
                                utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                                utterance.rate = 0.5
                                SpeechSynthesizerCommon.shared.speechSynthesizer?.speak(utterance)
                            }
                        }) {
                            Image(systemName: "speaker.wave.1.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                        .accessibilityShowsLargeContentViewer({
                            VStack {
                                Text("Speak")
                                Image(systemName: "speaker.wave.1.fill")
                            }
                        })
                        .buttonStyle(.borderless)
                        .accessibilityLabel("Speak")
                        .padding(.horizontal)
                        Button(action: {
                            UserDefaults.standard.set(true, forKey: "doneWelcome")
                            shouldOpenFeatures = true
                        }) {
                            Image(systemName: "play.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                        .accessibilityShowsLargeContentViewer({
                            VStack {
                                Text("Go")
                                Image(systemName: "play.circle.fill")
                            }
                        })
                        .buttonStyle(.borderless)
                        .accessibilityLabel("Go")
                    }
                    .padding(10)
                }
            }
            .padding(20)
        }
       
       
    }
}

#Preview {
    WelcomeView()
}
