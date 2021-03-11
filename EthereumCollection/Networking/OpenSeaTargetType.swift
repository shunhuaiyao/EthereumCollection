//
//  OpenSeaTargetType.swift
//  EthereumCollection
//
//  Created by Yao Shun-Huai on 2021/3/10.
//

import Moya

enum OpenSeaTask {
    case requestParameters(_ parameters: [String: Any])
}

protocol OpenSeaTargetType: TargetType {
    var openSeaTask: OpenSeaTask { get }
}

extension OpenSeaTargetType {
    var baseURL: URL {
        return URL(string: "https://api.opensea.io")!
    }
    
    var headers: [String : String]? {
        nil
    }
    
    var task: Task {
        switch openSeaTask {
        case let .requestParameters(parameters):
            let encoding: ParameterEncoding
            switch method {
            case .post, .patch, .delete, .put:
                encoding = JSONEncoding.default
            default:
                encoding = URLEncoding.default
            }
            return .requestParameters(parameters: parameters, encoding: encoding)
        }
    }
    
    var sampleData: Data {
        Data()
    }
}
