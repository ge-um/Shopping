//
//  SearchResultViewController.swift
//  Shopping
//
//  Created by 금가경 on 7/26/25.
//

import Alamofire
import SnapKit
import UIKit

class SearchResultViewController: UIViewController {
    private let query: String
    private var items = [Item]()
    private var start = 1
    private var isEnd = false
    
    private let totalLabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.font = .systemFont(ofSize: 13, weight: .bold)
        return label
    }()
    
    private let sortStackView = SortStackView()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    init(query: String) {
        self.query = query
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSubviews()
        configureConstraints()
        configureStyle()
        bindActions()
        configureCollectionViewLayout()
        configureCollectionView()
        callRequest(query: query)
    }
}

extension SearchResultViewController: CustomViewProtocol {
    internal func configureSubviews() {
        view.addSubview(totalLabel)
        view.addSubview(sortStackView)
        view.addSubview(collectionView)
    }
    
    internal func configureConstraints() {
        totalLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(12)
        }
        
        sortStackView.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(12)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(sortStackView.snp.bottom).offset(8)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    internal func configureStyle() {
        view.backgroundColor = .black
        navigationItem.titleView = BoldNavigationTitle(text: query)
        
        collectionView.backgroundColor = .clear
    }
    
    internal func bindActions() {
        for button in sortStackView.buttons {
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        }
    }
    
    // TODO: - 버튼에 따라 query 바꿔서 fetch하기
    @objc func buttonTapped(_ sender: UIButton) {
        for button in sortStackView.buttons {
            button.isSelected = button == sender ? true : false
            
            if button == sender {
                switch button.titleLabel?.text {
                case "가격낮은순":
                    items.sort { $0.lprice < $1.lprice }
                default: break
                }
                
                collectionView.reloadData()
            }
        }
    }
    
    internal func configureCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        let deviceWidth = UIScreen.main.bounds.width
        let cellWidth = deviceWidth - (2 * 12) - (1 * 12)
        
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: cellWidth / 2, height: cellWidth / 2 + 80)
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        
        collectionView.collectionViewLayout = layout
    }
    
    private func callRequest(query: String) {
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(query)&display=30&start=\(start)"
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
                    
                    // TODO: - 마지막에 total이 0이 되는 버그 있음.
                    let total = shoppingResponse.total
                    self.totalLabel.text = "\(total.formatted(.number)) 개의 검색 결과"
                    
                    let items = shoppingResponse.items
                    self.items.append(contentsOf: items)
                    
                    isEnd = total == items.count
                                        
                    collectionView.reloadData()
                    
                case .failure(let error):
                    print("error", error)
                }
            }
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: ItemCollectionViewCell.identifier)
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
