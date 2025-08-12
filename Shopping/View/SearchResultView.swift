//
//  SearchResultView.swift
//  Shopping
//
//  Created by 금가경 on 7/28/25.
//

import SnapKit
import UIKit

class SearchResultView: BaseView {
    let totalLabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.font = .systemFont(ofSize: 13, weight: .bold)
        return label
    }()
    
    let sortStackView = SortStackView()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
//    let peopleAlsoLikeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCollectionViewLayout()
//        configurePeopleAlsoLikeCollectionViewLayout()
    }
    
    internal override func configureSubviews() {
        addSubview(totalLabel)
        addSubview(sortStackView)
        addSubview(collectionView)
//        addSubview(peopleAlsoLikeCollectionView)
    }
    
    internal override func configureConstraints() {
        totalLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(8)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(12)
        }
        
        sortStackView.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(8)
            make.leading.equalTo(safeAreaLayoutGuide).inset(12)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(sortStackView.snp.bottom).offset(8)
            make.bottom.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
//        peopleAlsoLikeCollectionView.snp.makeConstraints { make in
//            make.height.equalTo(220)
//            make.bottom.equalTo(safeAreaLayoutGuide)
//            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
//        }
    }
    
    internal override func configureStyle() {
        backgroundColor = .black        
        collectionView.backgroundColor = .clear
//        peopleAlsoLikeCollectionView.backgroundColor = .white.withAlphaComponent(0.3)
//        peopleAlsoLikeCollectionView.layer.cornerRadius = 10
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
    
//    internal func configurePeopleAlsoLikeCollectionViewLayout() {
//        let layout = UICollectionViewFlowLayout()
//        let deviceWidth = UIScreen.main.bounds.width
//        let cellWidth = deviceWidth - (1 * 12) - (3 * 12)
//        
//        layout.scrollDirection = .horizontal
//        layout.itemSize = CGSize(width: cellWidth / 4 + 16, height: 220 - 24 * 2)
//        layout.minimumInteritemSpacing = 12
//        layout.sectionInset = UIEdgeInsets(top: 24, left: 12, bottom: 24, right: 0)
//        
//        peopleAlsoLikeCollectionView.collectionViewLayout = layout
//        
//    }
}
