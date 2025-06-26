//
//  ContentView.swift
//  Praktiki25
//
//  Created by Ivan on 20.6.25..
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var showingProfile = false
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MainView(selectedTab: $selectedTab, showingProfile: $showingProfile)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Главная")
                }
                .tag(0)
            
            ExploreStoriesView(showingProfile: $showingProfile)
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Все истории")
                }
                .tag(1)
            
            CommunityView(showingProfile: $showingProfile)
                .tabItem {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                    Text("Сообщество")
                }
                .tag(2)
        }
        .tint(.blue)
        .sheet(isPresented: $showingProfile) {
            ProfileView()
        }
    }
}

// MARK: - Main View
struct MainView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var themeManager: ThemeManager
    @State private var selectedCategory: Category? = nil
    @Binding var selectedTab: Int
    @Binding var showingProfile: Bool
    
    var filteredStories: [Story] {
        if let selectedCategory = selectedCategory {
            return dataManager.getStories(by: selectedCategory)
        } else {
            return dataManager.stories
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    UniversalHeaderView(
                        title: "Главная",
                        subtitle: "Поиск идей через истории",
                        rightAction: { showingProfile = true },
                        showBadge: false
                    )
                    
                    // Spacer between header and welcome section (96px)
                    Spacer()
                        .frame(height: 96)
                    
                    // Welcome Section
                    WelcomeSection()
                    
                    // Categories
                    CategoriesSection(selectedCategory: $selectedCategory)
                    
                    // Stories Grid
                    StoriesGridView(stories: filteredStories)
                    
                    // Community Discussions Section
                    CommunityDiscussionsSection(selectedTab: $selectedTab)
                }
                .standardScrollPadding()
            }
            .navigationBarHidden(true)
            .background(AppColors.background(themeManager).ignoresSafeArea())
        }
    }
}

// MARK: - Universal Header View
struct UniversalHeaderView: View {
    @EnvironmentObject var themeManager: ThemeManager
    let leftIcon: String
    let leftAction: () -> Void
    let title: String
    let subtitle: String
    let rightIcon: String
    let rightAction: () -> Void
    let showBadge: Bool
    let badgeCount: String
    
    init(
        leftIcon: String = "magnifyingglass",
        leftAction: @escaping () -> Void = {},
        title: String = "PRAKTIKI", 
        subtitle: String,
        rightIcon: String = "person.fill",
        rightAction: @escaping () -> Void = {},
        showBadge: Bool = false,
        badgeCount: String = "3"
    ) {
        self.leftIcon = leftIcon
        self.leftAction = leftAction
        self.title = title
        self.subtitle = subtitle
        self.rightIcon = rightIcon
        self.rightAction = rightAction
        self.showBadge = showBadge
        self.badgeCount = badgeCount
    }
    
    var body: some View {
        HStack {
            // Left Button
            Button(action: leftAction) {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: leftIcon)
                            .foregroundColor(AppColors.primaryText(themeManager))
                            .font(.system(size: 18, weight: .medium))
                    )
            }
            
            Spacer()
            
            // Logo and Description Section
            VStack(spacing: 4) {
                Text("PRAKTIKI")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundColor(AppColors.primaryText(themeManager))
                    .tracking(1.5)
                
                Text(subtitle)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.secondaryText(themeManager))
            }
            
            Spacer()
            
            // Right Button
            Button(action: rightAction) {
                ProfileAvatarView()
                    .frame(width: 44, height: 44)
            }
        }
        .padding(.top, 8)
    }
}

// MARK: - Welcome Section
struct WelcomeSection: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Привет!")
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(AppColors.secondaryText(themeManager))
            
            Text("Давай посмотрим\nлучшие практики")
                .font(.system(size: 40, weight: .medium))
                .foregroundColor(AppColors.primaryText(themeManager))
                .lineLimit(nil)
        }
    }
}

// MARK: - Categories Section
struct CategoriesSection: View {
    @Binding var selectedCategory: Category?
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                // All Stories
                CategoryButton(
                    title: "Все",
                    count: dataManager.stories.count,
                    isSelected: selectedCategory == nil
                ) {
                    selectedCategory = nil
                }
                
