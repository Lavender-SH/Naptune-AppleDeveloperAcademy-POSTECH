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
    
    @Binding var capturedImage: UIImage?
    @State var sleepComent: String = ""
    @State var isSelectingStatus: Bool = false
    @State var sleepStatusLevel: Double = 3
    @State var editedSleepStatusLevel: Double = 3
    
    let textLimit: Int = 16
    let imageWidth = UIScreen.size.width - 40
    
    // MARK: Body
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: UIScreen.isSE ? 53 : 133)
            FeedImage
            isSelectingStatus ? AnyView(StatusSection)
            : AnyView(BottomButton)
            Spacer()
        }
        .padding(.horizontal, 20)
        .background(
            BackgroundImage(image: Image(.basicBackground))
        )
        .dismissKeyboard()
        .onChange(of: editedSleepStatusLevel) { oldValue, newValue in
            HapticManager.instance.impact(style: .light)
        }
    }
}

private extension FeedRegister {
    
    // MARK: View
    
    var FeedImage: some View {
        Image(uiImage: capturedImage ?? .feedImage1)
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
            toggleBottomButton()
        } label: {
            sleepStatus
                .resizable()
                .scaledToFit()
                .frame(width: 32, height: 32)
                .padding(11.5)
                .background {
                    Circle()
                        .foregroundStyle(.ultraThinMaterial)
                }
                .tint(.clear)
        }
    }
    
    var BottomButton: some View {
        VStack {
            Spacer().frame(height: UIScreen.isSE ? 30 : 36)
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
            capturedImage = nil
        } label: {
            Image(.X)
                .renderingMode(.template)
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
            Spacer().frame(height: UIScreen.isSE ? 14 : 30)
            StatusSlider
            Spacer()
            HStack(spacing: 12) {
                StatusSelectCancelButton
                StatusSelectCompleteButton
            }
            Spacer().frame(height: 33)
        }
    }
    
    var StatusSlider: some View {
        VStack(spacing: 0) {
            Slider(value: $editedSleepStatusLevel,
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
            .foregroundStyle(level <= editedSleepStatusLevel ? .napBlue100 : .napBlackSlider)
            .offset(y: 0.5)
    }
    
    var StatusSelectCancelButton: some View {
        Button {
            cancelSelectingStatus()
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
            completeSelectingStatus()
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
    
    // MARK: Computed Values
    
    var sleepStatus: Image {
        switch editedSleepStatusLevel {
        case 1: return Image(.statusVeryBad)
        case 2: return Image(.statusBad)
        case 3: return Image(.statusNormal)
        case 4: return Image(.statusGood)
        case 5: return Image(.statusVeryGood)
        default: return Image(.statusVeryBad)
        }
    }
    
    // MARK: Action
    
    func toggleBottomButton() {
        isSelectingStatus ? cancelSelectingStatus() : startSelectingStatus()
    }
    
    func startSelectingStatus() {
        isSelectingStatus = true
    }
    
    func completeSelectingStatus() {
        isSelectingStatus = false
        sleepStatusLevel = editedSleepStatusLevel
    }
    
    func cancelSelectingStatus() {
        isSelectingStatus = false
        editedSleepStatusLevel = sleepStatusLevel
    }
}

#Preview {
    FeedRegister(capturedImage: .constant(nil))
}
