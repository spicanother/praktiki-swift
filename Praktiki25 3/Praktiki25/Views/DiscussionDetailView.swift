//
//  DiscussionDetailView.swift
//  Praktiki25
//
//  Created by Ivan on 20.6.25.
//

import SwiftUI

// MARK: - Discussion Detail View
struct DiscussionDetailView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    
    let discussion: Discussion
    @State private var newMessage = ""
    @State private var showingMessageField = false
    @State private var isJoined = false
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background(themeManager)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Header Section
                        DiscussionHeaderSection(discussion: discussion, isJoined: $isJoined)
                        
                        // Content Section
                        DiscussionContentSection(discussion: discussion)
                        
                        // Participants Section
                        DiscussionParticipantsSection(discussion: discussion)
                        
                        // Messages Section
                        DiscussionMessagesSection(discussion: discussion, showingMessageField: $showingMessageField)
                    }
                }
                .navigationBarHidden(true)
            }
            .overlay(alignment: .bottom) {
                if showingMessageField {
                    MessageInputView(
                        newMessage: $newMessage,
                        showingMessageField: $showingMessageField,
                        onSubmit: {
                            if !newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                dataManager.addMessage(to: discussion, content: newMessage)
                                newMessage = ""
                                showingMessageField = false
                            }
                        }
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                }
            }
        }
    }
}

// MARK: - Discussion Header Section
struct DiscussionHeaderSection: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Environment(\.dismiss) private var dismiss
    let discussion: Discussion
    @Binding var isJoined: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Navigation Bar
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppColors.primaryText(themeManager))
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(AppColors.surfaceBackground(themeManager))
                        )
                }
                
                Spacer()
                
                VStack(spacing: 2) {
                    Text("PRAKTIKI")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(AppColors.primaryText(themeManager))
                    
                    Text("Дискуссия")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(AppColors.secondaryText(themeManager))
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(AppColors.primaryText(themeManager))
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(AppColors.surfaceBackground(themeManager))
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            // Discussion Info
            VStack(alignment: .leading, spacing: 16) {
                // Category and Date
                HStack {
                    Text(discussion.category.rawValue)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(discussion.category.color)
                        )
                    
                    Spacer()
                    
                    Text(AppUtilities.timeAgoString(from: discussion.lastActivity))
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.secondaryText(themeManager))
                }
                
                // Title
                Text(discussion.title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(AppColors.primaryText(themeManager))
                    .lineLimit(nil)
                
                // Author Info
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color.blue.opacity(0.3))
                        .frame(width: 44, height: 44)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.blue)
                        )
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(discussion.author.name)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(AppColors.primaryText(themeManager))
                        
                        if let bio = discussion.author.bio {
                            Text(bio)
                                .font(.system(size: 14))
                                .foregroundColor(AppColors.secondaryText(themeManager))
                        }
                    }
                    
                    Spacer()
                    
                    // Join/Leave Button
                    Button(action: {
                        isJoined.toggle()
                    }) {
                        Text(isJoined ? "Покинуть" : "Присоединиться")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(isJoined ? AppColors.secondaryText(themeManager) : .white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(isJoined ? AppColors.surfaceBackground(themeManager) : Color.blue)
                                    .overlay(
                                        Capsule()
                                            .stroke(isJoined ? AppColors.secondaryText(themeManager).opacity(0.3) : Color.clear, lineWidth: 1)
                                    )
                            )
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
            .padding(.bottom, 24)
        }
    }
    

}

// MARK: - Discussion Content Section
struct DiscussionContentSection: View {
    @EnvironmentObject var themeManager: ThemeManager
    let discussion: Discussion
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(discussion.description)
                .font(.system(size: 16))
                .foregroundColor(AppColors.primaryText(themeManager))
                .lineSpacing(4)
            
            // Activity Stats
            HStack(spacing: 24) {
                HStack(spacing: 6) {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.secondaryText(themeManager))
                    Text("\(discussion.participants) участников")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.secondaryText(themeManager))
                }
                
                HStack(spacing: 6) {
                    Circle()
                        .fill(discussion.isActive ? Color.green : Color.gray)
                        .frame(width: 8, height: 8)
                    Text(discussion.isActive ? "Активно" : "Неактивно")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppColors.secondaryText(themeManager))
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 24)
    }
}

