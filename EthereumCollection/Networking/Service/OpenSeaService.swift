//
//  OpenSeaService.swift
//  EthereumCollection
//
//  Created by Yao Shun-Huai on 2021/3/10.
//

import RxSwift

class OpenSeaService: APIBaseService<OpenSeaAPI> {
    func assets(
        from owner: String,
        offset: String = "0",
        limit: String = "20",
        format: String = "json"
    ) -> Single<Assets> {
        return requestDecoded(
            target: .assets(
                owner: owner,
                offset: offset,
                limit: limit,
                format: format
            )
        )
    }
}
