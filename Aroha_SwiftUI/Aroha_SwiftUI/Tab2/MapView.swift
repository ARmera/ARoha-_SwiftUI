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
   
    init(coordinate: CLLocationCoordinate2D, poiId: String, title: String?, contentTypeId: String?) {
        
        self.coordinate = coordinate
        self.title = title
    }
}


struct MapView: UIViewRepresentable {
    // Map Relevant Fields
//    var annotations: [CustomPointAnnotation]
    
    private let mapView: MGLMapView = MGLMapView()
    
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
    }
    
    
    // MARK: - Configuring MGLMapView
    
    func styleURL(_ styleURL: URL) -> MapView {
        mapView.styleURL = styleURL
        return self
    }
    
    // passing MGLMapView argument
    private func updateAnnotations(_ view: MGLMapView) {
//
//        if let currentAnnotations = view.annotations {
//            view.removeAnnotations(currentAnnotations)
//        }
//        view.addAnnotations(annotations)
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
         
        
    }
}
