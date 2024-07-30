//
//  FriendRow.swift
//  Nap
//
//  Created by YunhakLee on 7/28/24.
//

import SwiftUI

struct FriendRow: View {
    
    @Binding var isSleeping: Bool
    @Binding var isAccepted: Bool
    @Binding var profile: Image
    @Binding var nickName: String
    
    var body: some View {
        HStack(spacing: 16) {
            ProfileImage
            Description
            Spacer()
            if isSleeping && isAccepted {
                RemainTime
            } else if isSleeping && !isAccepted {
                AwakeAcceptButton
            }
        }
        .padding(.vertical, 12)
    }
}
            
private extension FriendRow {
    var ProfileImage: some View {
        profile
            .resizable()
            .scaledToFill()
            .frame(width: 48, height: 48)
            .clipShape(Circle())
            .overlay {
                Circle()
                    .stroke(isSleeping ? .napBlue100 : .napWhite100,
                            lineWidth: 2.0)
            }
    }
    
    var Description: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(sleepingStatus)
                .font(.napCaption2)
                .foregroundStyle(.napBlue100)
            Text(nickName)
                .font(.napTitle2)
                .foregroundStyle(.napWhite100)
        }
    }
    
    var SleepingPart: some View {
        isAccepted ? AnyView(RemainTime)
                   : AnyView(AwakeAcceptButton)
    }
    
    var AwakeAcceptButton: some View {
        Button {
            print("낮잠 깨워주기")
        } label: {
            BlueButtonLabel(text: "낮잠 깨워주기")
        }
    }
    
    var RemainTime: some View {
        HStack(spacing: 4) {
            Image(.clock)
                .foregroundStyle(.napBlue100)
            Text("24:50")
                .foregroundStyle(.napBlue100)
                .font(.napCaption1)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 14)
        .background {
            Capsule()
                .foregroundStyle(.napBlue20)
        }
    }
    
    // MARK: Computed Values
    
    var sleepingStatus: String {
        isSleeping ? "충전하는 중" : "말똥말똥 깨어있는 중"
    }
}

#Preview {
    FriendRow(isSleeping: .constant(true),
              isAccepted: .constant(false),
              profile: .constant(Image(.feedImage1)),
              nickName: .constant("자두자두졸린해시"))
}
