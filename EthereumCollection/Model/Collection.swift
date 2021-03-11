//
//  Collection.swift
//  EthereumCollection
//
//  Created by Yao Shun-Huai on 2021/3/10.
//

import Foundation

struct Collection: Decodable {
    let name: String

    enum CodingKeys: String, CodingKey {
        case name
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
    }
}
