//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Юрий on 25.11.2023.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(_ coinManager: CoinManager, currency: CoinModel)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "89FDEBC3-3643-4FE0-B4D3-E4021B62026C"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func performRequest(for currency: String) {
        
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "")
                return
            }
            if let coinPrice = parseJSON(data) {
                delegate?.didUpdatePrice(self, currency: coinPrice)
            }
            
            
            func parseJSON(_ data: Data) -> CoinModel? {
                do {
                    let coinData = try JSONDecoder().decode(CoinData.self, from: data)
                    let rate = coinData.rate
                    let assetsId = coinData.asset_id_quote
                    
                    let coin = CoinModel(rate: rate, assetIdQuote: assetsId)
                    return coin
                } catch {
                    print(error)
                    return nil
                }
            }
            
        }.resume()
        
        
        
        //            guard let bitcoinPrice = parseJSON(data) else { return }
        //            delegate?.didUpdatePrice(<#T##coinManager: CoinManager##CoinManager#>, currency: <#T##CoinData#>)
        
        //            if error != nil {
        //                delegate?.didFailWithError(error: error!)
        //                return
        //            }
        //
        //            if let safeData = data {
        //                if let bitcoinPrice = parseJSON(safeData) {
        //                    delegate?.didUpdatePrice.(self, currency: bit)
        //                }
        //            }
        
        
        //        func parseJSON(_ data: Data) -> CoinData? {
        //
        //            let decoder = JSONDecoder()
        //            do {
        //                let decodedData = try decoder.decode(CoinData.self, from: data)
        //                let rate = decodedData.rate
        //                let assetsId = decodedData.asset_id_quote
        //
        //                let coin = CoinData(rate: rate, asset_id_quote: assetsId)
        //                return coin
        //
        //            } catch {
        //                delegate?.didFailWithError(error: error)
        //                return nil
        //            }
        //        }
    }
}
