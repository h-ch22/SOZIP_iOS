//
//  participateSOZIPResultModel.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/02.
//

import Foundation

enum participateSOZIPResultModel : Identifiable{
    case success, error, already_participated, blankField, exit, done_exit, error_exit, already_exit, done_close, error_close, already_close, close, noPayMethod, done_update, error_update, requireAccept, pause, done_pause, error_pause, resume, done_resume, error_resume
    
    var id : Int{
        hashValue
    }
}
