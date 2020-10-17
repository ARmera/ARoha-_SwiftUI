//
//  TourMapView.swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/09/19.
//  Copyright © 2020 김성헌. All rights reserved.
//

import Foundation
import SwiftUI
import Mapbox

struct TourMapView: UIViewRepresentable {
    // Map Relevant Fields
    private let mapView: MGLMapView = MGLMapView()
    var annotations:[CustomPointAnnotation]
    //callback
    @EnvironmentObject var settings:UserSettings
    
    // MARK: - Configuring UIViewRepresentable protocol
    func makeCoordinator() -> TourMapView.Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<TourMapView>) -> MGLMapView {
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func centerCoordinate(_ centerCoordinate: CLLocationCoordinate2D) -> TourMapView {
        mapView.centerCoordinate = centerCoordinate
        return self
    }
    
    func zoomLevel(_ zoomLevel: Double) -> TourMapView {
        mapView.zoomLevel = zoomLevel
        return self
    }
    
    
    func updateUIView(_ uiView: MGLMapView, context: UIViewRepresentableContext<TourMapView>) {
        updateAnnotations(uiView)
        updatePolyline(uiView)
        showRoute(nodeList: annotations, uiView.style)
    }
    
    private func updatePolyline(_ view: MGLMapView) {
        
        guard let layers = view.style?.layers else {
            return
        }
        for item in layers {
            if item.identifier.contains("polyline") || item.identifier.contains("symbol-layer"){
                view.style?.removeLayer(item)
            }
        }
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    /* showRoute - called in three places, updateUIView() + mapViewDidFinishLoadingMap */
    func showRoute(nodeList:[CustomPointAnnotation],_ style: MGLStyle?){
        
        if nodeList.count <= 1 { return }
        
        guard let style = style else { return }
        let randomIdentifier = randomString(length: 8)
        let geoJson:Data? = test
        
        if(geoJson == nil) {return}
        guard let shapeFromGeoJSON = try? MGLShape(data: geoJson!, encoding: String.Encoding.utf8.rawValue) else {
            fatalError("Could not generate MGLShape")
        }
        
        //1. inner layer
        let source = MGLShapeSource(identifier: "\(randomIdentifier)", shape: shapeFromGeoJSON, options: nil)
        style.addSource(source)
        
        // Create new layer for the line.
        let layer = MGLLineStyleLayer(identifier: "polyline\(randomIdentifier)", source: source)
        
        // Set the line join and cap to a rounded end.
        layer.lineJoin = NSExpression(forConstantValue: "round")
        layer.lineCap = NSExpression(forConstantValue: "round")
        
        // Set the line color to a constant Pintween Primary color.
        layer.lineColor = NSExpression(forConstantValue: UIColor(red: 0.2, green: 0.4, blue: 1.0, alpha: 1.0))
        
        // The line width should gradually increase based on the zoom level.
        // Use `NSExpression` to smoothly adjust the line width from 1pt to 20pt between zoom levels 14 and 18. The `interpolationBase` parameter allows the values to interpolate along an exponential curve.
        layer.lineWidth = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
                                       [14: 3, 18: 20])

        style.addLayer(layer)
        
    }
    
    // MARK: - Configuring MGLMapView
    
    func styleURL(_ styleURL: URL) -> TourMapView {
        mapView.styleURL = styleURL
        return self
    }
    
    // passing MGLMapView argument
    private func updateAnnotations(_ view: MGLMapView) {
        if let currentAnnotations = view.annotations {
            view.removeAnnotations(currentAnnotations)
        }
        view.addAnnotations(annotations)
    }
    
    // MARK: - Implementing MGLMapViewDelegate
    
    final class Coordinator: NSObject, MGLMapViewDelegate {
        
        var control: TourMapView
        
        init(_ control: TourMapView) {
            self.control = control
        }
        
        
        func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
            // do nothing
        }
        
        func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
            print("mapViewDidFinishLoadingMap")
        }
        
        func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
            return nil
        }
        
        func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
            print("aaaa")
            return true;
        }
        
        func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
            // Optionally handle taps on the callout.
            print("Tapped the callout for: \(annotation)")
            
            // Hide the callout.
            mapView.deselectAnnotation(annotation, animated: true)
        }
        
        func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
            return UIButton(type: .detailDisclosure)
        }
        
        
        func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
            // Hide the callout view.
            mapView.deselectAnnotation(annotation, animated: false)
            
            
        }
        
        
    }
}
