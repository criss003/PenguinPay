//
//  PPUserInfoModel.swift
//  PenguinPay
//
//  Created by Criss on 3/17/20.
//  Copyright © 2020 Criss. All rights reserved.
//

import Foundation

class PPUserInfoModel {
    var fullName: String?
    var phoneNumber: String?
    var amount: String?
    var country: PPCountryModel?
    
    func checkIfValidInfo() -> Bool {
        
        return checkIfValidName() && checkIfValidPhoneNumber() && checkIfValidAmount() && checkIfValidCountry()
    }
    
    func checkIfValidName() -> Bool {
        let components = fullName?.components(separatedBy: " ")
        if let comp = components,
            comp.count > 1,
            comp[0].count > 0,
            comp[1].count > 0 {
            return true
        }
        
        return false
    }
    
    func checkIfValidPhoneNumber() -> Bool {
        guard let phoneNumber = phoneNumber else {
            return false
        }
        let isPhoneNumber = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: phoneNumber))
        let numberOfDigit = phoneNumber.count
        
        return isPhoneNumber && (numberOfDigit == country?.numberOfDigit)
    }
    
    func checkIfValidAmount() -> Bool {
        guard amount?.removeCharacters(from: "01").count == 0,
            let amountVal = amount,
            let amountInt = Int(amountVal),
            amountInt > 0 else {
                return false
        }
        
        return true
    }
    
    func checkIfValidCountry() -> Bool {
        
        return country != nil
    }
}
