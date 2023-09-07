//
//  ImagePicker.swift
//  Instafilter
//
//  Created by Eugene on 06/09/2023.
//

import PhotosUI
import SwiftUI

// allows SwiftUI View to contain a UIKit view controller
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage? // this is so we can use the image in a containing view
    
    // Acts as a delegate for thr PHPickerViewController
    class Coordinator: NSObject, PHPickerViewControllerDelegate {

        // Pass in parent (ImagePicker) struct to the class so we can modify it (the image binding)
        var parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        // This method handles the picker results and allow us to close the sheet
        // - tell picker to dismiss
        // - exit if no selection made - results == []
        // - else grab results and check for UIImage, if exists and can load, add to ImagePicker
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider else { return } // .itemProvider, contains the URL / image data and not the finished image
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.parent.image = image as? UIImage
                }
            }
            
            
            
        }
    }
    
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator // Tells PHPickerViewController to use our coordinator.  Actions in view controller are reported to it
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    // This is the communcator between ImagePicker (SwiftUI) and PHPickerViewController (UIKit)
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
}
