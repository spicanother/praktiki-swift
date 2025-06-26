//
//  ProfileView.swift
//  Praktiki25
//
//  Created by Ivan on 20.6.25..
//

import SwiftUI

// MARK: - Profile View
struct ProfileView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var themeManager: ThemeManager
    @State private var isEditing = false
    @State private var editedName = ""
    @State private var editedEmail = ""
    @State private var editedBio = ""
    @State private var showingImagePicker = false
    @State private var showingActionSheet = false

    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    ProfileHeaderView(
                        isEditing: $isEditing,
                        showingImagePicker: $showingImagePicker,
                        showingActionSheet: $showingActionSheet
                    )
                    
                    // Profile Info
                    ProfileInfoView(
                        isEditing: $isEditing,
                        editedName: $editedName,
                        editedEmail: $editedEmail,
                        editedBio: $editedBio
                    )
                    
                    // Saved Stories Section
                    SavedStoriesSection()
                    
                    // Settings Section
                    SettingsSection()
                }
                .standardScrollPadding() // Space for tab bar
            }
            .navigationTitle("Профиль")
            .navigationBarTitleDisplayMode(.large)
            .background(AppColors.background(themeManager).ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(isEditing ? "Готово" : "Изменить") {
                        if isEditing {
                            saveProfile()
                        } else {
                            startEditing()
                        }
                        isEditing.toggle()
                    }
                    .fontWeight(.medium)
                }
            }
            .confirmationDialog("Выберите источник", isPresented: $showingActionSheet) {
                Button("Камера") {
                    // Camera action
                }
                Button("Галерея") {
                    showingImagePicker = true
                }
                Button("Отмена", role: .cancel) { }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePickerView { image in
                    // Handle selected image
                    updateProfileImage(image)
                }
            }
        }
    }
    
    private func startEditing() {
        editedName = dataManager.currentUser.name
        editedEmail = dataManager.currentUser.email ?? ""
        editedBio = dataManager.currentUser.bio ?? ""
    }
    
    private func saveProfile() {
        dataManager.currentUser.name = editedName
        dataManager.currentUser.email = editedEmail.isEmpty ? nil : editedEmail
        dataManager.currentUser.bio = editedBio.isEmpty ? nil : editedBio
    }
    
    private func updateProfileImage(_ image: UIImage) {
        // Сжимаем изображение и сохраняем как Data
        if let imageData = AppUtilities.compressImage(image) {
            dataManager.currentUser.avatarData = imageData
            dataManager.currentUser.avatar = nil // Убираем системную иконку
        }
    }
}

// MARK: - Profile Header View
struct ProfileHeaderView: View {
    @EnvironmentObject var dataManager: DataManager
    @Binding var isEditing: Bool
    @Binding var showingImagePicker: Bool
    @Binding var showingActionSheet: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            // Avatar
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.blue, Color.purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                
                if let avatarData = dataManager.currentUser.avatarData,
                   let uiImage = UIImage(data: avatarData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                } else if let avatar = dataManager.currentUser.avatar {
                    Image(systemName: avatar)
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                } else {
                    Image(systemName: "person.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                }
                
                if isEditing {
                    Circle()
                        .fill(Color.black.opacity(0.6))
                        .frame(width: 120, height: 120)
                    
                    Button(action: {
                        showingActionSheet = true
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                            Text("Изменить")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            
            // User Stats
            HStack(spacing: 40) {
                StatView(title: "Историй", value: "\(dataManager.currentUser.savedStories.count)")
                StatView(title: "Лайков", value: AppUtilities.formatLikesCount(156))
                StatView(title: "Подписчики", value: AppUtilities.formatLikesCount(42))
            }
        }
    }
}

// MARK: - Stat View
struct StatView: View {
    @EnvironmentObject var themeManager: ThemeManager
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(AppColors.primaryText(themeManager))
            Text(title)
                .font(.caption)
                .foregroundColor(AppColors.secondaryText(themeManager))
        }
    }
}

// MARK: - Profile Info View
struct ProfileInfoView: View {
    @EnvironmentObject var dataManager: DataManager
    @Binding var isEditing: Bool
    @Binding var editedName: String
    @Binding var editedEmail: String
    @Binding var editedBio: String
    
