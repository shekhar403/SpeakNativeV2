//
//  ConversationTranslatorView.swift
//  SpeakNative
//
//  Created by Shekhar.Dora on 26/08/23.
//

import SwiftUI
import TipKit

struct ConversationTranslatorView: View {
    @State var firstLanguage: String = "English"
    @State var secondLanguage: String = "English"
    @State var translationText: [MessageModel] = []
    @State var firstTranslatedtext = ""
    @State var secondTranslatedtext = ""
    @State var keyboardButtonTapped: Bool = false
    @State var keyboardText: String = ""
    @State var micButtonTapped: Bool = false
    @State var languageSelected: Int = 0
    let speechService = SpeechRecognitionManager.shared
    @State var selectedIndex: Int = 0
    
    @State var isMicActive: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack(alignment:.top) {
                    CustomLanguagePickerView(index:0, selectedLanguage: $firstLanguage, selectedIndex: $selectedIndex, selected: selectedIndex == 0 ? true : false, isCheckmarkRequired: true)
                        .padding(.top)
                        .padding(.leading)
                    Spacer()
                    CustomLanguagePickerView(index:1, selectedLanguage: $secondLanguage, selectedIndex: $selectedIndex, selected: selectedIndex == 1 ? true : false, isCheckmarkRequired: true)
                        .padding(.top)
                        .padding(.trailing)
                }
                
                ChartListItemView(messageModel: $translationText)
                    .cornerRadius(10)
                    .font(.body)
                    .scrollContentBackground(.hidden)
                    .background(Color("darkBlack"))
                    .padding(15)
                    .opacity(0.9)
                    .background(RoundedRectangle(cornerRadius: 25).fill(Color("darkWhite")))
                    .opacity(20)
                    .padding()
                
