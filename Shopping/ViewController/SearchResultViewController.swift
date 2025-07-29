//
//  SearchResultViewController.swift
//  Shopping
//
//  Created by 금가경 on 7/26/25.
//

import Alamofire
import UIKit

class SearchResultViewController: UIViewController {
    private let query: String
    private var items = [Item]()
    private var start = 1
    private var isEnd = false
    
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
        
        NetworkManager.shared.callRequest(query: query, start: start) { [weak self] shoppingResponse in
            
            guard let self else { return }

            initializeItems(items: shoppingResponse.items)
            
            let total = shoppingResponse.total
            searchResultView.totalLabel.text = "\(total.formatted(.number)) 개의 검색 결과"
        }
    }
    
    func initializeItems(items: [Item]) {
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
        for button in searchResultView.sortStackView.buttons {
            button.isSelected = button == sender ? true : false
            
            if button != sender { return }
            
            guard let title = button.titleLabel?.text, let type = SortType.allCases.first(where: { $0.title == title }) else {
                return
            }
            
            start = 1
            
            NetworkManager.shared.callRequest(query: query, start: start, type: type) { [weak self] shoppingResponse in
                guard let self = self else { return }
                
                initializeItems(items: shoppingResponse.items)
                
                searchResultView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
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
        searchResultView.peopleAlsoLikeCollectionView.register(RecommendedItemCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedItemCollectionViewCell.identifier)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
            
        case searchResultView.collectionView: return items.count
        case searchResultView.peopleAlsoLikeCollectionView: return 6
            
        default: return 0
        }
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case searchResultView.collectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.identifier, for: indexPath) as! ItemCollectionViewCell
            
            cell.configureData(item: items[indexPath.row])
            
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendedItemCollectionViewCell", for: indexPath)
            cell.backgroundColor = .blue
            
            return cell
        }

    }
    
    internal func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == items.count - 3 && !isEnd {
            start += 30
            
            NetworkManager.shared.callRequest(query: query, start: start) { [weak self] shoppingResponse in
                guard let self = self else { return }
                
                let items = shoppingResponse.items
                self.items.append(contentsOf: items)
                
                isEnd = shoppingResponse.total == 0
                
                searchResultView.collectionView.reloadData()
            }
        }
    }
}