                // Categories
                ForEach(dataManager.categories) { category in
                    let count = dataManager.getStories(by: category).count
                    if count > 0 {
                        CategoryButton(
                            title: category.rawValue,
                            count: count,
                            isSelected: selectedCategory == category
                        ) {
                            selectedCategory = category
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.horizontal, -16)
    }
}

// MARK: - Category Button
struct CategoryButton: View {
    @EnvironmentObject var themeManager: ThemeManager
    let title: String
    let count: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                HStack(spacing: 6) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                    
                    Text("\(count)")
                        .font(.system(size: 14, weight: .medium))
                        .opacity(0.7)
                }
                .foregroundColor(isSelected ? 
                    (themeManager.currentTheme == .light ? .black : .white) : 
                    .gray)
                .padding(.vertical, 4)
                
                // Underline for active category
                Rectangle()
                    .fill(isSelected ? 
                        (themeManager.currentTheme == .light ? Color.black : Color.white) : 
                        Color.clear)
                    .frame(height: 1)
            }
        }
    }
}

// MARK: - Stories Grid View
struct StoriesGridView: View {
    let stories: [Story]
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ], spacing: 12) {
            ForEach(Array(stories.prefix(6).enumerated()), id: \.element.id) { index, story in
                NavigationLink(destination: StoryDetailView(story: story)
                    .environmentObject(dataManager)
                    .environmentObject(themeManager)) {
                    StoryCard(story: story)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

// MARK: - Story Card
struct StoryCard: View {
    let story: Story
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 32)
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
                .frame(height: 220)
            
            VStack(alignment: .leading, spacing: 0) {
                // Author info at the top
                HStack {
                    Circle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 32, height: 32)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                        )
                    
                    Text(story.author.name)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                
                Spacer()
                
                // Title in the middle
                Text(story.title)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(.white)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                // Category tag at the bottom
                HStack {
                    Text(story.category.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.white.opacity(0.2))
                        )
                    
                    Spacer()
                }
            }
            .padding(16)
        }
    }
}

// MARK: - Category Color Extension
extension Category {
    var color: Color {
        switch self {
        case .architecture: return Color.blue
        case .design: return Color.purple
        case .technology: return Color.green
        case .business: return Color.orange
        case .art: return Color.pink
        case .community: return Color.red
        case .other: return Color.gray
        }
    }
}

// MARK: - Explore Stories View
struct ExploreStoriesView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var themeManager: ThemeManager
    @State private var selectedCategory: Category? = nil
    @State private var searchText = ""
    @Binding var showingProfile: Bool
    
    var filteredStories: [Story] {
        var stories = dataManager.stories
        
        // Filter by category
        if let selectedCategory = selectedCategory {
            stories = stories.filter { $0.category == selectedCategory }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            stories = stories.filter { 
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.content.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return stories
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    UniversalHeaderView(
                        title: "Все истории",
                        subtitle: "Исследуйте лучшие практики",
                        rightAction: { showingProfile = true },
                        showBadge: true
                    )
                    
                    // Title Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Все истории")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("Исследуйте лучшие практики и находите вдохновение")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    
                    // Categories (styled like main screen)
                    ExploreCategories(selectedCategory: $selectedCategory)
                    
                    // Stories Grid (like main screen)
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12)
                    ], spacing: 12) {
                        ForEach(filteredStories, id: \.id) { story in
                            NavigationLink(destination: StoryDetailView(story: story)
                                .environmentObject(dataManager)
                                .environmentObject(themeManager)) {
                                StoryCard(story: story)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 100)
            }
            .navigationBarHidden(true)
            .background(AppColors.background(themeManager).ignoresSafeArea())
        }
    }
}



// MARK: - Explore Categories
struct ExploreCategories: View {
    @Binding var selectedCategory: Category?
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                // All Stories
                CategoryButton(
                    title: "Все",
                    count: dataManager.stories.count,
                    isSelected: selectedCategory == nil
                ) {
                    selectedCategory = nil
                }
                
                // Categories
                ForEach(dataManager.categories) { category in
                    let count = dataManager.getStories(by: category).count
                    if count > 0 {
                        CategoryButton(
                            title: category.rawValue,
                            count: count,
                            isSelected: selectedCategory == category
                        ) {
                            selectedCategory = category
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.horizontal, -16)
    }
}



// MARK: - Community View
struct CommunityView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var themeManager: ThemeManager
    @State private var selectedSegment = 0 // 0 = Читать, 1 = Начать
    @Binding var showingProfile: Bool
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    UniversalHeaderView(
                        title: "Сообщество",
                        subtitle: "Комната для дискуссий",
                        rightAction: { showingProfile = true },
                        showBadge: false
                    )
                    
