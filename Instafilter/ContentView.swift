//
//  ContentView.swift
//  Instafilter
//
//  Created by Eugene on 06/09/2023.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ContentView: View {
    
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var filterRadius = 0.5
    @State private var filterScale = 0.5
    
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var processedImage: UIImage?
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()

    @State private var selectedFilterName = "Sepia"
    @State private var showingFilterSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(.secondary)
                    
                    Text("Tap to select picture")
                        .foregroundColor(.white)
                        .font(.headline)
                    
                    image?
                        .resizable()
                        .scaledToFit()
                    
                    
                }
                .onTapGesture {
                    showingImagePicker = true
                }
                
                VStack {
                    Text(selectedFilterName)
                        .font(.subheadline)
                        .padding(.bottom)
                    
                    Text("Intensity")
                    Slider(value: $filterIntensity)
                        .onChange(of: filterIntensity) { _ in applyProcessing()}
                    
                    Text("Radius")
                    Slider(value: $filterRadius)
                        .onChange(of: filterRadius) { _ in applyProcessing()}
                    
                    Text("Scale")
                    Slider(value: $filterScale)
                        .onChange(of: filterScale) { _ in applyProcessing()}
                }
                .padding(.vertical)
                
                HStack {
                    Button("Change Filter") {
                       showingFilterSheet = true
                    }
                    
                    Spacer()
                    
                    Button("Save", action: save)
                        .disabled(image == nil)
                }
                
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("InstaFilter")
            .onChange(of: inputImage) { _ in loadImage() }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $inputImage)
            }
            .confirmationDialog("Select Filter", isPresented: $showingFilterSheet) {
                Button("Crystallize") {
                    selectedFilterName = "Crystallize"
                    setFilter(CIFilter.crystallize())
                    
                }
                Button("Edges") {
                    selectedFilterName = "Edges"
                    setFilter(CIFilter.edges())
                    
                }
                Button("Gaussian Blur") {
                    selectedFilterName = "Gaussian Blur"
                    setFilter(CIFilter.gaussianBlur())
                    
                }
                Button("Pixellete") {
                    selectedFilterName = "Pixellate"
                    setFilter(CIFilter.pixellate())
                    
                }
                Button("Sepia") {
                    selectedFilterName = "Sepia"
                    setFilter(CIFilter.sepiaTone())
                    
                }
                Button("Unsharp Mask") {
                    selectedFilterName = "Unsharp Mask"
                    setFilter(CIFilter.unsharpMask())
                    
                }
                Button("Vignette") {
                    selectedFilterName = "Vignette"
                    setFilter(CIFilter.vignette())
                    
                }
                Button("Comic") {
                    selectedFilterName = "Comic"
                    setFilter(CIFilter.comicEffect())
                    
                }
                Button("Bokeh") {
                    selectedFilterName = "Bokeh"
                    setFilter(CIFilter.bokehBlur())

                }
  
                // 10 view limit !!
                
                Button("Cancel", role: .cancel) { }
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()

    }
    
    func save() {
        guard let processedImage = processedImage else { return }
        
        let imageSaver = ImageSaver()
        
        imageSaver.successHander = {
            print("Success")
        }
        imageSaver.errorHander = {
            print("Oops. \($0.localizedDescription)")
        }
        
        imageSaver.writeToPhotoAlbum(image: processedImage)
        
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        print(inputKeys)
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterRadius * 200, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterScale * 100, forKey: kCIInputScaleKey)
        }
        
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            processedImage = uiImage
            image = Image(uiImage: uiImage)
        }
    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
        applyProcessing()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
