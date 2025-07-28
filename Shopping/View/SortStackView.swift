//
//  SortStackView.swift
//  Shopping
//
//  Created by 금가경 on 7/27/25.
//

import UIKit

final class SortStackView: UIStackView {
    private let buttonType = ["정확도", "날짜순", "가격높은순", "가격낮은순"]
    var buttons: [UIButton] = []
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.distribution = .fillProportionally
        self.spacing = 8
        
        buttonType.forEach {
            let button = makeButton(title: $0)
            buttons.append(button)
            self.addArrangedSubview(button)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeButton(title: String) -> UIButton {
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
