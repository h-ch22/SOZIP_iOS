//
//  SOZIPLocationReceiver.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/02.
//

import Foundation

class SOZIPLocationReceiver : ObservableObject{
    @Published var location = ""
    @Published var description = ""
    @Published var address = ""
}
