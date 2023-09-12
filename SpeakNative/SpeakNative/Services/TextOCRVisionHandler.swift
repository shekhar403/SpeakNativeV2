//
//  TextOCRVisionHandler.swift
//  SpeakNative
//
//  Created by Shekhar.Dora on 19/08/23.
//
#if os(iOS)


import Foundation
import AVFoundation
import Vision
import UIKit

class TextOCRVisionHandler {
    static func recognizeText(image: CGImage?, updateResult: @escaping (String) -> Void) {
        guard let cgImage = image else { return }
        
        // Handler
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        // Request
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                return
            }
            
            let text = observations.compactMap({
                $0.topCandidates(1).first?.string
            }).joined(separator: " ")
            
            updateResult(text)
        }
        
        // Process
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }
}

#endif
