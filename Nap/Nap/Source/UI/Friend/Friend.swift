//
//  Friend.swift
//  Nap
//
//  Created by YunhakLee on 7/24/24.
//

import SwiftUI

struct Friend: View {
    
    @State var isListSuspended: Bool = false
    @State var friendCount: Int = 6
    @State var isCodeCopied: Bool = false
    @State var isFriendAdding: Bool = false
    
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
        }
        .scrollIndicators(.never)
        .overlay(alignment: .bottom) {
            if isCodeCopied {
                CodeCopyPopup
                    .padding(.bottom, 40)
                    .transition(.asymmetric(
                        insertion: .offset(y: 150).animation(.spring),
                        removal: .opacity.animation(.spring(duration: 0.2))))
            }
            if isFriendAdding {
                FriendAdd(isFriendAdding: $isFriendAdding)
                    .ignoresSafeArea(.container, edges: .top)
            }
        }
        .background {
            BackgroundImage(image: Image(.basicBackground))
        }
        .animation(.snappy,
                   value: isListSuspended)
        .animation(.snappy,
                   value: friendCount)
        .animation(.snappy,
                   value: isCodeCopied)
        .navigationTitle("친구")
    }
}

private extension Friend {
    
    // MARK: View-FriendAdd
    
    var FriendAddSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitle("친구 추가")
            MyCode
            FriendAddButton
        }
    }
    
    var MyCode: some View {
        HStack(spacing: 0) {
            Spacer()
            Text("FQ9XH")
                .font(.napLargeTitle)
                .foregroundStyle(.napWhite80)
                .overlay(alignment: .trailing) {
                    CodeCopyButton
                        .offset(x: 35)
                }
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
    }
    
    var CodeCopyButton: some View {
        Button {
            isCodeCopied = true
            UIPasteboard.general.string = "FQ9XH"
            print("CodeCopied!")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isCodeCopied = false
            }
        } label: {
            Image(.copy)
                .foregroundStyle(.napBlue100)
                .padding(8)
        }
        .disabled(isCodeCopied)
    }
    
    var FriendAddButton: some View {
        Button {
            showFriendAdd()
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
            if friendCount > 3 {
                MoreButton
            }
        }
    }
    
    var FriendCount: some View {
        HStack(spacing: 3) {
            Text("\(friendCount)")
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
        List {
            ForEach(0..<friendCount, id: \.self) { _ in
                FriendRow(isSleeping: true,
                          isAccepted: false)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                .swipeActions(edge: .trailing,
                              allowsFullSwipe: false) {
                    DeleteButton()
                }
            }
        }
        .listStyle(.plain)
        .scrollDisabled(true)
        .frame(height: CGFloat(listMaxNumber)*72)
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
    
    private func DeleteButton() -> some View {
        Button(role: .destructive){
            deleteFriend()
        } label: {
            Label("삭제", systemImage: "trash")
                .font(.subheadline)
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
    
    var CodeCopyPopup: some View {
        Text("코드가 복사되었습니다")
            .font(.napCaption1)
            .foregroundStyle(.napWhite80)
            .padding(.vertical, 8)
            .padding(.horizontal, 14)
            .background {
                RoundedRectangle(cornerRadius: 6)
                    .foregroundColor(.napWhite20)
            }
    }
    
    // MARK: Computed Values
    
    var listMaxNumber: Int {
        isListSuspended ? friendCount : min(3, friendCount)
    }
    
    var moreButtonText: String {
        isListSuspended ? "간단히 보기" : "자세히 보기"
    }
    
    // MARK: Action
    
    func deleteFriend() {
        friendCount -= 1
    }
    
    func showFriendAdd() {
        isFriendAdding = true
    }
}

#Preview {
    Friend()
}
