//
//  SortType.swift
//  Shopping
//
//  Created by 금가경 on 7/28/25.
//

enum SortType: String, CaseIterable {
    case sim = "sim"
    case date = "date"
    case asc = "asc"
    case dsc = "dsc"
    
    var title: String {
        switch self {
        case .sim: return "정확도"
        case .date: return "날짜순"
        case .asc: return "가격낮은순"
        case .dsc: return "가격높은순"
        }
    }
}
