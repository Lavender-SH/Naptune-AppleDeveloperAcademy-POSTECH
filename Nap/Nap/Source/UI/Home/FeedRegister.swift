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
    @State var isSelectingStatus: Bool = true
    @State var sleepStatusLevel: Double = 3
    
    let textLimit: Int = 16
    let imageWidth = UIScreen.size.width - 40
    
    // MARK: Body
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: UIScreen.isSE ? 30 : 80)
            FeedImage
            Spacer().frame(height: 30)
            isSelectingStatus ? AnyView(StatusSection)
                              : AnyView(BottomButton)
        }

        .padding(.horizontal, 20)
        .background(BackgroundImage(image: Image(.basicBackground)))
        .dismissKeyboard()
    }
}

private extension FeedRegister {
    
    // MARK: View
    
    var FeedImage: some View {
        Image(.feedImage5)
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
    }
    
    var SleepResult: some View {
        HStack(spacing: 8) {
            SleepComment
            SleepStatus
        }
        .padding(16)
    }
    
    var SleepComment: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("30분")
                .font(.napCaption2)
                .foregroundStyle(.napWhite60)
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
        .frame(width: 200, height: 55)
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
                .frame(width: 55, height: 55)
                .background(.ultraThinMaterial)
                .clipShape(Circle())
        }
    }
    
    var BottomButton: some View {
        VStack {
            HStack(spacing: 40) {
                CancelButton
                UploadButton
                Circle()
                    .foregroundColor(.clear)
                    .frame(width: 67, height: 67)
            }
            Spacer()
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
    
    var StatusSection: some View {
        VStack {
            StatusSlider
            Spacer()
            HStack(spacing: 12) {
                StatusSelectCancelButton
                StatusSelectCompleteButton
            }
        }
    }
    
    var StatusSlider: some View {
        VStack(spacing: 0) {
            Slider(value: $sleepStatusLevel,
                   in: 1...5,
                   step: 1)
            .tint(.napBlue100)
            .foregroundStyle(.blue)
            .background {
                HStack {
                    SliderStepCircle(level: 1)
                    Spacer()
                    SliderStepCircle(level: 2)
                    Spacer()
                    SliderStepCircle(level: 3)
                    Spacer()
                    SliderStepCircle(level: 4)
                    Spacer()
                    SliderStepCircle(level: 5)
                }
            }
            HStack {
                Text("매우 피곤함")
                Spacer()
                Text("매우 상쾌함")
            }
            .font(.napCaption3)
            .foregroundStyle(.napWhite40)
        }
    }
    
    func SliderStepCircle(level: Double) -> some View {
        Circle()
            .frame(width: 8, height: 8)
            .foregroundStyle(level <= sleepStatusLevel ? .napBlue100 : .napBlackSlider)
            .offset(y: 0.5)
    }
    
    var StatusSelectCancelButton: some View {
        Button {
            print("Cancel")
        } label: {
            Text("취소")
                .font(.napTitle2)
                .foregroundStyle(.napWhite60)
                .padding(.vertical, 18)
                .padding(.horizontal, 41)
                .background {
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundStyle(.napWhite10)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(.napWhite10, lineWidth: 1.0)
                }
        }
    }
    
    var StatusSelectCompleteButton: some View {
        Button {
            print("complete")
        } label: {
            HStack {
                Spacer()
                Text("완료")
                    .font(.napTitle2)
                    .foregroundStyle(.napBlack800)
                Spacer()
            }
            .padding(.vertical, 18)
            .background {
                RoundedRectangle(cornerRadius: 6)
                    .foregroundStyle(.napBlue100)
            }
        }
    }
    
//    var SelectStatusButton: some View {
//        Button {
//            changeBottomButton()
//        } label: {
//            Image(.smile)
//                .foregroundStyle(.napWhite100)
//                .frame(width: 27, height: 27)
//                .padding(20)
//                .background {
//                    Circle()
//                        .foregroundStyle(Color.napWhite10)
//                        .background(BackgroundBlur(radius: 10, opaque: true))
//                }
//                .overlay {
//                    Circle()
//                        .stroke(.napWhite10, lineWidth: 1.0)
//                }
//        }
//    }
//    
//    var SleepStatusButtons: some View {
//        HStack(spacing: 20) {
//            SleepStatusButton(status: "😑",
//                              description: "피곤해요")
//            SleepStatusButton(status: "🙂",
//                              description: "보통")
//            SleepStatusButton(status: "🤩",
//                              description: "기운 펄펄")
//        }
//    }
    
//    func SleepStatusButton(status: String, description: String) -> some View {
//        VStack(spacing: 8) {
//            Button {
//                changeSleepStatus(status: status)
//            } label: {
//                Text(status)
//                    .font(.system(size: 45))
//                    .padding(20)
//                    .background {
//                        Circle()
//                            .foregroundStyle(
//                                status == sleepStatus ? Color.napBlue20 : Color.napWhite10)
//                            .background(BackgroundBlur(radius: 10, opaque: true))
//                    }
//                    .overlay {
//                        if status == sleepStatus {
//                            Circle()
//                                .stroke(.napBlue100, lineWidth: 2.0)
//                        } else {
//                            Circle()
//                                .stroke(.napWhite10, lineWidth: 1.0)
//                        }
//                    }
//            }
//            
//            if status == sleepStatus {
//                Text(description)
//                    .font(.napCaption2)
//                    .foregroundStyle(.napBlue100)
//            } else {
//                Text(description)
//                    .font(.napCaption3)
//                    .foregroundStyle(.napWhite40)
//            }
//        }
//    }
    
    // MARK: Computed Values
    
    var sleepStatus: String {
        switch sleepStatusLevel {
        case 1: return "😑"
        case 2: return "🫥"
        case 3: return "🙂"
        case 4: return "🫥"
        case 5: return "🤩"
        default: return "Error"
        }
    }
    
    // MARK: Action
    
    func changeBottomButton() {
        isSelectingStatus.toggle()
    }
}

#Preview {
    FeedRegister()
}
