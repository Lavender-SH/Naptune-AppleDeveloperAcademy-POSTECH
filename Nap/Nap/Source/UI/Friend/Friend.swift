//
//  Friend.swift
//  Nap
//
//  Created by YunhakLee on 7/24/24.
//

import SwiftUI

struct Friend: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                FriendAddSection
                FriendListSection
            }
        }
        .navigationTitle("친구")
        .padding(.horizontal, 20)
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
        VStack(spacing: 12) {
            HStack(spacing: 10) {
                SectionTitle("친구")
                FriendCount
                Spacer()
                Text("편집")
                    .font(.napCaption1)
                    .foregroundStyle(.napWhite60)
            }
            
            FriendList
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
    
    var FriendList: some View {
        EmptyView()
    }
    
    func SectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.napTitle1)
            .foregroundStyle(.napWhite100)
    }
}

#Preview {
    Friend()
}
