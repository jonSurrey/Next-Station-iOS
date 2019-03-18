//
//  StatusPresenter.swift
//  NextStation
//
//  Created by Jonathan Martins on 28/01/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import Foundation

protocol StatusPresenterDelegate:class {
    
    /// Datasource which holds the status situation of the lines
    var linesSituation:[Line]{ get }
    
    /// Requests the service status of the lines
    func requestServiceStatus()
}

class StatusPresenter {
    
    /// Reference to the StatusView
    private weak var view:StatusViewDelegate!
    
    /// Internal variable to manipulate the linesSituation
    private var _linesSituation:[Line] = []
    
    /// The service which performs the request for the status of the lines
    private var requestService:RequestService?
    
    /// Binds the view to this presenter
    func attach(to view:StatusViewDelegate, requestService service: RequestService?){
        self.view = view
        self.requestService = service
        self.requestService?.delegate = self
    }
}

/// Implemnetation of RequestServiceDelegate
extension StatusPresenter:RequestServiceDelegate{
    
    func onSuccess(_ data: Data) {
        if let items = try? JSONDecoder().decode([Line].self, from: data) {
            _linesSituation = items
            view.hideErrorMessage()
        }
        else{
            _linesSituation = []
            view.showErrorMessage()
        }
        view.updateTableviewItems()
    }
    
    func onFailure(_ error: Error?) {
        _linesSituation = []
        view.showErrorMessage()
        view.updateTableviewItems()
    }
}

/// Implementation of StatusPresenterDelegate
extension StatusPresenter:StatusPresenterDelegate{
    
    var linesSituation: [Line] {
        return _linesSituation
    }
    
    func requestServiceStatus() {
        requestService?.getStatus()
    }
}
