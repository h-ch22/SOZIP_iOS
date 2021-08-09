//
//  SheetKey.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/29.
//

import Foundation
import SwiftUI

struct PresentationKey : EnvironmentKey{
    static let defaultValue: [Binding<Bool>] = []
    
}

extension EnvironmentValues {
    var presentations: [Binding<Bool>] {
        get { return self[PresentationKey] }
        set { self[PresentationKey] = newValue }
    }
}
