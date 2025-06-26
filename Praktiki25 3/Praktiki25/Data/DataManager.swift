//
//  DataManager.swift
//  Praktiki25
//
//  Created by Ivan on 25.6.25..
//

import Foundation

class DataManager: ObservableObject {
    @Published var stories: [Story] = []
    @Published var discussions: [Discussion] = []
    @Published var currentUser: User = User.placeholder
    @Published var categories: [Category] = Category.allCases
    
    init() {
        loadMockData()
    }
    
    // MARK: - Mock Data
    private func loadMockData() {
        loadMockStories()
        loadMockDiscussions()
    }
    
    private func loadMockStories() {
        let mockUsers = [
            User(name: "Анна Смирнова", email: "anna@example.com", avatar: "person.crop.circle.fill", bio: "Архитектор и урбанист"),
            User(name: "Михаил Петров", email: "mikhail@example.com", avatar: "person.crop.circle.fill", bio: "UX/UI дизайнер"),
            User(name: "Елена Козлова", email: "elena@example.com", avatar: "person.crop.circle.fill", bio: "Художник и иллюстратор"),
            User(name: "Игорь Сидоров", email: "igor@example.com", avatar: "person.crop.circle.fill", bio: "Студент архитектуры")
        ]
        
        var story1 = Story(
            title: "Новая архитектура московских парков",
            content: "Исследование современных подходов к проектированию общественных пространств. Как архитекторы создают места для отдыха, учитывая потребности разных групп населения...",
            author: mockUsers[0],
            category: .architecture,
            likes: 128,
            tags: ["архитектура", "парки", "москва", "урбанизм"]
        )
        
        // Add comments to story1
        story1.comments = [
            Comment(
                content: "Отличная статья! Очень актуальная тема для нашего города.",
                author: mockUsers[1]
            ),
            Comment(
                content: "Согласен с автором. Нужно больше внимания уделять инклюзивным решениям в парках.",
                author: mockUsers[3]
            )
        ]
        
        stories = [
            story1,
            Story(
                title: "Принципы минималистичного дизайна",
                content: "Разбираем основы минимализма в цифровом дизайне. Как создавать интерфейсы, которые фокусируют внимание пользователя на главном...",
                author: mockUsers[1],
                category: .design,
                likes: 89,
                tags: ["дизайн", "минимализм", "UI/UX", "интерфейсы"]
            ),
            Story(
                title: "Современное искусство и технологии",
                content: "Как цифровые технологии меняют мир искусства. От NFT до интерактивных инсталляций - обзор современных тенденций...",
                author: mockUsers[2],
                category: .art,
                likes: 67,
                tags: ["искусство", "технологии", "NFT", "цифровое искусство"]
            ),
            Story(
                title: "Стартап-культура в творческих индустриях",
                content: "Анализ того, как принципы стартапов применяются в креативных проектах. Истории успеха и неудач...",
                author: mockUsers[1],
                category: .business,
                likes: 45,
                tags: ["бизнес", "стартапы", "креатив", "предпринимательство"]
            )
        ]
        
        // Add some stories to saved list for testing
        currentUser.savedStories = [stories[0].id, stories[2].id]
        stories[0].isSaved = true
        stories[2].isSaved = true
    }
    
