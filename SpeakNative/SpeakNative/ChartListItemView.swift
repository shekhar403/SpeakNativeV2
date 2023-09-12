//
//  ChartListItemView.swift
//  SpeakNative
//
//  Created by Shekhar.Dora on 26/08/23.
//

import SwiftUI
import Speech
import TipKit

struct TranslationItemView: View {
    @State var message: MessageModel
    @State var buttonImage: String = "speaker.wave.3"
    @State private var personalVoices: [AVSpeechSynthesisVoice] = []
    @State private var isActive: Bool = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text((SwiftGoogleTranslate.shared.supportedLanguages.filter { $0.language == message.language }).first?.name ?? "Unknown Language")
                    .font(.title2)
                    .multilineTextAlignment(.leading)
                    .padding([.horizontal, .top])
                    .padding(.bottom, 5)
                    .dynamicTypeSize(.small ... .accessibility2)
                Text(message.message)
                    .font(.title)
                    .multilineTextAlignment(.leading)
                    .padding([.bottom, .horizontal])
                    .dynamicTypeSize(.small ... .accessibility2)
            }
            Spacer()
            
            Button(action: {
                if SpeechSynthesizerCommon.shared.speechSynthesizer?.isSpeaking == true || isActive {
                    SpeechSynthesizerCommon.shared.speechSynthesizer?.stopSpeaking(at: .word)
                    isActive = false
                }
                else {
                    isActive = true
                    let utterance = AVSpeechUtterance(string:message.message)
                    
                    if let voice = personalVoices.first {
                        utterance.voice = voice
                        SpeechSynthesizerCommon.shared.speechSynthesizer?.speak(utterance)
                    }
                    else {
                        utterance.voice = AVSpeechSynthesisVoice(language: message.language)
                        utterance.rate = 0.5
                        SpeechSynthesizerCommon.shared.speechSynthesizer?.speak(utterance)
                    }
                }
            }, label: {
                HStack {
                    if #available(macOS 14.0, iOS 17.0, *) {
                        Image(systemName: buttonImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35, height: 35, alignment: .leading)
                            .padding(10)
                            .symbolEffect(.variableColor.iterative.reversing, isActive: isActive)
#if os(iOS)
                            .popoverTip(ShowButtonTip(idValue: "Speak", titleValue: "Speak", messageValue: "·Click it once to read the content. Click it again to stop reading white it's reading the content."))
                        #endif
                    }
                    else {
                        Image(systemName: buttonImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 35, height: 35, alignment: .leading)
                            .padding(10)
                    }
                }
            })
            .accessibilityShowsLargeContentViewer({
                VStack {
                    Text("Speak")
                    Image(systemName: buttonImage)
                }
            })
            .accessibilityLabel(isActive ? "Stop" : "Speak")
            .buttonStyle(.borderless)
            .padding()
        }
        .onAppear {
            Task {
                if #available(macOS 14.0, iOS 17.0, *) {
                    await fetchPersonalVoices()
                }
            }
        }
    }
    
    @available(macOS 14.0, iOS 17.0, *)
    func fetchPersonalVoices() async {
        AVSpeechSynthesizer.requestPersonalVoiceAuthorization() { status in
            if status == .authorized {
                personalVoices = AVSpeechSynthesisVoice.speechVoices().filter { $0.voiceTraits.contains(.isPersonalVoice) }
            }
        }
    }
}

struct ChartListItemView: View {
    @Binding var messageModel: [MessageModel]
    
    var body: some View {
        List {
            ForEach(messageModel, id: \.message) { message in
                let color = Color.random
                
                TranslationItemView(message: message)
                    .background(RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(color)
                        .opacity(0.6)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color("darkWhite"), lineWidth: 2)
                            .opacity(0.6)
                    )
                    .listRowSeparator(.hidden)
                    .frame(alignment: .trailing)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color("darkBlack"))
    }
}
