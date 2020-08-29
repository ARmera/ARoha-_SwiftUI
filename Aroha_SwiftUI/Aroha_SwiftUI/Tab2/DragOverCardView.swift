//
//  DragOverCardView.swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/08/29.
//  Copyright © 2020 김성헌. All rights reserved.
//

import Foundation
import SwiftUI

struct DragOverCard : View {
    let middle = screenHeight/3;
    let bottom = screenHeight - 200;
    @Environment(\.colorScheme) var colorScheme
    @GestureState private var dragState = DragState.inactive
    @State var position = screenHeight - 200;
    @Binding var showSearchRouteView:Bool
    var body: some View {
        let drag = DragGesture()
        .onEnded(onDragEnded)
        
        return Group {
            Handle()
            DragContentView(position: $position, showSearchRouteView: self.$showSearchRouteView)
        }
        .frame(height: UIScreen.main.bounds.height)
        .background(colorScheme == .dark ? Color.black : Color.white)
        .cornerRadius(20, corners: [.topLeft, .topRight])
        .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
        .offset(y: self.position + self.dragState.translation.height)
        .animation(self.dragState.isDragging ? nil : .interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
        .gesture(drag)
    }
    
    
    private func onDragEnded(drag: DragGesture.Value) {
        let verticalDirection = drag.predictedEndLocation.y - drag.location.y
        let cardTopEdgeLocation = self.position + drag.translation.height
        let positionAbove: CGFloat
        let positionBelow: CGFloat
        
        if cardTopEdgeLocation > bottom{
            positionAbove = bottom;
            positionBelow = bottom
        }else{
            positionAbove = middle;
            positionBelow = bottom
        }
        
        if verticalDirection > 0 {
            self.position = positionBelow
        } else if verticalDirection < 0 {
            self.position = positionAbove
        }
    }
}

enum DragState {
    
    case inactive
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    
    var isDragging: Bool {
        switch self {
        case .inactive:
            return false
        case .dragging:
            return true
        }
    }
    
}

import SwiftUI

struct Handle : View {
    private let handleThickness = CGFloat(5.0)
    var body: some View {
        RoundedRectangle(cornerRadius: handleThickness / 2.0)
            .frame(width: 40, height: handleThickness)
            .foregroundColor(Color.secondary)
            .padding(5)
    }
}

