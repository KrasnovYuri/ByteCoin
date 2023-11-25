//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Юрий on 25.11.2023.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdate(_ coinManager: CoinManager, rate: CoinModel)
    func didFailWithError(error: Error)

}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "89FDEBC3-3643-4FE0-B4D3-E4021B62026C"
    
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)\(currencyArray[0])?apikey=\(apiKey)"
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let rate = parseJSON(safeData) {
                        delegate?.didUpdate(self, rate: rate)
                    }
                }
            }
            task.resume()
        }
        
        func parseJSON(_ coinData: Data) -> CoinModel? {
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(CoinData.self, from: coinData)
                let rate = decodedData.rate
                
                let coin = CoinModel(rate: rate)
                
                return coin
            } catch {
                delegate?.didFailWithError(error: error)
                return nil
            }
        }
    }
}
