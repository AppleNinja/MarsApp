//
//  FetchMarsImagesUseCaseTests.swift
//  MarsAppTests
//
//  Created by Sreekumar on 07/02/2025.
//

import XCTest
@testable import MarsApp

final class FetchMarsImagesUseCaseTests: XCTestCase {
    
    func test_execute_ReturnsImagesFromRepository() async throws {
        let mockRepo = MockMarsImagesRepository()
        let useCase = FetchMarsImagesUseCase(repository: mockRepo)
        
        let images = try await useCase.execute()
        
        XCTAssertEqual(images.count, 1)
        XCTAssertEqual(images.first?.title, "Test Title")
    }
    
    func test_execute_ThrowsErrorFromRepository() async {
        let mockRepo = MockMarsImagesRepository(shouldThrow: true)
        let useCase = FetchMarsImagesUseCase(repository: mockRepo)
        
        do {
            let _ = try await useCase.execute()
            XCTFail("Expected error but got success")
        } catch {
            XCTAssertEqual(error as? MockError, MockError.someError)
        }
    }
}

class MockMarsImagesRepository: MarsImagesRepository {
    private let shouldThrow: Bool
    
    init(shouldThrow: Bool = false) {
        self.shouldThrow = shouldThrow
    }
    
    func fetchMarsImages() async throws -> [MarsImage] {
        if shouldThrow {
            throw MockError.someError
        }
        return [
            MarsImage(
                id: "test_id",
                title: "Test Title",
                description: "Test Description",
                dateCreated: Date(),
                imageUrl: URL(string: "https://example.com/test.jpg")!,
                imageData: nil
            )
        ]
    }
}

enum MockError: Error {
    case someError
}

