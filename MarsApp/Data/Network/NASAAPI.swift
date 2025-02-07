//
//  NASAAPI.swift
//  MarsApp
//
//  Created by Sreekumar on 07/02/2025.
//

import Foundation

struct NASAImageSearchResponse: Decodable {
    let collection: NASACollection
}

struct NASACollection: Decodable {
    let items: [NASACollectionItem]
}

struct NASACollectionItem: Decodable {
    let data: [NASADataItem]
    let links: [NASALink]?
}

struct NASADataItem: Decodable {
    let nasa_id: String
    let title: String
    let description: String?
    let date_created: String
}

struct NASALink: Decodable {
    let href: String
    let rel: String
    let render: String
}
