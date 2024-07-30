//
//  ProfileSetting.swift
//  Nap
//
//  Created by YunhakLee on 7/30/24.
//

import SwiftUI

struct ProfileSetting: View {
    
    @State var nickname: String = ""
    @State var showProfileSetting: Bool = false
    @FocusState var focusField: Field?
    
    var textLimit = 10
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer().frame(height: 26)
            StageIndicator
            Spacer().frame(height: 16)
            Header
            Spacer().frame(height: 30)
            NicknameTextField
            Spacer().frame(height: 10)
            TextFieldCaption
            Spacer()
            NextButton
            Spacer().frame(height: 33)
        }
        .padding(.horizontal, 20)
        .background(BackgroundImage(image: Image(.basicBackground)))
        .navigationTitle("")
        .navigationDestination(isPresented: $showProfileSetting) {
            EmptyView()
        }
    }
}

private extension ProfileSetting {
    
    // MARK: View
    
    var StageIndicator: some View {
        HStack(spacing: 8) {
            PreviousStageIndicator
            ProfileStageIndicator
            
        }
    }
    
    var PreviousStageIndicator: some View {
        HStack(spacing: 4) {
            Text("1")
        }
        .font(.napCaption1)
        .foregroundStyle(.napWhite60)
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .background {
            Circle()
                .foregroundStyle(.napWhite10)
        }
    }
    
    var ProfileStageIndicator: some View {
        HStack(spacing: 4) {
            Text("2")
            Text("프로필")
        }
        .font(.napCaption1)
        .foregroundStyle(.napBlack800)
        .padding(.vertical, 4)
        .padding(.horizontal, 11)
        .background {
            Capsule()
                .foregroundStyle(.napBlue100)
        }
    }
    
    var Header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("친구들이 나를 알아볼 수 있는 사진으로 선정하면 좋아요")
                .font(.napCaption1)
                .foregroundStyle(.napBlue100)
            Text("프로필 사진을 등록해요")
                .font(.napLargeTitle)
                .foregroundStyle(.napWhite100)
        }
    }
    
    var NicknameTextField: some View {
        HStack {
            TextField(text: $nickname) {
                Text("예시) 어린낮잠왕자")
                    .font(.napTitle2)
                    .foregroundStyle(.napWhite40)
            }
            .font(.napTitle2)
            .foregroundStyle(.napWhite100)
            .focused($focusField, equals: .code)
            .onChange(of: nickname) { _, _ in
                if nickname.count > textLimit {
                    nickname = String(nickname.prefix(textLimit))
                }
            }
            .onSubmit {
                //makeFriendRequest()
            }
            Spacer()
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 16)
        .background {
            RoundedRectangle(cornerRadius: 6)
                .foregroundStyle(.napWhite10)
        }
        .onAppear {
            focusField = .code
        }
    }
    
    var TextFieldCaption: some View {
        Text("* 닉네임은 2 ~ 10글자로 작성해주세요 (공백제외)")
            .font(.napCaption3)
            .foregroundStyle(.napWhite60)
    }
    
    var NextButton: some View {
        Button {
            moveNextStage()
        } label: {
            HStack {
                Spacer()
                Text("다음")
                    .font(.napTitle2)
                    .foregroundStyle(
                        nextAvailable ? .napBlack800
                                      : .napWhite30
                    )
                Spacer()
            }
            .padding(.vertical, 18)
            .background(
                nextAvailable ? .napBlue100
                              : .napWhite10
            )
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .overlay {
                if !nextAvailable {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(.napWhite10,
                                lineWidth: 1.0)
                }
            }
        }

    }
    
    // MARK: Computed Values
    
    // MARK: Computed Values
    
    var nextAvailable: Bool {
        return nickname.count <= textLimit && 2 <= nickname.count
    }
    
    //MARK: Action
    
    func moveNextStage() {
        showProfileSetting = true
    }
}

#Preview {
    ProfileSetting()
}

