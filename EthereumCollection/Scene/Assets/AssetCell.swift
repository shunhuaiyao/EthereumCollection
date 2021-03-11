//
//  AssetCell.swift
//  EthereumCollection
//
//  Created by Yao Shun-Huai on 2021/3/11.
//

import Kingfisher
import UIKit

class AssetCell: UICollectionViewCell {

    private let assetImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    private let assetNameLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 16, weight: .regular)
        lb.textAlignment = .center
        lb.adjustsFontSizeToFitWidth = true
        return lb
    }()
    
    private let containerView: UIView = {
        let v = UIView()
        v.layer.borderWidth = 1.5
        v.layer.cornerRadius = 8.0
        v.layer.borderColor = UIColor.black.cgColor
        return v
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(assetImageView)
        containerView.addSubview(assetNameLabel)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
        assetImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(80)
        }
        assetNameLabel.snp.makeConstraints {
            $0.top.equalTo(assetImageView.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(5)
            $0.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(20)
        }
    }

    func configure(with asset: Asset) {
        assetImageView.kf.setImage(with: asset.imageURL, options: [.processor(SVGImgProcessor())])
        assetNameLabel.text = asset.name
    }
}