    var body: some View {
        VStack(spacing: 16) {
            // Name
            ProfileFieldView(
                title: "Имя",
                value: isEditing ? $editedName : .constant(dataManager.currentUser.name),
                isEditing: isEditing,
                placeholder: "Введите имя"
            )
            
            // Email
            ProfileFieldView(
                title: "Email",
                value: isEditing ? $editedEmail : .constant(dataManager.currentUser.email ?? ""),
                isEditing: isEditing,
                placeholder: "Введите email",
                keyboardType: .emailAddress
            )
            
            // Bio
            ProfileFieldView(
                title: "О себе",
                value: isEditing ? $editedBio : .constant(dataManager.currentUser.bio ?? ""),
                isEditing: isEditing,
                placeholder: "Расскажите о себе",
                isMultiline: true
            )
        }
        .padding(.horizontal, 4)
    }
}

// MARK: - Profile Field View
struct ProfileFieldView: View {
    @EnvironmentObject var themeManager: ThemeManager
    let title: String
    @Binding var value: String
    let isEditing: Bool
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    var isMultiline: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(AppColors.primaryText(themeManager))
            
            if isEditing {
                if isMultiline {
                    TextField(placeholder, text: $value, axis: .vertical)
                        .lineLimit(3...6)
                        .padding(12)
                        .background(AppColors.cardBackground(themeManager))
                        .cornerRadius(8)
                        .foregroundColor(AppColors.primaryText(themeManager))
                } else {
                    TextField(placeholder, text: $value)
                        .keyboardType(keyboardType)
                        .padding(12)
                        .background(AppColors.cardBackground(themeManager))
                        .cornerRadius(8)
                        .foregroundColor(AppColors.primaryText(themeManager))
                }
            } else {
                Text(value.isEmpty ? "Не указано" : value)
                    .foregroundColor(value.isEmpty ? AppColors.secondaryText(themeManager) : AppColors.primaryText(themeManager))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 8)
            }
        }
    }
}

// MARK: - Saved Stories Section
struct SavedStoriesSection: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var savedStories: [Story] {
        dataManager.getSavedStories()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Сохраненные истории")
                    .font(.headline)
                    .foregroundColor(AppColors.primaryText(themeManager))
                
                Spacer()
                
                if !savedStories.isEmpty {
                    NavigationLink(destination: SavedStoriesListView()
                        .environmentObject(dataManager)
                        .environmentObject(themeManager)) {
                        Text("Все")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
            }
            
            if savedStories.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "bookmark")
                        .font(.system(size: 40))
                        .foregroundColor(AppColors.secondaryText(themeManager))
                    Text("Пока нет сохраненных историй")
                        .foregroundColor(AppColors.secondaryText(themeManager))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(AppColors.cardBackground(themeManager))
                )
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(savedStories.prefix(5)) { story in
                            NavigationLink(destination: StoryDetailView(story: story)
                                .environmentObject(dataManager)
                                .environmentObject(themeManager)) {
                                SavedStoryCard(story: story)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 4)
                }
            }
        }
    }
}

// MARK: - Saved Story Card
struct SavedStoryCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    let story: Story
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 8)
                .fill(story.category.color.opacity(0.3))
                .frame(width: 120, height: 80)
                .overlay(
                    Image(systemName: story.category.icon)
                        .font(.system(size: 24))
                        .foregroundColor(story.category.color)
                )
            
            Text(story.title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(AppColors.primaryText(themeManager))
                .lineLimit(2)
                .frame(width: 120, alignment: .leading)
        }
    }
}

