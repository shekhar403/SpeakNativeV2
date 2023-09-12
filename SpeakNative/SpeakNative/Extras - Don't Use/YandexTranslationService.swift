//
//  AutoTranslationService.swift
//  SpeakNative
//
//  Created by Shekhar.Dora on 16/08/23.
//

//import Foundation


//let IAM_TOKEN = "<IAM token>"
//let folder_id = "<Folder ID>"
//let target_language = "ru"
//let texts = ["Hello", "World"]
//
//let body: [String: Any] = [
//    "targetLanguageCode": target_language,
//    "texts": texts,
//    "folderId": folder_id
//]
//
//var headers = [String: String]()
//headers["Content-Type"] = "application/json"
//headers["Authorization"] = "Bearer \(IAM_TOKEN)"
//
//let url = URL(string: "https://translate.api.cloud.yandex.net/translate/v2/translate")!
//var request = URLRequest(url: url)
//request.httpMethod = "POST"
//request.allHTTPHeaderFields = headers
//request.httpBody = try? JSONSerialization.data(withJSONObject: body)
//
//let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//    if let error = error {
//        print("Error: \(error)")
//        return
//    }
//    
//    if let data = data {
//        if let responseText = String(data: data, encoding: .utf8) {
//            print(responseText)
//        }
//    }
//}
//
//task.resume()
