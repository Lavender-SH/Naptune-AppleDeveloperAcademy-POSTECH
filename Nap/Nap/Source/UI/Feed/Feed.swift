//
//  Feed.swift
//  Nap
//
//  Created by YunhakLee on 7/24/24.
//

import SwiftUI

struct Feed: View {
    @State var isLargeCard: Bool = true
    
    // MARK: Body
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                SlideHeader
                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach(0..<10) { _ in
                        FeedCard(showInformation: $isLargeCard, image: Image(.feedImage1))
                    }
                }
            }
        }
        .scrollIndicators(.never)
        .contentMargins(.top, topMargin, for: .scrollContent)
        .padding(.horizontal, 20)
        .background {
            BackgroundImage(image: Image(.feedBackground))
        }
        .overlay(alignment: .bottomTrailing) {
            FloatingButton
                .padding(.trailing, 28)
                .padding(.bottom, 18)
        }
        .overlay(alignment: .top) {
            ZStack {
                BackgroundBlur(radius: 10, opaque: false)
                LinearGradient(colors: [Color.black.opacity(0.8), Color.black.opacity(0.5), Color.black.opacity(0.0)], startPoint: .top, endPoint: .bottom)
            }
            .frame(height: topMargin)
            .ignoresSafeArea()
        }
        .animation(.snappy(duration: 0.35),
                   value: isLargeCard)
    }
}

private extension Feed {
    
    // MARK: View
    
    var SlideHeader: some View {
        HStack {
            Spacer()
            VStack {
                Text("낮잠 자러가기")
                    .foregroundStyle(.white.opacity(0.5))
                    .font(.system(size: 12, weight: .medium))
                Image(.chevronUp)
                    .foregroundStyle(.white.opacity(0.6))
            }
            .padding(.vertical, 13)
            Spacer()
        }
        
    }
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
            changFeedMode()
        }
    }
    
    // MARK: Computed Values
    
    var columns: [GridItem] {
        isLargeCard ? [GridItem(.flexible())] : [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
    }
    
    var spacing: CGFloat {
        isLargeCard ? 24 : 12
    }
    
    var topMargin: CGFloat {
        UIScreen.isSE ? 24 : 54
    }
    
    // MARK: Action
    
    func changFeedMode() {
        isLargeCard.toggle()
    }
}

#Preview {
    Feed()
}
