//
//  ItemView.swift
//  Shopping
//
//  Created by 금가경 on 7/26/25.
//

import SnapKit
import UIKit

final class ItemCollectionViewCell: UICollectionViewCell {
    static let identifier = "ItemCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .blue
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
