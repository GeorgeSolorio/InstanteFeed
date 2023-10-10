//
//  FeedLoader.swift
//  InstanteFeed
//
//  Created by George Solorio on 10/7/23.
//

import Foundation

public enum LoadFeedResult{
    case success([FeedItem])
    case failure(Error)
}


public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
