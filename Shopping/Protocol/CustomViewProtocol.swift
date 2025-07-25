//
//  CustomViewProtocol.swift
//  Shopping
//
//  Created by 금가경 on 7/25/25.
//

import Foundation

@objc protocol CustomViewProtocol {
    func configureSubviews()
    func configureConstraints()
    func configureStyle()
    
    @objc optional func configureInitialData()
    @objc optional func bindActions()
}
