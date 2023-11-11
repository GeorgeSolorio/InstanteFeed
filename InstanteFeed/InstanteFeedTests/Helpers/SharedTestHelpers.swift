//
//  SharedTestHelpers.swift
//  InstanteFeedTests
//
//  Created by George Solorio on 11/5/23.
//

import Foundation

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}
