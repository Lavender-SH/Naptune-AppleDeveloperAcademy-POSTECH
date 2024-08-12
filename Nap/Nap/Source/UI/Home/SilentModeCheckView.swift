//
//  NagiCheckSilentModeView.swift
//  Nap
//
//  Created by YunhakLee on 8/3/24.
//

import SwiftUI
import FirebaseFunctions
import FirebaseAuth
import AuthenticationServices

struct SilentModeCheckView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var timeInterval: Double
    @State var showHome: Bool = false
    @State private var moveNext: Bool = false
    
    let firebaseManager = FirebaseManager.shared
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: UIScreen.isSE ? 60 : 86)
            Title
            Spacer().frame(height: UIScreen.isSE ? 20 : 50)
            BellImage
            Spacer().frame(minHeight: 30)
            BottomButton
            Spacer().frame(height: 33)
        }
        .padding(.horizontal, 20)
        .background {
            BackgroundImage(image: Image(.basicBackground))
        }
        .toolbar(.hidden, for: .navigationBar)
        .onChange(of: showHome) { _, _ in
            if showHome {
                dismissView()
            }
        }
        .navigationDestination(isPresented: $moveNext) {
            NapProgress(timeInterval: $timeInterval, showHome: $showHome)
        }
    }
}

private extension SilentModeCheckView {
    var Title: some View {
        Text("친구들의 전화 알림을 받기 위해\n무음모드를 꼭 해제해주세요")
            .font(.napLargeTitle)
            .foregroundStyle(.napWhite100)
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .fixedSize()
    }
    
    var BellImage: some View {
        Image("BellCheck")
            .resizable()
            .scaledToFill()
            .frame(width: imageWidth, height: imageHeight)
    }
    
    var BottomButton: some View {
        HStack(spacing: 12) {
            CancelButton
            CheckButton
        }
    }
    
    var CancelButton: some View {
        Button {
            dismissView()
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
    
    var CheckButton: some View {
        Button {
            moveNextAndNoti()
        } label: {
            MainButtonLabel(text: "확인했어요")
        }
    }
    
    var imageWidth: CGFloat {
        UIScreen.size.width - 40
    }
    
    var imageHeight: CGFloat {
        imageWidth/9*10
    }
    
    
    func dismissView() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func moveNextAndNoti() {
        moveNext = true
        firebaseManager.pushNoti(title: "친구가 잠들었어요!",
                                       body: "\(wakeupTime().formatted(date: .omitted, time: .shortened))에 전화로 낮잠을 깨워주세요.")
    }
    
    func wakeupTime() -> Date {
        let now = Date()
        return Calendar.current.date(byAdding: .second, value: Int(timeInterval), to: now) ?? now
    }
}

#Preview {
    SilentModeCheckView(timeInterval: .constant(25))
}
