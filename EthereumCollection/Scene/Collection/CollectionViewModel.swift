//
//  CollectionViewModel.swift
//  EthereumCollection
//
//  Created by Yao Shun-Huai on 2021/3/11.
//

import RxCocoa
import RxSwift

class CollectionViewModel: ViewModelType {
    struct Input {
        let didPermalinkButtonTapBinder: Binder<Void>
    }

    struct Output {
        let titleDriver: Driver<String>
        let imageURLDriver: Driver<URL?>
        let nameDriver: Driver<String>
        let descriptionDriver: Driver<String>
        let showWebViewSignal: Signal<URL>
    }
    
    private(set) lazy var input = Input(
        didPermalinkButtonTapBinder: didPermalinkButtonTapRelay.asBinder()
    )
    let output: Output
    
    private let assetRelay: BehaviorRelay<Asset>
    private let didPermalinkButtonTapRelay = PublishRelay<Void>()
    private let showWebViewRelay = PublishRelay<URL>()
    private let bag = DisposeBag()

    init(asset: Asset) {
        assetRelay = BehaviorRelay<Asset>(value: asset)
        output = Output(
            titleDriver: assetRelay.asDriver()
                .map { $0.collectionName },
            imageURLDriver: assetRelay.asDriver()
                .map { $0.imageURL },
            nameDriver: assetRelay.asDriver()
                .map { $0.name },
            descriptionDriver: assetRelay.asDriver()
                .map { $0.description },
            showWebViewSignal: showWebViewRelay.asSignal()
        )
        
        didPermalinkButtonTapRelay
            .withLatestFrom(assetRelay)
            .map { $0.permalink }
            .compactMap { $0 }
            .bind(to: showWebViewRelay)
            .disposed(by: bag)
    }
}


