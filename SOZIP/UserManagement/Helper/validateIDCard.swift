//
//  validateIDCard.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/27.
//

import Foundation
import FirebaseMLVision

class validateIDCard : ObservableObject{
    let vision = Vision.vision()
    
    func validate(image : UIImage?, studentNo : String, name : String, completion: @escaping(_ result : String?) -> Void){
        var resultName = false
        var resultStudentNo = false
        var resultSchool = false
        let options = VisionCloudTextRecognizerOptions()
        options.languageHints = ["ko"]
        
        let textRecognizer = vision.cloudTextRecognizer(options: options)
        
        let image = VisionImage(image : image!)

        textRecognizer.process(image){result, error in
            guard error == nil, let result = result else{
                completion(error?.localizedDescription)
                                
                return
            }
                        
            let validateGroup = DispatchGroup()

            validateGroup.enter()
            
            for block in result.blocks{

                for line in block.lines{
                    let lineText = line.text
                    let line_num = lineText
                        .components(separatedBy:CharacterSet.decimalDigits.inverted)
                        .joined()
                    
                    print(lineText)
                    
                    if line_num.contains(studentNo){
                        resultStudentNo = true
                        print("studentNo detected")
                    }
                    
                    if lineText.contains(name.trimmingCharacters(in: .whitespacesAndNewlines)){
                        resultName = true
                        print("name detected")
                    }
                    
                    if lineText.contains("전북대학교"){
                        resultSchool = true
                        print("school detected")
                    }
                }
            }
            
            validateGroup.leave()

            validateGroup.notify(queue:.main){
                if resultName && resultStudentNo && resultSchool{
                    completion("success")
                }
                
                else{
                    completion("fail")
                }
            }
            

        }
    }
}
