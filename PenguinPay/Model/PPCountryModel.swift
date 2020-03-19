//
//  PPCountryModel.swift
//  PenguinPay
//
//  Created by Criss on 3/17/20.
//  Copyright © 2020 Criss. All rights reserved.
//

import UIKit

struct PPCountryModelConstants {
    static let imagePath = "PPCountry.bundle/Images/"
}

struct PPCountryModel: Codable {
    let name: String
    let dialCode: String
    let code: String
    let numberOfDigit: Int

    public var flag: UIImage {
        return UIImage(named: "\(PPCountryModelConstants.imagePath)\(code.uppercased())",
            in: Bundle.main, compatibleWith: nil)!
    }
}
