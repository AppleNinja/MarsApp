//
//  GalleryViewModel.swift
//  MarsApp
//
//  Created by Sreekumar on 07/02/2025.
//

import Foundation
import Foundation

class GalleryViewModel {
    
    private(set) var images: [MarsImage] = []
    
    private(set) var isLoading: Bool = false {
        didSet { onLoadingStatusChanged?(isLoading) }
    }
    private(set) var errorMessage: String? = nil {
        didSet { onErrorMessageChanged?(errorMessage) }
    }
    
    var onLoadingStatusChanged: ((Bool) -> Void)?
    var onErrorMessageChanged: ((String?) -> Void)?
    
    private let fetchMarsImagesUseCase: FetchMarsImagesUseCase
    
    init(fetchMarsImagesUseCase: FetchMarsImagesUseCase) {
        self.fetchMarsImagesUseCase = fetchMarsImagesUseCase
    }
    
    func loadMarsImages() {
        isLoading = true
        
        Task {
            do {
                let fetched = try await fetchMarsImagesUseCase.execute()
                self.images = fetched
                self.errorMessage = nil
            } catch {
                self.errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
}

