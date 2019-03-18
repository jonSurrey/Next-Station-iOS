//
//  StatusView.swift
//  NextStationTests
//
//  Created by Jonathan Martins on 14/03/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import XCTest
@testable import NextStation

class RequestSuccessServiceMock:RequestService{
    
    override func getStatus() {
        let data = mockJsonData()
        self.delegate?.onSuccess(data)
    }
    
    func mockJsonData()->Data{
        let data = "[\n    {\n        \"Status\": \"Operação Normal\",\n        \"Descricao\": \"\",\n        \"LinhaId\": 1,\n        \"Nome\": \"AZUL\",\n        \"Tipo\": \"M\",\n        \"DataGeracao\": \"2019-03-14T18:56:40\"\n    },\n    {\n        \"Status\": \"Operação Normal\",\n        \"Descricao\": \"\",\n        \"LinhaId\": 2,\n        \"Nome\": \"VERDE\",\n        \"Tipo\": \"M\",\n        \"DataGeracao\": \"2019-03-14T18:56:40\"\n    },\n    {\n        \"Status\": \"Operação Normal\",\n        \"Descricao\": \"\",\n        \"LinhaId\": 3,\n        \"Nome\": \"VERMELHA\",\n        \"Tipo\": \"M\",\n        \"DataGeracao\": \"2019-03-14T18:56:40\"\n    },\n    {\n        \"Status\": \"Operação Normal\",\n        \"Descricao\": \"\",\n        \"LinhaId\": 4,\n        \"Nome\": \"AMARELA\",\n        \"Tipo\": \"4\",\n        \"DataGeracao\": \"2019-03-14T18:56:00\"\n    },\n    {\n        \"Status\": \"Operação Normal\",\n        \"Descricao\": \"\",\n        \"LinhaId\": 5,\n        \"Nome\": \"LILÁS\",\n        \"Tipo\": \"M\",\n        \"DataGeracao\": \"2019-03-14T18:56:40\"\n    },\n    {\n        \"Status\": \"Operação Normal\",\n        \"Descricao\": \"\",\n        \"LinhaId\": 7,\n        \"Nome\": \"RUBI\",\n        \"Tipo\": \"C\",\n        \"DataGeracao\": \"2019-03-14T18:56:33\"\n    },\n    {\n        \"Status\": \"Operação Normal\",\n        \"Descricao\": \"\",\n        \"LinhaId\": 8,\n        \"Nome\": \"DIAMANTE\",\n        \"Tipo\": \"C\",\n        \"DataGeracao\": \"2019-03-14T18:56:33\"\n    },\n    {\n        \"Status\": \"Operação Normal\",\n        \"Descricao\": \"\",\n        \"LinhaId\": 9,\n        \"Nome\": \"ESMERALDA\",\n        \"Tipo\": \"C\",\n        \"DataGeracao\": \"2019-03-14T18:56:33\"\n    },\n    {\n        \"Status\": \"Operação Normal\",\n        \"Descricao\": \"\",\n        \"LinhaId\": 10,\n        \"Nome\": \"TURQUESA\",\n        \"Tipo\": \"C\",\n        \"DataGeracao\": \"2019-03-14T18:56:33\"\n    },\n    {\n        \"Status\": \"Operação Normal\",\n        \"Descricao\": \"\",\n        \"LinhaId\": 11,\n        \"Nome\": \"CORAL\",\n        \"Tipo\": \"C\",\n        \"DataGeracao\": \"2019-03-14T18:56:33\"\n    },\n    {\n        \"Status\": \"Operação Normal\",\n        \"Descricao\": \"\",\n        \"LinhaId\": 12,\n        \"Nome\": \"SAFIRA\",\n        \"Tipo\": \"C\",\n        \"DataGeracao\": \"2019-03-14T18:56:33\"\n    },\n    {\n        \"Status\": \"Operação Normal\",\n        \"Descricao\": \"\",\n        \"LinhaId\": 13,\n        \"Nome\": \"JADE\",\n        \"Tipo\": \"C\",\n        \"DataGeracao\": \"2019-03-14T18:56:33\"\n    },\n    {\n        \"Status\": \"Operação Normal\",\n        \"Descricao\": \"\",\n        \"LinhaId\": 15,\n        \"Nome\": \"PRATA\",\n        \"Tipo\": \"M\",\n        \"DataGeracao\": \"2019-03-14T18:56:40\"\n    }\n]".data(using: String.Encoding.utf8)!
        
        return data
    }
}

class RequestFailureServiceMock:RequestService{
    
    override func getStatus() {
        self.delegate?.onFailure(nil)
    }
}

class StatusViewMock:StatusViewDelegate{
    
    var tableViewWasUpdated       = false
    var errorMessageWasCalled     = false
    var hideErrorMessageWasCalled = false
    
    func hideErrorMessage() {
        hideErrorMessageWasCalled = true
    }
    
    func showErrorMessage() {
        errorMessageWasCalled = true
    }
    
    func updateTableviewItems() {
        tableViewWasUpdated = true
    }
}

class StatusView: XCTestCase {
    
    func testDatasourceIsEmpty(){
        let presenter = StatusPresenter()
        XCTAssertTrue(presenter.linesSituation.isEmpty, "The datasource should be empty")
    }
    
    func testServiceRequestResultSuccess(){
        let view      = StatusViewMock()
        let presenter = StatusPresenter()
        
        presenter.attach(to: view, requestService: RequestSuccessServiceMock())
        presenter.requestServiceStatus()
        
        XCTAssertTrue(!presenter.linesSituation.isEmpty, "The datasource should not be empty")
        XCTAssertTrue(view.hideErrorMessageWasCalled, "hideErrorMessage was not called")
        XCTAssertTrue(view.tableViewWasUpdated, "updateTableviewItems was not called")
    }
    
    func testServiceRequestResultFailed(){
        let view      = StatusViewMock()
        let presenter = StatusPresenter()
        
        presenter.attach(to: view, requestService: RequestFailureServiceMock())
        presenter.requestServiceStatus()
        
        XCTAssertTrue(presenter.linesSituation.isEmpty, "The datasource should be empty")
        XCTAssertTrue(view.errorMessageWasCalled, "showErrorMessage was not called")
    }
}
