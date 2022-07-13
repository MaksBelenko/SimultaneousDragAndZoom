//
//  PinchZoom+ViewModifier.swift
//  SimultaniousZoomAndDrag
//
//  Created by Maksim on 13/07/2022.
//

import SwiftUI

extension View {
    
    func addPinchToZoom() -> some View {
        return PinchZoomContext { self }
    }
    
}

struct PinchZoomContext<Content: View>: View {
    
    var content: Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    @State private var offset = CGPoint.zero
    @State private var scale = CGFloat.zero
    @State private var scalePosition = CGPoint.zero
    
    
    var body: some View {
        content
            .offset(x: offset.x, y: offset.y)
            .overlay {
                GeometryReader { proxy in
                    let size = proxy.size

                    ZoomGesture(size: size, scale: $scale, offset: $offset, scalePosition: $scalePosition)
                }
            }
            .scaleEffect(1 + (scale < 0 ? 0 : scale), anchor: .init(x: scalePosition.x, y: scalePosition.y))
            .zIndex(scale != 0 ? 1000 : 0)
            .onChange(of: scale) { newValue in
                if scale == -1 {
                    // Give some time to finish animation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        scale = 0
                    }
                }
            }
    }
    
}
