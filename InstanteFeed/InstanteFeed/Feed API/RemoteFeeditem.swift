//
//  RemoteFeeditem.swift
//  InstanteFeed
//
//  Created by George Solorio on 10/28/23.
//

import Foundation

internal struct RemoteFeedItem: Decodable {
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let image: URL
}
