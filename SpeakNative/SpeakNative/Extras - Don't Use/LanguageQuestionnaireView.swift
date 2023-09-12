////
////  LanguageQuestionnaireView.swift
////  SpeakNative
////
////  Created by Shekhar.Dora on 11/08/23.
////
//
//import SwiftUI
//
//struct LanguageQuestionnaireView: View {
//    var columns: [GridItem] = [
//        GridItem(.adaptive(minimum: 200)),
//        GridItem(.adaptive(minimum: 200)),
//        GridItem(.adaptive(minimum: 200))
//    ]
//    
//    @Binding var settingProgress: Double
//    @State var doneQuestionaire: Bool = false
//    @Binding var selectedLanguageModel: LanguageModel?
//    @Environment(\.dismiss) private var dismiss
//    @State var resetCredentials: (()->Void)?
//    
//    var body: some View {
//        let questions = ["How did you hear about SpeakNative?", "How much \(selectedLanguageModel?.language ?? kBlankString) do you know?", "Why are you learning \(selectedLanguageModel?.language ?? kBlankString)?"]
//        let answers = [["Google Search", "Friends / Family", "Facebook", "Instagram", "TV", "Youtube", "News / Article / Blog", "App Store","Tiktok", "Other"], ["I'm new to \(selectedLanguageModel?.language ?? kBlankString)", "I know some words and phrases", "I can have simple conversations", "I am intermediate or higher"], ["Connect with people", "prepare for travel", "Just for fun", "Support my education", "Boost My Career", "Spend time productively", "Other"]]
//        let images = [["google", "family", "facebook", "instagram", "tv", "youtube", "newspaper", "appstore", "tiktok", "other"], ["battery-empty-solid", "battery-quarter-solid", "battery-half-solid", "battery-three-quarters-solid"], ["people-group-solid", "plane-solid", "face-laugh-beam-regular", "school-solid", "laptop-code-solid", "brain-solid", "other"]]
//        
//        GeometryReader { geo in
//            if doneQuestionaire {
//                VStack(alignment:.center) {
//                    Image("dungeon-solid")
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 150, height: 150, alignment: .center)
//                        .padding(3)
//                        .colorMultiply(.white)
//                    NavigationLink {
//                        MainFeaturesView()
//                    } label: {
//                        Text("Enter")
//                            .font(.title)
//                            .bold()
//                    }
//                }
//                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
//            }
//            else {
//                VStack {
//                    ScrollViewReader { proxy in
//                        ScrollView {
//                            ForEach(0..<questions.count, id: \.self) { i in
//                                VStack(alignment:.center) {
//                                    Image("mr-octo")
//                                        .aspectRatio(contentMode: .fit)
//                                        .frame(maxWidth: 200, maxHeight: 200)
//                                    Text(questions[i])
//                                        .font(.title).bold()
//                                        .padding(.bottom, 30)
//                                    HStack {
//                                        LazyVGrid(columns: columns, spacing: 30) {
//                                            ForEach(answers[i].indices, id: \.self) { j in
//                                                CardsButton(didTap: false, answer: answers[i][j], image: images[i][j], proxy: proxy, questionNumber: i, settingProgress: $settingProgress, totalScrolls: questions.count, doneQuestionaire: $doneQuestionaire)
//                                            }
//                                        }
//                                    }
//                                }
//                                .id("question \(i)")
//                                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
//                                .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
//                                .background(Color.black)
//                                
//                            }
//                            .background(Color.black)
//                        }
//                        .scrollDisabled(true)
//                    }
//                }
//            }
//        }
//        .onAppear(perform: {
//            if doneQuestionaire {
//                dismiss()
//            }
//        })
//        .toolbar(content: {
//            ToolbarItem(placement: .principal) {
//                Text("Questionaire")
//                    .font(.title)
//            }
//        })
//    }
//}
//
//struct CardView: View {
//    let title: String
//    let image: String
//    var body: some View {
//        HStack(alignment: .center) {
//            Image(image)
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(width: 25, height: 25, alignment: .leading)
//                .padding(3)
//                .colorMultiply(.white)
//            Text(title)
//                .font(.title2)
//        }
//    }
//}
//
//extension Color {
//    static var random: Color {
//        return Color(
//            red: .random(in: 0...1),
//            green: .random(in: 0...1),
//            blue: .random(in: 0...1)
//        )
//    }
//}
//
//struct CardsButton: View {
//    @State var didTap:Bool = false
//    @State var answer:String = ""
//    @State var image:String = ""
//    var proxy: ScrollViewProxy
//    var questionNumber: Int
//    @Binding var settingProgress: Double
//    var totalScrolls: Int
//    @Binding var doneQuestionaire: Bool
//    
//    var body: some View {
//        Button(action: {
//            self.didTap = true
//            settingProgress += 0.1
//            
//            Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (_) in
//                withAnimation {
//                    proxy.scrollTo("question \(questionNumber + 1)")
//                    
//                    if questionNumber == totalScrolls - 1 {
//                        settingProgress = 1
//                        doneQuestionaire = true
//                    }
//                }
//            }
//        }) {
//            CardView(title: answer, image: image)
//                .padding(10)
//        }
//        .background(didTap ? Color("AccentColor") : Color.gray)
//        .cornerRadius(22)
//    }
//}
