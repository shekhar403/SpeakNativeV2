//
//  CustomLanguagePickerView.swift
//  SpeakNative
//
//  Created by Kavya Rao on 31/08/2023.
//

import SwiftUI

struct CustomLanguagePickerView: View {
    var index: Int = 0
    @Binding var selectedLanguage: String
    @State private var isPickerExpanded = false
    @Binding var selectedIndex: Int
    @State private var image = "checkmark.circle"
    @State var selected: Bool = false
    var isCheckmarkRequired = false
    
    var body: some View {
        HStack {
            if isCheckmarkRequired {
                Button(action: {
                    selected = true
                    selectedIndex = index
                }, label: {
                    if #available(macOS 14.0, iOS 17.0, *) {
                        Image(systemName: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25)
                            .accessibilityLabel("")
                            .accessibilityElement(children: .ignore)
                            .accessibilityValue("")
                    }
                    else {
                        Image(systemName: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25)
                            .accessibilityLabel("")
                            .accessibilityElement(children: .ignore)
                            .accessibilityValue("")
                    }
                })
                .buttonStyle(.borderless)
                .accessibilityValue(selected ? "Selected" : "")
                .accessibilityLabel(index == 0 ? "Select First language" : "Select Second language")
            }
            
            Picker("", selection: $selectedLanguage) {
                ForEach(SwiftGoogleTranslate.shared.supportedLanguages, id: \.language) {
                    Text($0.name).tag($0.name)
                        .dynamicTypeSize(.small ... .large)
                }
            }
            .dynamicTypeSize(.small ... .accessibility2)
            .accessibilityLabel(isCheckmarkRequired ? (index == 0 ? "First language" : "Second language") : "Language")
            .tint(Color("darkWhite"))
            .pickerStyle(.menu)
            #if os(macOS)
            .frame(width: 400)
            #endif
        }
        .onChange(of: selectedIndex, perform: { newValue in
            image = index == selectedIndex ? "checkmark.circle.fill" : "checkmark.circle"
        })
        .onAppear {
            image = selected ? "checkmark.circle.fill" : "checkmark.circle"
        }
    }
}
