//
//  Assets.swift
//  EthereumCollection
//
//  Created by Yao Shun-Huai on 2021/3/10.
//

import Foundation

struct Assets: Decodable {
    let assets: [Asset]

    enum CodingKeys: String, CodingKey {
        case assets
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        assets = try container.decodeIfPresent([Asset].self, forKey: .assets) ?? []
    }
}
