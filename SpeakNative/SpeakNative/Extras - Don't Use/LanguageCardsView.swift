////
////  LanguageCardsView.swift
////  SpeakNative
////
////  Created by Shekhar.Dora on 11/08/23.
////
//
//import SwiftUI
//import Speech
//
//let kBlankString = ""
//
//struct LanguageCardsView: View {
//#if os(iOS)
//    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
//    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
//    #endif
//    @State var showPopover = true
//    @State var message = "Hello, I am octo!"
//    var messages = ["I will help you to learn new languages of your choice.", "I will be using English language to help you learn any other laguage.", "Please Select any laguage of your choice in the next screen.", "Let's get started..."];
//    @State var messageProgressCount = 0
//    @State var shouldShowIntroduction = true
//    @State var settingProgress = 0.0
//    @State var selectedRowIndex: Int? = nil
//    @State var disableNextButton: Bool = true
//    @State var selectedLanguageModel: LanguageModel?
//    @State var languageSelectionDone: Bool = false
//    @State var resetCredentials: (()->Void)?
//    
//    var body: some View {
//        ZStack {
//            Color.black.ignoresSafeArea()
//            VStack {
//                if shouldShowIntroduction {
//                    VStack {
//                        Image("mr-octo")
//                            .popover(isPresented: $showPopover, arrowEdge: .top) {
//                                #if os(iOS)
//                                Text(message)
//                                    .font(.custom("Arial Rounded MT bold", size: 60).bold())
//                                    .minimumScaleFactor(0.1)
//                                    .padding(10)
//                                    .interactiveDismissDisabled(horizontalSizeClass == .regular)
//                                #else
//                                Text(message)
//                                    .font(.custom("Arial Rounded MT bold", size: 60).bold())
//                                    .minimumScaleFactor(0.1)
//                                    .padding(10)
//                                    .interactiveDismissDisabled(true)
//                                #endif
//                            }
//                            .padding([.bottom], 150)
//                        Button(action: {
//                            if (messageProgressCount >= messages.count) {
//                                shouldShowIntroduction = false
//                            }
//                            else {
//                                message = messages[messageProgressCount]
//                                
//                                if !message.isEmpty {
//                                    settingProgress += 0.1
//                                }
//#if os(iOS)
//                                if horizontalSizeClass != .regular {
//                                    showPopover = true
//                                }
//                                #endif
//                            }
//                            
//                            messageProgressCount += 1
//                        }, label: {
//                            HStack {
//                                Text("Next")
//                                    .font(.custom("Arial Rounded MT bold", size: 30).bold())
//                                    .padding(10)
//                                Spacer()
//                                Image("forward-solid")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    .frame(width: 35, height: 35, alignment: .leading)
//                                    .padding(10)
//                                    .colorMultiply(.white)
//                            }
//                        })
//                        .buttonStyle(.borderedProminent)
//                        .contentShape(Rectangle())
//                        .tint(.white)
//                        .frame(width: 200)
//                    }
//                }
//                else {
//                    if !languageSelectionDone {
//                        VStack {
//                            Text("Select any laguage that you want to learn")
//                                .font(.custom("Arial Rounded MT bold", size: 30))
//                                .minimumScaleFactor(0.1)
//                                .padding(10)
//                            
//                            List(LocalDataStore.languages.indices, id: \.self) {index in
//                                languageCell(language: LocalDataStore.languages[index], settingProgress: $settingProgress, selectedRowIndex: $selectedRowIndex, selfIndex: index, disableNextButton: $disableNextButton, selectedLanguageModel: $selectedLanguageModel)
//                                    .background(Color.black)
//                                    .listRowSeparator(.visible)
//                                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0))
//                                    .listRowBackground(Color.black)
//                                    .overlay(RoundedRectangle(cornerRadius: 10)
//                                        .stroke((selectedRowIndex == index) ? Color("AccentColor") : Color.gray, lineWidth: 4))
//                                
//                            }
//                            .scrollContentBackground(.hidden)
//                            Spacer()
//                        }
//                    }
//                    else {
//                        VStack {
//                            LanguageQuestionnaireView(settingProgress: $settingProgress, selectedLanguageModel: $selectedLanguageModel, resetCredentials: resetCredentials)
//                        }
//                    }
//                }
//                
//                ProgressBar(value: $settingProgress)
//                    .padding(20)
//                    .toolbar {
//                        ToolbarItem(placement: .primaryAction) {
//                            Button(action: {
//                                disableNextButton = true
//                                languageSelectionDone = true
//                            }) { Text("Next") }.disabled(disableNextButton)
//                        }
//                    }
//            }
//        }
//#if os(iOS)
//        .navigationBarBackButtonHidden(true)
//        #endif
//    }
//}
//
////#Preview {
////    LanguageCardsView()
////}
//
//struct languageCell: View {
//    @State var language: LanguageModel
//    @State var isSelected: Bool = false
//    @Binding var settingProgress: Double
//    @Binding var selectedRowIndex: Int?
//    @State var selfIndex: Int
//    @Binding var disableNextButton: Bool
//    @Binding var selectedLanguageModel: LanguageModel?
//    
//    
//    var body: some View {
//        Button(action: {
//            settingProgress = 0.6
//            selectedRowIndex = selfIndex
//            disableNextButton = false
//            selectedLanguageModel = language
//            
//            let encoder = JSONEncoder()
//            if let encodedData = try? encoder.encode(selectedLanguageModel) {
//            }
//        }) {
//            HStack (alignment: .center) {
//                Image(language.flag)
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 75, height: 50, alignment: .leading)
//                    .padding(10)
//                Spacer()
//                
//                Text(language.language)
//                    .font(.title).bold()
//                
//                Spacer()
//                Text(language.languageCode)
//                    .font(.title).bold()
//                    .padding([.trailing], 10)
//            }
//            .background(.black)
//        }
//    }
//}
//
//
//struct LanguageModel: Identifiable, Hashable, Codable {
//    var id = UUID()
//    var language: String
//    var languageCode: String
//    var flag: String
//}
//
//
//struct ProgressBar: View {
//    @Binding var value: Double
//    
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack(alignment: .leading) {
//                Rectangle().frame(width: geometry.size.width , height: 28)
//                    .opacity(0.3)
//                
//                Rectangle().frame(width: min(CGFloat(self.value) * geometry.size.width, geometry.size.width), height: 28)
//                    .animation(.linear, value: value)
//            }.cornerRadius(45.0)
//        }
//        .fixedSize(horizontal: false, vertical: true)
//    }
//}
//
