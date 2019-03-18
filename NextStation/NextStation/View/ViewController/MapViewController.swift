//
//  MapViewController.swift
//  NextStation
//
//  Created by Jonathan Martins on 30/01/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    /// The controller's view, instance of MapView
    unowned var _view:MapView { return self.view as! MapView }
    
    /// The presenter for MapViewController
    var presenter = MapPresenter()
    
    /// A tuple for holding the polyline and it's stroke of the lines
    private var polylinePaths:[(line:LinePathPolyline, stroke:LinePathPolyline)] = []
    
    /// A tuple for holding the station's position and the station's name
    private var annotations:[(station:StationAnnotation, name:StationAnnotation)] = []

    /// Flag to indicate if the stations should be displayed or not
    private var isShowingStation = true
    
    /// Flag to indicate if the stations' name should be displayed or not
    private var isShowingInformation = true
    
    /// Manages the user's loctaion
    private var locationManager: CLLocationManager?

    override func loadView() {
        self.view = MapView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        presenter.attach(to: self)
        presenter.selectLines()
        
        zoomMapTo(latitude: -23.5351, andLongitude: -46.6353, zoom: 100.0)
    }
    
    /// Setups up the initial configurations of the map
    private func setupViews(){
        _view.mapView.delegate = self
        _view.mapView.addOverlay(DimOverlay(mapView: _view.mapView))
        
        drawSaoPaulo()
    }
    
    /// Loads the coordinates of São Paulo's borders to draw on the map
    private func drawSaoPaulo(){
        let url = Bundle.main.url(forResource:"saopaulo", withExtension: "plist")!
        do {
            let data     = try Data(contentsOf:url)
            let sections = (try PropertyListSerialization.propertyList(from: data, format: nil) as! NSDictionary)["coordinates"] as! [[Double]]
            
            let locations = sections.map({
                CLLocationCoordinate2DMake(CLLocationDegrees($0[1]), CLLocationDegrees($0[0]))
            })
            let polyline = MKPolygon(coordinates: locations, count: locations.count)
            _view.mapView.addOverlay(polyline)
            
        } catch {
            print("This error must never occur", error)
        }
    }
    
    /// Adds the polylines of the lines's path to the map
    private func addPolylinesToMap(){
         let strokes   = polylinePaths.map({$0.stroke})
         let polylines = polylinePaths.map({$0.line})
        
        _view.mapView.addOverlays(strokes)
        _view.mapView.addOverlays(polylines)
    }
    
    /// Removes the polylines of the lines's path from the map
    private func removePolylinesFromMap(){
        let strokes   = polylinePaths.map({$0.stroke})
        let polylines = polylinePaths.map({$0.line})
        
        _view.mapView.removeOverlays(strokes)
        _view.mapView.removeOverlays(polylines)
        
        polylinePaths.removeAll()
    }
    
    /// Removes the stations and the station's name from the map
    private func removeAnnotationsFromMap(){
        let names    = annotations.map({$0.name})
        let stations = annotations.map({$0.station})
        
        _view.mapView.removeAnnotations(names)
        _view.mapView.removeAnnotations(stations)
        
        annotations.removeAll()
    }
    
    /// Shows or hides the stations on the map
    private func shouldHideStationsOnMap(){
        let stations  = annotations.map({$0.station})
        let zoomLevel = _view.mapView.region.span.latitudeDelta
        
        if zoomLevel < 0.2 && !isShowingStation{
            isShowingStation = true
            _view.mapView.addAnnotations(stations)
        }
        else if zoomLevel > 0.2 && isShowingStation{
            isShowingStation = false
            _view.mapView.removeAnnotations(stations)
        }
    }
    
    /// Shows or hides the stations' name on the map
    private func shouldHideStationNamesOnMap(){
        let names     = annotations.map({$0.name})
        let zoomLevel = _view.mapView.region.span.latitudeDelta
        
        if zoomLevel < 0.06 && !isShowingInformation{
            isShowingInformation = true
            _view.mapView.addAnnotations(names)
        }
        else if zoomLevel > 0.06 && isShowingInformation{
            isShowingInformation = false
            _view.mapView.removeAnnotations(names)
        }
    }
}

/// Implementation of the MapView's delegate
extension MapViewController:MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        shouldHideStationsOnMap()
        shouldHideStationNamesOnMap()
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is LinePathPolyline{
            return drawPolylineOnMap(with: overlay)
        }
        else if overlay is DimOverlay{
            return DimOverlayRenderer(overlay: overlay, dimAlpha: 0.5, color: .white)
        }
        else if overlay is MKPolygon {
            let renderer =  MKPolygonRenderer(overlay: overlay)
            renderer.fillColor   = UIColor.lightGray.withAlphaComponent(0.2)
            renderer.strokeColor = .darkGray
            renderer.lineWidth = 1
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is StationAnnotation{
            return drawStationOnMap(with: annotation)
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // TODO: Do something when a station is selected
    }
    
    /// Adds the lines' path to the mao
    private func drawPolylineOnMap(with overlay:MKOverlay)->MKOverlayRenderer{
        guard let polyline = overlay as? LinePathPolyline else {
            return MKOverlayRenderer()
        }
        
        let polylineRenderer = MKPolylineRenderer(overlay: polyline)
        switch polyline.type{
            case .STROKE:
                polylineRenderer.lineWidth   = 3
                polylineRenderer.strokeColor = .black
                return polylineRenderer
            default:
                polylineRenderer.lineWidth   = 2
                polylineRenderer.strokeColor = polyline.colour
                return polylineRenderer
        }
    }
    
    /// Adds the stations and their name to the map
    private func drawStationOnMap(with annotation:MKAnnotation)->MKAnnotationView?{
        let annotation = annotation as! StationAnnotation
        if annotation.type == .STATION{
            return StationAnnotationView(annotation: annotation, reuseIdentifier: "Station")
        }
        else{
            return NameAnnotationView(annotation: annotation, reuseIdentifier: "StationName")
        }
    }
}

/// Implementation of MapViewDelegate
extension MapViewController:MapViewDelegate{
    
    func updatePolylineDataSource(with lines:[Line]) {
        removePolylinesFromMap()
        for line in lines{
            let path = line.path.map({
                CLLocationCoordinate2DMake(CLLocationDegrees($0.latitude), CLLocationDegrees($0.longitude))
            })

            let polyline = LinePathPolyline(coordinates: path, count: path.count)
            polyline.type   = .LINE
            polyline.number = line.number
            polyline.colour = UIColor.init(hexString: line.colour)

            let polylineStroke    = LinePathPolyline(coordinates: path, count: path.count)
            polylineStroke.type   = .STROKE
            polylineStroke.number = line.number

            polylinePaths.append((line: polyline, stroke:polylineStroke))
        }
        addPolylinesToMap()
    }
    
    func updateAnnotationDataSource(with lines:[Line]) {
        removeAnnotationsFromMap()
        for line in lines{
            line.stations.forEach({
                let colour  = UIColor.init(hexString: line.colour)
                let name    = StationAnnotation(with: colour, station: $0, type:.NAME)
                let station = StationAnnotation(with: colour, station: $0, type:.STATION)

                annotations.append((station: station, name: name))
            })
        }
    }
    
    func zoomMapTo(latitude:Double, andLongitude longitude:Double, zoom level:Double){
        let coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(latitude), CLLocationDegrees(longitude))
        let viewRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: level*1000, longitudinalMeters: level*1000)
        _view.mapView.setRegion(viewRegion, animated: true)
    }
}
