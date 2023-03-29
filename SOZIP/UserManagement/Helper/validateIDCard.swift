//
//  validateIDCard.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/27.
//

import Foundation
import FirebaseMLModelDownloader
import FirebaseFunctions
import UIKit

class validateIDCard : ObservableObject{
    func validate(image : UIImage?, studentNo : String, name : String, completion: @escaping(_ result : String?) -> Void){
        var resultName = false
        var resultStudentNo = false
        var resultSchool = false
        
        guard let imageData = image!.jpegData(compressionQuality: 1.0) else { return }
        let base64encodedImage = imageData.base64EncodedString()
        
        lazy var functions = Functions.functions()
        
        let requestData = [
            "image" : ["content" : base64encodedImage],
            "features" : ["type" : "TEXT_DETECTION"],
            "imageContext" : ["languageHints" : ["ko"]]
        ]
        
        functions.httpsCallable("annotateImage").call(requestData) {(result, error) in
            if let error = error as NSError?{
                if error.domain == FunctionsErrorDomain{
                    let code = FunctionsErrorCode(rawValue : error.code)
                    let message = error.localizedDescription
                    let details = error.userInfo[FunctionsErrorDetailsKey]
                    
                    print("\(code) : \(message)\n\(details)")
                    
                    completion(message)
                    return
                }
            } else{
                guard let annotation = (result?.data as? [String: Any])?["fullTextAnnotation"] as? [String: Any] else { return }
                let text = annotation["text"] as? String ?? ""
                
                guard let pages = annotation["pages"] as? [[String: Any]] else { return }
                for page in pages {
                    var pageText = ""
                    guard let blocks = page["blocks"] as? [[String: Any]] else { continue }
                    for block in blocks {
                        print(block)
                    }
                }
            }
        }
        
//        options.languageHints = ["ko"]
//
//        let textRecognizer = vision.cloudTextRecognizer(options: options)
//
//        let image = VisionImage(image : image!)
//
//        textRecognizer.process(image){result, error in
//            guard error == nil, let result = result else{
//                completion(error?.localizedDescription)
//
//                return
//            }
//
//            let validateGroup = DispatchGroup()
//
//            validateGroup.enter()
//
//            for block in result.blocks{
//
//                for line in block.lines{
//                    let lineText = line.text
//                    let line_num = lineText
//                        .components(separatedBy:CharacterSet.decimalDigits.inverted)
//                        .joined()
//
//                    print(lineText)
//
//                    if line_num.contains(studentNo){
//                        resultStudentNo = true
//                        print("studentNo detected")
//                    }
//
//                    if lineText.contains(name.trimmingCharacters(in: .whitespacesAndNewlines)){
//                        resultName = true
//                        print("name detected")
//                    }
//
//                    if lineText.contains("전북대학교"){
//                        resultSchool = true
//                        print("school detected")
//                    }
//                }
//            }
//
//            validateGroup.leave()
//
//            validateGroup.notify(queue:.main){
//                if resultName && resultStudentNo && resultSchool{
//                    completion("success")
//                }
//
//                else{
//                    completion("fail")
//                }
//            }
//
//
//        }
    }
}