                    // Segment Control
                    CommunitySegmentControl(selectedSegment: $selectedSegment)
                    
                    if selectedSegment == 0 {
                        // Читать tab content
                        VStack(alignment: .leading, spacing: 24) {
                            // Spacer between segment control and discussions (48px)
                            Spacer()
                                .frame(height: 48)
                            
                            // Открытые дискуссии (горизонтальные карточки)
                            OpenDiscussionsSection()
                            
                            // Must read секция (как на главном экране)
                            MustReadSection()
                        }
                    } else {
                        // Начать tab content (placeholder)
                        StartDiscussionPlaceholder()
                    }
                }
                .standardScrollPadding()
            }
            .navigationBarHidden(true)
            .background(AppColors.background(themeManager).ignoresSafeArea())
        }
    }
}

// MARK: - Modern Discussion Card
struct ModernDiscussionCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var dataManager: DataManager
    let discussion: Discussion
    
    var body: some View {
        NavigationLink(destination: DiscussionDetailView(discussion: discussion)
            .environmentObject(dataManager)
            .environmentObject(themeManager)) {
            VStack(alignment: .leading, spacing: 16) {
                // Header with category and activity
                HStack {
                    Text(discussion.category.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(discussion.category.color)
                        )
                    
                    Spacer()
                    
                    // Activity indicator
                    HStack(spacing: 4) {
                        Circle()
                            .fill(discussion.isActive ? Color.green : Color.gray)
                            .frame(width: 8, height: 8)
                        
                        Text(AppUtilities.timeAgoString(from: discussion.lastActivity))
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(AppColors.secondaryText(themeManager))
                    }
                }
                
                // Title
                Text(discussion.title)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(AppColors.primaryText(themeManager))
                    .lineLimit(2)
                    .lineSpacing(2)
                
                // Description
                Text(discussion.description)
                    .font(.system(size: 15))
                    .foregroundColor(AppColors.secondaryText(themeManager))
                    .lineLimit(3)
                    .lineSpacing(2)
                
                // Author and stats
                HStack(spacing: 16) {
                    // Author info
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.blue.opacity(0.3))
                            .frame(width: 32, height: 32)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 14))
                                    .foregroundColor(.blue)
                            )
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(discussion.author.name)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(AppColors.primaryText(themeManager))
                            
                            if let bio = discussion.author.bio {
                                Text(bio)
                                    .font(.system(size: 12))
                                    .foregroundColor(AppColors.secondaryText(themeManager))
                                    .lineLimit(1)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // Participants count
                    VStack(alignment: .trailing, spacing: 2) {
                        HStack(spacing: 4) {
                            Image(systemName: "person.2.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.blue)
                            
                            Text("\(discussion.participants)")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(AppColors.primaryText(themeManager))
                        }
                        
                        Text("участников")
                            .font(.system(size: 11))
                            .foregroundColor(AppColors.secondaryText(themeManager))
                    }
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.surfaceBackground(themeManager))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(AppColors.secondaryText(themeManager).opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    

}

// MARK: - Community Discussions Section
struct CommunityDiscussionsSection: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Section header with button
            HStack {
                Text("Сообщество")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(AppColors.primaryText(themeManager))
                
                Spacer()
                
                Button(action: {
                    selectedTab = 2
                }) {
                    Text("Читать все")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.blue)
                }
            }
            
            // Community discussions list
            VStack(spacing: 12) {
                ForEach(Array(dataManager.discussions.prefix(5)), id: \.id) { discussion in
                    CommunityDiscussionRow(discussion: discussion)
                }
            }
        }
        .padding(.top, 24)
    }
}

// MARK: - Discussion Mini Card
struct DiscussionMiniCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var dataManager: DataManager
    let discussion: Discussion
    
    var body: some View {
        NavigationLink(destination: DiscussionDetailView(discussion: discussion)
            .environmentObject(dataManager)
            .environmentObject(themeManager)) {
            VStack(alignment: .leading, spacing: 12) {
                // Category badge
                HStack {
                    Text(discussion.category.rawValue)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(discussion.category.color)
                        )
                    
                    Spacer()
                    
                    // Activity indicator
                    Circle()
                        .fill(Color.green)
                        .frame(width: 8, height: 8)
                }
                
                // Title
                Text(discussion.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppColors.primaryText(themeManager))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                // Description
                Text(discussion.description)
                    .font(.system(size: 13))
                    .foregroundColor(AppColors.secondaryText(themeManager))
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                // Footer info
                HStack(spacing: 8) {
                    // Author avatar
                    Circle()
                        .fill(Color.blue.opacity(0.3))
                        .frame(width: 20, height: 20)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 8))
                                .foregroundColor(.blue)
                        )
                    
                    Text(discussion.author.name)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(AppColors.secondaryText(themeManager))
                    
                    Spacer()
                    
                    // Participants count
                    HStack(spacing: 2) {
                        Image(systemName: "person.2.fill")
                            .font(.system(size: 10))
                            .foregroundColor(AppColors.secondaryText(themeManager))
                        Text("\(discussion.participants)")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(AppColors.secondaryText(themeManager))
                    }
                }
            }
            .padding(16)
            .frame(width: 240, height: 180)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.surfaceBackground(themeManager))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(AppColors.secondaryText(themeManager).opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}



