//
//  SearchResultViewController.swift
//  Shopping
//
//  Created by 금가경 on 7/26/25.
//

import Alamofire
import UIKit

class SearchResultViewController: UIViewController {
    /// collectionView Property
    private let query: String
    private var items = [Item]()
    private var start = 1
    private var isEnd = false
    
    /// peopleAlsoLikeCollectionView Property
    private var recommendedItems = [Item]()
    
    private let searchResultView = SearchResultView()
    
    init(query: String) {
        self.query = query
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        self.view = searchResultView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = BoldNavigationTitle(text: query)
        
        bindActions()
        configureCollectionView()
        configureInitialNetworkData()
    }
    
    // TODO: - 비동기처리 하기
    // TODO: - 중복 줄이기
    private func configureInitialNetworkData() {
        NetworkManager.shared.callRequest(query: query, start: start) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let response):
                initializeItems(items: response.items)
                
                let total = response.total
                searchResultView.totalLabel.text = "\(total.formatted(.number)) 개의 검색 결과"
                
            case .failure(let error):
                showAlert(message: error.localizedDescription)
            }
        }
        
        NetworkManager.shared.callRequest(start: 1) { [weak self] result in
            guard let self else { return }
            
            switch result {
            case .success(let response):
                self.recommendedItems = response.items
                searchResultView.peopleAlsoLikeCollectionView.reloadData()
            case .failure(let error):
                showAlert(message: error.localizedDescription)
            }

        }
    }
    
    private func initializeItems(items: [Item]) {
        self.items = items
        
        searchResultView.collectionView.reloadData()
    }
}

extension SearchResultViewController {
    internal func bindActions() {
        for button in searchResultView.sortStackView.buttons {
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        print(#function)
        for button in searchResultView.sortStackView.buttons {
            button.isSelected = button == sender ? true : false
            
            if button != sender { continue }
            
            guard let title = button.titleLabel?.text, let type = SortType.allCases.first(where: { $0.title == title }) else {
                return
            }
            
            start = 1
            
            NetworkManager.shared.callRequest(query: query, start: start, type: type) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    initializeItems(items: response.items)
                    
                    searchResultView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                case.failure(let error):
                    showAlert(message: error.localizedDescription)
                }
            }
        }
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    private func configureCollectionView() {
        searchResultView.collectionView.delegate = self
        searchResultView.collectionView.dataSource = self
        searchResultView.collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: ItemCollectionViewCell.identifier)
        
        searchResultView.peopleAlsoLikeCollectionView.delegate = self
        searchResultView.peopleAlsoLikeCollectionView.dataSource = self
        searchResultView.peopleAlsoLikeCollectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: ItemCollectionViewCell.identifier)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
            
        case searchResultView.collectionView: return items.count
        case searchResultView.peopleAlsoLikeCollectionView: return recommendedItems.count
            
        default: return 0
            
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.identifier, for: indexPath) as! ItemCollectionViewCell
        
        switch collectionView {
            
        case searchResultView.collectionView: cell.configureData(item: items[indexPath.row])
        case searchResultView.peopleAlsoLikeCollectionView: cell.configureData(item: recommendedItems[indexPath.row])
            
        default: break
            
        }
                
        return cell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == items.count - 3 && !isEnd {
            start += 30
            
            NetworkManager.shared.callRequest(query: query, start: start) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    let items = response.items
                    self.items.append(contentsOf: items)
                    
                    isEnd = response.total == 0
                    
                    searchResultView.collectionView.reloadData()
                case .failure(let error):
                    showAlert(message: error.localizedDescription)
                }
            }
        }
    }
}
