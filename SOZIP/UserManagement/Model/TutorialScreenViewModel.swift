//
//  TutorialScreenViewModel.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/02.
//

import Foundation

enum TutorialScreenViewModel : Identifiable{
    case real, mobile
    
    var id : Int{
        hashValue
    }
}
