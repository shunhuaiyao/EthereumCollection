//
//  Relay+AsBinder.swift
//  EthereumCollection
//
//  Created by Yao Shun-Huai on 2021/3/11.
//

import RxCocoa
import RxSwift

extension PublishRelay {
    func asBinder() -> Binder<Element> {
        return Binder<Element>(self) { relay, e in
            relay.accept(e)
        }
    }
}

extension BehaviorRelay {
    func asBinder() -> Binder<Element> {
        return Binder<Element>(self) { relay, e in
            relay.accept(e)
        }
    }
}
