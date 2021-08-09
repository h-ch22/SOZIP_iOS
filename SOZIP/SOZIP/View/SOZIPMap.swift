//
//  SOZIPMap.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/03.
//

import Foundation
import UIKit
import NMapsMap
import CoreLocation
import SwiftUI

class SOZIPMap : UIViewController, CLLocationManagerDelegate{
    var locationManager = CLLocationManager()
    var naverMapView : NMFNaverMapView!
    let models : [SOZIPDataModel]

    init(models : [SOZIPDataModel]){
        self.models = models
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        naverMapView = NMFNaverMapView(frame : view.frame)
        
        naverMapView.showZoomControls = true
        naverMapView.showLocationButton = true
        naverMapView.showCompass = true
        naverMapView.showScaleBar = true
        naverMapView.showIndoorLevelPicker = true
        naverMapView.showLocationButton = true
        naverMapView.mapView.isIndoorMapEnabled = true
        naverMapView.mapView.positionMode = .compass
        naverMapView.mapView.logoAlign = .rightTop
        
        var markers = [NMFMarker]()
        
        view.addSubview(naverMapView)
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationManager.location?.coordinate.latitude as? Double ?? 35.84690631294601,
                                                                   lng: locationManager.location?.coordinate.longitude as? Double ?? 127.12938865558989))
            
            naverMapView.mapView.moveCamera(cameraUpdate)
            
        }
        
        else{
            
        }
        
        for index in 0..<models.count{
            let position = models[index].location
            
            if models[index].status != "closed"{
                let position_split = position.components(separatedBy: ", ")
                
                let marker = NMFMarker(position: NMGLatLng(lat: Double(position_split[0])!, lng: Double(position_split[1])!))
                            
                marker.captionText = models[index].SOZIPName
                marker.captionColor = UIColor(models[index].SOZIP_Color)
                
                marker.subCaptionText = models[index].location_description
                marker.subCaptionColor = .black
                
                marker.iconImage = NMF_MARKER_IMAGE_BLACK
                marker.iconTintColor = UIColor(models[index].SOZIP_Color)
                markers.append(marker)
            }
            
            
        }
        
        DispatchQueue.main.async{
            for marker in markers{
                marker.mapView = self.naverMapView.mapView
            }
        }
    }
}
