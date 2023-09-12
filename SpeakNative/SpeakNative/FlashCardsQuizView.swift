//
//  FlashCardsQuizView.swift
//  SpeakNative
//
//  Created by Shekhar.Dora on 29/08/23.
//

import SwiftUI
import AVFoundation
import TipKit

struct FlashCardsQuizView: View {
    @State var subject: Categories
    
    @State var languageX: LanguageModel = LocalDataStore.languages[1]
    
    @State var languageXName: String = LocalDataStore.languages[1].language
    
    @State var tappedImageIndex: Int? = nil
    
#if os(iOS)
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
#endif
    
    var translations: [[String]] {
        var t: [[String]] = []
        if let numbersArray = LocalDataStore.data[subject.rawValue] {
            for numberInfo in numbersArray {
                if let translation = numberInfo[self.languageX.language] {
                    var temp: [String] = []
                    if let englishWord = numberInfo["English"] {
                        temp.append(englishWord)
                        temp.append(translation)
                    }
                    
                    t.append(temp)
                }
            }
        }
        
        return t
    }
    
    @State private var foundCorrectAnswer = false
    @State private var currentIndex = 0
    @State var audioPlayer: AVAudioPlayer!
    
    init(_ s: Categories) {
        _subject = State(initialValue: s)
        
        if let encodedLanguageMode = UserDefaults.standard.data(forKey: "languageModel") {
            let decoder = JSONDecoder()
            if let languageModel = try? decoder.decode(LanguageModel.self, from: encodedLanguageMode) {
                _languageX = State(initialValue: languageModel)
                _languageXName = State(initialValue: languageModel.language)
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color("darkBlack").ignoresSafeArea()
            GeometryReader { geo in
                ScrollViewReader { proxy in
                    ScrollView([.vertical, .horizontal], showsIndicators: false) {
                        VStack (alignment: .center, content: {
                            if #available(macOS 14.0, iOS 17.0, *) {
#if os(iOS)
                                TipView(ShowButtonTip(idValue: "learning_quiz_tip", titleValue: "Learning Flash Cards", messageValue: "·Language Selector : Press the button and update your learning language \n·Previous : Tap to view previous flash card \n·Pronounce : Tap to listen pronunciation of the work in selected language \n·Next : Tap to view next flash card \n·Image Buttons: tap to choose the correct option"), arrowEdge: .top)
                                    .padding(40)
                                    .zIndex(1)
                                #endif
                            }
                            
                            Text("Pick the exact matching card for the word below. Use the mic icon to listen to its pronunciation.")
                                .font(.system(size:40).bold())
                                .padding(10)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .padding(.bottom, 0)
                                .frame(width: geo.size.width * 0.9)
                                .foregroundStyle(.orange)
                                .dynamicTypeSize(.small ... .accessibility2)
                            Text(translations == [] ? "loading" : translations[currentIndex][1])
                                .font(.system(size:60).bold())
                                .padding(10)
                                .frame(width: geo.size.width * 0.9)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true)
                                .foregroundStyle(.orange)
                                .dynamicTypeSize(.small ... .accessibility2)
                            
#if os(iOS)
                            
                            if horizontalSizeClass == .regular {
                                HStack (alignment: .center) {
                                    CustomButton(buttonAction: {
                                        if currentIndex > 0 {
                                            tappedImageIndex = nil
                                            currentIndex -= 1
                                        }
                                        
                                        foundCorrectAnswer = false
                                    }, buttonImage: "arrow.turn.down.left", buttonTitle: "Previous", backgroundColor: Color.purple)
                                    .disabled(currentIndex <= 0)
                                    
                                    CustomButton(buttonAction: {
                                        let utterance = AVSpeechUtterance(string: translations == [] ? "loading" : translations[currentIndex][1].components(separatedBy: " (")[0])
                                        utterance.voice = AVSpeechSynthesisVoice(language: languageX.languageCode)
                                        utterance.rate = 0.3
                                        
                                        SpeechSynthesizerCommon.shared.speechSynthesizer?.speak(utterance)
                                    }, buttonImage: "mic", buttonTitle: "Pronounce",backgroundColor: Color.blue)
                                    
                                    CustomButton(buttonAction: {
                                        if currentIndex < translations.count - 1 {
                                            tappedImageIndex = nil
                                            currentIndex += 1
                                        }
                                        
                                        foundCorrectAnswer = false
                                    }, buttonImage: "arrow.turn.down.right", buttonTitle: "Next", backgroundColor: Color.purple)
                                    .disabled(currentIndex >= translations.count - 1)
                                }
                            }
                            else {
                                VStack (alignment: .center) {
                                    CustomButton(buttonAction: {
                                        if currentIndex > 0 {
                                            tappedImageIndex = nil
                                            currentIndex -= 1
                                        }
                                        
                                        foundCorrectAnswer = false
                                    }, buttonImage: "arrow.turn.down.left", buttonTitle: "Previous", backgroundColor: Color.purple)
                                    .disabled(currentIndex <= 0)
                                    
                                    CustomButton(buttonAction: {
                                        let utterance = AVSpeechUtterance(string: translations == [] ? "loading" : translations[currentIndex][1].components(separatedBy: " (")[0])
                                        utterance.voice = AVSpeechSynthesisVoice(language: languageX.languageCode)
                                        utterance.rate = 0.3
                                        
                                        SpeechSynthesizerCommon.shared.speechSynthesizer?.speak(utterance)
                                    }, buttonImage: "mic", buttonTitle: "Pronounce", backgroundColor: Color.blue)
                                    
                                    CustomButton(buttonAction: {
                                        if currentIndex < translations.count - 1 {
                                            tappedImageIndex = nil
                                            currentIndex += 1
                                        }
                                        
                                        foundCorrectAnswer = false
                                    }, buttonImage: "arrow.turn.down.right", buttonTitle: "Next", backgroundColor: Color.purple)
                                    .disabled(currentIndex >= translations.count - 1)
                                }
                            }
                            
                            ScrollView([.horizontal], showsIndicators: false) {
                                LazyHStack (alignment: .top, spacing: 25) {
                                    let wrongAnswerOne = translations == [] ? 0 : ((currentIndex < (translations.count - 2)) ? (currentIndex + 1) : (currentIndex - 1))
                                    let wrongAnswerTwo = translations == [] ? 0 : ((currentIndex < (translations.count - 3)) ? (currentIndex + 2) : (currentIndex - 2))
                                    
                                    imageWithBorderOnTap(translations == [] ? "loading" : "\(subject.rawValue.lowercased())-\((translations[wrongAnswerOne][0]).lowercased())", index: 0, translations == [] ? "loading" : translations[wrongAnswerOne][0])
                                        .frame(maxWidth: 400.0)
                                    imageWithBorderOnTap(translations == [] ? "loading" : "\(subject.rawValue.lowercased())-\((translations[currentIndex][0]).lowercased())", index: 1, translations == [] ? "loading" : translations[currentIndex][0])
                                        .frame(maxWidth: 400.0)
                                    imageWithBorderOnTap(translations == [] ? "loading" : "\(subject.rawValue.lowercased())-\((translations[wrongAnswerTwo][0]).lowercased())", index: 2, translations == [] ? "loading" : translations[wrongAnswerTwo][0])
                                        .frame(maxWidth: 400.0)
                                }
                                .padding(.horizontal, 50)
                               
                            }
                            
                            .frame(width: geo.size.width * 0.9)
                            .padding()
                            Spacer()
                            
#else
                            HStack (alignment: .center) {
                                CustomButton(buttonAction: {
                                    if currentIndex > 0 {
                                        tappedImageIndex = nil
                                        currentIndex -= 1
                                    }
                                    foundCorrectAnswer = false
                                }, buttonImage: "arrow.turn.down.left", buttonTitle: "Previous", backgroundColor: Color.purple)
                                .disabled(currentIndex <= 0)
                                
                                CustomButton(buttonAction: {
                                    let utterance = AVSpeechUtterance(string: translations == [] ? "loading" : translations[currentIndex][1].components(separatedBy: " (")[0])
                                    utterance.voice = AVSpeechSynthesisVoice(language: languageX.languageCode)
                                    utterance.rate = 0.3
                                    
                                    SpeechSynthesizerCommon.shared.speechSynthesizer?.speak(utterance)
                                }, buttonImage: "mic", buttonTitle: "Pronounce", backgroundColor: Color.blue)
                                
                                CustomButton(buttonAction: {
                                    if currentIndex < translations.count - 1 {
                                        tappedImageIndex = nil
                                        currentIndex += 1
                                    }
                                    
                                    foundCorrectAnswer = false
                                    proxy.scrollTo("scrollQuizToTop")
                                }, buttonImage: "arrow.turn.down.right", buttonTitle: "Next", backgroundColor: Color.purple)
                                .disabled(currentIndex >= translations.count - 1)
                            }
                                LazyHStack (alignment: .top, spacing: 25) {
                                    let wrongAnswerOne = translations == [] ? 0 : ((currentIndex < (translations.count - 2)) ? (currentIndex + 1) : (currentIndex - 1))
                                    let wrongAnswerTwo = translations == [] ? 0 : ((currentIndex < (translations.count - 3)) ? (currentIndex + 2) : (currentIndex - 2))
                                    
                                    imageWithBorderOnTap(translations == [] ? "loading" : "\(subject.rawValue.lowercased())-\((translations[wrongAnswerOne][0]).lowercased())", index: 0, translations == [] ? "loading" : translations[wrongAnswerOne][0])
                                        .frame(maxWidth: 400.0)
                                    imageWithBorderOnTap(translations == [] ? "loading" : "\(subject.rawValue.lowercased())-\((translations[currentIndex][0]).lowercased())", index: 1, translations == [] ? "loading" : translations[currentIndex][0])
                                        .frame(maxWidth: 400.0)
                                    imageWithBorderOnTap(translations == [] ? "loading" : "\(subject.rawValue.lowercased())-\((translations[wrongAnswerTwo][0]).lowercased())", index: 2, translations == [] ? "loading" : translations[wrongAnswerTwo][0])
                                        .frame(maxWidth: 400.0)
                                }
                            .frame(width: geo.size.width * 0.9)
                            .padding()
                            Spacer()
                            
#endif
                        })
                        .id("scrollQuizToTop")
                    }
                    .onAppear {
                        proxy.scrollTo("scrollQuizToTop")
                    }
                }
            }
        }
#if os(iOS)
        .toolbarBackground(Color("darkBlack"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
#endif
        .toolbar(content: {
            ToolbarItem(placement: .primaryAction) {
                if #available(macOS 14.0, iOS 17.0, *) {
                    // use the feature only available in iOS 9
                    // for ex. UIStackView
                    Picker("Update default Language", selection: $languageXName) {
                        ForEach(LocalDataStore.languages.map { $0.language }, id: \.self) {
                            Text($0).tag($0)
                                .dynamicTypeSize(.small ... .large)
                        }
                    }
                    .dynamicTypeSize(.small ... .accessibility2)
                    .accessibilityInputLabels(["language"])
                    .pickerStyle(.menu)
                } else {
                    // or use some work around
                    Picker("Update default Language", selection: $languageXName) {
                        ForEach(LocalDataStore.languages.map { $0.language }, id: \.self) {
                            Text($0).tag($0)
                                .dynamicTypeSize(.small ... .large)
                        }
                    }
                    .dynamicTypeSize(.small ... .accessibility2)
                    .accessibilityInputLabels(["language"])
                    .pickerStyle(.menu)
                }
               
                onChange(of: languageXName) { lang in
                    languageX = LocalDataStore.languages.filter { $0.language == lang }.first ?? languageX
                    let encoder = JSONEncoder()
                    if let encodedData = try? encoder.encode(LocalDataStore.languages.filter({ $0.language == lang })[0]) {
                        UserDefaults.standard.set(encodedData, forKey: "languageModel")
                    }
                }
            }
            
        })
    }
        
