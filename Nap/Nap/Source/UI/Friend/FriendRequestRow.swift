//
//  FriendRequestRow.swift
//  Nap
//
//  Created by YunhakLee on 7/28/24.
//

import SwiftUI

struct FriendRequestRow: View {
    
    var body: some View {
        HStack(spacing: 16) {
            ProfileImage
            UserName
            Spacer()
            AcceptButton
        }
        .padding(.vertical, 12)
    }
}

private extension FriendRequestRow {
    var ProfileImage: some View {
        Image(.feedImage1)
            .resizable()
            .scaledToFill()
            .frame(width: 48, height: 48)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.napBlue100,
                            lineWidth: 2.0)
            }
    }
    
    var UserName: some View {
        Text("쿨쿨나기")
            .font(.napTitle2)
            .foregroundStyle(.napWhite100)
    }
    
    var AcceptButton: some View {
        Button {
            print("친구 수락")
        } label: {
            BlueButtonLabel(text: "수락")
        }
    }
}

#Preview {
    FriendRequestRow()
}
