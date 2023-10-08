//
//  FeedItem.swift
//  InstanteFeed
//
//  Created by George Solorio on 10/7/23.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let description: String?
    let location: String?
    let imageURL: URL
}
