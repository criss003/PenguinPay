
//  PPExchangeRatesService.swift
//  PenguinPay
//
//  Created by Criss on 3/17/20.
//  Copyright © 2020 Criss. All rights reserved.
//

import Foundation

struct PPExchangeRatesServiceConstants {
    static let stringURL = "https://openexchangerates.org/api/latest.json?app_id=f09ad0feab0e4a53b3746164b08181fb"
}

class PPExchangeRatesService: PPBaseService {
    
    func fetchRates(completionHandler: @escaping (PPExchangeRatesModel?) -> Void) {
        
        performRequest(urlString: PPExchangeRatesServiceConstants.stringURL,
                       errorHandler: { error in
                        print(error.localizedDescription)
                        completionHandler(nil)
        }, successHandler: { data in
            do {
                let exchangeRatesModel = try JSONDecoder().decode(PPExchangeRatesModel.self, from: data)
                completionHandler(exchangeRatesModel)
            } catch let jsonError {
                print(jsonError.localizedDescription)
                completionHandler(nil)
            }
        })
    }
}


