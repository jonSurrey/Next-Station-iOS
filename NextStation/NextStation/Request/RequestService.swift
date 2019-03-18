//
//  RequestService.swift
//  Santander
//
//  Created by Jonathan Martins on 04/01/19.
//  Copyright © 2019 Surrey. All rights reserved.
//

import Foundation
import Alamofire

protocol RequestServiceDelegate:AnyObject{
    
    /// Notifies when host the data result of the request
    func onSuccess(_ data:Data)
    
    /// Notifies when host the error of the request
    func onFailure(_ error:Error?)
}

class RequestService: RequestBase {
    
    weak var delegate:RequestServiceDelegate?
    
    init(delegate:RequestServiceDelegate?=nil) {
        self.delegate = delegate
    }
    
    /// Request the service status of the lines
    func getStatus(){
        get(endpoint: .status).responseJSON { (response) in
            if let data = response.data{
                self.delegate?.onSuccess(data)
            }
            else{
                self.delegate?.onFailure(response.error)
            }
        }
    }
}
