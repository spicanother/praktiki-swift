//
//  DataModels.swift
//  Praktiki25
//
//  Created by Ivan on 20.6.25..
//

import Foundation

// MARK: - Category
enum Category: String, CaseIterable, Identifiable, Codable {
    case architecture = "Архитектура"
    case design = "Дизайн"
    case technology = "Технологии"
    case business = "Бизнес"
    case art = "Искусство"
    case community = "Сообщество"
    case other = "Другое"
    
    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .architecture: return "building.2"
        case .design: return "paintbrush"
        case .technology: return "laptopcomputer"
        case .business: return "briefcase"
        case .art: return "palette"
        case .community: return "person.3"
        case .other: return "circle.grid.hex"
        }
    }
}

// MARK: - User
struct User: Identifiable, Codable {
    var id = UUID()
    var name: String
    var email: String?
    var avatar: String? // URL или имя системной иконки
    var avatarData: Data? // Для хранения локального изображения
    var bio: String?
    var savedStories: [UUID] = []
    var createdAt: Date = Date()
    
    static let placeholder = User(
        name: "Иван Иванов",
        email: "ivan@example.com",
        avatar: "person.circle.fill",
        bio: "Студент дизайна, увлекаюсь архитектурой и современным искусством"
    )
}

// MARK: - Story
struct Story: Identifiable, Codable {
    var id = UUID()
    var title: String
    var content: String
    var author: User
    var category: Category
    var imageURL: String?
    var likes: Int = 0
    var isLiked: Bool = false
    var isSaved: Bool = false
    var comments: [Comment] = []
    var createdAt: Date = Date()
    var tags: [String] = []
    
    static let placeholder = Story(
        title: "Современная архитектура Москвы",
        content: "Исследование новых тенденций в архитектуре столицы. Как меняется облик города и что влияет на архитектурные решения...",
        author: User.placeholder,
        category: .architecture,
        imageURL: nil,
        likes: 42,
        tags: ["москва", "архитектура", "современность"]
    )
}

// MARK: - Comment
struct Comment: Identifiable, Codable {
    var id = UUID()
    var content: String
    var author: User
    var createdAt: Date = Date()
    var likes: Int = 0
    var isLiked: Bool = false
    
    static let placeholder = Comment(
        content: "Отличная статья! Очень интересная подача материала.",
        author: User.placeholder
    )
}

// MARK: - Discussion
struct Discussion: Identifiable, Codable {
    var id = UUID()
    var title: String
    var description: String
    var author: User
    var category: Category
    var messages: [DiscussionMessage] = []
    var participants: Int = 0
    var createdAt: Date = Date()
    var lastActivity: Date = Date()
    var isActive: Bool = true
    
    static let placeholder = Discussion(
        title: "Что мы знаем о новом обновлении ChatGPT",
        description: "Давайте обсудим новые возможности ChatGPT и как они повлияют на нашу работу",
        author: User.placeholder,
        category: .technology,
        participants: 25
    )
}

// MARK: - Discussion Message
struct DiscussionMessage: Identifiable, Codable {
    var id = UUID()
    var content: String
    var author: User
    var createdAt: Date = Date()
    var isReply: Bool = false
    var replyToMessageId: UUID?
    
    static let placeholder = DiscussionMessage(
        content: "Думаю, минимализм и темные темы будут доминировать. Что думаете?",
        author: User.placeholder
    )
} 
