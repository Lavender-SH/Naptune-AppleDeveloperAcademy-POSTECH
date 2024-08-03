//
//  Feed.swift
//  Nap
//
//  Created by YunhakLee on 7/24/24.
//

import SwiftUI

struct Feed: View {
    @State var isLargeCard: Bool = true
    @Binding var showHome: Bool
    
    // MARK: Body
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                SlideHeader
                LazyVGrid(columns: columns, spacing: spacing) {
                    ForEach(0..<10) { _ in
                        FeedCard(showInformation: $isLargeCard, image: Image(.feedImage2))
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
        .overlay(alignment: .bottom) {
            FloatingButton
        }
        // 상단 어둡게 블러처리.
//        .overlay(alignment: .top) {
//            ZStack {
//                BackgroundBlur(radius: 10, opaque: false)
//                LinearGradient(colors: [Color.black.opacity(0.8), Color.black.opacity(0.5), Color.black.opacity(0.0)], startPoint: .top, endPoint: .bottom)
//            }
//            .frame(height: topMargin)
//            .ignoresSafeArea()
//        }
        // 애니메이션 넣으면 깨질때가 있음.
//        .animation(.snappy(duration: 0.35),
//                   value: isLargeCard)
    }
}

private extension Feed {
    
    // MARK: View
    
    var SlideHeader: some View {
//        Button {
//            print("화면 올라가기")
//            showHome = true
//        } label: {
            HStack {
                Spacer()
                VStack(spacing: 1) {
                    Text("낮잠 자러가기")
                        .font(.napCaption1)
                    Image(.chevronUp)
                }
                .foregroundStyle(.napWhite60)
                .padding(.vertical, 13)
                Spacer()
            }
       // }
    }
    
    var Header: some View {
        Text("Feed")
            .foregroundStyle(.white)
            .font(.system(size: 24, weight: .bold))
    }
    
    var FloatingButton: some View {
        HStack {
            FriendListButton
            Spacer()
            ChangeSizeButton
        }
        .padding(.horizontal, 28)
        .padding(.bottom, 18)
    }
    
    var ChangeSizeButton: some View {
        Button {
            changFeedMode()
        } label: {
            Image(isLargeCard ? .minimize : .maximize)
                .foregroundStyle(.napWhite100)
                .frame(width: 27, height: 27)
                .padding(20)
                .background {
                    Circle()
                        .foregroundStyle(.ultraThinMaterial)
                        .overlay {
                            Circle()
                                .stroke(.napWhite20, lineWidth: 2.0)
                        }
                }
        }
       
//            .onTapGesture {
//                changFeedMode()
//            }
    }
    
    var FriendListButton: some View {
        NavigationLink {
            Friend()
        } label: {
            Image(.friend)
                .foregroundStyle(.napWhite100)
                .frame(width: 27, height: 27)
                .padding(20)
                .background {
                    Circle()
                        .foregroundStyle(.ultraThinMaterial)
                        .overlay {
                            Circle()
                                .stroke(.napWhite20, lineWidth: 2.0)
                        }
                }
        }
        
//            .onTapGesture {
//                // 화면 전환 코드 작성
//            }
    }
    
    // MARK: Computed Values
    
    var columns: [GridItem] {
        isLargeCard ? [GridItem(.flexible())] :
                      [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
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
    Feed(showHome: .constant(false))
}
