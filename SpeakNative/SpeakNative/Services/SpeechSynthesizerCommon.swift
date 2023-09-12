//
//  SpeechSynthesizerCommon.swift
//  SpeakNative
//
//  Created by Shekhar.Dora on 02/09/23.
//

import Foundation
import Speech

struct SpeechSynthesizerCommon {
    static let shared = SpeechSynthesizerCommon()
    var speechSynthesizer: AVSpeechSynthesizer?
    private init() {
        speechSynthesizer = AVSpeechSynthesizer()
    }
}

