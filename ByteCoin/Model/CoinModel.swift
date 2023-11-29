//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Юрий on 29.11.2023.
//

import Foundation

struct CoinModel: Codable {
    let rate: Double
    let assetIdQuote: String
    
    var stringRate: String {
        String(format: "%.2f", rate)
    }
}
