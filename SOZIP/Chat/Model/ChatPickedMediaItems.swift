//
//  ChatPickedMediaItems.swift
//  SOZIP
//
//  Created by 하창진 on 2021/09/05.
//

import Foundation
import PhotosUI
import SwiftUI

class ChatPickedMediaItems : ObservableObject{
    @Published var items = [ChatPhotoPickerModel]()
    
    func append(item : ChatPhotoPickerModel){
        items.append(item)
    }
}
