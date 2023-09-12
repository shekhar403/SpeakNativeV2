//
//  TranslationWidgetBundle.swift
//  TranslationWidget
//
//  Created by Shekhar.Dora on 08/09/23.
//

import WidgetKit
import SwiftUI

@main
struct TranslationWidgetBundle: WidgetBundle {
    var body: some Widget {
        if #available(macOS 14.0, iOS 17.0, *) {
            TranslationWidget()
        }
    }
}
