//
//  MapView.swift
//  NextStation
//
//  Created by Jonathan Martins on 30/01/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit
import MapKit
import Foundation

protocol MapViewDelegate:class {
    
    /// Notifies the MapView to update the polylines' data
    func updatePolylineDataSource(with lines: [Line])
    
    /// Notifies the MapView to update the annotaions' data
    func updateAnnotationDataSource(with lines:[Line])
    
    /// Zooms the map to a specific coordinate
    func zoomMapTo(latitude:Double, andLongitude longitude:Double, zoom level:Double)
}

class MapView: UIView {
    
    /// The view which displays the map
    let mapView:MKMapView = {
        let mapView = MKMapView()
        mapView.mapType           = .standard
        mapView.showsCompass      = false
        mapView.showsUserLocation = true
        mapView.isZoomEnabled     = true
        mapView.isScrollEnabled   = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    /// Wrapper for holding the title of the Controller
    let header: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// The title of the header
    let headerTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.text = "Mapa das Linhas"
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Sets up the constraints for this view
    private func setupConstraints(){
        self.addSubview(header)
        self.addSubview(mapView)
        header.addSubview(headerTitle)
        
        NSLayoutConstraint.activate([
            header.topAnchor     .constraint(equalTo: self.topAnchor),
            header.heightAnchor  .constraint(equalToConstant: 50),
            header.leadingAnchor .constraint(equalTo: self.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            headerTitle.bottomAnchor .constraint(equalTo: header.bottomAnchor, constant: -10),
            headerTitle.centerXAnchor.constraint(equalTo: header.centerXAnchor),
            
            mapView.topAnchor     .constraint(equalTo: header.bottomAnchor),
            mapView.bottomAnchor  .constraint(equalTo: self.bottomAnchor),
            mapView.leadingAnchor .constraint(equalTo: self.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
}
