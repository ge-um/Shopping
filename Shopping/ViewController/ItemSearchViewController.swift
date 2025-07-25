//
//  ItemSearchViewController.swift
//  Shopping
//
//  Created by 금가경 on 7/25/25.
//

import SnapKit
import UIKit

class ItemSearchViewController: UIViewController {
    let itemSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        
        searchBar.placeholder = "브랜드, 상품, 프로필, 태그 등"
        searchBar.searchBarStyle = .minimal
        searchBar.barStyle = .black
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSubviews()
        configureConstraints()
        configureStyle()
    }
}

extension ItemSearchViewController: CustomViewProtocol {
    func configureSubviews() {
        view.addSubview(itemSearchBar)
    }
    
    func configureConstraints() {
        itemSearchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    func configureStyle() {
        navigationItem.titleView = BoldNavigationTitle(text: "영캠러의 쇼핑쇼핑")
        view.backgroundColor = .black
    }
}

#Preview {
    ItemSearchViewController()
}
