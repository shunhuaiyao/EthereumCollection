//
//  AssetsViewModel.swift
//  EthereumCollection
//
//  Created by Yao Shun-Huai on 2021/3/10.
//

import RxCocoa
import RxSwift

class AssetsViewModel: ViewModelType {
    struct Input {
        let loadMoreBinder: Binder<Void>
        let itemSelectedBinder: Binder<IndexPath>
    }

    struct Output {
        let assetsDriver: Driver<[Asset]>
        let showCollectionSignal: Signal<Asset>
    }
    
    private(set) lazy var input = Input(
        loadMoreBinder: loadMoreRelay.asBinder(),
        itemSelectedBinder: itemSelectedRelay.asBinder()
    )
    let output: Output

    private let assetsRelay = BehaviorRelay<[Asset]>(value: [])
    private let nextOffsetRelay = BehaviorRelay<Int>(value: 1)
    private let loadMoreRelay = PublishRelay<Void>()
    private let itemSelectedRelay = PublishRelay<IndexPath>()
    private let showCollectionRelay = PublishRelay<Asset>()
    
    private let openSeaService: OpenSeaService
    private let bag = DisposeBag()

    init(openSeaService: OpenSeaService = APIServices.openSea) {
        output = Output(
            assetsDriver: assetsRelay.asDriver(),
            showCollectionSignal: showCollectionRelay.asSignal()
        )
        self.openSeaService = openSeaService
        
        fetchAssets()
            .subscribe(onNext: { [weak self] assets in
                self?.assetsRelay.accept(assets)
            })
            .disposed(by: bag)
        
        itemSelectedRelay
            .withLatestFrom(assetsRelay) { $1[$0.item] }
            .bind(to: showCollectionRelay)
            .disposed(by: bag)
    }
    
    private func fetchAssets() -> Observable<[Asset]> {
        return Observable.merge(
            fetchFirstAssets(),
            loadMoreRelay
                .withLatestFrom(nextOffsetRelay)
                .map { String($0) }
                .flatMapFirst { [weak self] offset -> Observable<[Asset]> in
                    guard let self = self else { return .never() }
                    return self.fetchNextAssets(offset: offset)
                }
        )
    }
    
    private func fetchFirstAssets() -> Observable<[Asset]> {
        return openSeaService.assets(from: GlobalConstants.ownerAddress)
            .map { $0.assets }
            .catchErrorJustReturn([])
            .asObservable()
    }
    
    private func fetchNextAssets(offset: String) -> Observable<[Asset]> {
        return openSeaService.assets(from: GlobalConstants.ownerAddress, offset: offset)
            .map { $0.assets }
            .asObservable()
            .withLatestFrom(assetsRelay) { nextAssets, currentAssets in
                currentAssets + nextAssets
            }
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                let nextOffset = self.nextOffsetRelay.value + 1
                self.nextOffsetRelay.accept(nextOffset)
            })
            .catchError { _ in .never() }
    }
}

