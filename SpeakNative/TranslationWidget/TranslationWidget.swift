//
//  TranslationWidget.swift
//  TranslationWidget
//
//  Created by Shekhar.Dora on 08/09/23.
//

import WidgetKit
import SwiftUI

@available(macOS 14.0, iOS 17.0, *)
struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry(date: Date(), text: "Hello", language: "French", translation: "Bonjour")
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        return SimpleEntry(date: Date(), text: "Hello", language: "French", translation: "Bonjour")
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        let word = LocalDataStore.wordArray.randomElement()!
        let translation = await getTranslationFrom(word: word, languageCode: configuration.selectedLanguage.languageCode)
        
        return Timeline(entries: [SimpleEntry(date: Date(), text: word, language: configuration.selectedLanguage.id, translation: translation)], policy: .never)
    }
    
    func getTranslationFrom(word: String, languageCode: String) async -> String {
       let translation = try? await SwiftGoogleTranslate.shared.translateAsync(word, languageCode, "en")
        
        return translation ?? "na"
    }
}

@available(macOS 14.0, iOS 17.0, *)
struct SimpleEntry: TimelineEntry {
    let date: Date
    let text: String
    let language: String
    let translation: String
}

@available(macOS 14.0, iOS 17.0, *)
struct TranslationWidgetEntryView : View {
    var entry: Provider.Entry
    let refreshAppIntent: RefreshAppIntent = RefreshAppIntent()

    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(LocalDataStore.paleGreen.gradient)
            HStack(alignment: .center) {
                VStack {
                    Image("AppImage")
                        .resizable()
                        .frame(width: 100, height: 100)
                    Text("SpeakNative")
                        .font(.subheadline)
                        .minimumScaleFactor(0.6)
                        .fontWeight(.bold)
                }
                .foregroundStyle(LocalDataStore.darkGreen)
                
                VStack {
                    Spacer()
                    Text("Word Wiz: Translate & Learn")
                        .font(.headline)
                        .minimumScaleFactor(0.6)
                    Spacer()
                    
                    HStack(spacing: 5) {
                        Text("English:")
                        Text(entry.text)
                    }
                    .font(.headline)
                    .fontWeight(.bold)
                    .minimumScaleFactor(0.6)
                    
                    Spacer()
                    
                    HStack(spacing: 5) {
                        Text("\(entry.language):")
                        Text(entry.translation)
                    }
                    .font(.headline)
                    .fontWeight(.bold)
                    .minimumScaleFactor(0.6)
                    
                    Spacer()
                    
                    Button("New Word", intent:refreshAppIntent)
                        .padding(2)
                        .tint(LocalDataStore.darkGreen.gradient)
                        .foregroundStyle(Color.white)
                    Spacer()
                }
                .foregroundStyle(LocalDataStore.darkGreen)
            }
        }
    }
}

@available(macOS 14.0, iOS 17.0, *)
struct TranslationWidget: Widget {
    let kind: String = "TranslationWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            TranslationWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .contentMarginsDisabled()
        .supportedFamilies([.systemMedium])
    }
}
