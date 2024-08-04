//
//  ProgressView.swift
//  TimerTest
//
//  Created by 이승현 on 7/28/24.


import SwiftUI
import KDCircularProgress

struct ProgressView: View {
    @State private var progress: Double = 0
    @Binding var remainingSeconds: Int
    var startTime: Date
    var endTime: Date
    @State private var showOverlayView: Bool = true
    @State private var resetTimer: Timer? = nil
    @Environment(\.presentationMode) var presentationMode
    @State private var showCameraView = false
    @State private var selectedImage: UIImage? = nil
    
    var body: some View {
        ZStack {
            Image("Background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("  걱정은 잠시 내려놓고 \n편안히 낮잠을 즐겨봐요")
                    .foregroundColor(.white)
                    .font(.system(size: 25).bold())
                    .padding(.bottom, 80)
                
                sleepTimeSlider()
                
                Text("             번개를 탭해서 \n남은 낮잠 시간을 확인해보세요")
                    .foregroundColor(.gray)
                    .font(.system(size: 15).bold())
                    .padding(.top, 30)
                
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("취소")
                            .foregroundColor(.white)
                    })
                    .padding(.horizontal, 40)
                    .padding(.vertical, 20)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray).opacity(0.3))
                    
                    Button(action: {
                        showCameraView = true
                    }, label: {
                        Text("일어나기")
                            .foregroundColor(.black)
                    })
                    .padding(.horizontal, 90)
                    .padding(.vertical, 20)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color("ManboBlue400")))
                }
                .padding(.top, 80)
            }
            .padding()
        }
//        .fullScreenCover(isPresented: $showCameraView) {
//            CameraViewTest()
//                .ignoresSafeArea()
//        }
                .onAppear {
                    startProgress()
                }
            
        }
        
        
        @ViewBuilder
        func sleepTimeSlider() -> some View {
            
            GeometryReader { proxy in
                
                let width = proxy.size.width
                
                ZStack {
                    // MARK: - 시계 디자인
                    Circle()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: width - 73, height: width - 73)
                    
                    ZStack {
                        
                        ForEach(1...60, id: \.self) { index in
                            Rectangle()
                                .fill(index % 5 == 0 ? .white : .gray)
                                .frame(width: 2, height: index % 5 == 0 ? 10 : 5)
                                .offset(y: (width - 60) / 2)
                                .rotationEffect(.init(degrees: Double(index) * 6))
                        }
                        
                        let texts = []
                        ForEach(texts.indices, id: \.self) { index in
                            Text("\(texts[index])")
                                .font(.caption.bold())
                                .foregroundColor(.white)
                                .rotationEffect(.init(degrees: Double(index) * -90))
                                .offset(y: (width - 90) / 2)
                                .rotationEffect(.init(degrees: Double(index) * 90))
                        }
                    }
                    
                    KDCircularProgressView(progress: $progress)
                        .frame(width: 400, height: 400)
                    // MARK: - 번개를 탭하는 로직
                    if showOverlayView {
                        VStack {
                            Image(systemName: "bolt.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(Color("ManboBlue400"))
                                .frame(width: 110, height: 110)
                                .padding(.top, 20)
                                .onTapGesture {
                                    withAnimation {
                                        showOverlayView = false
                                    }
                                    startResetTimer()
                                }
                            Text("\(Int(progress / 3.52))%")
                                .padding(.vertical, 5)
                                .padding(.horizontal, 12)
                                .font(.system(size: 15).bold())
                                .foregroundColor(Color("ManboBlue400"))
                                .background(.white.opacity(0.2), in: RoundedRectangle(cornerRadius: 20))
                                .padding(.top, 10)
                        }
                    } else {
                        
                        VStack(spacing: 10) {
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Label {
                                    Text("낮잠 시간")
                                        .foregroundColor(Color("ManboBlue400"))
                                } icon: {
                                    Image(systemName: "moon")
                                        .foregroundColor(Color("ManboBlue400"))
                                }
                                .font(.system(size: 13))
                                .padding(.leading, 15)
                                .padding(.top, 18)
                                
                                Text("\(startTime.formatted(date: .omitted, time: .shortened)) - \(endTime.formatted(date: .omitted, time: .shortened))")
                                    .font(.system(size:13))
                                    .foregroundColor(Color.white)
                            }
                            //남은 낮잠시간 나타내기
                            HStack(spacing: 5) {
                                makeNumberCard(number: formatTime(remainingSeconds)[0])
                                Text(":")
                                makeNumberCard(number: formatTime(remainingSeconds)[1])
                                makeNumberCard(number: formatTime(remainingSeconds)[2])
                                Text(":")
                                makeNumberCard(number: formatTime(remainingSeconds)[3])
                                makeNumberCard(number: formatTime(remainingSeconds)[4])
                            }.font(.system(size: 30).bold())
                                .foregroundColor(.white)
                            
                            //프로그레스바 진행률 게이지 %
                            Text("\(Int(progress / 3.52))%")
                                .padding(.vertical, 5)
                                .padding(.horizontal, 12)
                                .font(.system(size: 15).bold())
                                .foregroundColor(Color("ManboBlue400"))
                                .background(.white.opacity(0.2), in: RoundedRectangle(cornerRadius: 20))
                                .padding(.top, 15)
                            
                        }
                        .scaleEffect(1.1)
                    }
                    
                    
                }
                .frame(width: width, height: width, alignment: .center)
            }
            .frame(width: screenBounds().width / 1.3, height: screenBounds().width / 1.3)
        }
        // MARK: -  프로그레스바 함수
        func startProgress() {
            let duration = Double(remainingSeconds)
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                if self.remainingSeconds > 0 {
                    //self.remainingSeconds -= 1
                    self.progress = (1 - Double(self.remainingSeconds) / duration) * 360
                } else {
                    timer.invalidate()
                }
            }
        }
        // MARK: - 남은 낮잠시간 계산 함수
        func formatTime(_ seconds: Int) -> [String] {
            let hours = seconds / 3600
            
            var minutes = (seconds / 60) % 60 // minutes 값이 60을 초과하면 60을 뺀 나머지가 되도록
            
            // 60이 되면 0으로 설정
            if minutes == 60 {
                minutes = 0
            }
            
            let largeMinutes = minutes / 10
            let smallMinutes = minutes % 10
            
            let remainingSeconds = seconds % 60
            let largeSeconds = remainingSeconds / 10
            let smallSeconds = remainingSeconds % 10
            
            return [
                String(format: "%01d", hours),
                String(format: "%01d", largeMinutes),
                String(format: "%01d", smallMinutes),
                String(format: "%01d", largeSeconds),
                String(format: "%01d", smallSeconds)
            ]
        }
        // MARK: - 남은 낮잠시간의 네모난 회색 배경
        func makeNumberCard(number: String) -> some View {
            Text(number)
                .font(.system(size: 30).bold())
                .foregroundColor(Color.white)
            //            .frame(width: 28, height: 43)
            //            .background(
            //                RoundedRectangle(cornerRadius: 8)
            //                    .fill(Color.gray.opacity(0.5))
            //                    .frame(width: 35, height: 45)
            //            )
        }
        // MARK: - 번개를 탭했을때 다시 돌아오는 타이머 함수
        func startResetTimer() {
            resetTimer?.invalidate()
            resetTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
                withAnimation {
                    showOverlayView = true
                }
            }
        }
        
        
    }
    
    struct ProgressView_Previews: PreviewProvider {
        static var previews: some View {
            ProgressView(remainingSeconds: .constant(600), startTime: Date(), endTime: Date().addingTimeInterval(600))
        }
    }
    
    

