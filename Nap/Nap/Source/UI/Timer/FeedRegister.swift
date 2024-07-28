//
//  FeedRegister.swift
//  Nap
//
//  Created by YunhakLee on 7/28/24.
//

// MARK: TODO
// 수면시간 가독성 향상 예정,
// 버튼 방식 수정 예정

import SwiftUI

struct FeedRegister: View {
    
    @State var sleepComent: String = ""
    @State var isSelectingStatus: Bool = false
    @State var sleepStatus: String = "🫥"
    
    let textLimit: Int = 16
    let imageWidth = UIScreen.size.width - 40
    
    // MARK: Body
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: UIScreen.isSE ? 30 : 80)
            FeedImage
            Spacer().frame(height: 30)
            isSelectingStatus ? AnyView(SleepStatusButtons) 
                              : AnyView(BottomButton)
            Spacer()
        }
        .background(BackgroundImage(image: Image(.basicBackground)))
        .dismissKeyboard()
    }
}

private extension FeedRegister {
    
    // MARK: View
    
    var FeedImage: some View {
        Image(.feedImage7)
            .resizable()
            .scaledToFill()
            .frame(width: imageWidth,
                   height: imageWidth/3*4)
            .clipShape(RoundedRectangle(cornerRadius: 20.0))
            .overlay(alignment: .bottomLeading) {
                SleepResult
            }
            .padding(0.5)
            .overlay {
                RoundedRectangle(cornerRadius: 20.0)
                    .stroke(.napWhite10, lineWidth: 1.0)
            }
            .padding(.horizontal, 20)
    }
    
    var SleepResult: some View {
        HStack(spacing: 8) {
            SleepComment
            SleepStatus
        }
        .padding(16)
    }
    
    var SleepComment: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("30분")
                .font(.napFootnote1)
                .foregroundStyle(.napBlue100)
            TextField(text: $sleepComent) {
                Text("오늘 낮잠은 어떠셨나요?")
                    .font(.napCaption1)
                    .foregroundStyle(.napWhite60)
            }
            .font(.napCaption1)
            .foregroundStyle(.napWhite100)
            .onChange(of: sleepComent) { _, _ in
                if sleepComent.count > textLimit {
                    sleepComent = String(sleepComent.prefix(textLimit))
                }
            }
        }
        .frame(width: 200)
        .padding(.vertical, 10)
        .padding(.horizontal, 24)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
    }
    
    var SleepStatus: some View {
        Button {
            changeBottomButton()
        } label: {
            Text(sleepStatus)
                .font(.system(size: 32))
                .padding(10)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
        }
    }
    
    var BottomButton: some View {
        HStack(spacing: 40) {
            CancelButton
            UploadButton
            SelectStatusButton
        }
    }
    
    var CancelButton: some View {
        Button {
            
        } label: {
            Image(.X)
                .foregroundStyle(.napWhite100)
                .frame(width: 27, height: 27)
                .padding(20)
                .background {
                    Circle()
                        .foregroundStyle(Color.napWhite10)
                        .background(BackgroundBlur(radius: 10, opaque: true))
                }
                .overlay {
                    Circle()
                        .stroke(.napWhite10, lineWidth: 1.0)
                }
        }
    }
    
    var UploadButton: some View {
        Button {
            
        } label: {
            Image(.upload)
                .foregroundStyle(.napWhite100)
                .frame(width: 45, height: 45)
                .padding(20)
                .background {
                    Circle()
                        .foregroundStyle(Color.napWhite10)
                        .background(BackgroundBlur(radius: 10, opaque: true))
                }
                .overlay {
                    Circle()
                        .stroke(.napWhite10, lineWidth: 1.0)
                }
        }
    }
    
    var SelectStatusButton: some View {
        Button {
            changeBottomButton()
        } label: {
            Image(.smile)
                .foregroundStyle(.napWhite100)
                .frame(width: 27, height: 27)
                .padding(20)
                .background {
                    Circle()
                        .foregroundStyle(Color.napWhite10)
                        .background(BackgroundBlur(radius: 10, opaque: true))
                }
                .overlay {
                    Circle()
                        .stroke(.napWhite10, lineWidth: 1.0)
                }
        }
    }
    
    var SleepStatusButtons: some View {
        HStack(spacing: 20) {
            SleepStatusButton(status: "😑",
                              description: "피곤해요")
            SleepStatusButton(status: "🙂",
                              description: "보통")
            SleepStatusButton(status: "🤩",
                              description: "기운 펄펄")
        }
    }
    
    func SleepStatusButton(status: String, description: String) -> some View {
        VStack(spacing: 8) {
            Button {
                changeSleepStatus(status: status)
            } label: {
                Text(status)
                    .font(.system(size: 45))
                    .padding(20)
                    .background {
                        Circle()
                            .foregroundStyle(
                                status == sleepStatus ? Color.napBlue20 : Color.napWhite10)
                            .background(BackgroundBlur(radius: 10, opaque: true))
                    }
                    .overlay {
                        if status == sleepStatus {
                            Circle()
                                .stroke(.napBlue100, lineWidth: 2.0)
                        } else {
                            Circle()
                                .stroke(.napWhite10, lineWidth: 1.0)
                        }
                    }
            }
            
            if status == sleepStatus {
                Text(description)
                    .font(.napCaption2)
                    .foregroundStyle(.napBlue100)
            } else {
                Text(description)
                    .font(.napCaption3)
                    .foregroundStyle(.napWhite40)
            }
        }
    }
    
    // MARK: Action
    
    func changeBottomButton() {
        isSelectingStatus.toggle()
    }
    
    func changeSleepStatus(status: String) {
        sleepStatus = status
    }
}

#Preview {
    FeedRegister()
}
