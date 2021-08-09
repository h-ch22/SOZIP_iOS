//
//  PhotoPickerModel.swift
//  PhotoPickerModel
//
//  Created by 하창진 on 2021/08/06.
//

import SwiftUI
import Photos

struct PhotoPickerModel : Identifiable{
    var id : String
    var photo : UIImage?
    var url : URL?
    
    var mediaType : MediaType = .photo
    
    init(with url : URL){
        id = UUID().uuidString
        mediaType = .photo
        self.url = url
        
        if let data = try? Data(contentsOf: url){
            photo = UIImage(data : data)
        }
    }
}
