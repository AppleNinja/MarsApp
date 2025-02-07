//
//  MarsImagesRepositoryImpl.swift
//  MarsApp
//
//  Created by Sreekumar on 07/02/2025.
//

import Foundation

class MarsImagesRepositoryImpl: MarsImagesRepository {
    
    private let httpClient: HTTPClient
    private let localCache: LocalCache
    private let endpoint = URL(string: "https://images-api.nasa.gov/search?q=mars&media_type=image")!
    
    init(httpClient: HTTPClient, localCache: LocalCache) {
        self.httpClient = httpClient
        self.localCache = localCache
    }
    
    func fetchMarsImages() async throws -> [MarsImage] {
        do {
            let data = try await httpClient.getData(from: endpoint)
            let decoded = try JSONDecoder().decode(NASAImageSearchResponse.self, from: data)
            
            let domainImages = decoded.collection.items.compactMap { item -> MarsImage? in
                guard let link = item.links?.first?.href,
                      let url = URL(string: link),
                      let dataItem = item.data.first else {
                    return nil
                }
                
                let isoFormatter = ISO8601DateFormatter()
                guard let date = isoFormatter.date(from: dataItem.date_created) else {
                    return nil
                }
                
                return MarsImage(
                    id: dataItem.nasa_id,
                    title: dataItem.title,
                    description: dataItem.description ?? "",
                    dateCreated: date,
                    imageUrl: url,
                    imageData: nil
                )
            }
            
            localCache.saveMarsImages(domainImages)
            
            return domainImages
            
        } catch {
            let cachedImages = localCache.loadMarsImages()
            if !cachedImages.isEmpty {
                return cachedImages
            } else {
                throw error
            }
        }
    }
}

