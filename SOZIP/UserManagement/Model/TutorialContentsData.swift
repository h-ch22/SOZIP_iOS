//
//  TutorialContents.swift
//  SOZIP
//
//  Created by 하창진 on 2021/09/04.
//

import SwiftUI

struct TutorialContentsData: Hashable, Identifiable {
    let id : Int
    let background : Color
    let objectImage : String
    let primaryText : String
    let secondaryText : String
    
    static let contents_idCard : [TutorialContentsData] = [
        TutorialContentsData(id: 0, background : .tutorial_color_1, objectImage: "", primaryText: "1. 실물 학생증 촬영하기", secondaryText: "인적사항이 잘 보이도록 실물 학생증을 촬영해주세요!"),
        TutorialContentsData(id: 1, background : .tutorial_color_2, objectImage: "", primaryText: "2. 학생증 편집하기", secondaryText: "인적사항이 잘 보이도록 크기를 조절해주세요!"),
        TutorialContentsData(id: 2, background : .tutorial_color_3, objectImage: "", primaryText: "준비 완료!", secondaryText: "아래 버튼을 누르고 진행해보세요!")
    ]
    
    static let contents_mobileIdCard : [TutorialContentsData] = [
        TutorialContentsData(id: 0, background : .tutorial_color_1, objectImage: "", primaryText: "1. 모바일 학생증 캡처하기", secondaryText: "전북대앱 > 우측 상단 메뉴 > 오아시스 화면을 캡처하세요!"),
        TutorialContentsData(id: 1, background : .tutorial_color_2, objectImage: "", primaryText: "2. 학생증 편집하기", secondaryText: "인적사항이 잘 보이도록 위치를 조절해주세요!"),
        TutorialContentsData(id: 2, background : .tutorial_color_3, objectImage: "", primaryText: "준비 완료!", secondaryText: "아래 버튼을 누르고 진행해보세요!")
    ]
}
