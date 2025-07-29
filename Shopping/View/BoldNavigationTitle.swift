//
//  BoldNavigationTitle.swift
//  Shopping
//
//  Created by 금가경 on 7/26/25.
//

import Foundation

import UIKit

final class BoldNavigationTitle: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(text: String) {
        super.init(frame: .zero)
        self.text = text
        self.font = .systemFont(ofSize: 18, weight: .black)
        self.textColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

