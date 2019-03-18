//
//  TripPlannerTests.swift
//  NextStationTests
//
//  Created by Jonathan Martins on 14/03/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import XCTest
@testable import NextStation

class TripPlannerViewMock:TripPlannerViewDelegate{

    var time:String               = ""
    var errorTitle:String         = ""
    var errorMessage:String       = ""
    var stationOrigin:String      = ""
    var stationDetsination:String = ""
    var tableViewWasUpdated:Bool  = false
    
    func updateTableView() {
        tableViewWasUpdated = true
    }
    
    func showErrorMessage(title: String, message: String) {
        self.errorTitle   = title
        self.errorMessage = message
    }
    
    func updateOriginStationTextField(to text: String) {
        self.stationOrigin = text
    }
    
    func updateDestinationStationTextField(to text: String) {
        self.stationDetsination = text
    }
    
    func updateAverageTripTime(to time: String) {
        self.time = time
    }
}

class TripPlannerTests: XCTestCase {
    
    var view     :TripPlannerViewMock!
    var presenter:TripPlannerPresenter!
    
    let originStation      = Station(1, 1, 1, "TesteOrigin" , "", 0, 0, [])
    let destinationStation = Station(2, 2, 2, "TesteDestino", "", 0, 0, [])
    
    override func setUp() {
        view      = TripPlannerViewMock()
        presenter = TripPlannerPresenter()
        presenter.attach(to: view)
    }
    
    func testSetOriginStation(){
        let expectedResult = "Linha \(originStation.lineId) - \(originStation.name)"
        presenter.setOrigin(station: originStation)
        XCTAssertEqual(view.stationOrigin, expectedResult, "updateOriginStationTextField was not updated with the presenter value")
    }
    
    func testSetDestinationStation(){
        let expectedResult = "Linha \(destinationStation.lineId) - \(destinationStation.name)"
        presenter.setDestination(station: destinationStation)
        XCTAssertEqual(view.stationDetsination, expectedResult, "updateDestinationStationTextField was not updated with the presenter value")
    }
    
    func testGetStationIsNotEmpty(){
        let stations = presenter.getStations()
        XCTAssertTrue(!stations.isEmpty, "getStations result should not be empty")
    }
    
    func testDisplayErrorMEssageWhenUserDoesNotSetTheOriginStation(){
        setUp()
        presenter.findShortestPath()

        XCTAssertEqual(view.errorTitle  , "Ops!😅")
        XCTAssertEqual(view.errorMessage, "Acho que você esqueceu de selecionar a estação de origem!")
    }
    
    func testDisplayErrorMessageWhenUserDoesNotSetTheDestinationStation(){
        setUp()
        presenter.setOrigin(station: originStation)
        presenter.findShortestPath()
        
        XCTAssertEqual(view.errorTitle  , "Ops!😅")
        XCTAssertEqual(view.errorMessage, "Sem destino a gente não chega a lugar algum, né?")
    }
    
    func testDisplayErroressageWhenUserSetsSameOringinAndDestination(){
        setUp()
        presenter.setOrigin     (station: originStation)
        presenter.setDestination(station: originStation)
        presenter.findShortestPath()

        XCTAssertEqual(view.errorTitle  , "Ajuda a gente, vai?😩")
        XCTAssertEqual(view.errorMessage, "A estação de origem tem que ser diferente da de destino, coleguinha!")
    }
    
    func testFormatMinutesWhenIsLessThan1Hour(){
        setUp()
        
        let minutes      = 47
        let stringResult = presenter.format(minutes)
        XCTAssertEqual(stringResult, "47 minutos", "The result in the view does not conform to the expected value")
    }
    
    func testFormatMinutesWhenIsOver1Hour(){
        setUp()
        
        let minutes      = 136
        let stringResult = presenter.format(minutes)
        XCTAssertEqual(stringResult, "2 hora(s) e 16 minuto(s)", "The result in the view does not conform to the expected value")
    }
    
    func testUpdateAverageTripTimeLabel(){
        setUp()
        
        let time = presenter.format(115)
        view.updateAverageTripTime(to: time)
        
        XCTAssertEqual(view.time, "1 hora(s) e 55 minuto(s)", "The result in the view does not conform to the expected value")
    }
    
    func testUpdateTableView(){
        setUp()
        
        presenter.setOrigin     (station: originStation)
        presenter.setDestination(station: destinationStation)
        presenter.findShortestPath()
        
        XCTAssertTrue(view.tableViewWasUpdated, "updateTableView function was not called, therefore not updated")
    }
}
