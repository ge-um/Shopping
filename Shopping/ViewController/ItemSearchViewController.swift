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
    
    let viewModel = ItemSearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSubviews()
        configureConstraints()
        configureStyle()
        bindActions()
        bindData()
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
        view.backgroundColor = .black
        navigationItem.titleView = BoldNavigationTitle(text: "영캠러의 쇼핑쇼핑")
    }
    
    func bindActions() {
        itemSearchBar.delegate = self
    }
    
    private func bindData() {
        viewModel.output.queryText.lazyBind { [unowned self] query in
            let vm = SearchResultViewModel(query: query)
            let vc = SearchResultViewController(viewModel: vm)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        viewModel.output.queryErrorText.lazyBind { [unowned self] errorText in
            showAlert(message: errorText)
        }
    }
}

extension ItemSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.input.queryText.value = searchBar.text
    }
}
