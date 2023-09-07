//
//  ImageSaver.swift
//  Instafilter
//
//  Created by Eugene on 07/09/2023.
//

import UIKit

class ImageSaver: NSObject {
    
    var successHander: (() -> Void)?
    var errorHander: ((Error) -> Void)?
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        if let error = error {
            errorHander?(error)
        } else {
            successHander?()
        }
        
    }
    
}
