//
//  StoryDetailView.swift
//  Praktiki25
//
//  Created by Ivan on 20.6.25..
//

import SwiftUI

// MARK: - Story Detail View
struct StoryDetailView: View {
    let story: Story
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    @State private var newComment = ""
    @State private var showingCommentField = false
    @State private var keyboardHeight: CGFloat = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Hero Image Section
                HeroImageSection(story: story, dismiss: dismiss)
                
                // Content Section
                VStack(alignment: .leading, spacing: 20) {
                    // Story Header
                    StoryHeaderSection(story: story)
                    
                    // Story Content
                    StoryContentSection(story: story)
                    
                    // Action Buttons
                    StoryActionsSection(story: story)
                    
                    // Comments Section
                    CommentsSection(
                        story: story,
                        newComment: $newComment,
                        showingCommentField: $showingCommentField
                    )
                }
                .padding(.horizontal, 16)
                .padding(.bottom, keyboardHeight > 0 ? keyboardHeight + 20 : 100)
            }
        }
        .navigationBarHidden(true)
        .background(AppColors.background(themeManager).ignoresSafeArea())
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                keyboardHeight = keyboardFrame.cgRectValue.height
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            keyboardHeight = 0
        }
    }
}

// MARK: - Hero Image Section
struct HeroImageSection: View {
    let story: Story
    let dismiss: DismissAction
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Hero Image
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            story.category.color.opacity(0.8),
                            story.category.color.opacity(0.4)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 300)
                .overlay(
                    // Pattern overlay for texture
                    Rectangle()
                        .fill(Color.black.opacity(0.1))
                )
            
            // Navigation Header
            HStack {
                Button(action: { dismiss() }) {
                    Circle()
                        .fill(Color.black.opacity(0.3))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                        )
                }
                
                Spacer()
                
                // App Title
                VStack(spacing: 2) {
                    Text("PRAKTIKI")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .tracking(1)
                    
                    Text("История")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                // Share Button
                Button(action: {}) {
                    Circle()
                        .fill(Color.black.opacity(0.3))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 50)
        }
    }
}

// MARK: - Story Header Section
struct StoryHeaderSection: View {
    @EnvironmentObject var themeManager: ThemeManager
    let story: Story
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title
            Text(story.title)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(AppColors.primaryText(themeManager))
                .lineSpacing(4)
            
            // Author and Category Info
            HStack(spacing: 12) {
                // Category badges
                HStack(spacing: 8) {
                    Text(story.category.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(story.category.color)
                        )
                    
                    if !story.tags.isEmpty {
                        ForEach(story.tags.prefix(2), id: \.self) { tag in
                            Text("#\(tag)")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(AppColors.secondaryText(themeManager))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(AppColors.cardBackground(themeManager))
                                )
                        }
                    }
                }
                
                Spacer()
                
                // Date
                Text(AppUtilities.timeAgoString(from: story.createdAt))
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppColors.secondaryText(themeManager))
            }
            
            // Author Section
            AuthorInfoView(author: story.author)
        }
        .padding(.top, 20)
    }
    

}

// MARK: - Author Info View
struct AuthorInfoView: View {
    @EnvironmentObject var themeManager: ThemeManager
    let author: User
    
    var body: some View {
        HStack(spacing: 12) {
            // Author Avatar
            Circle()
                .fill(AppColors.cardBackground(themeManager))
                .frame(width: 44, height: 44)
                .overlay(
                    Group {
                        if let avatarData = author.avatarData,
                           let uiImage = UIImage(data: avatarData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.fill")
                                .font(.system(size: 20))
                                .foregroundColor(AppColors.primaryText(themeManager))
                        }
                    }
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(author.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.primaryText(themeManager))
                
                if let bio = author.bio {
                    Text(bio)
                        .font(.system(size: 13))
                        .foregroundColor(AppColors.secondaryText(themeManager))
                        .lineLimit(1)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.surfaceBackground(themeManager))
        )
    }
}

// MARK: - Story Content Section
struct StoryContentSection: View {
    @EnvironmentObject var themeManager: ThemeManager
    let story: Story
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Может ли сборно-разборное (flat-pack) жильё стать путём к улучшению повседневной городской жизни?")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(AppColors.primaryText(themeManager))
                .lineSpacing(4)
            
            Text(story.content)
                .font(.system(size: 16))
                .foregroundColor(AppColors.secondaryText(themeManager))
                .lineSpacing(6)
            
            // Additional content example
            Text("Мы объединились с архитектурным бюро EFFEKT, чтобы разработать концепцию проектирования, строительства и совместного использования нового поколения городского жилья и районов.")
                .font(.system(size: 16))
                .foregroundColor(AppColors.secondaryText(themeManager))
                .lineSpacing(6)
            
            // Example image placeholder
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColors.cardBackground(themeManager))
                .frame(height: 200)
                .overlay(
                    VStack {
                        Image(systemName: "photo")
                            .font(.system(size: 40))
                            .foregroundColor(AppColors.secondaryText(themeManager))
                        Text("Изображение проекта")
                            .font(.caption)
                            .foregroundColor(AppColors.secondaryText(themeManager))
                    }
                )
        }
    }
}