// MARK: - Community Welcome Section
struct CommunityWelcomeSection: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Добро пожаловать!")
                .font(.system(size: 28, weight: .medium))
                .foregroundColor(AppColors.secondaryText(themeManager))
            
            Text("Обсуждайте идеи\nи делитесь опытом")
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(AppColors.primaryText(themeManager))
                .lineLimit(nil)
        }
    }
}

// MARK: - Community Categories
struct CommunityCategories: View {
    @Binding var selectedCategory: Category?
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                // All Discussions
                CategoryButton(
                    title: "Все",
                    count: dataManager.discussions.count,
                    isSelected: selectedCategory == nil
                ) {
                    selectedCategory = nil
                }
                
                // Categories
                ForEach(dataManager.categories) { category in
                    let count = dataManager.discussions.filter { $0.category == category }.count
                    if count > 0 {
                        CategoryButton(
                            title: category.rawValue,
                            count: count,
                            isSelected: selectedCategory == category
                        ) {
                            selectedCategory = category
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.horizontal, -16)
    }
}

// MARK: - New Discussion Button
struct NewDiscussionButton: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Button(action: {
            // Create new discussion
        }) {
            HStack(spacing: 12) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Начать новое обсуждение")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppColors.primaryText(themeManager))
                    
                    Text("Поделитесь своими идеями с сообществом")
                        .font(.system(size: 13))
                        .foregroundColor(AppColors.secondaryText(themeManager))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(AppColors.secondaryText(themeManager))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(AppColors.surfaceBackground(themeManager))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Discussions List View
struct DiscussionsListView: View {
    @EnvironmentObject var themeManager: ThemeManager
    let discussions: [Discussion]
    
    var body: some View {
        LazyVStack(spacing: 16) {
            if discussions.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "bubble.left.and.bubble.right")
                        .font(.system(size: 50))
                        .foregroundColor(AppColors.secondaryText(themeManager).opacity(0.5))
                    
                    Text("Нет обсуждений")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(AppColors.primaryText(themeManager))
                    
                    Text("Начните первое обсуждение в этой категории")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.secondaryText(themeManager))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 60)
            } else {
                ForEach(discussions) { discussion in
                    ModernDiscussionCard(discussion: discussion)
                }
            }
        }
    }
}

// MARK: - Community Segment Control
struct CommunitySegmentControl: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var selectedSegment: Int
    
    var body: some View {
        HStack {
            Spacer()
            
            HStack(spacing: 0) {
                // Читать button
                Button(action: {
                    selectedSegment = 0
                }) {
                    Text("Читать")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(selectedSegment == 0 ? 
                            (themeManager.currentTheme == .light ? .white : .black) :
                            AppColors.secondaryText(themeManager))
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(selectedSegment == 0 ? 
                                    (themeManager.currentTheme == .light ? Color.black : Color.white) :
                                    Color.clear)
                        )
                }
                
                // Начать button
                Button(action: {
                    selectedSegment = 1
                }) {
                    Text("Начать")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(selectedSegment == 1 ? 
                            (themeManager.currentTheme == .light ? .white : .black) :
                            AppColors.secondaryText(themeManager))
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(selectedSegment == 1 ? 
                                    (themeManager.currentTheme == .light ? Color.black : Color.white) :
                                    Color.clear)
                        )
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(themeManager.currentTheme == .light ? 
                        Color.gray.opacity(0.2) : 
                        Color.white.opacity(0.1))
            )
            
            Spacer()
        }
    }
}

