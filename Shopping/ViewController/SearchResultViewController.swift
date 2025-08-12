//
//  SearchResultViewController.swift
//  Shopping
//
//  Created by 금가경 on 7/26/25.
//

import UIKit

class SearchResultViewController: UIViewController {
    let totalLabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.font = .systemFont(ofSize: 13, weight: .bold)
        return label
    }()
    
    let accuracyButton: UIButton = {
        let button = UIButton.makeButton(title: SortType.sim.title)
        button.isSelected = true
        return button
    }()
    
    let dateButton: UIButton = {
        let button = UIButton.makeButton(title: SortType.date.title)
        return button
    }()
    
    let ascButton: UIButton = {
        let button = UIButton.makeButton(title: SortType.asc.title)
        return button
    }()
    
    let dscButton: UIButton = {
        let button = UIButton.makeButton(title: SortType.dsc.title)
        return button
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        
        return stackView
    }()
        
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let deviceWidth = UIScreen.main.bounds.width
        let cellWidth = deviceWidth - (2 * 12) - (1 * 12)
        
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: cellWidth / 2, height: cellWidth / 2 + 80)
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .clear
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: ItemCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    let viewModel = SearchResultViewModel()
    
    private let query: String

    init(query: String) {
        self.query = query
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        navigationItem.titleView = BoldNavigationTitle(text: query)
        
        configureSubviews()
        configureConstraints()
        bindActions()
        bindData()
    }
    
    private func configureSubviews() {
        stackView.addArrangedSubview(accuracyButton)
        stackView.addArrangedSubview(dateButton)
        stackView.addArrangedSubview(ascButton)
        stackView.addArrangedSubview(dscButton)
        
        view.addSubview(totalLabel)
        view.addSubview(stackView)
        view.addSubview(collectionView)
    }
    
    private func configureConstraints() {
        totalLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(12)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(12)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(8)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bindData() {
        viewModel.inputQuery.value = query
    
        viewModel.outputResponse.lazyBind { response in
            self.totalLabel.text = response.overview
            self.collectionView.reloadData()
        }
    }
}

extension SearchResultViewController {
    internal func bindActions() {
        let buttons = stackView.arrangedSubviews.map { $0 as! UIButton }
        buttons.forEach { $0.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)}
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        stackView.arrangedSubviews.forEach { view in
            let button = view as! UIButton
            button.isSelected = false
        }
        
        sender.isSelected = true
        
        guard let title = sender.titleLabel?.text,
              let type = SortType.allCases.first(where: { $0.title == title }) else { return }
        
        viewModel.inputType.value = type
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputResponse.value.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCollectionViewCell.identifier, for: indexPath) as! ItemCollectionViewCell
        
        let item = viewModel.outputResponse.value.items[indexPath.row]
        
        cell.configureData(item: item)
                
        return cell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let count = viewModel.outputResponse.value.items.count
        if indexPath.item == count - 3 && !viewModel.outputIsEnd.value {
            viewModel.inputStartNum.value += 30
        }
    }
}
