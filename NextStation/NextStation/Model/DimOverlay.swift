//
//  DimOverlay.swift
//  NextStation
//
//  Created by Jonathan Martins on 03/02/19.
//  Copyright © 2019 Jonathan Martins. All rights reserved.
//

import MapKit
import Foundation
import CoreLocation

/// This class creates an overlays over the MapView
class DimOverlay:NSObject,MKOverlay {
    
    private var dimOverlayCoordinates:CLLocationCoordinate2D = kCLLocationCoordinate2DInvalid
    
    public init(mapView : MKMapView) {
        dimOverlayCoordinates = mapView.centerCoordinate
    }
    
    open var coordinate: CLLocationCoordinate2D {
        return dimOverlayCoordinates
    }
    
    open var boundingMapRect: MKMapRect {
        return .world
    }
}

/// This class configures the DimOverlay class
class DimOverlayRenderer:MKOverlayRenderer {
    
    open var overlayColor:UIColor = .black
    
    public override init(overlay: MKOverlay) {
        super.init(overlay: overlay)
        alpha = 0.1
    }
    
    public init(overlay: MKOverlay, dimAlpha : CGFloat, color : UIColor) {
        super.init(overlay: overlay)
        alpha = dimAlpha
        overlayColor = color
    }
    
    open override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        context.setFillColor(self.overlayColor.cgColor);
        context.fill(rect(for: MKMapRect.world))
    }
}