// MARK: - Story Actions Section
struct StoryActionsSection: View {
    @EnvironmentObject var themeManager: ThemeManager
    let story: Story
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        VStack(spacing: 16) {
            // Stats Row
            HStack(spacing: 24) {
                HStack(spacing: 6) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.red)
                    Text("\(story.likes)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.secondaryText(themeManager))
                }
                
                HStack(spacing: 6) {
                    Image(systemName: "bubble.left.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.blue)
                    Text("\(story.comments.count)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.secondaryText(themeManager))
                }
                
                Spacer()
            }
            
            // Action Buttons
            HStack(spacing: 12) {
                // Like Button
                Button(action: {
                    dataManager.toggleLike(for: story)
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: story.isLiked ? "heart.fill" : "heart")
                            .font(.system(size: 18, weight: .medium))
                        Text("\(story.likes)")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundColor(story.isLiked ? .red : AppColors.primaryText(themeManager))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(story.isLiked ? Color.red.opacity(0.2) : AppColors.cardBackground(themeManager))
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(story.isLiked ? Color.red : AppColors.secondaryText(themeManager).opacity(0.3), lineWidth: 1)
                            )
                    )
                }
                
                // Save Button
                Button(action: {
                    dataManager.toggleSave(for: story)
                }) {
                    Image(systemName: story.isSaved ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(story.isSaved ? .blue : AppColors.primaryText(themeManager))
                        .frame(width: 50, height: 50)
                        .background(
                            Circle()
                                .fill(story.isSaved ? Color.blue.opacity(0.2) : AppColors.cardBackground(themeManager))
                                .overlay(
                                    Circle()
                                        .stroke(story.isSaved ? Color.blue : AppColors.secondaryText(themeManager).opacity(0.3), lineWidth: 1)
                                )
                        )
                }
            }
        }
        .padding(.vertical, 16)
    }
}

// MARK: - Comments Section
struct CommentsSection: View {
    @EnvironmentObject var themeManager: ThemeManager
    let story: Story
    @Binding var newComment: String
    @Binding var showingCommentField: Bool
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Comments Header
            HStack {
                Text("Комментарии (\(story.comments.count))")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(AppColors.primaryText(themeManager))
                
                Spacer()
                
                Button(action: { showingCommentField.toggle() }) {
                    Text("Написать")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.blue)
                }
            }
            
            // Comment Input Field
            if showingCommentField {
                CommentInputView(
                    newComment: $newComment,
                    showingCommentField: $showingCommentField,
                    onSubmit: {
                        if !newComment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            dataManager.addComment(to: story, content: newComment)
                            newComment = ""
                            showingCommentField = false
                        }
                    }
                )
            }
            
            // Comments List
            if story.comments.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "bubble.left")
                        .font(.system(size: 32))
                        .foregroundColor(AppColors.secondaryText(themeManager).opacity(0.5))
                    
                    Text("Пока нет комментариев")
                        .font(.system(size: 16))
                        .foregroundColor(AppColors.secondaryText(themeManager))
                    
                    Text("Будьте первым, кто оставит комментарий")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.secondaryText(themeManager).opacity(0.7))
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                LazyVStack(spacing: 16) {
                    ForEach(story.comments) { comment in
                        CommentView(comment: comment)
                    }
                }
            }
        }
        .padding(.top, 24)
    }
}

// MARK: - Comment Input View
struct CommentInputView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var newComment: String
    @Binding var showingCommentField: Bool
    let onSubmit: () -> Void
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                // User Avatar
                Circle()
                    .fill(Color.blue.opacity(0.3))
                    .frame(width: 36, height: 36)
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.blue)
                    )
                
                // Text Field
                VStack(spacing: 8) {
                    TextField("Что думаешь?", text: $newComment, axis: .vertical)
                        .focused($isTextFieldFocused)
                        .foregroundColor(AppColors.primaryText(themeManager))
                        .font(.system(size: 16))
                        .lineLimit(4, reservesSpace: false)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppColors.cardBackground(themeManager))
                        )
                    
                    // Action Buttons
                    HStack {
                        Button("Отмена") {
                            newComment = ""
                            showingCommentField = false
                            isTextFieldFocused = false
                        }
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.secondaryText(themeManager))
                        
                        Spacer()
                        
                        Button("Отправить") {
                            onSubmit()
                            isTextFieldFocused = false
                        }
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.blue)
                        .disabled(newComment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.surfaceBackground(themeManager))
        )
        .onAppear {
            isTextFieldFocused = true
        }
    }
}

// MARK: - Comment View
struct CommentView: View {
    let comment: Comment
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Author Avatar
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 36, height: 36)
                .overlay(
                    Group {
                        if let avatarData = comment.author.avatarData,
                           let uiImage = UIImage(data: avatarData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                        }
                    }
                )
            
            VStack(alignment: .leading, spacing: 8) {
                // Comment Header
                HStack {
                    Text(comment.author.name)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppColors.primaryText(themeManager))
                    
                    Text("• \(AppUtilities.timeAgoString(from: comment.createdAt))")
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.secondaryText(themeManager))
                    
                    Spacer()
                }
                
                // Comment Content
                Text(comment.content)
                    .font(.system(size: 15))
                    .foregroundColor(AppColors.primaryText(themeManager))
                    .lineSpacing(2)
                
                // Comment Actions
                HStack(spacing: 16) {
                    Button(action: {
                        dataManager.toggleCommentLike(comment: comment)
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: comment.isLiked ? "heart.fill" : "heart")
                                .font(.system(size: 12))
                            
                            if comment.likes > 0 {
                                Text("\(comment.likes)")
                                    .font(.system(size: 12))
                            }
                        }
                        .foregroundColor(comment.isLiked ? .red : AppColors.secondaryText(themeManager))
                    }
                    
                    Button("Ответить") {
                        // Reply functionality
                    }
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppColors.secondaryText(themeManager))
                }
                .padding(.top, 4)
            }
        }
    }
    

}

#Preview {
    NavigationStack {
        StoryDetailView(story: Story.placeholder)
            .environmentObject(DataManager())
            .environmentObject(ThemeManager())
    }
} 
