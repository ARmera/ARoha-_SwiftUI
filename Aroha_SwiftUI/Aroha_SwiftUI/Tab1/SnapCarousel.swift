//
//  SnapCarousel.swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/07/25.
//  Copyright © 2020 김성헌. All rights reserved.
//

import Foundation
import SwiftUI

struct SnapCarousel: View {
    var UIState: UIStateModel
    @EnvironmentObject var settings:UserSettings
    var body: some View
    {
        let spacing:            CGFloat = 30
        let widthOfHiddenCards: CGFloat = 60    // UIScreen.main.bounds.width - 10
        let cardHeight:         CGFloat = 200
        
        
        return  Canvas
            {
                //
                // TODO: find a way to avoid passing same arguments to Carousel and Item
                //
                Carousel( numberOfItems: CGFloat( self.settings.currentBeaconList.count ), spacing: spacing, widthOfHiddenCards: widthOfHiddenCards )
                {
                    ForEach( self.settings.currentBeaconList, id: \.self.index ) { item in
                        Item( _id:                  Int((item as BeaconInfo).index),
                              spacing:              spacing,
                              widthOfHiddenCards:   widthOfHiddenCards,
                              cardHeight:           cardHeight )
                        {

                            ZStack{
                                Image("konkuk-logo").resizable().opacity(0.5)
                                    .offset(x: 70, y: 70).background(Color("blue200")).foregroundColor(Color("blue200"))
                                VStack{
                                    Text("\((item as BeaconInfo).title)").font(Font.custom("BMJUA", size: 20))
                                    Text("\((item as BeaconInfo).description)")
                                    .font(Font.custom("SpoqaHanSans-Regular", size: 10))
                                }
                                //MARK: -하드코딩
                                if((item as BeaconInfo).index < 4){
                                    Text("Clear")
                                        .font(.headline)
                                        .padding()
                                        .cornerRadius(10)
                                        .foregroundColor(Color.blue)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.blue, lineWidth: 3.0)
                                    ).padding(24)
                                        .rotationEffect(Angle.degrees(45))
                                    .offset(x: 80, y: -15)
                                }else if((item as BeaconInfo).index == 2){
                                    Text("진행중")
                                        .font(.headline)
                                        .padding()
                                        .cornerRadius(10)
                                        .foregroundColor(Color.green)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.green, lineWidth: 3.0)
                                    ).padding(24)
                                        .rotationEffect(Angle.degrees(45))
                                    .offset(x: 80, y: -15)
                                }
                                
                            }
                        }
                        .foregroundColor( Color.black )
                        .background( Color("blue200") )
                        .cornerRadius( 8 )
                        .shadow( color: Color( "Blue200" ), radius: 4, x: 0, y: 4 )
                        .transition( AnyTransition.slide )
                        .animation( .spring() )
                    }
                }
                .environmentObject( self.UIState )
        }
    }
}



struct Card: Decodable, Hashable, Identifiable
{
    var id:     Int
    var name:   String = ""
}



public class UIStateModel: ObservableObject
{
    @Published var activeCard: Int      = 0
    @Published var screenDrag: Float    = 0.0
}



struct Carousel<Items : View> : View {
    let items: Items
    let numberOfItems: CGFloat //= 8
    let spacing: CGFloat //= 16
    let widthOfHiddenCards: CGFloat //= 32
    let totalSpacing: CGFloat
    let cardWidth: CGFloat
    
    @GestureState var isDetectingLongPress = false
    
    @EnvironmentObject var UIState: UIStateModel
    
    @inlinable public init(
        numberOfItems: CGFloat,
        spacing: CGFloat,
        widthOfHiddenCards: CGFloat,
        @ViewBuilder _ items: () -> Items) {
        
        self.items = items()
        self.numberOfItems = numberOfItems
        self.spacing = spacing
        self.widthOfHiddenCards = widthOfHiddenCards
        self.totalSpacing = (numberOfItems - 1) * spacing
        self.cardWidth = UIScreen.main.bounds.width - (widthOfHiddenCards*2) - (spacing*2) //279
        
    }
    
    var body: some View {
        
        let totalCanvasWidth: CGFloat = (cardWidth * numberOfItems) + totalSpacing
        let xOffsetToShift = (totalCanvasWidth - UIScreen.main.bounds.width) / 2
        let leftPadding = widthOfHiddenCards + spacing
        let totalMovement = cardWidth + spacing
        
        let activeOffset = xOffsetToShift + (leftPadding) - (totalMovement * CGFloat(UIState.activeCard))
        let nextOffset = xOffsetToShift + (leftPadding) - (totalMovement * CGFloat(UIState.activeCard) + 1)
        
        var calcOffset = Float(activeOffset)
        
        if (calcOffset != Float(nextOffset)) {
            calcOffset = Float(activeOffset) + UIState.screenDrag
        }
        
        return HStack(alignment: .center, spacing: spacing) {
            items
        }
        .offset(x: CGFloat(calcOffset), y: 0)
        .gesture(DragGesture().updating($isDetectingLongPress) { currentState, gestureState, transaction in
            self.UIState.screenDrag = Float(currentState.translation.width)
            
        }.onEnded { value in
            self.UIState.screenDrag = 0
            
            if (value.translation.width < -50) {
                self.UIState.activeCard = self.UIState.activeCard + 1
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            }
            
            if (value.translation.width > 50) {
                self.UIState.activeCard = self.UIState.activeCard - 1
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
            }
        })
    }
}



struct Canvas<Content : View> : View {
    let content: Content
    @EnvironmentObject var UIState: UIStateModel
    
    @inlinable init(@ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
    }
}



struct Item<Content: View>: View {
    @EnvironmentObject var UIState: UIStateModel
    let cardWidth: CGFloat
    let cardHeight: CGFloat
    
    var _id: Int
    var content: Content
    
    @inlinable public init(
        _id: Int,
        spacing: CGFloat,
        widthOfHiddenCards: CGFloat,
        cardHeight: CGFloat,
        @ViewBuilder _ content: () -> Content
    ) {
        self.content = content()
        self.cardWidth = UIScreen.main.bounds.width - (widthOfHiddenCards*2) - (spacing*2) //279
        self.cardHeight = cardHeight
        self._id = _id
    }
    
    var body: some View {
        content
            .frame(width: cardWidth, height: _id == UIState.activeCard ? cardHeight : cardHeight - 60, alignment: .center)
    }
}


