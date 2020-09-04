//
//  GridLayout.swift
//  Aroha_SwiftUI
//
//  Created by 김성헌 on 2020/09/04.
//  Copyright © 2020 김성헌. All rights reserved.
//

import Foundation
import SwiftUI

struct GridView<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content

    var body: some View {
        ScrollView {
            ForEach(0 ..< rows, id: \.self) { row in
                HStack {
                    ForEach(0 ..< self.columns, id: \.self) { column in
                        self.content(row, column)
                    }
                }
            }
        }
    }

    //컨텐츠 클로저
    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }
}
