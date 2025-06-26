//
//  ThemeManager.swift
//  Praktiki25
//
//  Created by Ivan on 25.6.25..
//

import SwiftUI

// MARK: - Theme Manager
class ThemeManager: ObservableObject {
    @Published var currentTheme: AppTheme {
        didSet {
            UserDefaults.standard.set(currentTheme.rawValue, forKey: "selectedTheme")
        }
    }
    
    init() {
        let savedTheme = UserDefaults.standard.string(forKey: "selectedTheme") ?? AppTheme.dark.rawValue
        self.currentTheme = AppTheme(rawValue: savedTheme) ?? .dark
    }
    
    enum AppTheme: String, CaseIterable {
        case light = "Светлая"
        case dark = "Темная"
        case system = "Системная"
        
        var colorScheme: ColorScheme? {
            switch self {
            case .light: return .light
            case .dark: return .dark
            case .system: return nil
            }
        }
        
        var isDark: Bool {
            switch self {
            case .light: return false
            case .dark: return true
            case .system: 
                return UITraitCollection.current.userInterfaceStyle == .dark
            }
        }
    }
    
    func setTheme(_ theme: AppTheme) {
        currentTheme = theme
    }
}

// MARK: - App Colors
struct AppColors {
    static func background(_ themeManager: ThemeManager) -> Color {
        switch themeManager.currentTheme {
        case .light: return .white
        case .dark: return .black
        case .system: return Color(UIColor.systemBackground)
        }
    }
    
    static func cardBackground(_ themeManager: ThemeManager) -> Color {
        switch themeManager.currentTheme {
        case .light: return Color.gray.opacity(0.1)
        case .dark: return Color.gray.opacity(0.2)
        case .system: return Color(UIColor.secondarySystemBackground)
        }
    }
    
    static func primaryText(_ themeManager: ThemeManager) -> Color {
        switch themeManager.currentTheme {
        case .light: return .black
        case .dark: return .white
        case .system: return Color(UIColor.label)
        }
    }
    
    static func secondaryText(_ themeManager: ThemeManager) -> Color {
        switch themeManager.currentTheme {
        case .light: return .gray
        case .dark: return .gray
        case .system: return Color(UIColor.secondaryLabel)
        }
    }
    
    static func surfaceBackground(_ themeManager: ThemeManager) -> Color {
        switch themeManager.currentTheme {
        case .light: return Color(UIColor.secondarySystemBackground)
        case .dark: return Color.gray.opacity(0.15)
        case .system: return Color(UIColor.tertiarySystemBackground)
        }
    }
    
    // Static colors that don't change
    static let accent = Color.blue
    static let success = Color.green
    static let warning = Color.orange
    static let error = Color.red
}

// MARK: - App Fonts
struct AppFonts {
    static let largeTitle = Font.largeTitle.weight(.bold)
    static let title = Font.title.weight(.semibold)
    static let title2 = Font.title2.weight(.medium)
    static let headline = Font.headline.weight(.semibold)
    static let body = Font.body
    static let callout = Font.callout
    static let caption = Font.caption
    static let footnote = Font.footnote
    
    // Custom frequently used fonts
    static let buttonMedium = Font.system(size: 16, weight: .medium)
    static let sectionTitle = Font.system(size: 20, weight: .bold)
    static let cardTitle = Font.system(size: 18, weight: .semibold)
    static let subtitle = Font.system(size: 14, weight: .medium)
    static let timestamp = Font.system(size: 12, weight: .medium)
}

// MARK: - App Spacing
struct AppSpacing {
    static let xxs: CGFloat = 4
    static let xs: CGFloat = 8
    static let s: CGFloat = 12
    static let m: CGFloat = 16
    static let l: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
    
    // Standard horizontal padding used throughout the app
    static let horizontalPadding: CGFloat = 16
    // Standard bottom padding for scrollable content (accounts for tab bar)
    static let bottomScrollPadding: CGFloat = 100
}

// MARK: - App Sizes
struct AppSizes {
    // Standard button sizes
    static let actionButtonSize: CGFloat = 44
    static let smallIconSize: CGFloat = 32
    static let mediumIconSize: CGFloat = 40
    static let largeIconSize: CGFloat = 60
    static let avatarSize: CGFloat = 120
}

// MARK: - App Corner Radius
struct AppCornerRadius {
    static let small: CGFloat = 8
    static let medium: CGFloat = 12
    static let large: CGFloat = 16
    static let xlarge: CGFloat = 24
}

// MARK: - View Extensions
extension View {
    /// Applies standard horizontal padding used throughout the app
    func standardHorizontalPadding() -> some View {
        self.padding(.horizontal, AppSpacing.horizontalPadding)
    }
    
    /// Applies standard bottom padding for scrollable content
    func standardBottomPadding() -> some View {
        self.padding(.bottom, AppSpacing.bottomScrollPadding)
    }
    
    /// Combines standard horizontal and bottom padding for scrollable views
    func standardScrollPadding() -> some View {
        self.standardHorizontalPadding()
            .standardBottomPadding()
    }
    
    /// Applies standard card background style with border
    func standardCardBackground(_ themeManager: ThemeManager) -> some View {
        self.background(
            RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                .fill(AppColors.surfaceBackground(themeManager))
                .overlay(
                    RoundedRectangle(cornerRadius: AppCornerRadius.medium)
                        .stroke(AppColors.secondaryText(themeManager).opacity(0.2), lineWidth: 1)
                )
        )
    }
} 