//
//  TranslatorView.swift
//  SpeakNative
//
//  Created by Shekhar.Dora on 19/08/23.
//

import SwiftUI
import TipKit

#if os(iOS)

struct TranslatorView: View {
    @State var firstLanguage: String = "English"
    @State var translationText: [MessageModel] = []
    @State var selectedIndex: Int = 0
    
    var body: some View {
        ZStack {
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
                
                HStack(alignment: .center) {
                    VStack {
                        NavigationLink(destination: TextRecognizerCameraView(translationText: $translationText, language: firstLanguage)) {
                            if #available(macOS 14.0, iOS 17.0, *) {
                                Image(systemName: "camera")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(10)
                                    .frame(width: 60)
                            }
                            else {
                                Image(systemName: "camera")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(10)
                                    .frame(width: 60)
                            }
                        }
                        .accessibilityShowsLargeContentViewer({
                            VStack {
                                Text("Capture")
                                Image(systemName: "camera")
                            }
                        })
                    }
                }
                .padding(.trailing)
            }
            .toolbarBackground(Color("darkBlack"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .background(Color("darkBlack"))
            .navigationTitle("Translate")
            .navigationBarTitleDisplayMode(.inline)
            
            if #available(macOS 14.0, iOS 17.0, *) {
#if os(iOS)
                TipView(ShowButtonTip(idValue: "ocr_tip", titleValue: "Simple Translator", messageValue: "·Language Selector : Tap on the language selector button at the top to select any desired translation language \n·Camera: Tap on the camera button to capture an image"), arrowEdge: .top)
                    .padding(40)
                    .zIndex(1)
#endif
            }
        }
    }
}

#endif

//struct CustomPickerView: View {
//    var index: Int = 0
//    @Binding var selectedLanguage: String
//    @State private var isPickerExpanded = false
//    @Binding var selectedIndex: Int
//    
//    var body: some View {
//        VStack {
//            if #available(macOS 14.0, iOS 17.0, *) {
//                TipView(ShowButtonTip(idValue: "Language Selector", titleValue: "Language Selector", messageValue: "Tap the button to select a language and also to set it as primary input language. The checkmark denotes the primary input language"), arrowEdge: .bottom)
//            }
//            Button(action: {
//                isPickerExpanded.toggle()
//                selectedIndex = index
//            }) {
//                HStack {
//                    Text(selectedLanguage)
//                        .font(.largeTitle)
//                        .padding(.horizontal)
//                }
//                
//                if selectedIndex == index {
//                    Image(systemName: "checkmark.circle")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 25)
//                }
//            }
//            .buttonStyle(.borderless)
//            .padding()
//            .popover(isPresented: $isPickerExpanded, arrowEdge: .top) {
//                ZStack {
//                    Color.black.opacity(0.5)
//                        .edgesIgnoringSafeArea(.all)
//                    
//                    ScrollView(.vertical, showsIndicators: false) {
//                        ForEach(SwiftGoogleTranslate.shared.supportedLanguages, id: \.language) { language in
//                            Button(action: {
//                                selectedLanguage = language.name
//                                isPickerExpanded.toggle()
//                            }) {
//                                Text(language.name)
//                                    .font(.title)
//                                    .padding()
//                                    .cornerRadius(10)
//                                    .padding(.vertical, 5)
//                                    .frame(width: 200)
//                            }
//                        }
//                    }
//                    .cornerRadius(15)
//                    .padding(.horizontal)
//                    .background(Color.white)
//                    .buttonStyle(.borderless)
//                }
//                
//            }
//        }
//    }
//}

public struct MessageModel {
    var language: String
    var message: String
}
