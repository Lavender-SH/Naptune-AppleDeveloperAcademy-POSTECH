//
//  FeedRegister.swift
//  Nap
//
//  Created by YunhakLee on 7/28/24.
//

import SwiftUI

struct FeedRegister: View {
    
    @State var sleepComent: String = ""
    
    // MARK: Body
    
    var body: some View {
        GeometryReader { geo in
            FeedImage
                .frame(width: geo.size.width, height: geo.size.width/3*4)
                .clipShape(RoundedRectangle(cornerRadius: 20.0))
                .overlay(alignment: .bottomLeading) {
                    SleepResult
                }
        }
        .padding(.horizontal, 20)
    }
}

private extension FeedRegister {
    
    // MARK: View
    
    var FeedImage: some View {
        Image(.feedImage7)
            .resizable()
            .scaledToFill()
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
            TextField(text: $sleepComent) {
                Text("오늘 낮잠은 어떠셨나요?")
            }
            .font(.napCaption1)
            .foregroundStyle(.napWhite100)
        }
        .frame(width: 196)
        .padding(.vertical, 10)
        .padding(.horizontal, 24)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
    }
    
    var SleepStatus: some View {
        Button {
            // Status 선택 Action
        } label: {
            Text("😑")
                .font(.system(size: 32))
                .padding(10)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
        }
    }
}

#Preview {
    FeedRegister()
}
