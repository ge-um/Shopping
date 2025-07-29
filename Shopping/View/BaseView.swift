//
//  BaseView.swift
//  Shopping
//
//  Created by 금가경 on 7/28/25.
//

import UIKit

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureSubviews()
        configureConstraints()
        configureStyle()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureSubviews() {}
    func configureConstraints() {}
    func configureStyle() {}
}
