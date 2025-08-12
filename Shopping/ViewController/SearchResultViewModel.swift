//
//  SearchResultViewModel.swift
//  Shopping
//
//  Created by 금가경 on 8/12/25.
//

import Foundation

final class SearchResultViewModel {
    var inputQuery: Observable<String> = Observable("")
    var inputStartNum: Observable<Int> = Observable(1)
    var inputType: Observable<SortType> = Observable(.sim)
    
    var outputResponse: Observable<ShoppingResponse?> = Observable(nil)
    
    init() {
        inputQuery.lazyBind { query in
            self.updateShoppingData(query: query, start: self.inputStartNum.value, type: self.inputType.value)
        }
        
        inputType.bind { type in
            self.updateShoppingData(query: self.inputQuery.value, start: 1, type: type)
        }
    }
    
    // TODO: - 비동기처리 하기
    private func updateShoppingData(query: String, start: Int, type: SortType = .sim) {
        NetworkManager.shared.callRequest(query: query, start: start, type: type) { [weak self](result: Result<ShoppingResponse, Error>) in
            guard let self else { return }

            switch result {
            case .success(let response):
                outputResponse.value = response
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
