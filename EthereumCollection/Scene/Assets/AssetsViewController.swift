//
//  AssetsViewController.swift
//  EthereumCollection
//
//  Created by Yao Shun-Huai on 2021/3/10.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

class AssetsViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(AssetCell.self, forCellWithReuseIdentifier: String(describing: AssetCell.self))
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 47, right: 0)
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.alwaysBounceVertical = true
        cv.delegate = self
        return cv
    }()
    
    private let viewModel: AssetsViewModel
    private let bag = DisposeBag()
    
    init() {
        viewModel = AssetsViewModel()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupViews()
        setupBindings()
    }
    
    private func setupViews() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupBindings() {
        viewModel.output.assetsDriver
            .drive(collectionView.rx.items) { cv, item, asset in
                let cell: AssetCell = cv.dequeueReusableCell(
                    withReuseIdentifier: String(describing: AssetCell.self),
                    for: IndexPath(item: item, section: 0)
                ) as! AssetCell
                cell.configure(with: asset)
                return cell
            }
            .disposed(by: bag)
        
        collectionView.rx.loadMoreVertically
            .bind(to: viewModel.input.loadMoreBinder)
            .disposed(by: bag)
        
        collectionView.rx.itemSelected
            .bind(to: viewModel.input.itemSelectedBinder)
            .disposed(by: bag)
        
        viewModel.output.showCollectionSignal
            .emit(onNext: { [weak self] asset in
                let vc = CollectionViewController(asset: asset)
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: bag)
    }
}

extension AssetsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: GlobalConstants.screenSize.width / 2.0, height: 150)
    }
}