        @ViewBuilder
        func imageWithBorderOnTap(_ imageName: String, index: Int, _ name: String) -> some View {
            let isSelected = tappedImageIndex == index
            
            VStack {
                if imageName.contains("color") {
                    Rectangle()
                        .fill(colorFromString(name.lowercased()))
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 300)
                        .padding(0)
                }
                else {
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 300)
                        .background(Color("darkBlack"))
                        .padding(0)
                }
                
                Text(name)
                    .font(.system(size:25).bold())
                    .dynamicTypeSize(.small ... .accessibility2)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke( isSelected ? (tappedImageIndex == 1 ? Color.green : Color.red) : Color.orange, lineWidth: 5)
            )
            .padding()
            .accessibilityAddTraits(.isButton)
            .onTapGesture {
                if !foundCorrectAnswer {
                    if tappedImageIndex == index {
                        tappedImageIndex = nil
                    } else {
                        tappedImageIndex = index
                        
                        if tappedImageIndex == 1 {
                            foundCorrectAnswer = true
                            playSounds("claps-44774.mp3")
                        }
                    }
                }
            }
        }
        
        func playSounds(_ soundFileName : String) {
            guard let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: nil) else {
                fatalError("Unable to find \(soundFileName) in bundle")
            }
            
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            } catch {
                print(error.localizedDescription)
            }
            audioPlayer.play()
        }
        
        func colorFromString(_ colorName: String) -> Color {
            switch colorName.lowercased() {
            case "red":
                return .red
            case "blue":
                return .blue
            case "green":
                return .green
            case "yellow":
                return .yellow
            case "orange":
                return .orange
            case "purple":
                return .purple
            case "pink":
                return .pink
            case "brown":
                return .brown
            case "black":
                return .black
            case "white":
                return .white
            default:
                return .clear
            }
        }
    }
    
    //#Preview {
    //    FlashCardsView()
    //}
