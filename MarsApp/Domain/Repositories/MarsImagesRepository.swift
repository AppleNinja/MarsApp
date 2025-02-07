//
//  MarsImagesRepository.swift
//  MarsApp
//
//  Created by Sreekumar on 07/02/2025.
//

import Foundation

protocol MarsImagesRepository {
    func fetchMarsImages() async throws -> [MarsImage]
}
