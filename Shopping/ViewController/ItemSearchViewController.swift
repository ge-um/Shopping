//
//  ItemSearchViewController.swift
//  Shopping
//
//  Created by 금가경 on 7/25/25.
//

import SnapKit
import UIKit

class ItemSearchViewController: UIViewController {
    private let itemSearchBar: UISearchBar = {
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
        bindActions()
    }
}

extension ItemSearchViewController: CustomViewProtocol {
    internal func configureSubviews() {
        view.addSubview(itemSearchBar)
    }
    
    internal func configureConstraints() {
        itemSearchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    internal func configureStyle() {
        view.backgroundColor = .black
        navigationItem.titleView = BoldNavigationTitle(text: "영캠러의 쇼핑쇼핑")
    }
    
    internal func bindActions() {
        itemSearchBar.delegate = self
    }
}

extension ItemSearchViewController: UISearchBarDelegate {
    internal func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let query = searchBar.text!
        
        guard query.count >= 2 else {
            print("텍스트를 두 글자 이상 입력하세요.")
            return
        }
        
        navigationController?.pushViewController(SearchResultViewController(query: query), animated: true)
    }
}

#Preview {
    ItemSearchViewController()
}
