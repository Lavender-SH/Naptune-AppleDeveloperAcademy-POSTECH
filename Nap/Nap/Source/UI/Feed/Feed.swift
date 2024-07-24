//
//  Feed.swift
//  Nap
//
//  Created by YunhakLee on 7/24/24.
//

import SwiftUI

struct Feed: View {
    @State var isLargeCard: Bool = true
    
    var columns: [GridItem] {
        isLargeCard ? [GridItem()] : [GridItem(), GridItem()]
    }
    
    var spacing: CGFloat {
        isLargeCard ? 24 : 12
    }
    
    var body: some View {
        GeometryReader { proxy in
            let cardWidth = isLargeCard ? proxy.size.width :
                                         (proxy.size.width-20)/2
            ScrollView {
                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach(0..<10) { _ in
                        FeedLargeCard(showInformation: $isLargeCard)
                            .frame(width: cardWidth, height: cardWidth/3*4)
                    }
                }
            }
            .scrollIndicators(.never)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    Feed()
}
