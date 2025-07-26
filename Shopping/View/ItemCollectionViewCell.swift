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
    
    let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "star")
        imageView.layer.cornerRadius = 20
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    let likeButton: UIButton = {
        let button = UIButton()
        
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "heart")
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 14, weight: .regular)
        config.preferredSymbolConfigurationForImage = symbolConfig
        
        config.baseForegroundColor = .black
        config.background.backgroundColor = .white
        config.background.cornerRadius = 14
        
        button.configuration = config
        
        return button
    }()
    
    let companyName: UILabel = {
        let companyName = UILabel()
        companyName.text = "회사명"
        companyName.textColor = .darkGray
        companyName.font = .systemFont(ofSize: 13, weight: .light)
        companyName.numberOfLines = 1
        
        return companyName
    }()
    
    let title: UILabel = {
        let title = UILabel()
        title.text = "매우긴품목이름매우긴품목이름매우긴품목이름매우긴품목이름매우긴품목이름매우긴품목이름매우긴품목이름"
        title.textColor = .white
        title.font = .systemFont(ofSize: 14, weight: .regular)
        title.numberOfLines = 2

        return title
    }()
    
    let price: UILabel = {
        let price = UILabel()
        price.text = "19,900,000"
        price.textColor = .white
        price.font = .systemFont(ofSize: 16, weight: .bold)
        price.numberOfLines = 1
        
        return price
    }()
    
    let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        configureSubviews()
        configureConstraints()
        configureStyle()
        bindActions()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ItemCollectionViewCell: CustomViewProtocol {
    func configureSubviews() {
        itemImageView.addSubview(likeButton)
        
        textStackView.addArrangedSubview(companyName)
        textStackView.addArrangedSubview(title)
        textStackView.addArrangedSubview(price)
        
        contentView.addSubview(itemImageView)
        contentView.addSubview(textStackView)
    }
    
    func configureConstraints() {
        itemImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(itemImageView.snp.width).multipliedBy(0.9)
        }
        
        likeButton.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(12)
            make.size.equalTo(28)
        }
        
        textStackView.snp.makeConstraints { make in
            make.top.equalTo(itemImageView.snp.bottom).offset(8)
            make.leading.equalTo(itemImageView.snp.leading).offset(8)
            make.trailing.equalTo(itemImageView.snp.trailing)
        }
    }
    
    func configureStyle() {
        self.backgroundColor = .clear
    }
    
    func bindActions() {
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        likeButton.configurationUpdateHandler = {
            button in
            
            var config = button.configuration
            
            config?.image = button.isSelected ?
            UIImage(systemName: "heart.fill") :
            UIImage(systemName: "heart")
            
            button.configuration = config
        }
    }
    
    @objc func likeButtonTapped() {
        print(#function)
        likeButton.isSelected.toggle()
    }
}
