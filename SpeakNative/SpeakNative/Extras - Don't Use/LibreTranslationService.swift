//
//  LibreTranslationService.swift
//  SpeakNative
//
//  Created by Shekhar.Dora on 18/08/23.
//

import Foundation

class LibreTranslationService {
    static func translate(_ stringToBeTranslated: String, targetLanguageCode: String, sourceLanguageCode: String = "auto", updateText: @escaping (String) -> Void) {
        let url = URL(string: "https://51c6-171-76-87-149.ngrok-free.app/translate")!
        let requestBody: [String: Any] = [
            "q": stringToBeTranslated,
            "source": sourceLanguageCode,
            "target": targetLanguageCode
        ]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            
            // Create request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = jsonData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // Send the request
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                if let data = data {
                    do {
                        // Parse the response JSON
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            if let t = json["translatedText"] as? String {
                                updateText(t)
                            }
                        }
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                }
            }
            
            task.resume()
        } catch {
            print("Error creating JSON data: \(error)")
        }
    }
}
