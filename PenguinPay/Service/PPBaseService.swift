//
//  PPBaseService.swift
//  PenguinPay
//
//  Created by Criss on 3/18/20.
//  Copyright © 2020 Criss. All rights reserved.
//

import Foundation

struct PPBaseServiceConstants {
    static let invalidURLErrorMessage = "invalid URL"
    static let invalidURLErrorCode = 10001
    static let invalidDataErrorMessage = "invalid Data"
    static let invalidDataErrorCode = 10002
}

class PPBaseService {
    func performRequest(urlString: String,
                        errorHandler: @escaping (_ error: Error) -> Void,
                        successHandler: @escaping (_ data: Data) -> Void) {
        
        guard let url = URL(string: urlString) else {
            errorHandler(NSError(domain: PPBaseServiceConstants.invalidURLErrorMessage, code: PPBaseServiceConstants.invalidURLErrorCode, userInfo: nil))
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let err = error {
                errorHandler(err)
                return
            }
            
            guard let jsonData = data else {
                errorHandler(NSError(domain: PPBaseServiceConstants.invalidDataErrorMessage, code: PPBaseServiceConstants.invalidDataErrorCode, userInfo: nil))
                return
            }
            
            successHandler(jsonData)
            
            }.resume()
    }
}
