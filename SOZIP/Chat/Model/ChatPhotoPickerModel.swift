//
//  ChatPhotoPickerModel.swift
//  SOZIP
//
//  Created by 하창진 on 2021/09/05.
//

import SwiftUI
import Photos

struct ChatPhotoPickerModel : Identifiable{
    enum MediaType{
        case photo
    }
    
    var id : String
    var photo : UIImage?
    var url : URL?
    var mediaType : MediaType = .photo
    
    init(with url : URL){
        mediaType = .photo
        id = UUID().uuidString
        self.url = url
        
        if let data = try? Data(contentsOf : url){
            photo = UIImage(data : data)
        }
    }
}
