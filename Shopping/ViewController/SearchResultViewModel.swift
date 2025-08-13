//
//  SearchResultViewModel.swift
//  Shopping
//
//  Created by 금가경 on 8/12/25.
//

import Foundation

final class SearchResultViewModel {
    struct Input {
        var query: Observable<String> = Observable("")
        var startNum: Observable<Int> = Observable(1)
        var type: Observable<SortType> = Observable(.sim)
    }

    struct Output {
        var response: Observable<ShoppingResponse> = Observable(ShoppingResponse(total: 0, items: []))
        var error: Observable<Error?> = Observable(nil)
        var isEnd: Observable<Bool> = Observable(false)
    }
    
    var input: Input
    var output: Output
    
    init() {
        input = Input()
        output = Output()
        
        input.query.lazyBind { query in
            self.updateShoppingData(query: query, start: self.input.startNum.value, type: self.input.type.value)
        }
        
        input.type.lazyBind { type in
            self.updateShoppingData(query: self.input.query.value, start: 1, type: type)
        }
        
        input.startNum.lazyBind { start in
            self.addNextShoppingData(start: start)
        }
    }
    
    // TODO: - 비동기처리 하기
    private func updateShoppingData(query: String, start: Int, type: SortType = .sim) {
        NetworkManager.shared.callRequest(api: .getSortedShoppingResponse(query: query, sort: type), query: query, start: start, type: type) { [weak self](result: Result<ShoppingResponse, Error>) in
            guard let self else { return }

            switch result {
            case .success(let response):
                output.response.value = response
                output.error.value = nil

            case .failure(let error):
                print(error)
                output.error.value = error
            }
        }
    }
    
    private func addNextShoppingData(start: Int) {
        NetworkManager.shared.callRequest(api: .addShoppingResponse(query: input.query.value, start: start, sort: input.type.value), query: input.query.value, start: start) { [weak self] (result: Result<ShoppingResponse, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                let items = response.items
                
                output.response.value.items.append(contentsOf: items)
                output.isEnd.value = response.total == 0
                output.error.value = nil
                
            case .failure(let error):
                print(error)
                output.error.value = error
            }
        }
    }
}
