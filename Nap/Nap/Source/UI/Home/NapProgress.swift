//
//  NagiProgressView.swift
//  Nap
//
//  Created by YunhakLee on 8/3/24.
//

import SwiftUI
import KDCircularProgress

struct NapProgress: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var timeInterval: Double
    @Binding var showHome: Bool
    
    @State private var progress: Double = 0
    @State private var remainingSeconds: Double = 0
    
    @State private var showRemainTime: Bool = false
    @State private var resetTimer: Timer? = nil
    @State private var showCameraView: Bool = false
    
    let currentDate: Date = Date()
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: UIScreen.isSE ? 60 : 86)
            Title
            Spacer().frame(height: UIScreen.isSE ? 40 : 60)
            TimerChargeProgress
            Spacer().frame(height: UIScreen.isSE ? 20 : 24)
            if !showRemainTime {
                TapInstruction
            }
            Spacer()
            BottomButton
            Spacer().frame(height: 33)
        }
        .padding(.horizontal, 20)
        .background {
            BackgroundImage(image: Image(.basicBackground))
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            remainingSeconds = timeInterval
            startProgress()
        }
        .fullScreenCover(isPresented: $showCameraView) {
            NapFeedRegister(showHome: $showHome)
                .ignoresSafeArea()
        }
        .onChange(of: showHome) { _, _ in
            if showHome {
                dismissView()
            }
        }
        .onChange(of: remainingSeconds) { _, _ in
            if remainingSeconds <= 0 {
                startCall()
            }
        }
    }
}

private extension NapProgress {
    var Title: some View {
        Text(progress >= 354 ? "충전 완료!" : "걱정은 잠시 내려놓고\n편안히 낮잠을 즐겨봐요")
            .font(.napLargeTitle)
            .foregroundStyle(.napWhite100)
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .frame(height: 68)
            .fixedSize()
    }
    
    var TimerChargeProgress: some View {
        ZStack {
            TimerChargeBackground
                .frame(width: UIScreen.size.width-80,
                       height: UIScreen.size.width-80)
            CircularProgressView(progress: $progress)
                .frame(width: (UIScreen.size.width-80)*1.25,
                       height: (UIScreen.size.width-80)*1.25)
            
            Image(.tiredPrince)
                .frame(width: 24, height: 24)
                .background {
                    Circle()
                        .frame(width: 26, height: 26)
                        .foregroundStyle(.napWhite20)
                }
            // Moving To Right & Rotating
                .offset(y: -(UIScreen.size.width-110)/2)
            
            // Slider Buttons
            Image(.freshPrince)
                .frame(width: 24, height: 24)
                .background {
                    Circle()
                        .frame(width: 26, height: 26)
                        .foregroundStyle(.napWhite20)
                }
            // Rotating Image inside the Circle
                .rotationEffect(.degrees(90))
                .rotationEffect(.degrees(-(progress+5)))
            //Moving To Right & Rotating
                .offset(x: (UIScreen.size.width-110)/2)
            // To the Current Angle
                .rotationEffect(.degrees(progress+5))
                .rotationEffect(.init(degrees: -90))
            if showRemainTime {
                RemainTime
            } else {
                TimerChargeBolt
            }
        }
        .frame(width: UIScreen.size.width-80,
               height: UIScreen.size.width-80)
        .overlay(alignment: .bottom) {
            TimerChargePercentage
                .padding(.bottom, 60)
        }
        .overlay(alignment: .top) {
            if showRemainTime {
                RemainTimeInterval
                    .padding(.top, 68)
            }
        }
    }
    
    var TimerChargePercentage: some View {
        Text("\(Int(progress / 3.54))%")
            .font(.napCaption1)
            .foregroundStyle(.napBlue100)
            .frame(width: 55, height: 25)
            .background {
                Capsule()
                    .foregroundStyle(.napBlue20)
            }
        
    }
    
