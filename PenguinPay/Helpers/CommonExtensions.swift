//
//  CommonExtensions.swift
//  PenguinPay
//
//  Created by Criss on 3/18/20.
//  Copyright © 2020 Criss. All rights reserved.
//

import UIKit

struct CommonExtensionsConstants {
    static let confirmation = "Ok"
}

extension String {
    var binaryToInt: Int {
        return Int(strtoul(self, nil, 2))
    }
    
    func removeCharacters(fromChars: CharacterSet) -> String {
        let passed = self.unicodeScalars.filter { !fromChars.contains($0) }
        return String(String.UnicodeScalarView(passed))
    }

    func removeCharacters(from: String) -> String {
        return removeCharacters(fromChars: CharacterSet(charactersIn: from))
    }
}

extension Int {
    var binaryString: String {
        return String(self, radix: 2)
    }
    
    var doubleValue: Double {
        return Double(self)
    }
}

extension UIAlertController {

    static func showAlert(parentController: UIViewController,
                          message: String?,
                          title: String?,
                          confirmationTitle: String = CommonExtensionsConstants.confirmation,
                          confirmationStyle: UIAlertAction.Style = .cancel,
                          handler: ((UIAlertAction) -> ())? = nil) {
        let alert = UIAlertController(title: title,
                                      message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: confirmationTitle,
                                      style: confirmationStyle, handler: handler))
        parentController.present(alert, animated: true, completion: nil)
    }
}
