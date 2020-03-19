//
//  PPViewModel.swift
//  PenguinPay
//
//  Created by Criss on 3/17/20.
//  Copyright © 2020 Criss. All rights reserved.
//

import UIKit

struct PPViewModelConstants {
    static let resourcePath = "PPCountry.bundle/Data/CountryCodes"
    static let resourceType = "json"
    
    static let errorMessageRates = "Unable to retrieve exchange rates data"
    static let errorMessageCurrencies = "Unable to retrieve currencies data"
    static let errorMessageCountries = "Unable to retrieve exchange countrie data"
    
    static let errorMessageNetwork = "No internet connection"
    
    static let baseCurrencyDefault = "USD"
}

protocol PPViewModelDelegate: class {
    func modelUpdateDidFinish(errorMessage: String?)
    func infoDidUpdate()
}

class PPViewModel {
    
    // MARK: Vars
    
    weak var delegate: PPViewModelDelegate?
        
    var userInfo = PPUserInfoModel()
    var selectedCountry: PPCountryModel? {
        didSet {
            userInfo.country = selectedCountry
            delegate?.infoDidUpdate()
        }
    }
    
    var rates: Dictionary<String, Double> = [:]
    var currencies: Dictionary<String, String> = [:]
    var baseCurrency = PPViewModelConstants.baseCurrencyDefault
    
    var rows = [PPRowInfoModel(rowCellType: .name, rowHasError: false),
                PPRowInfoModel(rowCellType: .phone, rowHasError: false),
                PPRowInfoModel(rowCellType: .amount, rowHasError: false)]
    
    let countries: [PPCountryModel] = {
        var availableCountries = [PPCountryModel]()
        guard let jsonPath = Bundle.main.path(forResource: PPViewModelConstants.resourcePath,
                                              ofType: PPViewModelConstants.resourceType),
            let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
                return availableCountries
        }
        
        do {
            availableCountries = try JSONDecoder().decode(Array<PPCountryModel>.self, from: jsonData)
        } catch let jsonError {
            print(jsonError.localizedDescription)
        }
        
        return availableCountries
    }()
    
    var receivedAmount: String {
        var receivedAmount = 0
        var receivedCurrency = ""
        if let country = selectedCountry {
            let rateSelected = rates.filter({ $0.key == country.code })
            if let amountVal = userInfo.amount,
                let amountInt = Int(amountVal),
                amountInt > 0,
                let rateSelectedCountry = rateSelected[country.code] {
                
                let amount = amountVal.binaryToInt
                let amountValue = amount.doubleValue * rateSelectedCountry
                receivedAmount = Int(amountValue)
            }
            let currencySelected = currencies.filter({ $0.key == country.code })
            receivedCurrency = currencySelected[country.code] ?? ""
        }
        return String("\(receivedAmount.binaryString) \(receivedCurrency)")
    }
    
    static var isNetworkReachable: Bool {
        let reachability = try? Reachability()
        if let reachabilityConnection = reachability?.connection {
            return reachabilityConnection != .unavailable
        }
        
        return false
    }
    
    // MARK: Methods
        
    func populateViewModel() {
        guard countries.count > 0 else {
            delegate?.modelUpdateDidFinish(errorMessage: PPViewModelConstants.errorMessageCountries)
            return
        }
        
        selectedCountry = countries[0]
        let countryCodes = self.countries.map({ $0.code })
        
        var errorMessage: String?
        let group = DispatchGroup()
        
        group.enter()
        PPExchangeRatesService().fetchRates(completionHandler: { exchangeRatesModel in
            defer {
                group.leave()
            }
            guard let ratesModel = exchangeRatesModel,
                ratesModel.rates.count > 0 else {
                    errorMessage = PPViewModelConstants.errorMessageRates
                    return
            }
            self.baseCurrency = ratesModel.base
            self.rates = ratesModel.rates.filter({ countryCodes.contains($0.key) })
        })
        
        group.enter()
        PPCurrenciesService().fetchCurrencies(completionHandler: { dataCurrencies in
            defer {
                group.leave()
            }
            guard dataCurrencies.count > 0 else {
                errorMessage = PPViewModelConstants.errorMessageCurrencies
                return
            }
            self.currencies = dataCurrencies.filter({ countryCodes.contains($0.key) })
        })
        
        group.notify(queue: DispatchQueue.main) {
            self.delegate?.modelUpdateDidFinish(errorMessage: errorMessage)
        }
    }
    
    func populateUserInfo(indexPath: IndexPath, text: String?) {
        guard rows.count > indexPath.row else {
            return
        }
        
        let row = rows[indexPath.row]
        row.updateData(userInfo: userInfo, text: text)
    }
    
    func validateUserInfo() -> Bool {
        rows.forEach({
            $0.updateData(userInfo: userInfo, text: $0.cellType.text(userInfo: userInfo))
        })
        return userInfo.checkIfValidInfo()
    }
    
    func customizeCell(cell: PPInfoTableViewCell, indexPath: IndexPath, target: Any, selector: Selector) {
        guard rows.count > indexPath.row else {
            return
        }
        
        let rowInfo = rows[indexPath.row]
        cell.configure(text: rowInfo.cellType.text(userInfo: userInfo),
                       placeholderText: rowInfo.cellType.placeholderText,
                       errorText: rowInfo.cellType.errorText,
                       hasError: rowInfo.hasError)
        
        switch rowInfo.cellType {
        case .name:
            break
        case .phone:
            if let country = selectedCountry {
                let tapGestureRecognizer = UITapGestureRecognizer(target: target, action: selector)
                cell.configureCountryInfo(country: country, tapGestureRecognizer: tapGestureRecognizer)
            }
        case .amount:
            cell.configureCurrencyInfo(currency: baseCurrency)
        }
    }
}
