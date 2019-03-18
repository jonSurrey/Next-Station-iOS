//
//  LinePresenter.swift
//  NextStation
//
//  Created by Jonathan Martins on 28/01/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

protocol LinePresenterDelegate:class {
    
    /// The model which represents the line that this presenter will manipulate
    var line:Line{ get }
    
    /// Notifies the LineView to update the Stations with the StationItem objects
    func loadStationItems() -> [StationItem]
    
    /// Selects the Line's name and company logo to be displayed on the LineViewController
    func selectColourAndCompany()
    
    /// Converts the Station objects to StationItem objects that will be used by the LineViewController
    func stationsToStationItem() ->[StationItem]
}

class LinePresenter {
    
    /// Internal variable to manipulate the Line model
    private var _line:Line!
    
    /// Reference to the LineView
    private weak var view:LineViewDelegate!
    
    /// Binds the View and Model to this presenter
    func attach(to view:LineViewDelegate, with line:Line){
        self.view  = view
        self._line = line
    }
}

/// Implementation of LinePresenterDelegate
extension LinePresenter:LinePresenterDelegate {
    
    var line: Line {
        return _line
    }
    
    @discardableResult func loadStationItems() -> [StationItem] {
        let items = stationsToStationItem()
        view.updateTableView(items)
        return items
    }

    func stationsToStationItem() -> [StationItem] {
        var items    = [StationItem]()
        let stations = line.stations
        
        for station in stations{
            items.append(StationItem(colour: line.colour, station))
        }
        return items
    }
    
    func selectColourAndCompany() {

        let colourName  = line.colourName
        let companyLogo = line.companyImageName

        view.updateLineName(colourName)
        view.updateCompanyLogo(companyLogo)
    }
}