// MARK: - Open Discussions Section
struct OpenDiscussionsSection: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Открытые дискуссии")
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(AppColors.primaryText(themeManager))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(dataManager.discussions.prefix(3)), id: \.id) { discussion in
                        HorizontalDiscussionCard(discussion: discussion)
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.horizontal, -16)
        }
    }
}

// MARK: - Horizontal Discussion Card
struct HorizontalDiscussionCard: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var dataManager: DataManager
    let discussion: Discussion
    
    var body: some View {
        NavigationLink(destination: DiscussionDetailView(discussion: discussion)
            .environmentObject(dataManager)
            .environmentObject(themeManager)) {
            ZStack {
                // Gradient background based on category
                RoundedRectangle(cornerRadius: 32)
                    .fill(
                        LinearGradient(
                            colors: [
                                discussion.category.color.opacity(0.7),
                                discussion.category.color.opacity(0.3)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                VStack(alignment: .leading, spacing: 12) {
                    // Author avatar and participants
                    HStack {
                        Circle()
                            .fill(Color.white.opacity(0.3))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16))
                            )
                        
                        Spacer()
                        
                        // Participants count with +
                        Text("+\(discussion.participants)")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.2))
                            )
                    }
                    
                    Spacer()
                    
                    // Title
                    Text(discussion.title)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    // Author name and category
                    VStack(alignment: .leading, spacing: 4) {
                        Text(discussion.author.name)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                        
                        Text(discussion.category.rawValue)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white.opacity(0.2))
                            )
                    }
                }
                .padding(20)
            }
            .frame(width: 240, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 32))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Must Read Section
struct MustReadSection: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Must read")
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(AppColors.primaryText(themeManager))
            
            // Must read discussions list (как на главном экране)
            VStack(spacing: 12) {
                ForEach(Array(dataManager.discussions.suffix(3)), id: \.id) { discussion in
                    CommunityDiscussionRow(discussion: discussion)
                }
            }
        }
    }
}

// MARK: - Start Discussion Placeholder
struct StartDiscussionPlaceholder: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "plus.circle")
                .font(.system(size: 60))
                .foregroundColor(AppColors.secondaryText(themeManager).opacity(0.5))
            
            VStack(spacing: 8) {
                Text("Начать новое обсуждение")
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(AppColors.primaryText(themeManager))
                
                Text("Поделитесь своими идеями с сообществом")
                    .font(.system(size: 16))
                    .foregroundColor(AppColors.secondaryText(themeManager))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 60)
    }
}

// MARK: - Community Discussion Row
struct CommunityDiscussionRow: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var dataManager: DataManager
    let discussion: Discussion
    
    var body: some View {
        NavigationLink(destination: DiscussionDetailView(discussion: discussion)
            .environmentObject(dataManager)
            .environmentObject(themeManager)) {
            HStack(spacing: 16) {
                // Avatar
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "person.circle.fill")
                            .foregroundColor(AppColors.primaryText(themeManager))
                            .font(.system(size: 20, weight: .medium))
                    )
                
                // Discussion info
                VStack(alignment: .leading, spacing: 4) {
                    Text(discussion.title)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(AppColors.primaryText(themeManager))
                        .lineLimit(1)
                    
                    Text(discussion.description)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(AppColors.secondaryText(themeManager))
                        .lineLimit(1)
                }
                
                Spacer()
                
                // Arrow
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(AppColors.primaryText(themeManager))
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 32)
                    .fill(AppColors.surfaceBackground(themeManager))
                    .overlay(
                        RoundedRectangle(cornerRadius: 32)
                            .stroke(AppColors.secondaryText(themeManager).opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Profile Avatar View
struct ProfileAvatarView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Circle()
            .fill(Color.gray.opacity(0.3))
            .overlay(
                Group {
                    if let avatarData = dataManager.currentUser.avatarData,
                       let uiImage = UIImage(data: avatarData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .strokeBorder(Color.white, lineWidth: 2)
                            )
                    } else if let avatar = dataManager.currentUser.avatar {
                        Image(systemName: avatar)
                            .foregroundColor(AppColors.primaryText(themeManager))
                            .font(.system(size: 18, weight: .medium))
                    } else {
                        Image(systemName: "person.fill")
                            .foregroundColor(AppColors.primaryText(themeManager))
                            .font(.system(size: 18, weight: .medium))
                    }
                }
            )
            .overlay(
                Circle()
                    .strokeBorder(Color.white, lineWidth: 2)
            )
    }
}

#Preview {
    ContentView()
        .environmentObject(ThemeManager())
        .environmentObject(DataManager())
}
