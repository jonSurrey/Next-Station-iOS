//
//  MapPresenter.swift
//  NextStation
//
//  Created by Jonathan Martins on 31/01/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import CoreLocation

protocol MapPresenterDelegate:class {
    
    /// The datasource which holds the lines to be displayed
    var lines:[Line] { get }

    /// Selected the lines from the database
    func selectLines()
    
    /// Notifies the view to center the map on a specific station position
    func centerMap(on station:Station)
}

class MapPresenter {
    
    /// Internal variable to manipulate the datasource
    private var _lines:[Line] = []
    
    /// Reference to the MapView
    private weak var view:MapViewDelegate!
    
    /// Binds the MapView to this presenter
    func attach(to view:MapViewDelegate){
        self.view   = view
    }
}

/// Implementation of MapPresenterDelegate
extension MapPresenter:MapPresenterDelegate {
    
    var lines: [Line] {
        return _lines
    }
    
    func selectLines() {
        self._lines = try! DatabaseManager.current.selectLines()
        
        view.updatePolylineDataSource  (with: lines)
        view.updateAnnotationDataSource(with: lines)
    }
    
    func centerMap(on station:Station) {
        view.zoomMapTo(latitude: station.latitude, andLongitude: station.longitude, zoom: 1.0)
    }
}
