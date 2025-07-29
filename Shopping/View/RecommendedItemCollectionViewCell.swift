//
//  RecommendedItemCollectionViewCell.swift
//  Shopping
//
//  Created by 금가경 on 7/29/25.
//

import UIKit

class RecommendedItemCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecommendedItemCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .green
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
