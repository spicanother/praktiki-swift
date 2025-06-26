//
//  Praktiki25App.swift
//  Praktiki25
//
//  Created by Ivan on 25.6.25..
//

import SwiftUI

@main
struct Praktiki25App: App {
    @StateObject private var themeManager = ThemeManager()
    @StateObject private var dataManager = DataManager()
    @State private var isOnboardingCompleted = UserDefaults.standard.bool(forKey: "isOnboardingCompleted")
    
    var body: some Scene {
        WindowGroup {
            if isOnboardingCompleted {
                ContentView()
                    .environmentObject(themeManager)
                    .environmentObject(dataManager)
                    .preferredColorScheme(themeManager.currentTheme.colorScheme)
            } else {
                OnboardingView(isOnboardingCompleted: $isOnboardingCompleted)
                    .environmentObject(themeManager)
                    .preferredColorScheme(themeManager.currentTheme.colorScheme)
            }
        }
    }
}
