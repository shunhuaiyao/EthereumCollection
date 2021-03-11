//
//  OpenSeaAPI.swift
//  EthereumCollection
//
//  Created by Yao Shun-Huai on 2021/3/10.
//

import Moya

enum OpenSeaAPI {
    case assets(owner: String, offset: String, limit: String, format: String)
}

extension OpenSeaAPI: OpenSeaTargetType {
    var path: String {
        switch self {
        case .assets:
            return "/api/v1/assets"
        }
    }

    var method: Method {
        switch self {
        case .assets:
            return .get
        }
    }

    var openSeaTask: OpenSeaTask {
        switch self {
        case let .assets(owner, offset, limit, format):
            let params: [String: Any] = [
                "owner": owner,
                "offset": offset,
                "limit": limit,
                "format": format
            ]
            return .requestParameters(params)
        }
    }
}

