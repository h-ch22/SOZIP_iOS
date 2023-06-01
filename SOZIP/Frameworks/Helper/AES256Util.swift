//
//  AES256Util.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/28.
//

import Foundation
import CryptoSwift

class AES256Util{
    private static let SECRET_KEY = ""
    private static let IV = ""
    private static let str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

    private static func getAESObject() -> AES{
        let keyDecodes : Array<UInt8> = Array(SECRET_KEY.utf8)
        let ivDecodes : Array<UInt8> = Array(IV.utf8)
        let aesObject = try! AES(key: keyDecodes, blockMode: CBC(iv: ivDecodes), padding: .pkcs5)
        
        return aesObject
    }
    
    static func encrypt(string : String) -> String{
        guard !string.isEmpty else{return ""}
        return try! getAESObject().encrypt(string.bytes).toBase64()
    }
    
    static func decrypt(encoded : String) -> String{
        var encoded_new = encoded
        
        if encoded.contains {$0.isNewline}{
            let encodedAsDeletedLineSeperator = encoded.split(whereSeparator : \.isNewline)
            encoded_new = String(encodedAsDeletedLineSeperator[0])
        }
        
        let datas = Data(base64Encoded: encoded_new)

        
        guard datas != nil else {
            print("data variable is null (original data : \(encoded_new))")
            
            return ""
        }
                
        if encoded_new == ""{
            print("encoded variable is empty string")
            
            return ""
        }
 
        let bytes = datas!.bytes
        let decode = try! getAESObject().decrypt(bytes)
 
        return String(bytes: decode, encoding: .utf8) ?? ""
    }
}
