//
//  HomeViewController.swift
//  Shopping
//
//  Created by 금가경 on 7/25/25.
//

import SnapKit
import UIKit

class HomeViewController: UIViewController {
    private let navButton: UIButton = {
        var config = UIButton.Configuration.filled()
        
        config.buttonSize = .large
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black
        
        var container = AttributeContainer()
        container.font = UIFont.systemFont(ofSize: 20, weight: .bold)

        config.attributedTitle = AttributedString("쇼핑하기", attributes: container)
        
        return UIButton(configuration: config)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSubviews()
        configureConstraints()
        configureStyle()
        bindActions()
    }
}

extension HomeViewController: CustomViewProtocol {
    internal func configureSubviews() {
        view.addSubview(navButton)
    }
    
    internal func configureConstraints() {
        navButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    internal func configureStyle() {
        view.backgroundColor = .black
    }
    
    internal func bindActions() {
        navButton.addTarget(self, action: #selector(navButtonTapped), for: .touchUpInside)
    }
    
    @objc func navButtonTapped() {
        let vc = ItemSearchViewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

#Preview {
    HomeViewController()
}
