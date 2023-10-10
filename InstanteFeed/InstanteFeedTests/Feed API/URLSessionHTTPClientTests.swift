//
//  URLSessionHTTPClientTests.swift
//  InstanteFeedTests
//
//  Created by George Solorio on 10/10/23.
//

import XCTest
import InstanteFeed

class URLSessionHTTPClient {
    
    let session: URLSession
    
    init(session: URLSession) {
        self.session = session
    }
    
    public func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url) { _, _, error in
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
}

class URLSessionHTTPClientTests: XCTestCase {
    
    func test_getFromURL_resumesDataTaskWithURL() {
        let url = URL(string: "http://any-url.com")!
        let session = URLSessionSpy()
        let task = URLDataTaskSpy()
        session.stub(url: url, task: task)
        
        let sut = URLSessionHTTPClient(session: session)
        sut.get(from: url) { _ in }
        
        XCTAssertEqual(task.resumeCallCount, 1)
    }
    
    func test_getFromURL_failsOnError() {
        let url = URL(string: "http://any-url.com")!
        let expectedError = NSError(domain: "any error", code: 1)
        let session = URLSessionSpy()
        let task = URLDataTaskSpy()
        session.stub(url: url, error: expectedError)
        
        let sut = URLSessionHTTPClient(session: session)
        
        let exp = expectation(description: "Wait for completion")
        sut.get(from: url) { result in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertEqual(receivedError.domain, expectedError.domain)
                XCTAssertEqual(receivedError.code, expectedError.code)
            default:
                XCTFail("Expected failure with error \(expectedError), got \(result) instead")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    
    // MARK: - Helpers
    private class URLSessionSpy: URLSession {
        private var stubs = [URL: Stub]()
        
        private struct Stub {
            let task: URLSessionDataTask
            let error: Error?
        }
        
        override init() { }
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            guard let stub = stubs[url] else {
                fatalError("Couldn't find stub for \(url)")
            }
            
            completionHandler(nil, nil, stub.error)
            return stub.task
        }
        
        func stub(url: URL, task: URLSessionDataTask = FakeDataTask(), error: Error? = nil) {
            stubs[url] = Stub(task: task, error: error)
        }
    }
    
    private class FakeDataTask: URLSessionDataTask {
        override init() { }
        
        override func resume() { }
    }
    
    private class URLDataTaskSpy: URLSessionDataTask {
        var resumeCallCount = 0
        
        override func resume() {
            resumeCallCount += 1
        }
        
        override init() { }
    }
}
