//
//  SpeakNativeTests.swift
//  SpeakNativeTests
//
//  Created by Shekhar.Dora on 11/08/23.
//

import XCTest
@testable import SpeakNative

final class SpeakNativeTests: XCTestCase {
    
    var supportedLanguages: [SwiftGoogleTranslate.Language] = []

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLogin() {
        var shouldEnableLinks = false
        
        let login = LoginHandler(username: "Kavya", password: "Testing@123")
        (shouldEnableLinks, _, _, _) = login.savePasswordToKeychain()
        
        (shouldEnableLinks, _, _, _) = login.retrievePasswordFromKeychain()
        XCTAssertTrue(shouldEnableLinks)
        
        login.password = "WrongPassword"
        (shouldEnableLinks, _, _, _) = login.retrievePasswordFromKeychain()
        XCTAssertFalse(shouldEnableLinks)
    }
    
    func testTranslation() async throws {
        let firstLanguage: String = "en"
        let secondLanguage: String = "German"
        let inputString: String = "Test"
        let expectedOutputString: String = "Prüfen"
        
        self.supportedLanguages = try await SwiftGoogleTranslate.shared.loadLanguagesAsync() ?? []
        if let languageDict: SwiftGoogleTranslate.Language = (self.supportedLanguages.filter { $0.name == secondLanguage }).first {
            let languageCode = languageDict.language
            var recognizedLanguage = "en"
            recognizedLanguage = try! await SwiftGoogleTranslate.shared.detectAsync(inputString)
            
            XCTAssertTrue(firstLanguage == recognizedLanguage)
            let a = try? await SwiftGoogleTranslate.shared.translateAsync(inputString, languageCode, recognizedLanguage)
            XCTAssertTrue(a == expectedOutputString)
        }
    }

}
