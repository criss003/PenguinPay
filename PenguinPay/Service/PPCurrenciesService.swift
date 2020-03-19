//
//  PPCurrenciesService.swift
//  PenguinPay
//
//  Created by Criss on 3/18/20.
//  Copyright © 2020 Criss. All rights reserved.
//

import Foundation

struct PPCurrenciesConstants {
    static let stringURL = "https://openexchangerates.org/api/currencies.json"
}

class PPCurrenciesService: PPBaseService {
    
    func fetchCurrencies(completionHandler: @escaping (Dictionary<String, String>) -> Void) {
        
        performRequest(urlString: PPCurrenciesConstants.stringURL,
                       errorHandler: { error in
                        print(error.localizedDescription)
                        completionHandler([:])
        }, successHandler: { data in
            do {
                let rates = try JSONSerialization.jsonObject(with: data, options: []) as? Dictionary<String, String>
                completionHandler(rates ?? [:])
            } catch let jsonError {
                print(jsonError.localizedDescription)
                completionHandler([:])
            }
        })
    }
}
    
