//
//  Kingfisher+SVGProcessor.swift
//  EthereumCollection
//
//  Created by Yao Shun-Huai on 2021/3/11.
//

import Kingfisher
import SVGKit

public struct SVGImgProcessor: ImageProcessor {
    public var identifier: String = ""
    public func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
        switch item {
        case let .image(image):
            return image
        case let .data(data):
            guard let svgImage = SVGKImage(data: data) else {
                return KingfisherWrapper.image(
                    data: data,
                    options: ImageCreatingOptions(
                        scale: 1.0,
                        duration: 0.0,
                        preloadAll: false,
                        onlyFirstFrame: false
                    )
                )
            }
            return svgImage.uiImage
        }
    }
}
