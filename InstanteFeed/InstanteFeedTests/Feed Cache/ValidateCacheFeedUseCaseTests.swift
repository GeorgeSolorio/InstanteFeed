//
//  ValidateCacheFeedUseCaseTests.swift
//  InstanteFeedTests
//
//  Created by George Solorio on 11/5/23.
//

import XCTest
import InstanteFeed

class ValidateCacheFeedUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_validateCache_deletesCacheOnRetrievalError() {
        let (sut, store) = makeSUT()
        
        sut.validateCache()
        store.completeRetrieval(with: anyNSError())
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCacheFeed])
    }
    
    func test_validateCache_doesNotDeleteCacheOnEmptyCache() {
        let (sut, store) = makeSUT()
        
        sut.validateCache()
        store.completeRetrievalWithEmptyCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_validateCache_doesNotDeleteNonExpiredCache() {
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(days: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate})
        
        sut.validateCache()
        store.completeRetrieval(with: feed.local, timestamp: nonExpiredTimestamp)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_validateCache_deletesCacheExpiration() {
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        let expirationTimestamp = fixedCurrentDate.adding(days: -7)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate})
        
        sut.validateCache()
        store.completeRetrieval(with: feed.local, timestamp: expirationTimestamp)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCacheFeed])
    }
    
    func test_load_deletesOnExpiredCache() {
        let feed = uniqueImageFeed()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.adding(days: -7).adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate})
        
        sut.validateCache()
        store.completeRetrieval(with: feed.local, timestamp: expiredTimestamp)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve, .deleteCacheFeed])
    }
    
    func test_validateCache_doesNotDeleteInvalidCacheAfterSUTInstanceHasBeenDeallocated() {
        let store = FeedStoreSpy()
        var sut: LocalFeedLoader? = LocalFeedLoader(store: store, currentDate: Date.init)
        
        sut?.validateCache()
        
        sut = nil
        store.completeRetrieval(with: anyNSError())
    }
    
    // MARK: - Helpers
    
    func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, store)
    }
}
