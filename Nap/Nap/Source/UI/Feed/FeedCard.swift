//
//  FeedLargeCard.swift
//  Nap
//
//  Created by YunhakLee on 7/24/24.
//

import SwiftUI

struct FeedCard: View {
    @Binding var showInformation: Bool
    
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
        Image(.feedImage1)
            .resizable()
            .scaledToFill()
        
            .clipShape(RoundedRectangle(cornerRadius: 20.0))
    }
    
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
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.napPurple100)
            Text("오늘 너무 피곤했어요...")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
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
    FeedCard(showInformation: .constant(true))
}

