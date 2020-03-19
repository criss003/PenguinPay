//
//  PPExchangeRatesModel.swift
//  PenguinPay
//
//  Created by Criss on 3/18/20.
//  Copyright © 2020 Criss. All rights reserved.
//

import Foundation

class PPExchangeRatesModel: Codable {
    let rates: Dictionary<String, Double>
    let base: String
}
