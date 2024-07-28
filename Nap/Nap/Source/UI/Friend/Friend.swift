//
//  Friend.swift
//  Nap
//
//  Created by YunhakLee on 7/24/24.
//

import SwiftUI

struct Friend: View {
    var body: some View {
        VStack {
            FriendAddSection
                .navigationTitle("친구")
        }
        .padding(.horizontal, 20)
        .background {
            BackgroundImage(image: Image(.basicBackground))
        }
    }
}

private extension Friend {
    var FriendAddSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            FriendAddSectionTitle
            CodeCopyButton
            FriendAddButton
        }
    }
    
    var FriendAddSectionTitle: some View {
        Text("친구 추가")
            .font(.napTitle1)
            .foregroundStyle(.napWhite100)
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
}

#Preview {
    Friend()
}
