//
//  FeedLargeCard.swift
//  Nap
//
//  Created by YunhakLee on 7/24/24.
//

import SwiftUI

struct FeedLargeCard: View {
    
    var body: some View {
        Image(.feedImage1)
            .resizable()
            .scaledToFill()
            .frame(width: 300, height: 400)
            .clipShape(RoundedRectangle(cornerRadius: 20.0))
            .overlay(alignment: .topLeading) {
                UserProfile
                    .padding(16)
            }
            
    }
}

extension FeedLargeCard {
    var UserProfile: some View {
        HStack {
            Image(.feedImage6)
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 32, height: 32)
            VStack(alignment: .leading, spacing: 1) {
                Text("hash.jung")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                Text("2시간 전")
                    .font(.system(size: 10, weight: .regular))
                    .foregroundStyle(.white)
            }
        }
        .padding(6)
        .padding(.trailing, 10)
        .background {
            BackgroundBlur(radius: 6)
                .clipShape(Capsule())
        }
    }
}

#Preview {
    FeedLargeCard()
}