    private func loadMockDiscussions() {
        let mockUsers = [
            User(name: "Дмитрий Волков", email: "dmitry@example.com", avatar: "person.crop.circle.fill", bio: "Product Designer"),
            User(name: "Ольга Иванова", email: "olga@example.com", avatar: "person.crop.circle.fill", bio: "Архитектор интерьеров"),
            User(name: "Анна Смирнова", email: "anna@example.com", avatar: "person.crop.circle.fill", bio: "Архитектор и урбанист")
        ]
        
        var discussion1 = Discussion(
            title: "Будущее удаленной работы для дизайнеров",
            description: "Обсуждаем, как изменилась работа дизайнеров после пандемии и что нас ждет дальше",
            author: mockUsers[0],
            category: .design,
            participants: 23
        )
        
        // Add initial messages to discussion1
        discussion1.messages = [
            DiscussionMessage(
                content: "Я думаю, что удаленная работа навсегда изменила индустрию дизайна. Теперь мы можем работать с командами по всему миру!",
                author: mockUsers[0]
            ),
            DiscussionMessage(
                content: "Согласна! Но есть и минусы - сложнее проводить креативные сессии и мозговые штурмы онлайн.",
                author: mockUsers[1]
            ),
            DiscussionMessage(
                content: "Главное - найти баланс между удаленкой и офисной работой. Гибридная модель кажется оптимальной.",
                author: mockUsers[2]
            )
        ]
        
        var discussion2 = Discussion(
            title: "Устойчивая архитектура: миф или реальность?",
            description: "Говорим о экологических аспектах современного строительства",
            author: mockUsers[1],
            category: .architecture,
            participants: 15
        )
        
        // Add initial messages to discussion2
        discussion2.messages = [
            DiscussionMessage(
                content: "Экологичность в архитектуре - это не просто тренд, а необходимость. Мы должны думать о будущих поколениях.",
                author: mockUsers[1]
            ),
            DiscussionMessage(
                content: "Полностью поддерживаю! Использование переработанных материалов и возобновляемых источников энергии - ключевые аспекты.",
                author: mockUsers[2]
            )
        ]
        
        var discussion3 = Discussion(
            title: "AI в творческих профессиях",
            description: "Как искусственный интеллект влияет на творческие процессы",
            author: mockUsers[0],
            category: .technology,
            participants: 31
        )
        
        // Add initial messages to discussion3
        discussion3.messages = [
            DiscussionMessage(
                content: "ИИ может стать отличным помощником, но никогда не заменит человеческую креативность и эмоции в дизайне.",
                author: mockUsers[0]
            ),
            DiscussionMessage(
                content: "Интересно наблюдать, как AI помогает в генерации идей. Главное - использовать его как инструмент, а не замену творчеству.",
                author: mockUsers[1]
            )
        ]
        
        discussions = [discussion1, discussion2, discussion3]
    }
    
    // MARK: - Actions
    func toggleLike(for story: Story) {
        if let index = stories.firstIndex(where: { $0.id == story.id }) {
            stories[index].isLiked.toggle()
            stories[index].likes += stories[index].isLiked ? 1 : -1
        }
    }
    
    func toggleSave(for story: Story) {
        if let index = stories.firstIndex(where: { $0.id == story.id }) {
            stories[index].isSaved.toggle()
            
            if stories[index].isSaved {
                currentUser.savedStories.append(story.id)
            } else {
                currentUser.savedStories.removeAll { $0 == story.id }
            }
        }
    }
    
    func getSavedStories() -> [Story] {
        return stories.filter { currentUser.savedStories.contains($0.id) }
    }
    
    func getStories(by category: Category) -> [Story] {
        return stories.filter { $0.category == category }
    }
    
    func addComment(to story: Story, content: String) {
        if let index = stories.firstIndex(where: { $0.id == story.id }) {
            let newComment = Comment(
                content: content,
                author: currentUser
            )
            stories[index].comments.append(newComment)
        }
    }
    
    func toggleCommentLike(comment: Comment) {
        // Find the story containing this comment
        for storyIndex in stories.indices {
            if let commentIndex = stories[storyIndex].comments.firstIndex(where: { $0.id == comment.id }) {
                stories[storyIndex].comments[commentIndex].isLiked.toggle()
                stories[storyIndex].comments[commentIndex].likes += stories[storyIndex].comments[commentIndex].isLiked ? 1 : -1
                break
            }
        }
    }
    
    // MARK: - Discussion Actions
    func addMessage(to discussion: Discussion, content: String) {
        if let index = discussions.firstIndex(where: { $0.id == discussion.id }) {
            let newMessage = DiscussionMessage(
                content: content,
                author: currentUser
            )
            discussions[index].messages.append(newMessage)
            discussions[index].lastActivity = Date()
        }
    }
    
    func getMessages(for discussion: Discussion) -> [DiscussionMessage] {
        if let index = discussions.firstIndex(where: { $0.id == discussion.id }) {
            return discussions[index].messages
        }
        return []
    }
} 