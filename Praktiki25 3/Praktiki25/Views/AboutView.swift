//
//  AboutView.swift
//  Praktiki25
//
//  Created by Ivan on 20.6.25..
//

import SwiftUI
import MapKit

// MARK: - About View
struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var themeManager: ThemeManager
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 55.693612, longitude: 37.623047),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // App Logo Section
                    AppLogoSection()
                    
                    // Mission Section
                    MissionSection()
                    
                    // Team Section
                    TeamSection()
                    
                    // Location Section
                    LocationSection(region: $region)
                    
                    // Version Section
                    VersionSection()
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 50)
            }
            .background(AppColors.background(themeManager).ignoresSafeArea())
            .navigationTitle("О приложении")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Готово") {
                        dismiss()
                    }
                    .fontWeight(.medium)
                    .foregroundColor(AppColors.primaryText(themeManager))
                }
            }
        }
    }
}

// MARK: - App Logo Section
struct AppLogoSection: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 16) {
            // App Icon
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [Color.blue, Color.purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 80, height: 80)
                .overlay(
                    Text("P")
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                )
            
            VStack(spacing: 4) {
                Text("PRAKTIKI")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundColor(AppColors.primaryText(themeManager))
                
                Text("Практики творчества")
                    .font(.subheadline)
                    .foregroundColor(AppColors.secondaryText(themeManager))
            }
        }
    }
}

// MARK: - Mission Section
struct MissionSection: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Наша миссия")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(AppColors.primaryText(themeManager))
            
            Text("Объединять людей вокруг творчества, вдохновлять на новые идеи и помогать раскрывать потенциал через обмен знаниями и реальными кейсами.")
                .font(.body)
                .foregroundColor(AppColors.secondaryText(themeManager))
                .lineSpacing(4)
            
            // Mission highlights
            VStack(spacing: 12) {
                MissionPoint(icon: "person.3.fill", title: "Объединяем", description: "Людей вокруг творчества")
                MissionPoint(icon: "lightbulb.fill", title: "Вдохновляем", description: "На новые идеи")
                MissionPoint(icon: "chart.line.uptrend.xyaxis", title: "Развиваем", description: "Потенциал через практики")
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.surfaceBackground(themeManager))
        )
    }
}

// MARK: - Mission Point
struct MissionPoint: View {
    @EnvironmentObject var themeManager: ThemeManager
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(AppColors.primaryText(themeManager))
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(AppColors.secondaryText(themeManager))
            }
            
            Spacer()
        }
    }
}

// MARK: - Team Section
struct TeamSection: View {
    @EnvironmentObject var themeManager: ThemeManager
    let teamMembers = [
        TeamMember(name: "Юля", role: "Студент 1", avatar: "person.crop.circle.fill", color: .pink),
        TeamMember(name: "Диана", role: "Студент 2", avatar: "person.crop.circle.fill", color: .purple),
        TeamMember(name: "Ваня", role: "Студент 3", avatar: "person.crop.circle.fill", color: .blue)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Наша команда")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(AppColors.primaryText(themeManager))
            
            VStack(spacing: 12) {
                ForEach(teamMembers, id: \.name) { member in
                    TeamMemberRow(member: member)
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.surfaceBackground(themeManager))
        )
    }
}

// MARK: - Team Member
struct TeamMember {
    let name: String
    let role: String
    let avatar: String
    let color: Color
}

// MARK: - Team Member Row
struct TeamMemberRow: View {
    @EnvironmentObject var themeManager: ThemeManager
    let member: TeamMember
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(member.color.opacity(0.2))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: member.avatar)
                        .font(.system(size: 20))
                        .foregroundColor(member.color)
                )
            
            VStack(alignment: .leading, spacing: 2) {
                Text(member.name)
                    .font(.headline)
                    .foregroundColor(AppColors.primaryText(themeManager))
                
                Text(member.role)
                    .font(.subheadline)
                    .foregroundColor(AppColors.secondaryText(themeManager))
            }
            
            Spacer()
        }
    }
}

// MARK: - Location Section
struct LocationSection: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Binding var region: MKCoordinateRegion
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Наше местоположение")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(AppColors.primaryText(themeManager))
            
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    Image(systemName: "location.fill")
                        .foregroundColor(.red)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("НИУ ВШЭ, Школа дизайна")
                            .font(.headline)
                            .foregroundColor(AppColors.primaryText(themeManager))
                        
                        Text("Москва, Малая Пионерская улица, 12\nметро «Павелецкая»")
                            .font(.subheadline)
                            .foregroundColor(AppColors.secondaryText(themeManager))
                    }
                    
                    Spacer()
                }
                
                // Map
                MapViewRepresentable()
                    .frame(height: 200)
                    .cornerRadius(12)
                
                // Open Maps button
                Button(action: {
                    openInMaps()
                }) {
                    HStack {
                        Image(systemName: "map.fill")
                        Text("Открыть в Картах")
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.blue)
                    )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColors.surfaceBackground(themeManager))
        )
    }
    
    private func openInMaps() {
        let coordinate = CLLocationCoordinate2D(latitude: 55.693612, longitude: 37.623047)
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "НИУ ВШЭ, Школа дизайна"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }
}

// MARK: - Location Annotation
struct LocationAnnotation: Identifiable {
    let id = UUID()
    let name = "НИУ ВШЭ, Школа дизайна"
    let coordinate = CLLocationCoordinate2D(latitude: 55.693612, longitude: 37.623047)
}

// MARK: - Map View Representable
struct MapViewRepresentable: UIViewRepresentable {
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        
        // Set up the map
        let coordinate = CLLocationCoordinate2D(latitude: 55.693612, longitude: 37.623047)
        let region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        mapView.setRegion(region, animated: false)
        
        // Add annotation
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "НИУ ВШЭ, Школа дизайна"
        annotation.subtitle = "Москва, Малая Пионерская улица, 12, метро «Павелецкая»"
        mapView.addAnnotation(annotation)
        
        // Disable user interaction to prevent scrolling conflicts
        mapView.isUserInteractionEnabled = true
        mapView.isScrollEnabled = true
        mapView.isZoomEnabled = true
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // No updates needed
    }
}

// MARK: - Version Section
struct VersionSection: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Версия 1.0.0")
                .font(.footnote)
                .foregroundColor(AppColors.secondaryText(themeManager))
            
            Text("© 2025 PRAKTIKI. Сделано с ❤️")
                .font(.footnote)
                .foregroundColor(AppColors.secondaryText(themeManager))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
} 
