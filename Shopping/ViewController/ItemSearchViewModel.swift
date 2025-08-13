//
//  ItemSearchViewModel.swift
//  Shopping
//
//  Created by 금가경 on 8/12/25.
//

import Foundation

final class ItemSearchViewModel {
    struct Input {
        var queryText: Observable<String?> = Observable(nil)

    }
    
    struct Output {
        var queryText: Observable<String> = Observable("")
        var queryErrorText: Observable<String> = Observable("")
    }

    var input = Input()
    var output = Output()
    
    init() {
        input.queryText.bind { [unowned self] text in
            do {
                let query = try validate(text)
                self.output.queryText.value = query
                
            } catch {
                self.output.queryErrorText.value = error.localizedDescription
            }
        }
    }
    
    private func validate(_ text: String?) throws (QueryTextError) -> String {
        guard let text = text else {
            throw .nil
        }
        
        guard text.trimmingCharacters(in: .whitespaces).count >= 2 else {
            throw .outOfRange
        }
        
        return text
    }
}
