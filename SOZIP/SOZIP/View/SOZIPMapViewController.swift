//
//  SOZIPMapViewController.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/02.
//

import Foundation
import UIKit
import NMapsMap
import SwiftUI

class SOZIPMapViewController : UIViewController{
    let marker = NMFMarker()
    let location : NMGLatLng!
    let descript : String
    let color : Color
    var naverMapView : NMFNaverMapView!
    
    init(location : NMGLatLng, descript : String, color : Color){
        self.location = location
        self.descript = descript
        self.color = color
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.frame = CGRect(x: 0, y: 0, width : UIScreen.main.bounds.width / 1.2, height : UIScreen.main.bounds.height / 3)
        
        naverMapView = NMFNaverMapView(frame: view.frame)
        naverMapView.showZoomControls = true
        naverMapView.showCompass = true
        naverMapView.showScaleBar = false

        marker.position = location
        marker.iconImage = NMF_MARKER_IMAGE_BLACK
        marker.iconTintColor = UIColor(color)
        marker.captionText = "소집 장소"
        marker.captionColor = UIColor(color)
        
        let cameraUpdate = NMFCameraUpdate(scrollTo : location)
        naverMapView.mapView.moveCamera(cameraUpdate)
        
        marker.subCaptionText = descript 
        
        marker.mapView = naverMapView.mapView
        view.addSubview(naverMapView)
    }
}
