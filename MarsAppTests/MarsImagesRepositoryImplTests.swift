//
//  MarsImagesRepositoryImplTests.swift
//  MarsAppTests
//
//  Created by Sreekumar on 07/02/2025.
//

import XCTest
@testable import MarsApp

final class MarsImagesRepositoryImplTests: XCTestCase {
    
    func test_fetchMarsImages_SuccessFromNetwork() async throws {
        let mockHTTP = MockHTTPClient(successData: NASAStub.sampleJSON)
        let mockCache = MockLocalCache()
        let repo = MarsImagesRepositoryImpl(httpClient: mockHTTP, localCache: mockCache)
        
        let images = try await repo.fetchMarsImages()
        
        XCTAssertFalse(images.isEmpty)
        XCTAssertFalse(mockCache.savedImages.isEmpty)
    }
    
    func test_fetchMarsImages_NetworkFails_UsesCache() async throws {
        let mockHTTP = MockHTTPClient(errorToThrow: URLError(.badServerResponse))
        let mockCache = MockLocalCache()
        mockCache.savedImages = [
            MarsImage(id: "cached", title: "Cached Title", description: "...", dateCreated: Date(),
                      imageUrl: URL(string: "https://example.com/cached.jpg")!, imageData: nil)
        ]
        let repo = MarsImagesRepositoryImpl(httpClient: mockHTTP, localCache: mockCache)
        
        let images = try await repo.fetchMarsImages()
        
        XCTAssertEqual(images.first?.id, "cached")
    }
    
    func test_fetchMarsImages_NetworkFailsAndCacheEmpty_ThrowsError() async {
        let mockHTTP = MockHTTPClient(errorToThrow: URLError(.badServerResponse))
        let mockCache = MockLocalCache()
        mockCache.savedImages = []
        let repo = MarsImagesRepositoryImpl(httpClient: mockHTTP, localCache: mockCache)
        
        do {
            _ = try await repo.fetchMarsImages()
            XCTFail("Expected to throw error, but got success.")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }
}

class MockHTTPClient: HTTPClient {
    let successData: Data?
    let errorToThrow: Error?
    
    init(successData: Data? = nil, errorToThrow: Error? = nil) {
        self.successData = successData
        self.errorToThrow = errorToThrow
    }
    
    func getData(from url: URL) async throws -> Data {
        if let error = errorToThrow {
            throw error
        }
        return successData ?? Data()
    }
}

class MockLocalCache: LocalCache {
    var savedImages: [MarsImage] = []
    
    func saveMarsImages(_ images: [MarsImage]) {
        savedImages = images
    }
    
    func loadMarsImages() -> [MarsImage] {
        return savedImages
    }
}

// Stub NASA JSON
struct NASAStub {
    static let sampleJSON = """
    {
      "collection": {
        "items": [
          {
            "data": [
              {
                "nasa_id": "TestNasaId",
                "title": "Test Title",
                "description": "Some Description",
                "date_created": "2020-05-20T00:00:00Z"
              }
            ],
            "links": [
              {
                "href": "https://example.com/test.jpg",
                "rel": "preview",
                "render": "image"
              }
            ]
          }
        ]
      }
    }
    """.data(using: .utf8)!
}

