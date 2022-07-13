//
//  ContentView.swift
//  SimultaniousZoomAndDrag
//
//  Created by Maksim on 13/07/2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                ForEach(1...5, id: \.self) { index in
                    Image("image")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(15)
                        .addPinchToZoom()
                }
                
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
