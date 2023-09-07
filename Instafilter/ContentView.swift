//
//  ContentView.swift
//  Instafilter
//
//  Created by Eugene on 06/09/2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var image: Image?
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
            ImagePicker()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
