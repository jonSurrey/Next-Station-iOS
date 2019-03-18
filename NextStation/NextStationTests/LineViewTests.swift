//
//  LineViewTests.swift
//  NextStationTests
//
//  Created by Jonathan Martins on 14/03/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import XCTest
@testable import NextStation

class LineViewMock:LineViewDelegate{
    
    var name:String = ""
    var logo:String = ""
    var items: [StationItem] = []
    
    func updateLineName(_ name: String) {
        self.name = name
    }
    
    func updateCompanyLogo(_ logo: String) {
        self.logo = logo
    }
    
    func updateTableView(_ items: [StationItem]) {
        self.items = items
    }
}

class LineViewTests: XCTestCase {

    let view      = LineViewMock()
    let presenter = LinePresenter()
    
    override func setUp() {
        let line = Line(1, "Metro", [], [Station(), Station()])
        presenter.attach(to: view, with: line)
    }
    
    func testConvertStationToStationItem() {
        
        let stations     = presenter.line.stations
        let stationItems = presenter.stationsToStationItem()
        
        XCTAssertEqual(stations.count, stationItems.count, "The function did not produce the same number of items from the source.")
    }
    
    func testViewUpdatedTableView() {
        
        let stationItems = presenter.loadStationItems()
        
        XCTAssertEqual(view.items.count, stationItems.count, "The presenter did not update the view with the same items from the source.")
    }
    
    func testUpdateColourAndCompany() {
        
        presenter.selectColourAndCompany()
        
        XCTAssertEqual(view.name, "Azul"      , "The presenter did not update the LineView name correctely")
        XCTAssertEqual(view.logo, "logo_metro", "The presenter did not update the LineView logo correctely")
    }
}
