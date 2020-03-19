//
//  PPCountryTableViewCell.swift
//  PenguinPay
//
//  Created by Criss on 3/17/20.
//  Copyright © 2020 Criss. All rights reserved.
//

import UIKit

class PPCountryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func configure(country: PPCountryModel) {
        nameLabel.text = country.name
        flagImageView.image = country.flag
    }
}
