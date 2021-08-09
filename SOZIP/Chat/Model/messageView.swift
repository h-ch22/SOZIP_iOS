//
//  messageView.swift
//  messageView
//
//  Created by 하창진 on 2021/08/04.
//

import SwiftUI
import Firebase

struct messageView: View {
    let items : ChatDataModel
    let color : Color
    
    var body: some View {
        HStack(alignment : .bottom, spacing : 15){
            if items.sender != Auth.auth().currentUser?.uid{
                
            }
            
            else{
                Spacer()
            }
            
            chatBubble(message: items.msg, sender: items.sender, color: color, type : items.type, participants : items.participants, index : items.index, docId : items.docId, items : items.items)
        }
    }
}
