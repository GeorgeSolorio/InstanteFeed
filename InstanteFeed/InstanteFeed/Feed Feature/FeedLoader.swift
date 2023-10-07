//
//  FeedLoader.swift
//  InstanteFeed
//
//  Created by George Solorio on 10/7/23.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
