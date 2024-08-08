//
//  ProfileSetting.swift
//  Nap
//
//  Created by YunhakLee on 7/30/24.
//

import SwiftUI
import PhotosUI

struct ProfileSetting: View {
    
    @State private var selectedPhotos: PhotosPickerItem? = nil
    @State private var profile: Image = Image("fox")
    @State private var profileUIImage: UIImage? = UIImage(resource: .fox)
    @Binding var nickname: String
    @FocusState var focusField: Field?
    @AppStorage("firstLaunch") var firstLaunch: Bool = true
    
    var textLimit = 10
    var firebaseManager = FirebaseManager.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer().frame(height: topMargin)
            StageIndicator
            Spacer().frame(height: 16)
            Header
            Spacer()
            ProfileSection
            Spacer()
            Spacer()
            ProfilePreview
            Spacer()
            Spacer()
            Spacer()
            NextButton
            Spacer().frame(height: 33)
        }
        .background(BackgroundImage(image: Image(.basicBackground)))
        .navigationTitle("")
    }
}

private extension ProfileSetting {
    
    // MARK: View
    
    var StageIndicator: some View {
        HStack(spacing: 8) {
            PreviousStageIndicator
            ProfileStageIndicator
        }
        .padding(.horizontal, 20)
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
        .padding(.horizontal, 20)
    }
    
    var ProfileSection: some View {
        HStack(spacing: 20) {
            Spacer()
            ProfileImage
            VStack(spacing: 12) {
                BasicProfileButton(imageName: "prince")
                BasicProfileButton(imageName: "pilot")
                BasicProfileButton(imageName: "fox")
                ImagePickerButton
            }
            Spacer()
        }
    }
    
    var ProfileImage: some View {
            profile
                .resizable()
                .scaledToFill()
                .frame(width: imageWidth, height: imageHeight)
                .clipShape(Circle())
    }
    
    var ImagePickerButton: some View {
        PhotosPicker(selection: $selectedPhotos, matching: .images) {
            Circle()
                .frame(width: 53, height: 53)
                .foregroundStyle(.napWhite20)
                .overlay {
                    Image(.album)
                }
                .overlay {
                    Circle()
                        .stroke(.napWhite20, lineWidth: 2.0)
                }
        }
        .onChange(of: selectedPhotos) {
            Task {
                if let loaded = try? await selectedPhotos?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: loaded) {
                    profileUIImage = uiImage
                    profile = Image(uiImage: uiImage)
                } else {
                    profile = Image(.fox)
                }
            }
        }
    }
    
    func BasicProfileButton(imageName: String) -> some View {
        Button {
            profile = Image(imageName)
            profileUIImage = UIImage(named: imageName)
        } label: {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 53, height: 53)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke(.napWhite10, lineWidth: 2.0)
                }
        }
    }
    
    var ProfilePreview: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("프로필 미리보기")
                .font(.napCaption2)
                .foregroundStyle(.napWhite80)
                .padding(.horizontal, 20)
            
            FriendRow(isSleeping: .constant(true),
                      isAccepted: .constant(true),
                      profile: $profile,
                      nickName: $nickname)
            .padding(.horizontal, 20)
            .background(.napWhite10)
        }
    }
    
    var NextButton: some View {
        Button {
            moveNextStage()
        } label: {
            HStack {
                Spacer()
                Text(nextButtonText)
                    .font(.napTitle2)
                    .foregroundStyle(
                        isSkipping ? .napBlue100
                        : .napBlack800
                    )
                Spacer()
            }
            .padding(.vertical, 18)
            .background(
                isSkipping ? .napWhite10
                : .napBlue100
            )
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .overlay {
                if isSkipping {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(.napWhite10,
                                lineWidth: 1.0)
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: Computed Values
   
    var topMargin: CGFloat {
        UIScreen.isSE ? 12 : 26
    }
    
    var isSkipping: Bool {
        return profile == Image("fox") || profile == Image("pilot") || profile == Image("prince")
    }
    
    var nextButtonText: String {
        isSkipping ? "건너뛰기" : "완료"
    }
    
    var imageWidth: CGFloat {
        250
    }
    
    var imageHeight: CGFloat {
        imageWidth
    }
    
    //MARK: Action
    
    func moveNextStage() {
        firstLaunch = false
        firebaseManager.uploadImage(profileImage: profileUIImage)
    }
}

#Preview {
    ProfileSetting(nickname: .constant("자두자두졸린해시"))
}

