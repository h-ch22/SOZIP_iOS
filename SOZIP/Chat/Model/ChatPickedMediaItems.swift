//
//  ChatPickedMediaItems.swift
//  ChatPickedMediaItems
//
//  Created by 하창진 on 2021/08/06.
//

import Foundation

class ChatPickedMediaItems : ObservableObject{
    @Published var items = [PhotoPickerModel]()
    
    func append(item : PhotoPickerModel){
        items.append(item)
    }
}