// MARK: - Settings Section
struct SettingsSection: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showingAbout = false
    @State private var showingThemePicker = false
    @State private var showingHelp = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Настройки")
                .font(.headline)
                .foregroundColor(AppColors.primaryText(themeManager))
            
            VStack(spacing: 12) {
                SettingsRow(
                    icon: "moon.circle.fill",
                    title: "Тема приложения",
                    subtitle: themeManager.currentTheme.rawValue
                ) {
                    showingThemePicker = true
                }
                
                SettingsRow(
                    icon: "bell.circle.fill",
                    title: "Уведомления",
                    subtitle: "Включены"
                ) {
                    // Notifications settings
                }
                
                SettingsRow(
                    icon: "questionmark.circle.fill",
                    title: "Помощь",
                    subtitle: "Часто задаваемые вопросы и поддержка"
                ) {
                    showingHelp = true
                }
                
                SettingsRow(
                    icon: "info.circle.fill",
                    title: "О приложении",
                    subtitle: nil
                ) {
                    showingAbout = true
                }
                
                SettingsRow(
                    icon: "arrow.clockwise.circle.fill",
                    title: "Показать онбординг",
                    subtitle: "Посмотреть введение заново"
                ) {
                    resetOnboarding()
                }
            }
        }
        .sheet(isPresented: $showingAbout) {
            AboutView()
                .environmentObject(themeManager)
        }
        .sheet(isPresented: $showingHelp) {
            HelpView()
                .environmentObject(themeManager)
        }
        .confirmationDialog("Выберите тему", isPresented: $showingThemePicker) {
            ForEach(ThemeManager.AppTheme.allCases, id: \.self) { theme in
                Button(theme.rawValue) {
                    themeManager.setTheme(theme)
                }
            }
            Button("Отмена", role: .cancel) { }
        }
    }
    
    private func resetOnboarding() {
        UserDefaults.standard.set(false, forKey: "isOnboardingCompleted")
        // Restart the app to show onboarding
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = UIHostingController(rootView: 
                OnboardingView(isOnboardingCompleted: .constant(false))
                    .environmentObject(themeManager)
            )
        }
    }
}

// MARK: - Settings Row
struct SettingsRow: View {
    @EnvironmentObject var themeManager: ThemeManager
    let icon: String
    let title: String
    let subtitle: String?
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.blue)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .foregroundColor(AppColors.primaryText(themeManager))
                        .font(.body)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .foregroundColor(AppColors.secondaryText(themeManager))
                            .font(.caption)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.secondaryText(themeManager))
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Image Picker
struct ImagePickerView: UIViewControllerRepresentable {
    let completion: (UIImage) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(completion: completion)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let completion: (UIImage) -> Void
        
        init(completion: @escaping (UIImage) -> Void) {
            self.completion = completion
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                completion(image)
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

// MARK: - Saved Stories List View
struct SavedStoriesListView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var savedStories: [Story] {
        dataManager.getSavedStories()
    }
    
    var body: some View {
        ScrollView {
            if savedStories.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "bookmark")
                        .font(.system(size: 60))
                        .foregroundColor(AppColors.secondaryText(themeManager))
                    
                    Text("Нет сохраненных историй")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(AppColors.primaryText(themeManager))
                    
                    Text("Сохраняйте интересные истории, чтобы читать их позже")
                        .font(.body)
                        .foregroundColor(AppColors.secondaryText(themeManager))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 100)
            } else {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ], spacing: 12) {
                    ForEach(savedStories) { story in
                        NavigationLink(destination: StoryDetailView(story: story)
                            .environmentObject(dataManager)
                            .environmentObject(themeManager)) {
                            SavedStoryDetailCard(story: story)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 100)
            }
        }
        .navigationTitle("Сохраненные истории")
        .navigationBarTitleDisplayMode(.large)
        .background(AppColors.background(themeManager).ignoresSafeArea())
    }
}

// MARK: - Saved Story Detail Card
struct SavedStoryDetailCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    let story: Story
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Category and date
            HStack {
                Text(story.category.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(story.category.color)
                    )
                
                Spacer()
                
                                            Text(AppUtilities.timeAgoString(from: story.createdAt))
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText(themeManager))
            }
            
            // Title
            Text(story.title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(AppColors.primaryText(themeManager))
                .lineLimit(3)
                .multilineTextAlignment(.leading)
            
            // Author
            HStack(spacing: 8) {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 24, height: 24)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.white)
                    )
                
                Text(story.author.name)
                    .font(.caption)
                    .foregroundColor(AppColors.secondaryText(themeManager))
                
                Spacer()
            }
            
            Spacer()
            
            // Stats
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: story.isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 12))
                        .foregroundColor(story.isLiked ? .red : AppColors.secondaryText(themeManager))
                    Text("\(story.likes)")
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText(themeManager))
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "bubble.left")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.secondaryText(themeManager))
                    Text("\(story.comments.count)")
                        .font(.caption)
                        .foregroundColor(AppColors.secondaryText(themeManager))
                }
                
                Spacer()
                
                Image(systemName: "bookmark.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.blue)
            }
        }
        .padding(16)
        .frame(height: 180)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground(themeManager))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(AppColors.secondaryText(themeManager).opacity(0.3), lineWidth: 1)
                )
        )
    }
    

} 
