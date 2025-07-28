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
        callRequest(query: query)
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
            
            if button == sender {
                guard let title = button.titleLabel?.text, let type = SortType.allCases.first(where: { $0.title == title }) else {
                    return
                }
                items.removeAll()
                callRequest(query: query, type: type)
                start = 1
            }
        }
    }
    
    private func callRequest(query: String, type: SortType = .sim) {
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(query)&display=30&start=\(start)&sort=\(type.rawValue)"
        
        let header: HTTPHeaders = [
            "X-Naver-Client-Id":
                Bundle.main.infoDictionary?["NaverClientId"] as! String,
            "X-Naver-Client-Secret":
                Bundle.main.infoDictionary?["NaverClientSecret"] as! String
        ]
        
        AF.request(url, method: .get, headers: header)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: ShoppingResponse.self) { [weak self] response in
                guard let self = self else { return }
                
                switch response.result {
                case .success(let shoppingResponse):
                    print("success", shoppingResponse)
                    
                    let items = shoppingResponse.items
                    self.items.append(contentsOf: items)
                    
                    isEnd = shoppingResponse.total == 0
                    
                    searchResultView.collectionView.reloadData()
                    
                    if start == 1 {
                        let total = shoppingResponse.total
                        searchResultView.totalLabel.text = "\(total.formatted(.number)) 개의 검색 결과"
                        searchResultView.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                    }
                    
                case .failure(let error):
                    print("error", error)
                }
            }
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    private func configureCollectionView() {
        searchResultView.collectionView.delegate = self
        searchResultView.collectionView.dataSource = self
        
        searchResultView.collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: ItemCollectionViewCell.identifier)
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return items.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.identifier, for: indexPath) as! ItemCollectionViewCell
        
        cell.configureData(item: items[indexPath.row])
        
        return cell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == items.count - 3 && !isEnd {
            start += 30
            callRequest(query: query)
        }
    }
}
