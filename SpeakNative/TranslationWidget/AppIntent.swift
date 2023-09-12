//
//  AppIntent.swift
//  TranslationWidget
//
//  Created by Shekhar.Dora on 08/09/23.
//

import WidgetKit
import AppIntents

@available(macOS 14.0, iOS 17.0, *)
struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Widget Configuration"
    static var description = IntentDescription("This is a widget configuration intent.")

    @Parameter(title: "Selected Language")
    var selectedLanguage: WidgetLanguage
    
    init(selectedLanguage: WidgetLanguage) {
        self.selectedLanguage = selectedLanguage
    }
    
    init() {
        self.selectedLanguage = WidgetLanguage(id: "af", languageCode: "Afrikaans")
    }
}

@available(macOS 14.0, iOS 17.0, *)
struct WidgetLanguage: AppEntity {
    var id: String
    var languageCode: String
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Widget Language"
    static var defaultQuery = WidgetLanguageQuery()
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(id)")
    }
    
    static let allLanguages: [WidgetLanguage] = SwiftGoogleTranslate.shared.supportedLanguages.map { lang in
        WidgetLanguage(id: lang.name, languageCode: lang.language)
    }
}

@available(macOS 14.0, iOS 17.0, *)
struct WidgetLanguageQuery: EntityQuery {
    
    func entities(for identifiers: [WidgetLanguage.ID]) async throws -> [WidgetLanguage] {
        let languages =  try? await suggestedEntities()
        
        return (languages?.filter { lang in
            identifiers.contains(lang.id)
        }) ??  (WidgetLanguage.allLanguages.filter { lang in
            identifiers.contains(lang.id)
        })
    }
    
    func defaultResult() async -> WidgetLanguage? {
        try? await suggestedEntities().first
    }
    
    func suggestedEntities() async throws -> [WidgetLanguage] {
        let languages = try? await SwiftGoogleTranslate.shared.loadLanguagesAsync()
        let widgetLanguages = languages?.map { lang in
            WidgetLanguage(id: lang.name, languageCode: lang.language)
        }
        
        return widgetLanguages ?? WidgetLanguage.allLanguages
    }
}

@available(macOS 14.0, iOS 17.0, *)
struct RefreshAppIntent: AppIntent {
    static var title: LocalizedStringResource = "Refresh"
    static var description = IntentDescription("This is a refresh widget intent.")
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
}

