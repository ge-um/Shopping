//
//  SearchResultViewController.swift
//  Shopping
//
//  Created by 금가경 on 7/26/25.
//

import SnapKit
import UIKit

class SearchResultViewController: UIViewController {
    let query: String
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    init(query: String) {
        self.query = query
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Bundle.main.infoDictionary?["NaverClientSecret"])
        print(Bundle.main.infoDictionary?["NaverClientId"])
        
        configureSubviews()
        configureConstraints()
        configureStyle()
        configureCollectionViewLayout()
        configureCollectionView()
    }
}

extension SearchResultViewController: CustomViewProtocol {
    func configureSubviews() {
        view.addSubview(collectionView)
    }
    
    func configureConstraints() {
        collectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.verticalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureStyle() {
        view.backgroundColor = .black
        navigationItem.titleView = BoldNavigationTitle(text: query)
        
        collectionView.backgroundColor = .clear
    }
    
    func configureCollectionViewLayout() {
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
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.identifier, for: indexPath) as! ItemCollectionViewCell
        
        return cell
    }
    
    func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: ItemCollectionViewCell.identifier)
    }
}
