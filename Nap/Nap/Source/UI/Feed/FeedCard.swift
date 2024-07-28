//
//  FeedLargeCard.swift
//  Nap
//
//  Created by YunhakLee on 7/24/24.
//

import SwiftUI

struct FeedCard: View {
    @Binding var showInformation: Bool
    let image: Image
    
    // MARK: Body
    
    var body: some View {
        FeedImage
            .overlay(alignment: .topLeading) {
                showInformation ? AnyView(UserProfile) : AnyView(EmptyView())
            }
            .overlay(alignment: .bottomLeading) {
                showInformation ? AnyView(SleepResult) : AnyView(EmptyView())
            }
    }
}

extension FeedCard {
    // MARK: View
    
    var FeedImage: some View {
        image
            .resizable()
            .scaledToFill()
            .clipShape(RoundedRectangle(cornerRadius: 20.0))
    }
    
    var UserProfile: some View {
        HStack {
            image
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: 32, height: 32)
            VStack(alignment: .leading, spacing: 1) {
                Text("hash.jung")
                    .font(.napCaption1)
                Text("2시간 전")
                    .font(.napFootnote2)
            }
            .foregroundStyle(.napWhite100)
        }
        .padding(6)
        .padding(.trailing, 10)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .padding(16)
    }
    
    var SleepResult: some View {
        HStack(spacing: 8) {
            SleepComment
            SleepStatus
        }
        .padding(16)
    }
    
    var SleepComment: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("30분 쿨쿨")
                .font(.napFootnote1)
                .foregroundStyle(.napBlue100)
            Text("오늘 너무 피곤했어요...")
                .font(.napCaption1)
                .foregroundStyle(.napWhite100)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 24)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
    }
    
    var SleepStatus: some View {
        Text("😑")
            .font(.system(size: 32))
            .padding(10)
            .background(.ultraThinMaterial)
            .clipShape(Circle())
    }
}

// MARK: - Previews

#Preview {
    FeedCard(showInformation: .constant(true), image: Image(.feedImage7))
}

