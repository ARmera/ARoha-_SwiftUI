//
//  RouteCardView.swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/09/15.
//  Copyright © 2020 김성헌. All rights reserved.
//

import Foundation
import SwiftUI

struct CardView: View {
    @State private var translation: CGSize = .zero
    @State private var swipeStatus: LikeDislike = .none
    
    private var route: RouteInfo
    private var onRemove: (_ user: RouteInfo) -> Void
    
    private var thresholdPercentage: CGFloat = 0.8 // when the user has draged 50% the width of the screen in either direction
    
    private enum LikeDislike: Int {
        case like, dislike, none
    }
    
    init(route: RouteInfo, onRemove: @escaping (_ user: RouteInfo) -> Void) {
        self.route = route
        self.onRemove = onRemove
    }
    
    private func getGesturePercentage(_ geometry: GeometryProxy, from gesture: DragGesture.Value) -> CGFloat {
        gesture.translation.width / geometry.size.width
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                ZStack(alignment: self.swipeStatus == .like ? .topLeading : .topTrailing) {
                    Image("konkuk\(self.route.id)")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.75)
                        .clipped()
                }
                
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Spacer().frame(height:5)
                        HStack{
                            Image("route").frame(width: 20, height: 20)
                            Text("\(self.route.title)")
                                .font(Font.custom("BMJUA", size: 20))
                                .bold()
                        }
                        Spacer().frame(height:3)
                        HStack{
                            Image(systemName: "timer").foregroundColor(.gray)
                            Text("\(String(format:"%.1f",self.route.estimated_time)) 분 소요 됩니다.")
                                .font(Font.custom("SpoqaHanSans-Regular", size: 15))
                                .foregroundColor(.gray)
                        }
                        HStack{
                            Image(systemName: "tortoise.fill").foregroundColor(.gray)
                            Text("\(String(format:"%.1f",self.route.total_distance)) km")
                            .font(Font.custom("SpoqaHanSans-Regular", size: 15))
                            .foregroundColor(.gray)
                        }
                    }
                    Spacer()
                    
                    Image(systemName: "info.circle")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
            }
            .padding(.bottom)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .animation(.interactiveSpring())
            .offset(x: self.translation.width, y: 0)
            .rotationEffect(.degrees(Double(self.translation.width / geometry.size.width) * 25), anchor: .bottom)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        self.translation = value.translation
                        
                }.onEnded { value in
                    // determine snap distance > 0.5 aka half the width of the screen
                    if abs(self.getGesturePercentage(geometry, from: value)) > self.thresholdPercentage {
                        self.onRemove(self.route)
                    } else {
                        self.translation = .zero
                    }
                }
            )
        }
    }
}
