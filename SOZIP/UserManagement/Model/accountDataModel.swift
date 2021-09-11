//
//  accountDataModel.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/24.
//

import Foundation

struct accountDataModel : Hashable{
    var bank : String
    var accountNumber : String
    var name : String
    
    init(bank : String, accountNumber : String, name : String){
        self.bank = bank
        self.accountNumber = accountNumber
        self.name = name
    }
}
