//
//  ChatPhotoPicker.swift
//  ChatPhotoPicker
//
//  Created by 하창진 on 2021/08/06.
//

import SwiftUI
import PhotosUI

struct ChatPhotoPicker : UIViewControllerRepresentable{
    @ObservedObject var mediaItems : ChatPickedMediaItems
    @Binding var isPresented : Bool
    @Binding var mediaType : MediaType?
    
    let rootDocId : String
    let helper : ChatHelper
        
    typealias UIViewControllerType = PHPickerViewController

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator : PHPickerViewControllerDelegate{
        var photoPicker : ChatPhotoPicker

        init(_ photoPicker : ChatPhotoPicker){
            self.photoPicker = photoPicker
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

            guard !results.isEmpty else{
                return
            }
            
            var currentIndex = 0
            
            for result in results{
                currentIndex+=1
                let itemProvider = result.itemProvider
                guard let typeIdentifier = itemProvider.registeredTypeIdentifiers.first, let utType = UTType(typeIdentifier) else{continue}

                self.getPhoto(from: itemProvider, typeIdentifier: typeIdentifier, helper : self.photoPicker.helper, rootDocId: self.photoPicker.rootDocId, index : results.count, currentIndex : currentIndex)
                
            }
                        
            self.photoPicker.isPresented = false
        }

        private func getPhoto(from itemProvider : NSItemProvider, typeIdentifier : String, helper : ChatHelper, rootDocId : String, index : Int, currentIndex : Int){
            print("index : \(index), currentIndex : \(currentIndex)")

            itemProvider.loadFileRepresentation(forTypeIdentifier: typeIdentifier){url, error in
                if let error = error{
                    print(error)
                }

                guard let url = url else{return}

                let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                guard let targetURL = documentDirectory?.appendingPathComponent(url.lastPathComponent) else{return}

                do{
                    if FileManager.default.fileExists(atPath: targetURL.path){
                        try FileManager.default.removeItem(at: targetURL)
                    }

                    try FileManager.default.copyItem(at: url, to: targetURL)

                    DispatchQueue.main.async{
                        self.photoPicker.mediaItems.append(item:PhotoPickerModel(with: targetURL))
                        
                    }
                    
                }  catch{print(error)}
                
                if currentIndex == index{
                    helper.sendImage(rootDocId: rootDocId, mediaItems: self.photoPicker.mediaItems){result in
                        guard let result = result else{return}
                    }
                }
                
                self.photoPicker.isPresented = false
            }
        }
        
        
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        if !mediaItems.items.isEmpty{
            mediaItems.items.removeAll()
        }

        var config = PHPickerConfiguration()
        
        switch mediaType{
        case .photo:
            config.filter = .images
            config.selectionLimit = 10
            
        case .video:
            config.filter = .videos
            config.selectionLimit = 1
        case .none:
            break
        }
        
        config.preferredAssetRepresentationMode = .current

        let controller = PHPickerViewController(configuration: config)
        controller.delegate = context.coordinator

        return controller
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {

    }
}
