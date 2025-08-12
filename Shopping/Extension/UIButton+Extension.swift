//
//  UIButton+Extension.swift
//  Shopping
//
//  Created by 금가경 on 8/12/25.
//

import UIKit

extension UIButton {
    static func makeButton(title: String) -> UIButton {
        let button = UIButton()
        
        var config = UIButton.Configuration.bordered()
        
        button.configurationUpdateHandler = { button in
            config.background.backgroundColor =
            button.isSelected ? .white : .clear
            
            config.baseForegroundColor = button.isSelected ? .black : .white
            button.configuration = config
        }
        
        let attributeContainer = AttributeContainer([.font: UIFont.systemFont(ofSize: 14, weight: .light)])
        config.attributedTitle = AttributedString(title, attributes: attributeContainer)

        config.background.strokeColor = .white
        config.contentInsets = .init(top: 6, leading: 6, bottom: 6, trailing: 6)
        
        button.configuration = config
        
        return button
    }
}
