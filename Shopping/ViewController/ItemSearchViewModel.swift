//
//  ItemSearchViewModel.swift
//  Shopping
//
//  Created by 금가경 on 8/12/25.
//

import Foundation

final class ItemSearchViewModel {
    var inputQueryText: Observable<String?> = Observable(nil)
    
    var outputQueryText: Observable<String> = Observable("")
    var outputQueryErrorText: Observable<String> = Observable("")
    
    init() {
        inputQueryText.bind { [unowned self] text in
            do {
                let query = try validate(text)
                self.outputQueryText.value = query
                
            } catch {
                self.outputQueryErrorText.value = error.localizedDescription
            }
        }
    }
    
    private func validate(_ text: String?) throws (QueryTextError) -> String {
        guard let text = text else {
            throw .nil
        }
        
        guard text.trimmingCharacters(in: .whitespaces).count > 2 else {
            throw .outOfRange
        }
        
        return text
    }
}