// MARK: - Discussion Participants Section
struct DiscussionParticipantsSection: View {
    @EnvironmentObject var themeManager: ThemeManager
    let discussion: Discussion
    
    // Mock participants data
    private let participants = [
        ("person.fill", "Анна К.", "Дизайнер"),
        ("person.fill", "Михаил Р.", "Разработчик"),
        ("person.fill", "Елена С.", "UX Writer"),
        ("person.fill", "Дмитрий П.", "Product Manager"),
        ("person.fill", "Ольга Н.", "Researcher")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Участники")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(AppColors.primaryText(themeManager))
                .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(participants.prefix(8).enumerated()), id: \.offset) { index, participant in
                        ParticipantCard(
                            iconName: participant.0,
                            name: participant.1,
                            role: participant.2
                        )
                    }
                    
                    if participants.count > 8 {
                        VStack(spacing: 8) {
                            Circle()
                                .fill(AppColors.surfaceBackground(themeManager))
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Text("+\(participants.count - 8)")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(AppColors.secondaryText(themeManager))
                                )
                            
                            Text("Ещё")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(AppColors.secondaryText(themeManager))
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .padding(.bottom, 24)
    }
}

// MARK: - Participant Card
struct ParticipantCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    let iconName: String
    let name: String
    let role: String
    
    var body: some View {
        VStack(spacing: 8) {
            Circle()
                .fill(Color.blue.opacity(0.3))
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: iconName)
                        .font(.system(size: 24))
                        .foregroundColor(.blue)
                )
            
            VStack(spacing: 2) {
                Text(name)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(AppColors.primaryText(themeManager))
                
                Text(role)
                    .font(.system(size: 10))
                    .foregroundColor(AppColors.secondaryText(themeManager))
            }
        }
        .frame(width: 80)
    }
}

// MARK: - Discussion Messages Section
struct DiscussionMessagesSection: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var dataManager: DataManager
    let discussion: Discussion
    @Binding var showingMessageField: Bool
    
    var messages: [DiscussionMessage] {
        return dataManager.getMessages(for: discussion)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Сегодня")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.secondaryText(themeManager))
                    .padding(.horizontal, 16)
                
                Spacer()
            }
            
            ScrollViewReader { proxy in
                LazyVStack(spacing: 16) {
                    ForEach(messages) { message in
                        MessageBubble(message: message)
                            .id(message.id)
                    }
                }
                .onChange(of: messages.count) { _ in
                    if let lastMessage = messages.last {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
            }
            
            // Add Message Button
            if !showingMessageField {
                Button(action: {
                    showingMessageField = true
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)
                        
                        Text("Что думаешь?")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(AppColors.secondaryText(themeManager))
                        
                        Spacer()
                        
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.blue)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(AppColors.surfaceBackground(themeManager))
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(AppColors.secondaryText(themeManager).opacity(0.2), lineWidth: 1)
                            )
                    )
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
        }
        .padding(.bottom, showingMessageField ? 120 : 40)
    }
}

// MARK: - Message Bubble
struct MessageBubble: View {
    @EnvironmentObject var themeManager: ThemeManager
    let message: DiscussionMessage
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Avatar
            Circle()
                .fill(Color.blue.opacity(0.3))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "person.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.blue)
                )
            
            VStack(alignment: .leading, spacing: 8) {
                // Header
                HStack {
                    Text(message.author.name)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppColors.primaryText(themeManager))
                    
                    Text(AppUtilities.timeAgoString(from: message.createdAt))
                        .font(.system(size: 12))
                        .foregroundColor(AppColors.secondaryText(themeManager))
                    
                    Spacer()
                }
                
                // Content
                Text(message.content)
                    .font(.system(size: 15))
                    .foregroundColor(AppColors.primaryText(themeManager))
                    .lineSpacing(2)
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
    

}

// MARK: - Message Input View
struct MessageInputView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var newMessage: String
    @Binding var showingMessageField: Bool
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
                    TextField("Что думаешь?", text: $newMessage, axis: .vertical)
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
                            newMessage = ""
                            showingMessageField = false
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
                        .disabled(newMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
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



#Preview {
    NavigationStack {
        DiscussionDetailView(discussion: Discussion.placeholder)
            .environmentObject(DataManager())
            .environmentObject(ThemeManager())
    }
} 