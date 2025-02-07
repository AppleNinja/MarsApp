//
//  HTTPClient.swift
//  MarsApp
//
//  Created by Sreekumar on 07/02/2025.
//

import Foundation

protocol HTTPClient {
    func getData(from url: URL) async throws -> Data
}

class URLSessionHTTPClient: HTTPClient {
    func getData(from url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return data
    }
}
