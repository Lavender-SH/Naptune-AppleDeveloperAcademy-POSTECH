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
        isLargeCard ? [GridItem(.flexible())] : [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
    }
    
    var spacing: CGFloat {
        isLargeCard ? 24 : 12
    }
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: spacing) {
                        ForEach(0..<10) { _ in
                            FeedLargeCard(showInformation: $isLargeCard)
                        }
                    }
                }
                .scrollIndicators(.never)
                .contentMargins(12, for: .scrollContent)
                .padding(.top, 18)
                .padding(.horizontal, 4)
                // 기본 padding 16으로 줄이는건 어떤지
                
                FloatingButton
                    .padding(.trailing, 28)
            }
            .background {
                Image(.feedBackground)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
            }
            
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Header
                }
                ToolbarItem(placement: .topBarTrailing) {
                    FriendCount
                }
            }
        }
    }
}

extension Feed {
    var Header: some View {
        Text("Feed")
            .foregroundStyle(.white)
            .font(.system(size: 24, weight: .bold))
    }
    
    var FriendCount: some View {
        HStack(spacing: 0) {
            Image(systemName: "person.2.fill")
                .foregroundStyle(.white)
                .font(.system(size: 14, weight: .regular))
            Spacer().frame(width: 4)
            Text("친구")
                .foregroundStyle(.white)
                .font(.system(size: 14, weight: .bold))
            // figma 폰트에서는 한글은 bold - nonbold 두가지 밖에 안되는듯 ?
            Spacer().frame(width: 12)
            Text("4")
                .foregroundStyle(.white)
                .font(.system(size: 14, weight: .medium))
            Spacer().frame(width: 2)
            Text("/")
                .foregroundStyle(.white.opacity(0.4))
                .font(.system(size: 11, weight: .bold))
            Spacer().frame(width: 2)
            Text("6")
                .foregroundStyle(.white.opacity(0.4))
                .font(.system(size: 14, weight: .medium))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background {
            Capsule()
                .foregroundStyle(.white.opacity(0.1))
        }
    }
    
    var FloatingButton: some View {
        Image(systemName: isLargeCard ? "arrow.up.right.and.arrow.down.left" :
                "arrow.down.backward.and.arrow.up.forward")
        .resizable()
        .scaledToFit()
        .foregroundStyle(.white)
        .frame(width: 27, height: 27)
        .padding(20)
        .background {
            Circle()
                .foregroundStyle(.ultraThinMaterial)
                .overlay {
                    Circle()
                        .stroke(.white.opacity(0.2), lineWidth: 2.0)
                }
        }
        .onTapGesture {
            isLargeCard.toggle()
        }
        .animation(.easeInOut(duration: 0.2), value: isLargeCard)
    }
}

#Preview {
    Feed()
}
