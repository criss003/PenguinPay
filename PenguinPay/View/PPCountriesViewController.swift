//
//  PPCountriesViewController.swift
//  PenguinPay
//
//  Created by Criss on 3/17/20.
//  Copyright © 2020 Criss. All rights reserved.
//

import UIKit

struct PPCountriesViewControllerConstants {
    static let title = "Select Country"
    static let countryCellIdentifier = "PPCountryTableViewCell"
}

class PPCountriesViewController: UITableViewController {
    
    var viewModel: PPViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = PPCountriesViewControllerConstants.title
    }
}
    
// MARK: UITableViewDataSource, UITableViewDelegate

extension PPCountriesViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.countries.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PPCountriesViewControllerConstants.countryCellIdentifier, for: indexPath) as! PPCountryTableViewCell
        if let viewModel = viewModel,
            viewModel.countries.count > indexPath.row {
            let country = viewModel.countries[indexPath.row]
            cell.configure(country: country)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewModel = viewModel,
            viewModel.countries.count > indexPath.row {
            let country = viewModel.countries[indexPath.row]
            viewModel.selectedCountry = country
        }
        navigationController?.popViewController(animated: true)
    }
}


