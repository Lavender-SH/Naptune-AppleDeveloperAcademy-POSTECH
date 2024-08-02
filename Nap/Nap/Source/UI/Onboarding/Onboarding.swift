//
//  Onboarding.swift
//  Nap
//
//  Created by YunhakLee on 7/24/24.
//

import SwiftUI
import Firebase
import CryptoKit
import AuthenticationServices

struct Onboarding: View {
    
    @State var currentStage: Int = 1
    @State var showBasicSetting: Bool = false
    @Binding var isOnboarding: Bool
    
    var firebaseManager = FirebaseManager.shared
    
    // MARK: Body
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                Spacer().frame(height: topMargin)
                StageIndicatorSection
                Spacer().frame(height: 16)
                Title
                Spacer().frame(minHeight: 20, maxHeight: 30)
                OnboardingTabView
                Spacer().frame(minHeight: 20)
                if currentStage == 4 {
                    LoginButton
                } else {
                    NextButton
                }
                Spacer().frame(height: 33)
            }
            .background {
                BackgroundImage(image: Image(.basicBackground))
            }
            .animation(.easeInOut(duration: 0.1),
                       value: currentStage)
            .navigationTitle("")
            .navigationDestination(isPresented: $showBasicSetting) {
                NicknameSetting(isOnboarding: $isOnboarding)
            }
        }
    }
}

private extension Onboarding {
    
    // MARK: View
    
    var StageIndicatorSection: some View {
        HStack(spacing: 8) {
            StageIndicator(stage: 1)
            StageIndicator(stage: 2)
            StageIndicator(stage: 3)
            StageIndicator(stage: 4)
        }
        .padding(.horizontal, 20)
    }
    
    func StageIndicator(stage: Int) -> some View {
        Circle()
            .foregroundStyle(
                currentStage == stage ? .napBlue100
                                      : .napWhite10
            )
            .frame(width: 25, height: 25)
            .overlay {
                if stage == 4 {
                    Image(.flash)
                        .renderingMode(.template)
                        .foregroundStyle(
                            currentStage == stage ? .napBlack800
                                                  : .napWhite60
                        )
                } else {
                    Text("\(stage)")
                        .font(.napCaption1)
                        .foregroundStyle(
                            currentStage == stage ? .napBlack800
                                                  : .napWhite60
                        )
                }
            }
    }
    
    var Title: some View {
        Text(titleText)
            .font(.napLargeTitle)
            .foregroundStyle(.napWhite100)
            .lineLimit(2)
            .fixedSize()
            .padding(.horizontal, 20)
    }
    
    var OnboardingTabView: some View {
            TabView(selection: $currentStage) {
                ForEach(1..<5, id: \.self) { stage in
                    OnboardingImage(stage: stage)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: imageHeight)
    }
    
    func OnboardingImage(stage: Int) -> some View {
        getOnboardingImage(stage: stage)
            .resizable()
            .scaledToFill()
            .frame(width: imageWidth, height: imageHeight)
            .background(.napWhite10)
            .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    var NextButton: some View {
        Button {
            moveNextStage()
        } label: {
            MainButtonLabel(text: "다음")  
        }
        .padding(.horizontal, 20)
    }
    
    var LoginButton: some View {
        SignInWithAppleButton(
            onRequest: { request in
                firebaseManager.nonce = firebaseManager.randomNonceString()
                request.requestedScopes = [.email, .fullName]
                request.nonce = firebaseManager.sha256(firebaseManager.nonce)
            },
            onCompletion: { result in
                switch result {
                case .success(let authorization):
                    print("Apple Sign-In successful")
                    showBasicSetting = true
                    if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
                        firebaseManager.authenticate(credential: credential)
                    }
                case .failure(let error):
                    print("Apple Sign-In failed: \(error.localizedDescription)")
                }
            }
        )
        .signInWithAppleButtonStyle(.white)
        .frame(height: 56)
        .padding(.horizontal, 20)
    }
    
    // MARK: Computed Values
    
    var titleText: String {
        switch currentStage {
        case 1: return "원하는 시간만큼\n낮잠시간을 설정해요"
        case 2: return "자는동안 걱정말아요\n전화로 친구들이 깨워줄 거에요"
        case 3: return "잠깐 짐을 내려놓으면,\n더 힘찬 하루가 될거에요"
        case 4: return "마음의 짐을 내려놓고,\n잠깐 낮잠을 즐겨볼까요?"
        default: return "Error"
        }
    }
    
    func getOnboardingImage(stage: Int) -> Image {
        switch stage {
        case 1: return Image(.onboarding1)
        case 2: return Image(.onboarding2)
        case 3: return Image(.onboarding3)
        case 4: return Image(.onboarding4)
        default: return Image(.onboarding4)
        }
    }
    
    // MARK: Action
    
    func moveNextStage() {
        if currentStage < 4 {
            currentStage += 1
        } else {
            showBasicSetting = true
        }
    }
    
    var topMargin: CGFloat {
        UIScreen.isSE ? 20 : 40
    }
    
    var imageWidth: CGFloat {
        UIScreen.size.width - 40
    }
    
    var imageHeight: CGFloat {
        imageWidth/353*414
    }
}

#Preview {
    Onboarding(isOnboarding: .constant(true))
}
