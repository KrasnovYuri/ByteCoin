//
//  ViewController.swift
//  ByteCoin
//
//  Created by Юрий on 25.11.2023.
//

import UIKit



class ViewController: UIViewController {
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
    }
}

// MARK: - CoinManagerDelegate
extension ViewController: CoinManagerDelegate {

    func didUpdatePrice(_ price: CoinManager, currency: CoinModel) {
        
        DispatchQueue.main.async {
            self.bitcoinLabel.text = currency.stringRate
            self.currencyLabel.text = currency.assetIdQuote
            
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    
}

// MARK: - UIPickerViewDataSource
extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        coinManager.currencyArray.count
    }
    
    
}

// MARK: - UIPickerViewDelegate
extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectCurrency = coinManager.currencyArray[row]
        coinManager.performRequest(for: selectCurrency)
       
        
    }
}