                if keyboardButtonTapped {
                    if #available(macOS 14.0, iOS 17.0, *) {
                        HStack {
                            TextEditor(text: $keyboardText)
                                .padding()
                                .cornerRadius(10)
                                .font(.body)
                                .scrollContentBackground(.hidden)
                                .background(Color("darkBlack"))
                                .padding(15)
                                .opacity(0.9)
                                .background(RoundedRectangle(cornerRadius: 25).fill(Color("darkWhite")))
                                .opacity(20)
                                .frame(height: 100)
                                .padding(.leading)
                                .accessibilityInputLabels(["input"])
                            
                            Button(action: {
                                micButtonTapped.toggle()
                                if micButtonTapped {
                                    isMicActive = true
                                    let firstLocaleCode = ((SwiftGoogleTranslate.shared.supportedLanguages.filter { $0.name == firstLanguage }).first?.language ?? "en") + "-" + (Locale.current.region?.identifier.lowercased() ?? "us")
                                    let secondLocaleCode = ((SwiftGoogleTranslate.shared.supportedLanguages.filter { $0.name == secondLanguage }).first?.language ?? "en") + "-" + (Locale.current.region?.identifier.lowercased() ?? "us")
                                    speechService.updateSpeechLanguage(languageCode: selectedIndex == 0 ? firstLocaleCode : secondLocaleCode)
                                    
                                    speechService.startRecordingAndRecognition { text in
                                        keyboardText  = text
                                    }
                                }
                                else {
                                    speechService.stopRecordingAndRecognition()
                                    isMicActive = false
                                }
                            }, label: {
                                Image(systemName: "mic.and.signal.meter")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(10)
                                    .symbolEffect(.variableColor.iterative.reversing, isActive: isMicActive)
                                    .accessibilityElement(children: .ignore)
                            })
                            .accessibilityShowsLargeContentViewer({
                                VStack {
                                    Text("Microphone")
                                    Image(systemName: "mic.and.signal.meter")
                                }
                            })
                            .buttonStyle(.borderless)
                            .frame(width: 40)
                            .accessibilityLabel(isMicActive ? "Disable Microphone" : "Enable Microphone")
                            
                            Button(action: {
                                keyboardButtonTapped.toggle()
                                
                                let gTranslator = SwiftGoogleTranslate.shared
                                let source = selectedIndex == 0 ? firstLanguage : secondLanguage
                                let destination = selectedIndex == 0 ? secondLanguage : firstLanguage
                                
                                if let sourceLanguage = (gTranslator.supportedLanguages.filter { $0.name == source }).first, let destinationLanguage = (gTranslator.supportedLanguages.filter { $0.name == destination }).first {
                                    let sourceCode = sourceLanguage.language
                                    let destinationCode = destinationLanguage.language
                                    
                                    translationText.append(MessageModel(language: sourceCode, message: keyboardText))
                                    
                                    // translating to target language
                                    gTranslator.translate(keyboardText, destinationCode, sourceCode) { (text, error) in
                                        if let t = text {
                                            translationText.append(MessageModel(language: destinationCode, message: t))
                                        }
                                        keyboardText = ""
                                    }
                                }
                                
                                speechService.stopRecordingAndRecognition()
                                micButtonTapped = false
                            }, label: {
                                Image(systemName: "arrow.uturn.right")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(10)
                                    .foregroundStyle(keyboardText.count == 0 ? Color.gray : Color("darkWhite"))
                                    .accessibilityElement(children: .ignore)
                            })
                            .accessibilityShowsLargeContentViewer({
                                VStack {
                                    Text("Translate")
                                    Image(systemName: "arrow.uturn.right")
                                }
                            })
                            .disabled(keyboardText.count == 0)
                            .buttonStyle(.borderless)
                            .frame(width: 40)
                            .padding(.trailing)
                            .accessibilityLabel("Translate")
                        }
                        #if os(iOS)
                        .popoverTip(ShowButtonTip(idValue: "conversation_inputs", titleValue: "Simple translator Inputs", messageValue: "·Text Editor : Enter the text that you want to translate \n·Microphone : Press to enable microphone and select your input language \n·Translate : Press to translate your input text"), arrowEdge: .bottom)
                        #endif
                    }
                    else {
                        HStack {
                            TextEditor(text: $keyboardText)
                                .padding()
                                .cornerRadius(10)
                                .font(.body)
                                .scrollContentBackground(.hidden)
                                .background(Color("darkBlack"))
                                .padding(15)
                                .opacity(0.9)
                                .background(RoundedRectangle(cornerRadius: 25).fill(Color("darkWhite")))
                                .opacity(20)
                                .frame(height: 100)
                                .padding(.leading)
                                .accessibilityInputLabels(["input"])
                            
                            Button(action: {
                                micButtonTapped.toggle()
                                if micButtonTapped {
                                    isMicActive = true
                                    let firstLocaleCode = ((SwiftGoogleTranslate.shared.supportedLanguages.filter { $0.name == firstLanguage }).first?.language ?? "en") + "-" + (Locale.current.region?.identifier.lowercased() ?? "us")
                                    let secondLocaleCode = ((SwiftGoogleTranslate.shared.supportedLanguages.filter { $0.name == secondLanguage }).first?.language ?? "en") + "-" + (Locale.current.region?.identifier.lowercased() ?? "us")
                                    speechService.updateSpeechLanguage(languageCode: selectedIndex == 0 ? firstLocaleCode : secondLocaleCode)
                                    
                                    speechService.startRecordingAndRecognition { text in
                                        keyboardText  = text
                                    }
                                }
                                else {
                                    speechService.stopRecordingAndRecognition()
                                    isMicActive = false
                                }
                            }, label: {
                                Image(systemName: isMicActive ? "mic" : "mic.slash")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(10)
                                    .accessibilityElement(children: .ignore)
                            })
                            .accessibilityShowsLargeContentViewer({
                                VStack {
                                    Text("Microphone")
                                    Image(systemName: isMicActive ? "mic" : "mic.slash")
                                }
                            })
                            .buttonStyle(.borderless)
                            .frame(width: 40)
                            .accessibilityLabel(isMicActive ? "Disable Microphone" : "Enable Microphone")
                            
                            Button(action: {
                                keyboardButtonTapped.toggle()
                                
                                let gTranslator = SwiftGoogleTranslate.shared
                                let source = selectedIndex == 0 ? firstLanguage : secondLanguage
                                let destination = selectedIndex == 0 ? secondLanguage : firstLanguage
                                
                                if let sourceLanguage = (gTranslator.supportedLanguages.filter { $0.name == source }).first, let destinationLanguage = (gTranslator.supportedLanguages.filter { $0.name == destination }).first {
                                    let sourceCode = sourceLanguage.language
                                    let destinationCode = destinationLanguage.language
                                    
                                    translationText.append(MessageModel(language: sourceCode, message: keyboardText))
                                    
                                    // translating to target language
                                    gTranslator.translate(keyboardText, destinationCode, sourceCode) { (text, error) in
                                        if let t = text {
                                            translationText.append(MessageModel(language: destinationCode, message: t))
                                        }
                                        keyboardText = ""
                                    }
                                }
                                
                                speechService.stopRecordingAndRecognition()
                                micButtonTapped = false
                            }, label: {
                                Image(systemName: "arrow.uturn.right")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(10)
                                    .foregroundStyle(keyboardText.count == 0 ? Color.gray : Color("darkWhite"))
                                    .accessibilityElement(children: .ignore)
                            })
                            .accessibilityShowsLargeContentViewer({
                                VStack {
                                    Text("Translate")
                                    Image(systemName: "arrow.uturn.right")
                                }
                            })
                            .disabled(keyboardText.count == 0)
                            .buttonStyle(.borderless)
                            .frame(width: 40)
                            .padding(.trailing)
                            .accessibilityLabel("Translate")
                        }
                    }
                }
                
                HStack(alignment: .center) {
                    Button(action: {
                        keyboardButtonTapped.toggle()
                        speechService.stopRecordingAndRecognition()
                        keyboardText = ""
                        micButtonTapped = false
                    }, label: {
                        Image(systemName: "keyboard")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(10)
                            .frame(width: 60)
                    })
                }
                .accessibilityShowsLargeContentViewer({
                    VStack {
                        Text("Keyboard")
                        Image(systemName: "keyboard")
                    }
                })
                .buttonStyle(.borderless)
                .padding(.trailing)
            }
#if os(iOS)
            .toolbarBackground(Color("darkBlack"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .background(Color("darkBlack"))
            .navigationTitle("Translate")
            
            if #available(macOS 14.0, iOS 17.0, *) {
#if os(iOS)
                TipView(ShowButtonTip(idValue: "conversation_tip", titleValue: "Simple Translator", messageValue: "·First Language Selector : Tap on the language selector button at the top to select any desired translation language for person one \n·Second Language Selector : Tap on the language selector button at the top to select any desired translation language for person two \n·Selection Buttons (Checkmark) : Tap on the checkmark button to set either first language or second language as current input language, the other language will automatically be set as translation language \n·Keyboard: Tap on the keyboard button to provide the input text"), arrowEdge: .bottom)
                    .padding(40)
                    .zIndex(1)
                #endif
            }
        }
    }
}

//#Preview {
//    ConversationTranslatorView()
//}
