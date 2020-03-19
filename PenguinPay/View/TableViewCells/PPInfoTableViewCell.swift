//
//  PPInfoTableViewCell.swift
//  PenguinPay
//
//  Created by Criss on 3/17/20.
//  Copyright © 2020 Criss. All rights reserved.
//

import UIKit

protocol PPInfoTableViewCellDelegate: class {
    func inputFieldDidEndEditing(_ inputField: PPInfoTableViewCell)
}

class PPInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var infoTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var dialCodeLabel: UILabel!
    
    weak var delegate: PPInfoTableViewCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        infoTextField.text = nil
        errorLabel.text = nil
        flagImageView.isHidden = true
        dialCodeLabel.isHidden = true
    }
    
    func configure(text: String?, placeholderText: String?, errorText: String?, hasError: Bool) {
        infoTextField.keyboardType = .default
        
        infoTextField.delegate = self
        infoTextField.text = text
        infoTextField.placeholder = placeholderText
        errorLabel.text = hasError ? errorText : nil
    }
    
    func configureCountryInfo(country: PPCountryModel, tapGestureRecognizer: UITapGestureRecognizer) {
        infoTextField.keyboardType = .numberPad
        
        flagImageView.isHidden = false
        dialCodeLabel.isHidden = false
        
        dialCodeLabel.text = country.dialCode
        flagImageView.image = country.flag
        
        flagImageView.isUserInteractionEnabled = true
        flagImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func configureCurrencyInfo(currency: String) {
        infoTextField.keyboardType = .numberPad
        
        dialCodeLabel.isHidden = false
        dialCodeLabel.text = currency
    }
}

extension PPInfoTableViewCell: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.inputFieldDidEndEditing(self)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }

}
