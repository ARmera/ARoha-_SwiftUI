//
//  MapView.swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/08/22.
//  Copyright © 2020 김성헌. All rights reserved.
//

import SwiftUI
import Mapbox

// Essential Fields - title + coordinate
extension MGLPointAnnotation {
    convenience init(title: String, coordinate: CLLocationCoordinate2D) {
        self.init()
        self.title = title
        self.coordinate = coordinate
    }
}

/*  CustomPointAnnotation Four Fields   */

class CustomPointAnnotation: NSObject, MGLAnnotation {
    
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var title: String? //placeName
    var index: Int //순서
    
    init(coordinate: CLLocationCoordinate2D, title: String?,index: Int) {
        
        self.coordinate = coordinate
        self.title = title
        self.index = index
    }
}


struct MapView: UIViewRepresentable {
    // Map Relevant Fields
    //    var annotations: [CustomPointAnnotation]
    
    private let mapView: MGLMapView = MGLMapView()
    var annotations:[CustomPointAnnotation]
    //callback
    var showDetailBeacon:(Int)->()
    @EnvironmentObject var settings:UserSettings
    
    // MARK: - Configuring UIViewRepresentable protocol
    func makeCoordinator() -> MapView.Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MGLMapView {
        mapView.delegate = context.coordinator
        return mapView
    }
    
    
    func updateUIView(_ uiView: MGLMapView, context: UIViewRepresentableContext<MapView>) {
        updateAnnotations(uiView)
        //setCenter returns CLLocationCoordinate2D
        let viewCenter = setCenter(annotations: annotations)
        if !viewCenter.latitude.isNaN && !viewCenter.longitude.isNaN {
            
            uiView.centerCoordinate = CLLocationCoordinate2D(latitude: viewCenter.latitude, longitude: viewCenter.longitude)
            uiView.zoomLevel = setZoomLevel(annotations: annotations).0
            uiView.setCenter(viewCenter, animated: true)
        }
        
    }
    
    
    
    // MARK: - Configuring MGLMapView
    
    func styleURL(_ styleURL: URL) -> MapView {
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
        
        var control: MapView
        
        init(_ control: MapView) {
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
        
        //        func mapView(_ mapView: MGLMapView, leftCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView?{
        //                // Callout height is fixed; width expands to fit its content.
        //                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 50))
        //                label.textAlignment = .right
        //                label.textColor = UIColor(red: 0.81, green: 0.71, blue: 0.23, alpha: 1)
        //
        //                return label
        //            }
        //
        //            return nil
        //        }
        
        func mapView(_ mapView: MGLMapView, rightCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView? {
            return UIButton(type: .detailDisclosure)
        }
        
        func mapView(_ mapView: MGLMapView, leftCalloutAccessoryViewFor annotation: MGLAnnotation) -> UIView?{
            // Callout height is fixed; width expands to fit its content.
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            label.textAlignment = .center
            label.textColor = UIColor(red: 0.81, green: 0.71, blue: 0.23, alpha: 1)
            label.text = (annotation as! CustomPointAnnotation).index == -1 ? "-" : String((annotation as! CustomPointAnnotation).index)
            label.font = UIFont(name: "BMJUA", size: 30)
            
            return label
        }
        
        func mapView(_ mapView: MGLMapView, annotation: MGLAnnotation, calloutAccessoryControlTapped control: UIControl) {
            // Hide the callout view.
            mapView.deselectAnnotation(annotation, animated: false)
            self.control.showDetailBeacon((annotation as! CustomPointAnnotation).index)
            // Show an alert containing the annotation's details
            
            
        }
        
        
    }
}
