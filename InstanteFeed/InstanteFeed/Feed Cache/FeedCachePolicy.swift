//
//  FeedCachePolicy.swift
//  InstanteFeed
//
//  Created by George Solorio on 11/5/23.
//

import Foundation

internal struct FeedCachePolicy {
    private static let calendar = Calendar(identifier: .gregorian)
    
    private static var maxCacheAgeInDays: Int {
        return 7
    }
    
    private init() {}
    
    static func validate(_ timestamp: Date, againts date: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else {
            return false
        }
        
        return date < maxCacheAge
    }
}
