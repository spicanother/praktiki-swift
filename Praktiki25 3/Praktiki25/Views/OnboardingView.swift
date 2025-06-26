//
//  OnboardingView.swift
//  Praktiki25
//
//  Created by Ivan on 20.6.25.
//

import SwiftUI

// MARK: - Onboarding Main View
struct OnboardingView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var currentPage = 0
    @Binding var isOnboardingCompleted: Bool
    
    let pages = OnboardingPage.allPages
    
    var body: some View {
        ZStack {
            // Background
            AppColors.background(themeManager)
                .ignoresSafeArea()
            
            VStack {
                // Skip button
                HStack {
                    Spacer()
                    Button("Пропустить") {
                        completeOnboarding()
                    }
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.secondaryText(themeManager))
                    .padding(.trailing, 20)
                    .padding(.top, 16)
                }
                
                // Page content
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                
                // Page indicators and navigation
                VStack(spacing: 24) {
                    // Custom page indicators
                    HStack(spacing: 8) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentPage ? Color.blue : AppColors.secondaryText(themeManager).opacity(0.3))
                                .frame(width: 8, height: 8)
                                .animation(.easeInOut(duration: 0.3), value: currentPage)
                        }
                    }
                    
                    // Navigation buttons
                    HStack(spacing: 16) {
                        if currentPage > 0 {
                            Button(action: {
                                withAnimation {
                                    currentPage -= 1
                                }
                            }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 16, weight: .medium))
                                    Text("Назад")
                                        .font(.system(size: 16, weight: .medium))
                                }
                                .foregroundColor(AppColors.secondaryText(themeManager))
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(AppColors.surfaceBackground(themeManager))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 25)
                                                .stroke(AppColors.secondaryText(themeManager).opacity(0.3), lineWidth: 1)
                                        )
                                )
                            }
                        } else {
                            Spacer()
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            if currentPage < pages.count - 1 {
                                withAnimation {
                                    currentPage += 1
                                }
                            } else {
                                completeOnboarding()
                            }
                        }) {
                            HStack(spacing: 8) {
                                Text(currentPage == pages.count - 1 ? "Начать" : "Далее")
                                    .font(.system(size: 16, weight: .semibold))
                                if currentPage < pages.count - 1 {
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 16, weight: .medium))
                                }
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.blue, Color.blue.opacity(0.8)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 40)
            }
        }
    }
    
    private func completeOnboarding() {
        withAnimation(.easeInOut(duration: 0.5)) {
            isOnboardingCompleted = true
        }
        UserDefaults.standard.set(true, forKey: "isOnboardingCompleted")
    }
}

// MARK: - Onboarding Page View
struct OnboardingPageView: View {
    @EnvironmentObject var themeManager: ThemeManager
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            // Icon/Image section
            ZStack {
                // Background circle with gradient
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                page.accentColor.opacity(0.2),
                                page.accentColor.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 200, height: 200)
                
                // Main icon
                Image(systemName: page.iconName)
                    .font(.system(size: 64, weight: .light))
                    .foregroundColor(page.accentColor)
            }
            
            // Text content
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(AppColors.primaryText(themeManager))
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                
                Text(page.description)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(AppColors.secondaryText(themeManager))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .lineLimit(nil)
                    .padding(.horizontal, 32)
            }
            
            // Features list (if any)
            if !page.features.isEmpty {
                VStack(spacing: 12) {
                    ForEach(page.features, id: \.self) { feature in
                        HStack(spacing: 12) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 16))
                                .foregroundColor(page.accentColor)
                            
                            Text(feature)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(AppColors.primaryText(themeManager))
                            
                            Spacer()
                        }
                        .padding(.horizontal, 48)
                    }
                }
                .padding(.top, 8)
            }
            
            Spacer()
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Onboarding Page Model
struct OnboardingPage {
    let title: String
    let description: String
    let iconName: String
    let accentColor: Color
    let features: [String]
    
    static let allPages: [OnboardingPage] = [
        OnboardingPage(
            title: "Добро пожаловать в PRAKTIKI",
            description: "Платформа для творцов, где рождаются лучшие идеи и практики",
            iconName: "sparkles",
            accentColor: .blue,
            features: []
        ),
        OnboardingPage(
            title: "Делитесь историями",
            description: "Рассказывайте о своем опыте и вдохновляйте других творцов",
            iconName: "text.book.closed",
            accentColor: .purple,
            features: [
                "Создавайте истории",
                "Делитесь опытом",
                "Получайте фидбек"
            ]
        ),
        OnboardingPage(
            title: "Исследуйте практики",
            description: "Находите вдохновение в работах других участников сообщества",
            iconName: "magnifyingglass.circle",
            accentColor: .green,
            features: [
                "Просматривайте практики",
                "Изучайте разное",
                "Сохраняйте интересное"
            ]
        ),
        OnboardingPage(
            title: "Общайтесь",
            description: "Присоединяйтесь к обсуждениям и расширяйте контакты",
            iconName: "person.3.fill",
            accentColor: .orange,
            features: [
                "Участвуйте в дискуссиях",
                "Задавайте вопросы",
                "Находите братву"
            ]
        ),
        OnboardingPage(
            title: "Начните творить",
            description: "Все готово! Пора создавать, делиться и вдохновляться вместе с PRAKTIKI",
            iconName: "rocket.fill",
            accentColor: .pink,
            features: []
        )
    ]
}

#Preview {
    OnboardingView(isOnboardingCompleted: .constant(false))
        .environmentObject(ThemeManager())
} 
