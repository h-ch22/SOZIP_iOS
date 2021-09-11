//
//  showMapView.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/02.
//

import Combine
import SwiftUI
import NMapsMap

struct showMapView : UIViewControllerRepresentable{
    let data : SOZIPDataModel
    
    typealias UIViewControllerType = SOZIPMapViewController
    
    func makeUIViewController(context: Context) -> SOZIPMapViewController {
        let loc_split = data.location.components(separatedBy: ", ")
        
        return SOZIPMapViewController(location: NMGLatLng(lat : Double(loc_split[0])!, lng : Double(loc_split[1])!), descript: data.location_description, color : data.color)
    }
    
    func updateUIViewController(_ uiViewController: SOZIPMapViewController, context: Context) {
    }
}