    var TimerChargeBackground: some View {
        ZStack {
            Circle()
                .foregroundStyle(.napWhite10)
            Circle()
                .foregroundStyle(.napWhite10)
                .frame(width: UIScreen.size.width-140,
                       height: UIScreen.size.width-140)
            
            ForEach(1...60, id: \.self) { index in
                Rectangle()
                    .fill(index % 5 == 0 ? .napWhite100
                          : .napWhite20)
                // Each hour will have big Line
                // 60/5 = 12
                // 12 Hours
                    .frame(width: 2,
                           height: index % 5 == 0 ? 10 : 8)
                // Setting into entire Circle
                    .offset(y: (UIScreen.size.width/2) - 57)
                    .rotationEffect(.init(degrees: Double(index) * 6))
            }
        }
    }
    
    var TimerChargeBolt: some View {
        VStack(spacing: 0) {
            Spacer()
            Image(systemName: "bolt.fill")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundColor(.napBlue100)
                .frame(width: (UIScreen.size.width)*(60/393))
            Spacer()
        }
        .frame(width: UIScreen.size.width-140,
               height: UIScreen.size.width-140)
        .background {
            Circle()
                .foregroundStyle(.clear)
        }
        .onTapGesture {
            withAnimation {
                showRemainTime = true
            }
            startResetTimer()
        }
    }
    
    var RemainTimeInterval: some View {
        VStack(spacing: 6) {
            HStack(spacing: 4) {
                Image(.moon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 13, height: 13)
                Text("낮잠 시간")
                    .font(.napCaption2)
                    .foregroundStyle(.napBlue100)
            }
            
            HStack(spacing: 4) {
                Text(currentDate.formatted(date: .omitted, time: .shortened))
                Text("-")
                Text(wakeupTime().formatted(date: .omitted, time: .shortened))
            }
            .font(.napCaption1)
            .foregroundStyle(.napWhite100)
        }
    }
    
    var RemainTime: some View {
        Text(formatTime(Int(remainingSeconds)))
            .font(.napDisplay)
            .foregroundStyle(.napWhite100)
    }
    
    var TapInstruction: some View {
        Text("번개를 탭해서\n남은 낮잠 시간을 확인해보세요")
            .font(.napCaption3)
            .foregroundStyle(.napWhite60)
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .fixedSize()
    }
    
    var BottomButton: some View {
        HStack(spacing: 12) {
            CancelButton
            CheckButton
        }
    }
    
    var CancelButton: some View {
        Button {
            showHome = true
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
            showCamera()
        } label: {
            MainButtonLabel(text: "일어나기")
        }
    }
    
    func dismissView() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func showCamera() {
        showCameraView = true
    }
    
    // MARK: - 번개를 탭했을때 다시 돌아오는 타이머 함수
    func startResetTimer() {
        resetTimer?.invalidate()
        resetTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
            withAnimation {
                showRemainTime = false
            }
        }
    }
    
    // MARK: -  프로그레스바 함수
    func startProgress() {
        let duration = Double(remainingSeconds)
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            if self.remainingSeconds > 0 {
                self.remainingSeconds -= 0.01
                self.progress = (1 - Double(self.remainingSeconds) / duration) * 354
            } else {
                timer.invalidate()
            }
        }
    }
    
    func wakeupTime() -> Date {
        let now = currentDate
        return Calendar.current.date(byAdding: .second, value: Int(timeInterval), to: now) ?? now
    }
    
    func formatTime(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds / 60) % 60
        let remainingSeconds = seconds % 60
        
        return String(format: "%01d:%02d:%02d", hours, minutes, remainingSeconds)
    }
    
    func startCall() {
        DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
            let callManager = CallManager.shared
            let id = UUID()
            callManager.reportIncomingCall(id: id, handle: "TimCook")
        })
    }
}

//#Preview {
//    NagiProgressView(remainingSeconds: .constant(120))
//}
