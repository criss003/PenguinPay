//
//  PPViewController.swift
//  PenguinPay
//
//  Created by Criss on 3/17/20.
//  Copyright © 2020 Criss. All rights reserved.
//

import UIKit

struct PPViewControllerConstants {
    static let title = "Penguin Pay"
    static let mainStoryboard = "Main"
    static let infoCellIdentifier = "PPInfoTableViewCell"
    
    static let successTitle = "Success"
    static let successMessage = "Your transaction is being sent."
    
    static let errorTitle = "Error"
    static let errorMessage = "Your data is invalid."
    
    static let receiveMessage = "The recipient will receive: "
}

class PPViewController: UIViewController {
    
    @IBOutlet weak var userInfoTableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var receiveLabel: UILabel!
    
    let viewModel = PPViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        customizeUI()
        customizeData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateReceiveLabel()
    }
    
    func customizeUI() {
        title = PPViewControllerConstants.title
            
        navigationItem.rightBarButtonItem?.target = self
        navigationItem.rightBarButtonItem?.action = #selector(sendAction(sender:))
        
        activityIndicatorView.center = view.center
        activityIndicatorView.startAnimating()
    }
    
    func customizeData() {
        viewModel.delegate = self
        viewModel.populateViewModel()
    }
    
    func updateReceiveLabel() {
        receiveLabel.text = String("\(PPViewControllerConstants.receiveMessage)\(viewModel.receivedAmount)")
    }

    @objc func sendAction(sender: UIBarButtonItem) {
        guard PPViewModel.isNetworkReachable else {
            UIAlertController.showAlert(parentController: self,
                                        message: PPViewModelConstants.errorMessageNetwork,
                                        title: PPViewControllerConstants.errorTitle)
            return
        }
        
        view.endEditing(true)
        guard viewModel.validateUserInfo() == true else {
            userInfoTableView.reloadData()
            UIAlertController.showAlert(parentController: self,
                                        message: PPViewControllerConstants.errorMessage,
                                        title: PPViewControllerConstants.errorTitle)
            return
        }
        
        UIAlertController.showAlert(parentController: self,
                  message: PPViewControllerConstants.successMessage,
                  title: PPViewControllerConstants.successTitle)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
        guard let countriesViewController = UIStoryboard(name: PPViewControllerConstants.mainStoryboard,
                                                       bundle: nil).instantiateViewController(withIdentifier: String(describing: PPCountriesViewController.self))
                                        as? PPCountriesViewController else {
            return
        }
        
        countriesViewController.viewModel = viewModel
        navigationController?.pushViewController(countriesViewController, animated: true)
    }
    
}

extension PPViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: PPViewControllerConstants.infoCellIdentifier, for: indexPath) as! PPInfoTableViewCell
        cell.delegate = self
        
        let selector = #selector(imageTapped(tapGestureRecognizer:))
        viewModel.customizeCell(cell: cell, indexPath: indexPath, target: self, selector: selector)
                
        return cell
    }
}

extension PPViewController: PPViewModelDelegate {
    
    func modelUpdateDidFinish(errorMessage: String?) {
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
            guard errorMessage == nil else {
                UIAlertController.showAlert(parentController: self,
                                            message: errorMessage,
                                            title: PPViewControllerConstants.errorTitle)
                return
            }
            self.userInfoTableView.reloadData()
            self.updateReceiveLabel()
        }
    }
    
    func infoDidUpdate() {
        DispatchQueue.main.async {
            self.activityIndicatorView.stopAnimating()
            self.userInfoTableView.reloadData()
        }
    }
}

extension PPViewController: PPInfoTableViewCellDelegate {
    
    func inputFieldDidEndEditing(_ inputField: PPInfoTableViewCell) {
        let indexPath = userInfoTableView.indexPath(for: inputField)
        guard let rIndexPath = indexPath else {
            return
        }
        
        viewModel.populateUserInfo(indexPath: rIndexPath, text: inputField.infoTextField.text)
        userInfoTableView.reloadRows(at: [rIndexPath], with: .automatic)
        updateReceiveLabel()
    }
}

