//
//  UIViewController+Extension.swift
//  Shopping
//
//  Created by 금가경 on 7/29/25.
//

import UIKit

extension UIViewController {
    func showAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        
        self.present(alert, animated: true)
    }
}
