//
//  AppUtilities.swift
//  Praktiki25
//
//  Created by Ivan on 20.6.25.
//

import Foundation
import UIKit

// MARK: - App Utilities
struct AppUtilities {
    
    // MARK: - Date Formatting
    static func timeAgoString(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "ru")
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    // MARK: - String Utilities
    static func formatParticipantsCount(_ count: Int) -> String {
        switch count {
        case 1:
            return "1 участник"
        case 2...4:
            return "\(count) участника"
        default:
            return "\(count) участников"
        }
    }
    
    static func formatLikesCount(_ count: Int) -> String {
        if count < 1000 {
            return "\(count)"
        } else if count < 1000000 {
            return String(format: "%.1fК", Double(count) / 1000.0)
        } else {
            return String(format: "%.1fМ", Double(count) / 1000000.0)
        }
    }
    
    // MARK: - Image Utilities
    static func compressImage(_ image: UIImage, quality: CGFloat = 0.8) -> Data? {
        return image.jpegData(compressionQuality: quality)
    }
} 