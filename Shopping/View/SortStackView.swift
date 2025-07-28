//
//  SortStackView.swift
//  Shopping
//
//  Created by 금가경 on 7/27/25.
//

import UIKit

// TODO: buttonType sortType으로 교체 후 정확도 버튼 기본으로 선택하기
final class SortStackView: UIStackView {
    var buttons: [UIButton] = []
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.distribution = .fillProportionally
        self.spacing = 8
        
        SortType.allCases.forEach {
            let button = makeButton(title: $0.title)
            
            if $0 == .sim { button.isSelected = true }
            
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
