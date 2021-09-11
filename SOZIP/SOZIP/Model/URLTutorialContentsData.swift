//
//  URLTutorialContentsData.swift
//  SOZIP
//
//  Created by 하창진 on 2021/09/05.
//

import SwiftUI

struct URLTutorialContentsData: Hashable, Identifiable {
    let id : Int
    let objectImage : String
    let primaryText : String
    let secondaryText : String
    
    static let contents : [URLTutorialContentsData] = [
        URLTutorialContentsData(id: 0, objectImage: "urlTutorialImg_1", primaryText: "1. 복사 준비하기", secondaryText: "배달앱에서 [공유] 버튼을 누르세요"),
        URLTutorialContentsData(id: 1, objectImage: "urlTutorialImg_2", primaryText: "2. URL 복사하기", secondaryText: "[복사] 버튼을 눌러서 URL을 복사하세요."),
        URLTutorialContentsData(id: 2, objectImage: "urlTutorialImg_3", primaryText: "3. URL 붙여넣기", secondaryText: "복사한 URL을 붙여넣으세요!")
    ]
}
