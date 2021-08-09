//
//  CheckBox_w.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/02.
//

import SwiftUI

struct CheckBox_w: View {
    @Binding var checked: Bool

    var body: some View {
        Image(systemName: checked ? "checkmark.circle.fill" : "circle")
            .foregroundColor(checked ? .white : .accent)
    }
}
