//
//  FetchMarsImagesUseCase.swift
//  MarsApp
//
//  Created by Sreekumar on 07/02/2025.
//

import Foundation

struct FetchMarsImagesUseCase {
    
    private let repository: MarsImagesRepository
    
    init(repository: MarsImagesRepository) {
        self.repository = repository
    }
    
    func execute() async throws -> [MarsImage] {
        return try await repository.fetchMarsImages()
    }
}
