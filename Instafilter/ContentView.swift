//
//  ContentView.swift
//  Instafilter
//
//  Created by Eugene on 06/09/2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var showingPicker = false
    
    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
        }
        
        Button("Select image") {
            showingPicker = true
            
        }.sheet(isPresented: $showingPicker) {
            ImagePicker(image: $inputImage)
        }
        .onChange(of: inputImage) { _ in loadImage()}
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
        

        // V old UIKit code
        // - 1 the image to save
        // - 2 the object (class) inherited from NSObject that will handle the method
        // - 3 the method to be called on the class in 2.  Method name string not the method itself.
        // SwiftUI needs this to have a #selector and @objc attribute
        // #selector literally scans the class for the method name to look it up
        // - 4 (not used here) - context.  Some data is returned when 3 is called.
        UIImageWriteToSavedPhotosAlbum(inputImage, nil, nil, nil)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
