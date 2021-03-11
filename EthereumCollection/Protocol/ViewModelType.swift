//
//  ViewModelType.swift
//  EthereumCollection
//
//  Created by Yao Shun-Huai on 2021/3/10.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    var input: Input { get }
    var output: Output { get }
}
