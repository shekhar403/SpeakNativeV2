//
//  SimpleTranslatorView.swift
//  SpeakNative
//
//  Created by Shekhar.Dora on 26/08/23.
//

import SwiftUI
import TipKit

struct SimpleTranslatorView: View {
    @State var firstLanguage: String = "English"
    @State var translationText: [MessageModel] = []
    @State var keyboardButtonTapped: Bool = false
    @State var keyboardText: String = ""
    @State var micButtonTapped: Bool = false
    let speechService: SpeechRecognitionManager = SpeechRecognitionManager.shared
    @State var shouldShowLanguagePicker: Bool = false
    @State var selectedVoiceLanguage: String = "en-us"
    @State var selectedIndex: Int = 0
    @State var isMicActive: Bool = false
    
    var body: some View {
        ZStack(alignment: .center) {
            VStack {
                HStack(alignment:.top) {
                    CustomLanguagePickerView(index:0, selectedLanguage: $firstLanguage, selectedIndex: $selectedIndex)
                        .padding(.top)
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
                                    shouldShowLanguagePicker = true
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
                                
                                if let languageDict = (gTranslator.supportedLanguages.filter { $0.name == firstLanguage }).first {
                                    let languageCode = languageDict.language
                                    var recognizedLanguage = "en"
                                    
                                    gTranslator.detect(keyboardText) { (detections, error) in
                                        if let detections = detections {
                                            for detection in detections {
                                                recognizedLanguage = detection.language
                                                translationText.append(MessageModel(language: recognizedLanguage, message: keyboardText))
                                                
                                                // translating to target language
                                                gTranslator.translate(keyboardText, languageCode, recognizedLanguage) { (text, error) in
                                                    if let t = text {
                                                        translationText.append(MessageModel(language: languageCode, message: t))
                                                    }
                                                }
                                            }
                                        }
                                        else {
                                            translationText.append(MessageModel(language: recognizedLanguage, message: keyboardText))
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
                                    .foregroundStyle(keyboardText.count == 0 || keyboardText == " " ? Color.gray : Color("darkWhite"))
                                    .accessibilityElement(children: .ignore)
                            })
                            .accessibilityShowsLargeContentViewer({
                                VStack {
                                    Text("Translate")
                                    Image(systemName: "arrow.uturn.right")
                                }
                            })
                            .disabled(keyboardText.count == 0 || keyboardText == " ")
                            .buttonStyle(.borderless)
                            .frame(width: 40)
                            .padding(.trailing)
                            .accessibilityLabel("Translate")
                        }
#if os(iOS)
                        .popoverTip(ShowButtonTip(idValue: "simple_translator_inputs", titleValue: "Simple translator Inputs", messageValue: "·Text Editor : Enter the text that you want to translate \n·Microphone : Press to enable microphone and select your input language \n·Translate : Press to translate your input text"), arrowEdge: .bottom)
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
                                .dynamicTypeSize(.small ... .accessibility2)
                                .padding(.leading)
                                .accessibilityInputLabels(["input"])
                            
                            Button(action: {
                                micButtonTapped.toggle()
                                if micButtonTapped {
                                    shouldShowLanguagePicker = true
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
                                
                                if let languageDict = (gTranslator.supportedLanguages.filter { $0.name == firstLanguage }).first {
                                    let languageCode = languageDict.language
                                    var recognizedLanguage = "en"
                                    
                                    gTranslator.detect(keyboardText) { (detections, error) in
                                        if let detections = detections {
                                            for detection in detections {
                                                recognizedLanguage = detection.language
                                                translationText.append(MessageModel(language: recognizedLanguage, message: keyboardText))
                                                
                                                // translating to target language
                                                gTranslator.translate(keyboardText, languageCode, recognizedLanguage) { (text, error) in
                                                    if let t = text {
                                                        translationText.append(MessageModel(language: languageCode, message: t))
                                                    }
                                                }
                                            }
                                        }
                                        else {
                                            translationText.append(MessageModel(language: recognizedLanguage, message: keyboardText))
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
                                    .foregroundStyle(keyboardText.count == 0 || keyboardText == " " ? Color.gray : Color("darkWhite"))
                                    .accessibilityElement(children: .ignore)
                            })
                            .accessibilityShowsLargeContentViewer({
                                VStack {
                                    Text("Translate")
                                    Image(systemName: "arrow.uturn.right")
                                }
                            })
                            .disabled(keyboardText.count == 0 || keyboardText == " ")
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
                    })
                    .accessibilityShowsLargeContentViewer({
                        VStack {
                            Text("Keyboard")
                            Image(systemName: "keyboard")
                        }
                    })
                    .buttonStyle(.borderless)
                    .frame(width: 60)
                    .padding(.trailing)
                }
            }
#if os(iOS)
            .toolbarBackground(Color("darkBlack"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .background(Color("darkBlack"))
            .navigationTitle("Translate")
            .sheet(isPresented: $shouldShowLanguagePicker) {
                isMicActive = true
                speechService.updateSpeechLanguage(languageCode: selectedVoiceLanguage)
                
                speechService.startRecordingAndRecognition { text in
                    keyboardText  = text
                }
            } content: {
                let languages = speechService.getSupportedLocales()
                VStack {
#if os(iOS)
                    Text("Please choose your preferred voice language")
                        .font(.headline)
                        .dynamicTypeSize(.small ... .accessibility2)
#endif
                    Picker("Please choose your preferred voice language", selection: $selectedVoiceLanguage) {
                        ForEach(languages, id: \.code) {language in
                            Text(language.name)
                                .padding()
                                .dynamicTypeSize(.small ... .accessibility2)
                        }
                    }
                    .dynamicTypeSize(.small ... .accessibility2)
                    .padding(.top)
                    Button {
                        shouldShowLanguagePicker = false
                        keyboardText += ""
                    } label: {
                        Text("Close")
                            .dynamicTypeSize(.small ... .accessibility2)
                    }
                    .padding()
                    
                }
                .padding(.horizontal)
            }
            
            if #available(macOS 14.0, iOS 17.0, *) {
#if os(iOS)
                TipView(ShowButtonTip(idValue: "simple_translator_tip", titleValue: "Simple Translator", messageValue: "·Language Selector : Tap on the language selector button at the top to select any desired translation language \n·Keyboard: Tap on the keyboard button to provide the input text"), arrowEdge: .bottom)
                    .padding(40)
                    .zIndex(1)
                #endif
            }
        }
    }
}
