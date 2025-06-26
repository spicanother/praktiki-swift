//
//  HelpView.swift
//  Praktiki25
//
//  Created by Ivan on 20.6.25.
//

import SwiftUI
import MessageUI

// MARK: - Help View
struct HelpView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    @State private var showingMailComposer = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background(themeManager)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        VStack(spacing: 16) {
                            Image(systemName: "questionmark.circle.fill")
                                .font(.system(size: 64))
                                .foregroundColor(.blue)
                            
                            VStack(spacing: 8) {
                                Text("Помощь и поддержка")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(AppColors.primaryText(themeManager))
                                
                                Text("Мы всегда готовы помочь!")
                                    .font(.system(size: 16))
                                    .foregroundColor(AppColors.secondaryText(themeManager))
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .padding(.top, 20)
                        
                        // FAQ Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Частые вопросы")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(AppColors.primaryText(themeManager))
                            
                            VStack(spacing: 12) {
                                FAQItem(
                                    question: "Как сохранить историю?",
                                    answer: "Нажмите на иконку закладки в правом верхнем углу истории"
                                )
                                
                                FAQItem(
                                    question: "Как присоединиться к обсуждению?",
                                    answer: "Откройте интересное обсуждение и нажмите 'Присоединиться'"
                                )
                                
                                FAQItem(
                                    question: "Как изменить тему приложения?",
                                    answer: "Перейдите в Профиль → Настройки → Тема приложения"
                                )
                                
                                FAQItem(
                                    question: "Как добавить свою историю?",
                                    answer: "Эта функция появится в следующих обновлениях приложения"
                                )
                            }
                        }
                        
                        // Contact Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Связаться с нами")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(AppColors.primaryText(themeManager))
                            
                            VStack(spacing: 12) {
                                ContactButton(
                                    icon: "envelope.fill",
                                    title: "Написать разработчикам",
                                    subtitle: "Отправить отзыв или сообщить о проблеме",
                                    action: {
                                        if MFMailComposeViewController.canSendMail() {
                                            showingMailComposer = true
                                        } else {
                                            alertMessage = "Почтовый клиент не настроен на вашем устройстве"
                                            showingAlert = true
                                        }
                                    }
                                )
                                
                                ContactButton(
                                    icon: "star.fill",
                                    title: "Оценить приложение",
                                    subtitle: "Поставьте оценку в App Store",
                                    action: {
                                        // В реальном приложении здесь был бы переход в App Store
                                        alertMessage = "Спасибо! Эта функция будет доступна после публикации в App Store"
                                        showingAlert = true
                                    }
                                )
                                
                                ContactButton(
                                    icon: "globe",
                                    title: "Сайт PRAKTIKI",
                                    subtitle: "Посетить наш веб-сайт",
                                    action: {
                                        // В реальном приложении здесь был бы переход на сайт
                                        alertMessage = "Сайт находится в разработке"
                                        showingAlert = true
                                    }
                                )
                            }
                        }
                        
                        // App Info
                        VStack(spacing: 8) {
                            Text("PRAKTIKI")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(AppColors.primaryText(themeManager))
                            
                            Text("Версия 1.0.0")
                                .font(.system(size: 14))
                                .foregroundColor(AppColors.secondaryText(themeManager))
                            
                            Text("© 2025 PRAKTIKI Team")
                                .font(.system(size: 12))
                                .foregroundColor(AppColors.secondaryText(themeManager))
                        }
                        .padding(.top, 24)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 40)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Закрыть") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                }
            }
        }
        .sheet(isPresented: $showingMailComposer) {
            MailComposerView()
        }
        .alert("Информация", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
}

// MARK: - FAQ Item
struct FAQItem: View {
    @EnvironmentObject var themeManager: ThemeManager
    let question: String
    let answer: String
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(question)
                                                        .font(AppFonts.buttonMedium)
                        .foregroundColor(AppColors.primaryText(themeManager))
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.secondaryText(themeManager))
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                Text(answer)
                    .font(.system(size: 15))
                    .foregroundColor(AppColors.secondaryText(themeManager))
                    .lineSpacing(2)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.surfaceBackground(themeManager))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.secondaryText(themeManager).opacity(0.2), lineWidth: 1)
                )
        )
    }
}

// MARK: - Contact Button
struct ContactButton: View {
    @EnvironmentObject var themeManager: ThemeManager
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.blue)
                    .frame(width: 32, height: 32)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(AppFonts.buttonMedium)
                        .foregroundColor(AppColors.primaryText(themeManager))
                    
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.secondaryText(themeManager))
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.secondaryText(themeManager))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(AppColors.surfaceBackground(themeManager))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(AppColors.secondaryText(themeManager).opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Mail Composer View
struct MailComposerView: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = context.coordinator
        
        // Настройка письма
        composer.setSubject("Обратная связь PRAKTIKI")
        composer.setToRecipients(["support@praktiki.com"]) // Замените на ваш email
        
        // Предустановленный текст
        let messageBody = """
        Здравствуйте!
        
        Пишу вам по поводу приложения PRAKTIKI.
        
        Тип обращения: [Отзыв/Ошибка/Предложение]
        
        Описание:
        
        
        ---
        Системная информация:
        Устройство: \(UIDevice.current.model)
        iOS: \(UIDevice.current.systemVersion)
        Версия приложения: 1.0.0
        """
        
        composer.setMessageBody(messageBody, isHTML: false)
        
        return composer
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        let parent: MailComposerView
        
        init(_ parent: MailComposerView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            parent.dismiss()
        }
    }
}

#Preview {
    HelpView()
        .environmentObject(ThemeManager())
} 