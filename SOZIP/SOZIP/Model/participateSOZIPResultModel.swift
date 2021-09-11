//
//  participateSOZIPResultModel.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/02.
//

import Foundation

enum participateSOZIPResultModel : Identifiable{
    case success, error, already_participated, exit, done_exit, error_exit, already_exit, done_close, error_close, already_close, close, requireAccept, pause, done_pause, error_pause, resume, done_resume, error_resume, limitPeople
    
    var id : Int{
        hashValue
    }
}
