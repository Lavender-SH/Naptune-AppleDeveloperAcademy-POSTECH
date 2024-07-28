//
//  Friend.swift
//  Nap
//
//  Created by YunhakLee on 7/24/24.
//

import SwiftUI

struct Friend: View {
    
    @State var isListSuspended: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Spacer().frame(height: 20)
                FriendAddSection
                Spacer().frame(height: 30)
                FriendListSection
                Spacer().frame(height: 30)
                FriendRequestSection
                Spacer()
            }
            .padding(.horizontal, 20)
            .animation(.snappy,
                       value: isListSuspended)
        }
        .scrollIndicators(.never)
        .navigationTitle("친구")
        .background {
            BackgroundImage(image: Image(.basicBackground))
        }
    }
}

private extension Friend {
    
    // MARK: View-FriendAdd
    
    var FriendAddSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitle("친구 추가")
            CodeCopyButton
            FriendAddButton
        }
    }
    
    var CodeCopyButton: some View {
        HStack(spacing: 8) {
            Spacer()
            Text("FQ9XH")
                .font(.napLargeTitle)
                .foregroundStyle(.napWhite80)
            Image(.copy)
                .foregroundStyle(.napBlue100)
            Spacer()
        }
        .frame(height: 55)
        .background {
            RoundedRectangle(cornerRadius: 6)
                .foregroundColor(Color.napWhite10)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.napWhite10, lineWidth: 1.0)
        }
        .onTapGesture {
            print("CodeCopied!")
        }
    }
    
    var FriendAddButton: some View {
        Button {
            print("Friend Add")
        } label: {
            HStack(spacing: 8) {
                Spacer()
                Text("친구 추가")
                    .font(.napTitle2)
                    .foregroundStyle(.napBlack800)
                Spacer()
            }
            .frame(height: 55)
            .background {
                RoundedRectangle(cornerRadius: 6)
                    .foregroundColor(Color.napBlue100)
            }
        }
    }
    
    // MARK: View-FriendList
    
    var FriendListSection: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                SectionTitle("친구")
                FriendCount
                Spacer()
                EditButton
            }
            FriendList
            MoreButton
        }
    }
    
    var FriendCount: some View {
        HStack(spacing: 3) {
            Text("3")
                .font(.napTitle1)
                .foregroundStyle(.napBlue100)
            Text("/")
                .font(.napTitle2)
                .foregroundStyle(.napWhite100)
            Text("6")
                .font(.napTitle1)
                .foregroundStyle(.napWhite100)
        }
    }
    
    var EditButton: some View {
        Button {
            print("편집")
        } label: {
            Text("편집")
                .font(.napCaption1)
                .foregroundStyle(.napWhite60)
        }
    }
    
    var FriendList: some View {
        VStack(spacing: 0) {
            ForEach(0..<friendList, id: \.self) { _ in
                FriendRow(isSleeping: false,
                          isAccepted: true)
            }
        }
    }
    
    var MoreButton: some View {
        HStack(spacing: 12) {
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.napWhite20)
            Button {
                isListSuspended.toggle()
            } label: {
                Text(moreButtonText)
                    .font(.napCaption2)
                    .foregroundStyle(.napWhite80)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 14)
                    .background {
                        Capsule()
                            .foregroundStyle(.napWhite20)
                    }
            }
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(.napWhite20)
        }
       
        
    }
    
    // MARK: View-FriendRequest
    
    var FriendRequestSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionTitle("친구 요청")
            FriendRequestList
        }
    }
    
    var FriendRequestList: some View {
        VStack(spacing: 0) {
            ForEach(0..<5, id: \.self) { _ in
                FriendRequestRow()
            }
        }
    }
    
    // MARK: View-Base
    
    func SectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.napTitle1)
            .foregroundStyle(.napWhite100)
    }
    
    // MARK: Computed Values
    
    var friendList: Int {
        isListSuspended ? 6 : 3
    }
    
    var moreButtonText: String {
        isListSuspended ? "간단히 보기" : "자세히 보기"
    }
}

#Preview {
    Friend()
}
