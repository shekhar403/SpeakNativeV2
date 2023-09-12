//
//  AIImagegenerator.swift
//  SpeakNative
//
//  Created by Shekhar.Dora on 13/08/23.
//

//import Foundation
//
//let apiKey = "00bfe2c8-d36b-43d4-9da5-b9ba85a11b45"
//let apiUrl = "https://api.deepai.org/api/cute-creature-generator"
//
//
//class AIImagegenerator {
//     Example directly sending a text string:
//     don't use unless using paid api key.
//    static func example3() {
//        let text = "Generate an animated image of a tiger in hd quality."
//        var request = URLRequest(url: URL(string: apiUrl)!)
//        request.httpMethod = "POST"
//        request.addValue(apiKey, forHTTPHeaderField: "api-key")
//        request.httpBody = "text=\(text)".data(using: .utf8)
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            if let data = data {
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//                    print(json ?? [:])
//                    
//                } catch {
//                    print(error)
//                }
//            }
//        }
//        task.resume()
//    }
//
//}
