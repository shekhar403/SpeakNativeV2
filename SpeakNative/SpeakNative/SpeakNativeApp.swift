//
//  SpeakNativeApp.swift
//  SpeakNative
//
//  Created by Shekhar.Dora on 11/08/23.
//

import SwiftUI
import TipKit

/// XCode 15 Beta 7, XCode 15 Beta 8 - iOS app
/// Tipkit is not supported for macos app, as it's not stable and causing hang issues in Macos. Don't enable it until it's stable.

@main
struct SpeakNativeApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
#if os(macOS)
            ContentView().environment(\.managedObjectContext,persistenceController.container.viewContext).frame(minWidth: 1500, minHeight: 900)
//                .task {
////                    await configureTipsMacOS()
//                }
#else
            ContentView().environment(\.managedObjectContext,persistenceController.container.viewContext)
#endif
        }
    }
    
    init() {
#if os(macOS)
        
#else
        if #available(iOS 17.0, *) {
            configureTipsIOS()
        }
#endif
    }
    
//    func configureTipsMacOS() async {
//        if #available(macOS 14.0, *) {
//#if DEBUG
//            try? Tips.resetDatastore()
//#endif
//            try? await Tips.setSharedConfiguration([
//                .datastoreLocation(.applicationDefault),
//                .displayFrequency(.immediate)
//            ])
//        }
//    }
    
    func configureTipsIOS() {
        if #available(macOS 14.0, iOS 17.0, *) {
#if DEBUG
            try? Tips.resetDatastore()
#endif
            try? Tips.configure([.datastoreLocation(ApplicationTipConfiguration.storeLocation),
                                 .displayFrequency(ApplicationTipConfiguration.displayFrequency)])
        }
    }
    
    @available(iOS 17.0, *)
    public struct ApplicationTipConfiguration {
        @available(macOS 14.0, *)
        public static var storeLocation: Tips.ConfigurationOption.DatastoreLocation {
            var url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
            url = url.appending(path: "tipstore")
            return .url(url)
        }
        @available(macOS 14.0, *)
        public static var displayFrequency: Tips.ConfigurationOption.DisplayFrequency {
            .immediate // Show all tips as soon as eligible.
        }
    }
}
