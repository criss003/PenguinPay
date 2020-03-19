//
//  PPRowInfoModel.swift
//  PenguinPay
//
//  Created by Criss on 3/17/20.
//  Copyright © 2020 Criss. All rights reserved.
//

import Foundation

struct PPRowInfoModelConstants {
    static let placeholderName = "Name"
    static let placeholderPhone = "Phone"
    static let placeholderAmount = "0"
    
    static let errorName = "Invalid Name"
    static let errorPhone = "Invalid Phone"
    static let errorAmount = "Invalid Amount"
}

enum PPCellType: Int {
    case name
    case phone
    case amount
    
    var placeholderText: String {
        switch self {
        case .name:
            return PPRowInfoModelConstants.placeholderName
        case .phone:
            return PPRowInfoModelConstants.placeholderPhone
        case .amount:
            return PPRowInfoModelConstants.placeholderAmount
        }
    }
    
    var errorText: String {
        switch self {
        case .name:
            return PPRowInfoModelConstants.errorName
        case .phone:
            return PPRowInfoModelConstants.errorPhone
        case .amount:
            return PPRowInfoModelConstants.errorAmount
        }
    }
    
    func text(userInfo: PPUserInfoModel) -> String? {
        switch self {
        case .name:
            return userInfo.fullName
        case .phone:
            return userInfo.phoneNumber
        case .amount:
            return userInfo.amount
        }
    }
}

class PPRowInfoModel {
    var cellType = PPCellType.name
    var hasError = false
    
    init(rowCellType: PPCellType, rowHasError: Bool) {
        cellType = rowCellType
        hasError = rowHasError
    }
    
    func updateData(userInfo: PPUserInfoModel, text: String?) {
        switch cellType {
        case .name:
            userInfo.fullName = text
            hasError = !userInfo.checkIfValidName()
        case .phone:
            userInfo.phoneNumber = text
            hasError = !userInfo.checkIfValidPhoneNumber()
        case .amount:
            userInfo.amount = text
            hasError = !userInfo.checkIfValidAmount()
        }
    }
}
