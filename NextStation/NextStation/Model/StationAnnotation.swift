//
//  StationAnnotation.swift
//  NextStation
//
//  Created by Jonathan Martins on 03/02/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import MapKit
import Foundation
import CoreLocation

/// Types what kind of Annotation a view can be
enum AnnotationType {
    case STATION
    case NAME
}

class StationAnnotation:NSObject,MKAnnotation {
    
    let lineColour:UIColor
    let station:Station
    let type:AnnotationType
    let coordinate:CLLocationCoordinate2D
    
    init(with lineColour:UIColor, station: Station, type:AnnotationType) {
        self.type       = type
        self.station    = station
        self.lineColour = lineColour
        self.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(station.latitude), CLLocationDegrees(station.longitude))
        super.init()
    }
    
    var title: String? {
        return station.name
    }
    
    var subtitle: String? {
        return station.address
    }
}

class StationAnnotationView: MKAnnotationView {
    
    /// The border of the stationView
    let border:CircleView = {
        let view = CircleView(frame: CGRect(x: 0, y: 0, width: 9, height: 9))
        view.backgroundColor = .black
        view.fullCircle()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// The view that represents a station on the map
    let stationView:CircleView = {
        let view = CircleView(frame: CGRect(x: 0, y: 0, width: 8, height: 8))
        view.backgroundColor = .white
        view.border_Width = 1
        view.fullCircle()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Indicates on the stationView if the station has tranferences
    let transferPoint:CircleView = {
        let view = CircleView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        view.fullCircle()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        guard let annotation = self.annotation as? StationAnnotation else {
            return
        }
        
        addViewToAnnotation()
        checkIfStationHasTranferences(annotation)
    }
    
    /// Adds the views to the Annotation
    private func addViewToAnnotation(){
        addSubview(border)
        addSubview(stationView)
        addSubview(transferPoint)
        NSLayoutConstraint.activate([
            border.widthAnchor .constraint(equalToConstant: 9),
            border.heightAnchor.constraint(equalToConstant: 9),
            border.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            border.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            stationView.widthAnchor .constraint(equalToConstant: 8),
            stationView.heightAnchor.constraint(equalToConstant: 8),
            stationView.centerYAnchor.constraint(equalTo: border.centerYAnchor),
            stationView.centerXAnchor.constraint(equalTo: border.centerXAnchor),
            
            transferPoint.widthAnchor .constraint(equalToConstant: 5),
            transferPoint.heightAnchor.constraint(equalToConstant: 5),
            transferPoint.centerYAnchor.constraint(equalTo: stationView.centerYAnchor),
            transferPoint.centerXAnchor.constraint(equalTo: stationView.centerXAnchor),
        ])
    }
    
    /// Verifies if the station has tranferences, if so, transferPoint is visible
    private func checkIfStationHasTranferences(_ annotation:StationAnnotation){
        stationView.border_Color      = annotation.lineColour
        transferPoint.backgroundColor = !annotation.station.tranferences.isEmpty ? .black:.white
    }
}

class NameAnnotationView: MKAnnotationView {
    
    /// The name of the station on the map
    private let stationName:RoundedCornerLabel = {
        let roundedCorner = RoundedCornerLabel()
        roundedCorner.border_Width = 2
        roundedCorner.label.textColor = .black
        roundedCorner.label.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        roundedCorner.translatesAutoresizingMaskIntoConstraints = false
        return roundedCorner
    }()
    
    /// Holds the stationName
    let wrapper:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        guard let annotation = self.annotation as? StationAnnotation else {
            return
        }
        
        addViewToAnnotation()
        setupStationInformation(annotation)
    }
    
    /// Adds the views to the Annotation
    private func addViewToAnnotation(){
        addSubview(wrapper)
        wrapper.addSubview(stationName)
        NSLayoutConstraint.activate([
            stationName.centerYAnchor .constraint(equalTo: wrapper.centerYAnchor),
            stationName.leadingAnchor .constraint(equalTo: wrapper.leadingAnchor, constant:5),
            stationName.trailingAnchor.constraint(lessThanOrEqualTo: wrapper.trailingAnchor)
        ])
    }
    
    /// Adds the station's informations to the view
    private func setupStationInformation(_ annotation:StationAnnotation){
        stationName.label.text      = annotation.station.name
        stationName.backgroundColor = .white
        stationName.border_Color    = annotation.lineColour
    }
}
