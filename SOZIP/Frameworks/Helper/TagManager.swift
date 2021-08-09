//
//  TagManager.swift
//  SOZIP
//
//  Created by 하창진 on 2021/07/30.
//

import Foundation
import Firebase

class TagManager : ObservableObject{
    @Published var tags = []
    @Published var categoryList : [TagCategoryDataModel] = []
    var category : [String] = []
    var category_KR : [String] = []
    private let db = Firestore.firestore()
    
    func getTag(){
        
    }
    
    func getCategory(){
        let docRef = db.collection("Tags").document("CategoryKR")
        self.categoryList.append(TagCategoryDataModel(category_KR: "전체", category: "All"))
        
        var cnt = 0
        
        docRef.getDocument(){(document, error) in
            if let document = document, document.exists{
                let categoryList = Array(document.data()!.keys)
                
                for i in 0..<categoryList.count{
                    if let info = document.data()!["categoryList"] as? [String : Any]{
                        let categories = info.map{$0.value}
                        self.category.append(contentsOf: info.keys)
                        
                        var cnt = 0
                        
                        for category in self.category{
                            if !self.categoryList.contains(where: {($0.category == category)}){
                                self.categoryList.append(TagCategoryDataModel(category_KR: categories[cnt] as! String, category: category))
                            }
                            
                            cnt+=1
                        }
                        
                    }
                }
            }
            
            else{
                
            }
        }
    }
}
