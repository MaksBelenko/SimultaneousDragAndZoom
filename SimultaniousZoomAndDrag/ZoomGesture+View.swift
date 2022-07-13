//
//  ZoomGesture+View.swift
//  SimultaniousZoomAndDrag
//
//  Created by Maksim on 13/07/2022.
//

import SwiftUI

struct ZoomGesture: UIViewRepresentable {
    
    var size: CGSize
    @Binding var scale: CGFloat
    @Binding var offset: CGPoint
    @Binding var scalePosition: CGPoint
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        view.backgroundColor = .clear
        
        let pinchGesture = UIPinchGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePinch(sender:)))
        
        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handlePan(sender:)))
        
        panGesture.delegate = context.coordinator
        
        view.addGestureRecognizer(pinchGesture)
        view.addGestureRecognizer(panGesture)
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        
        private var parent: ZoomGesture
        
        init(parent: ZoomGesture) {
            self.parent = parent
        }
        
        func gestureRecognizer(
            _ gestureRecognizer: UIGestureRecognizer,
            shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
        ) -> Bool {
            return true
        }
        
        @objc func handlePan(sender: UIPanGestureRecognizer) {
            sender.minimumNumberOfTouches = 2
            
            if (sender.state == .began || sender.state == .changed) && parent.scale > 0 {
                if let view = sender.view {
                    let translation = sender.translation(in: view)
                    parent.offset = translation
                }
            } else {
                withAnimation {
                    parent.offset = .zero
                }
            }
        }
        
        @objc func handlePinch(sender: UIPinchGestureRecognizer) {
            if sender.state == .began || sender.state == .changed {
                parent.scale = sender.scale - 1
                
                let scalePoint  = CGPoint(
                    x: sender.location(in: sender.view).x / sender.view!.frame.size.width,
                    y: sender.location(in: sender.view).y / sender.view!.frame.size.height
                )
                
                // result will be ((0...1),(0...1))
                parent.scalePosition = parent.scalePosition == .zero ? scalePoint : parent.scalePosition
                
            } else {
                withAnimation(.easeInOut(duration: 0.35)) {
                    parent.scale = -1
                    parent.scalePosition = .zero
                }
            }
        }
    }
    
}
