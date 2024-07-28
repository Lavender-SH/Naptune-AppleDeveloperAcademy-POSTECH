//
//  FriendRow.swift
//  Nap
//
//  Created by YunhakLee on 7/28/24.
//

import SwiftUI

struct FriendRow: View {
    let isSleeping: Bool
    let isAccepted: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            ProfileImage
            Description
            Spacer()
            isSleeping ? AnyView(SleepingPart)
                       : AnyView(EmptyView())
        }
        .padding(.vertical, 12)
    }
}
            
private extension FriendRow {
    var ProfileImage: some View {
        Image(.feedImage1)
            .resizable()
            .scaledToFill()
            .frame(width: 48, height: 48)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSleeping ? .napBlue100 : .napWhite100,
                            lineWidth: 2.0)
            }
    }
    
    var Description: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(sleepingStatus)
                .font(.napCaption2)
                .foregroundStyle(.napBlue100)
            Text("쿨쿨나기")
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
            Text("낮잠 깨워주기")
                .font(.napCaption2)
                .foregroundStyle(.napBlue100)
                .padding(.vertical, 6)
                .padding(.horizontal, 14)
                .background {
                    Capsule()
                        .foregroundStyle(.napBlue20)
                }
        }
    }
    
    var RemainTime: some View {
        HStack(spacing: 4) {
            Image(.clock)
                .foregroundStyle(.napBlue100)
            Text("24:50")
                .foregroundStyle(.napBlue100)
                .font(.napCaption2)
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
    FriendRow(isSleeping: true,
              isAccepted: true)
}
