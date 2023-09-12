//
//  SpeechToTextService.swift
//  SpeakNative
//
//  Created by Shekhar.Dora on 21/08/23.
//

import Foundation
import Foundation
import Speech


public class SpeechRecognitionManager: NSObject, SFSpeechRecognizerDelegate {
    private var audioEngine: AVAudioEngine!
    private var speechRecognizer: SFSpeechRecognizer!
    private var isAuthorised = false
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var timer: DispatchSourceTimer?
    private var bufferString: String = kBlankString
    static var shared: SpeechRecognitionManager = SpeechRecognitionManager(languageCode: "en-us")
    
    private init(languageCode: String) {
        super.init()
        audioEngine = AVAudioEngine()
        // sets current locale of the systsem
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: languageCode))
        
        if speechRecognizer == nil {
            speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
        }
        
        speechRecognizer.delegate = self
    }
    
    @objc func startRecordingAndRecognition(voiceHandler: @escaping (String) -> ()) {
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest?.shouldReportPartialResults = true
        
        guard let recognitionRequest = self.recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        if let speechRecognizer = self.speechRecognizer {
            self.recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] (result, error) in
                guard let strongSelf = self else { return }
                
                if let result = result {
                    voiceHandler(result.bestTranscription.formattedString)
                    
                    if result.isFinal {
                        voiceHandler(result.bestTranscription.formattedString)
                        strongSelf.audioEngine.stop()
                        strongSelf.audioEngine.inputNode.removeTap(onBus: 0)
                        strongSelf.recognitionRequest = nil
                        
                        strongSelf.recognitionTask = nil
                    }
                }
                
                if let error = error {
                    print("Recognition task error: \(error)")
                }
            }
        }
        
        let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] (buffer, time) in
            self?.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error: \(error)")
        }
    }
    
    @objc func stopRecordingAndRecognition() {
        recognitionRequest?.endAudio()
        audioEngine.stop()
        
        if audioEngine.inputNode.numberOfInputs > 0 {
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        
        recognitionTask?.finish()
        recognitionTask = nil
    }
    
    @objc func isRunning() -> Bool {
        return audioEngine.isRunning
    }
    
    func updateSpeechLanguage(languageCode: String) {
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: languageCode))
    }
    
    func getSupportedLocales() -> [SupportedLanguage] {
        var availableLanguages: [SupportedLanguage] = []
        
        for locale in SFSpeechRecognizer.supportedLocales() {
            let language = SupportedLanguage (
                code: locale.identifier,
                name: Locale.init(identifier: "en").localizedString(forIdentifier: locale.identifier) ?? "Unknown"
            )
            
            availableLanguages.append(language)
        }
        
        return availableLanguages
    }
}

struct SupportedLanguage {
    let code: String
    let name: String
}
