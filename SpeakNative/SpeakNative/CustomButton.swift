//
//  CustomButton.swift
//  SpeakNative
//
//  Created by Kavya Rao on 29/08/2023.
//

import SwiftUI
import TipKit


struct CustomButton: View {
    @State var buttonAction: () -> Void
    @State var buttonImage: String
    @State var buttonTitle: String
    @State var backgroundColor: Color
    
    var body: some View {
        VStack {
            Button(action: buttonAction, label: {
                ZStack {
                    Color.clear
                        .frame(height: 35)
                    HStack {
                        Spacer()
                        Image(systemName: buttonImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 35, height: 35, alignment: .leading)
                            .padding(10)
                            .colorMultiply(.white)
                            .tint(backgroundColor)
                        Text(buttonTitle)
                            .font(.custom("Arial Rounded MT bold", size: 30).bold())
                            .padding(10)
                            .dynamicTypeSize(.small ... .large)
                        Spacer()
                    }
                    .padding(.vertical, 5)
                }
            })
            .buttonStyle(.plain)
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(backgroundColor, lineWidth: 4))
            .padding(10)
            .frame(width: 280)
            .foregroundStyle(backgroundColor)
            .accessibilityElement(children: .combine)
        }
    }
}

@available(macOS 14.0, iOS 17.0, *)
public struct ShowButtonTip: Tip {
    public var idValue: String = ""
    public var titleValue: String = ""
    public var messageValue: String = ""
    
    @Parameter
    static var showTip: Bool = false
    
    public var id: String {
        return idValue
    }
    
    public var title: Text {
        return Text(titleValue)
    }
    
    public var message: Text? {
        return Text(messageValue)
    }
    
    public var image: Image? {
        Image(systemName: "wand.and.stars")
    }
    
//    public var actions: [Action] {
//        [
//
//        ]
//    }
    #if os(iOS)
    public var rules: [Rule] {
        #Rule(Self.$showTip) { $0 == false }
    }
    #endif
    
    public var options: [TipOption] {
        [Tips.MaxDisplayCount(1)]
    }
}
