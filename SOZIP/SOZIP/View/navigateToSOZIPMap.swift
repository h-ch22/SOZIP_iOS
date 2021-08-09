//
//  navigateToSOZIPMap.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/03.
//

import SwiftUI

struct navigateToSOZIPMap : View{
    var data : [SOZIPDataModel] = []
    
    var body : some View{
        VStack{
            SOZIPMapController(data : data)
        }
    }
}

struct SOZIPMapController : UIViewControllerRepresentable{
    let data : [SOZIPDataModel]

    typealias UIViewControllerType = SOZIPMap

    func makeUIViewController(context: Context) -> SOZIPMap {
        return SOZIPMap(models: data)
    }

    func updateUIViewController(_ uiViewController: SOZIPMap, context: Context) {
        
    }

}
