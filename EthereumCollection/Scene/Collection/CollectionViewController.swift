//
//  CollectionViewController.swift
//  EthereumCollection
//
//  Created by Yao Shun-Huai on 2021/3/11.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit
import Kingfisher

class CollectionViewController: UIViewController {
    
    private enum Constant {
        static let collectionImageViewLeftAndRightMargin: CGFloat = 25
        static let collectionImageViewWidth: CGFloat = GlobalConstants.screenSize.width - Constant.collectionImageViewLeftAndRightMargin * 2
    }
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        return sv
    }()
    
    private let containerView: UIView = {
        let v = UIView()
        return v
    }()
    
    private let collectionImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let nameLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 18, weight: .semibold)
        lb.textAlignment = .center
        lb.adjustsFontSizeToFitWidth = true
        return lb
    }()
    
    private let descriptionLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 16, weight: .regular)
        lb.textAlignment = .center
        lb.numberOfLines = 0
        return lb
    }()
    
    private let permalinkButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        btn.setTitle("Permalink", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .black
        btn.tintColor = .clear
        btn.layer.cornerRadius = 3.0
        btn.clipsToBounds = true
        return btn
    }()
    
    private let viewModel: CollectionViewModel
    private let bag = DisposeBag()
    
    init(asset: Asset) {
        viewModel = CollectionViewModel(asset: asset)
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
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        containerView.addSubview(collectionImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(descriptionLabel)
        view.addSubview(permalinkButton)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        collectionImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(25)
            $0.left.right.equalToSuperview().inset(Constant.collectionImageViewLeftAndRightMargin)
            $0.height.equalTo(0)
        }
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(collectionImageView.snp.bottom).offset(30)
            $0.left.right.equalToSuperview().inset(25)
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(20)
            $0.left.right.equalToSuperview().inset(25)
            $0.bottom.equalToSuperview().inset(70)
            $0.height.greaterThanOrEqualTo(20)
        }
        permalinkButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(25)
            $0.left.right.equalToSuperview().inset(35)
            $0.height.equalTo(37)
        }
    }
    
    private func setupBindings() {
        viewModel.output.titleDriver
            .drive(onNext: { [weak self] title in
                self?.title = title
            })
            .disposed(by: bag)
        
        viewModel.output.imageURLDriver
            .drive(onNext: { [weak self] url in
                guard let self = self else { return }
                self.collectionImageView.kf.setImage(
                    with: url,
                    options: [.processor(SVGImgProcessor())],
                    completionHandler: { result in
                        switch result {
                        case let .success(image):
                            let resizedHeight = (image.image.size.height / image.image.size.width) * Constant.collectionImageViewWidth
                            self.resizeCollectionImageView(with: resizedHeight)
                        case .failure:
                            break
                        }
                    }
                )
            })
            .disposed(by: bag)
        
        viewModel.output.nameDriver
            .drive(nameLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.output.descriptionDriver
            .drive(descriptionLabel.rx.text)
            .disposed(by: bag)
        
        permalinkButton.rx.tap
            .bind(to: viewModel.input.didPermalinkButtonTapBinder)
            .disposed(by: bag)
        
        viewModel.output.showWebViewSignal
            .emit(onNext: { [weak self] url in
                let vc = WebViewController(url: url)
                vc.modalPresentationStyle = .pageSheet
                self?.present(vc, animated: true)
            })
            .disposed(by: bag)
    }
    
    private func resizeCollectionImageView(with height: CGFloat) {
        collectionImageView.snp.updateConstraints {
            $0.height.equalTo(height)
        }
    }
}
