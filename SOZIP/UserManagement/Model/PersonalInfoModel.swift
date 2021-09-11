//
//  PersonalInfoModel.swift
//  SOZIP
//
//  Created by 하창진 on 2021/09/06.
//

import Foundation

struct PersonalInfoModel : Hashable{
    var name : String
    var phone : String
    var email : String
    var studentNo : String
    var school : String
    var nickName : String
    
    init(name : String, phone : String, email : String, studentNo : String, school : String, nickName : String){
        self.name = name
        self.phone = phone
        self.email = email
        self.studentNo = studentNo
        self.school = school
        self.nickName = nickName
    }
}
