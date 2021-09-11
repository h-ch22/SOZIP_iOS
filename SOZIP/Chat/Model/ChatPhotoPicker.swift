//
//  ChatPhotoPicker.swift
//  SOZIP
//
//  Created by 하창진 on 2021/08/27.
//

import SwiftUI
import PhotosUI
import MobileCoreServices

struct ChatPhotoPicker : UIViewControllerRepresentable{
    typealias UIViewControllerType = PHPickerViewController
    
    @Binding var isPresented : Bool
    @ObservedObject var mediaItems : ChatPickedMediaItems
    
    var didFinishPicking : (_ didSelectItems : Bool) -> Void
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 10
        config.preferredAssetRepresentationMode = .current
        
        let controller = PHPickerViewController(configuration: config)
        controller.delegate = context.coordinator
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(with : self)
    }
    
    class Coordinator : PHPickerViewControllerDelegate{
        var photoPicker : ChatPhotoPicker
        
        init(with photoPicker : ChatPhotoPicker){
            self.photoPicker = photoPicker
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            guard !results.isEmpty else{
                self.photoPicker.isPresented = false

                return
            }
            
            for result in results{
                let itemProvider = result.itemProvider
                guard let typeIdentifier = itemProvider.registeredTypeIdentifiers.first, let utType = UTType(typeIdentifier) else{return}
                
                self.getPhoto(from : itemProvider, typeIdentifier: typeIdentifier)
            }
        
        }
        
        private func getPhoto(from itemProvider : NSItemProvider, typeIdentifier : String){
            itemProvider.loadFileRepresentation(forTypeIdentifier: typeIdentifier){url, error in
                if let error = error{
                    print(error)
                    self.photoPicker.isPresented = false

                    return
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
                        self.photoPicker.mediaItems.append(item:ChatPhotoPickerModel(with: targetURL))
                    }
                    
                    self.photoPicker.didFinishPicking(true)
                    
                    self.photoPicker.isPresented = false
                }  catch{print(error)}
            }
        }
    }
}
