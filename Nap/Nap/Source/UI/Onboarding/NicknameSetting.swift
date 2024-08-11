//
//  BasicInfo.swift
//  Nap
//
//  Created by YunhakLee on 7/29/24.
//

import SwiftUI

struct NicknameSetting: View {
    
    @State var nickname: String = ""
    @State var showProfileSetting: Bool = false
    @FocusState var focusField: Field?
    @Binding var isOnboarding: Bool
    
    var textLimit = 10
    var firebaseManager = FirebaseManager.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer().frame(height: topMargin)
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
            ProfileSetting(nickname: $nickname, isOnboarding: $isOnboarding)
        }
    }
}

private extension NicknameSetting {
    
    // MARK: View
    
    var StageIndicator: some View {
        HStack(spacing: 8) {
            NicknameStageIndicator
            NextStageIndicator
        }
    }
    
    var NicknameStageIndicator: some View {
        HStack(spacing: 4) {
            Text("1")
            Text("닉네임")
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
    
    var NextStageIndicator: some View {
        HStack(spacing: 4) {
            Text("2")
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
    
    var Header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("친구들이 나를 알아볼 수 있도록 닉네임을 설정해주세요")
                .font(.napCaption1)
                .foregroundStyle(.napBlue100)
            Text("닉네임을 알려주세요")
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
                nickname.removeAll(where: {$0 == " "})
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
        Text("* 띄어쓰기 없이 닉네임을 설정해주세요 (최대 10자)")
            .font(.napCaption3)
            .foregroundStyle(.napWhite60)
    }
    
    var NextButton: some View {
        Button {
            UserDefaults.standard.set(nickname, forKey: "nickname")
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
        .disabled(!nextAvailable)
    }
    
    // MARK: Computed Values
    
    var topMargin: CGFloat {
        UIScreen.isSE ? 12 : 26
    }
    
    var nextAvailable: Bool {
        return nickname != ""
    }
    
    //MARK: Action
    
    func moveNextStage() {
        showProfileSetting = true
        firebaseManager.createUserDataWithNickname(nickname: nickname)
    }
}

#Preview {
    NicknameSetting(isOnboarding: .constant(true))
}
