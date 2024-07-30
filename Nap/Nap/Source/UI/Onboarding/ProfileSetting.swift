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
    @State private var profile: Image = Image(.fox)
    @Binding var nickname: String
    
    @FocusState var focusField: Field?
    
    var textLimit = 10
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer().frame(height: topMargin)
            StageIndicator
            Spacer().frame(height: 16)
            Header
            Spacer()
            ProfileSection
            Spacer()
            ProfilePreview
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
        ProfileImage
            .overlay(alignment: .bottomTrailing) {
                ImagePickerButton
            }
            .padding(.horizontal, ProfileSectionMargin)
    }
    
    var ProfileImage: some View {
            profile
                .resizable()
                .scaledToFill()
                .frame(width: imageWidth, height: imageHeight)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke(.napWhite10, lineWidth: 2.0)
                }
    }
    
    var ImagePickerButton: some View {
        PhotosPicker(selection: $selectedPhotos) {
            Circle()
                .frame(width: 66, height: 66)
                .foregroundStyle(.napBlue100)
                .overlay {
                    Image(.album)
                }
        }
        .onChange(of: selectedPhotos) {
            Task {
                if let loaded = try? await selectedPhotos?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: loaded) {
                    profile = Image(uiImage: uiImage)
                } else {
                    profile = Image(.fox)
                }
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
    
    var ProfileSectionMargin: CGFloat {
        UIScreen.isSE ? 80 : 60
    }
    
    var isSkipping: Bool {
        return profile == Image(.fox)
    }
    
    var nextButtonText: String {
        isSkipping ? "건너뛰기" : "완료"
    }
    
    var imageWidth: CGFloat {
        UIScreen.isSE ? UIScreen.size.width - 160 : UIScreen.size.width - 120
    }
    
    var imageHeight: CGFloat {
        imageWidth
    }
    
    //MARK: Action
    
    func moveNextStage() {
        
    }
}

#Preview {
    ProfileSetting(nickname: .constant("자두자두졸린해시"))
}

