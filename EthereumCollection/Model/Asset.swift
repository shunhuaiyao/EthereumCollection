//
//  Asset.swift
//  EthereumCollection
//
//  Created by Yao Shun-Huai on 2021/3/10.
//

import Foundation

struct Asset: Decodable {
    let name: String
    let imageURL: URL?
    let collectionName: String
    let description: String
    let permalink: URL?
    private let collection: Collection?

    enum CodingKeys: String, CodingKey {
        case name
        case imageURL = "imageUrl"
        case collection
        case description
        case permalink
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        imageURL = try container.decodeIfPresent(URL.self, forKey: .imageURL)
        collection = try container.decodeIfPresent(Collection.self, forKey: .collection)
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        permalink = try container.decodeIfPresent(URL.self, forKey: .permalink)
        if let collectionName = collection?.name {
            self.collectionName = collectionName
        } else {
            collectionName = ""
        }
    }
}
