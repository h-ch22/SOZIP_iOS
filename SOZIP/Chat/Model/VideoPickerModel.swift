//
//  VideoPickerModel.swift
//  VideoPickerModel
//
//  Created by 하창진 on 2021/08/06.
//

import SwiftUI
import Photos

struct VieoPickerModel : Identifiable{
    var id : String
    var url : URL?
    
    var mediaType : MediaType = .video
    
    init(with url : URL){
        id = UUID().uuidString
        mediaType = .video
        self.url = url
    }
}
