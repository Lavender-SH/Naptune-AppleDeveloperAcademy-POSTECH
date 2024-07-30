//
//  Home.swift
//  Nap
//
//  Created by YunhakLee on 7/24/24.
//

import SwiftUI

struct Home: View {
    
    // MARK: - Properties
    @State var startAngle: Double = 0
    // Since our to progress is 0.5
    // 0.5 * 360 = 180
    @State var toAngle: Double = 180
    @State var startProgress: CGFloat = 0
    @State var toProgress: CGFloat = 0.5
    @State private var lastHapticAngle: Double = 0
    // Timer properties
    @State private var timer: Timer?
    @State private var remainingSeconds: Int = 0
    @State private var totalDuration: Int = 0
    
    @State private var isShowingProgressView = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("낮잠")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
                            //                            Text(currentDateString())
                            //                                .font(.headline)
                            //                                .foregroundColor(.gray)
                            HStack {
                                Text("Zzz..")
                                    .font(.system(size: 20).bold())
                                    .foregroundColor(.white)
                                Spacer()
                                Button {
                                    
                                } label: {
                                    
                                    Image(systemName: "person.2")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.white)
                                    Text("친구 4 / 6")
                                        .foregroundStyle(.white)
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal, 16)
                                .background(.white.opacity(0.2), in: RoundedRectangle(cornerRadius: 20))
                                
                                
                            }
                            Text("지금 깨어있는 친구들")
                                .font(.system(size: 15).bold())
                                .foregroundStyle(.gray)
                            HStack {
                                Circle()
                                    .foregroundColor(.gray)
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Image("여우")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 50, height: 50)
                                    )
                                Circle()
                                    .foregroundColor(.gray)
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Image("여우")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 50, height: 50)
                                    )
                                Circle()
                                    .foregroundColor(.gray)
                                    .frame(width: 50, height: 50)
                                    .overlay(
                                        Image("여우")
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 50, height: 50)
                                    )
                            }
                            Text("낮잠 설정하기")
                                .font(.system(size: 15).bold())
                                .foregroundStyle(.gray)
                                .padding(.top, 13)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                    .padding(.top, 40)
                    VStack {
                        VStack{
                            HStack(spacing: 0) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Label {
                                        Text("낮잠 시간")
                                            .foregroundColor(Color("ManboBlue400"))
                                    } icon: {
                                        Image(systemName: "moon")
                                            .foregroundColor(Color("ManboBlue400"))
                                    }
                                    .font(.callout)
                                    
                                    Text(currentKSTTime().formatted(date: .omitted, time: .shortened))
                                        .font(.title2.bold())
                                        .foregroundColor(Color.white)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Label {
                                        Text("일어날 시간")
                                            .foregroundColor(Color("ManboBlue400"))
                                    } icon: {
                                        Image(systemName: "alarm")
                                            .foregroundColor(Color("ManboBlue400"))
                                    }
                                    .font(.callout)
                                    
                                    Text(wakeupTime().formatted(date: .omitted, time: .shortened))
                                        .font(.title2.bold())
                                        .foregroundColor(Color.white)
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                            }
                            .padding()
                            //.padding(.top, 35)
                            VStack{
                                sleepTimeSlider()
                                    .padding(.top, 10)
                                Button {
                                    startTimer()
                                    isShowingProgressView = true
                                } label: {
                                    Text("낮잠 자러가기")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                        .padding(.horizontal, 110)
                                        .padding(.vertical, 15)
                                        .background(Color("ManboBlue400"))
                                        .cornerRadius(10)
                                }
                                .padding(.top, 50)
                                .padding(.bottom, 30)
                            }//.background(.blue.opacity(0.8), in: RoundedRectangle(cornerRadius: 15))
                            NavigationLink(destination: ProgressView(remainingSeconds: $remainingSeconds, startTime: currentKSTTime(), endTime: wakeupTime()), isActive: $isShowingProgressView) {
                                EmptyView()
                            }
                        }.background(.gray.opacity(0.2), in: RoundedRectangle(cornerRadius: 15))
                    }//.background(.red.opacity(0.8), in: RoundedRectangle(cornerRadius: 15))
                    
                    
                }
                .padding()
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
    }
    // MARK: - Sleep Time Circular Slider
    @ViewBuilder
    func sleepTimeSlider() -> some View {
        
        GeometryReader{ proxy in
            
            let width = proxy.size.width
            
            ZStack {
                
                // Background Image
                Image("낮잠")
                    .resizable()
                    .scaledToFill()
                    .frame(width: width - 40, height: width - 40)
                    .clipShape(Circle())
                    .edgesIgnoringSafeArea(.all)
                
                // MARK: - Clock Design
                ZStack {
                    
                    ForEach(1...60, id: \.self) { index in
                        Rectangle()
                            .fill(index % 5 == 0 ? .white : .gray)
                        // Each hour will have big Line
                        // 60/5 = 12
                        // 12 Hours
                            .frame(width: 2, height: index % 5 == 0 ? 10 : 5)
                        // Setting into entire Circle
                            .offset(y: (width - 60) / 2)
                            .rotationEffect(.init(degrees: Double(index) * 6))
                        
                    }
                    // MARK: - Clock Text
                    let texts = [60, 90, 120, 30]
                    ForEach(texts.indices, id: \.self) { index in
                        Text("\(texts[index])")
                            .font(.caption.bold())
                            .foregroundColor(.white)
                            .rotationEffect(.init(degrees: Double(index) * -90))
                            .offset(y: (width - 90) / 2)
                            .rotationEffect(.init(degrees: Double(index) * 90))
                        
                        
                    }
                    
                }
                
                Circle()
                    .stroke(.gray.opacity(0.3), lineWidth: 40)
                
                // Allowing Reverse Swiping
                let reverseRotation = (startProgress > toProgress) ? -Double((1 - startProgress) * 360) : 0
                Circle()
                    .trim(from: startProgress > toProgress ? 0 : startProgress, to: toProgress + (-reverseRotation / 360))
                //.stroke(Color.purple, style: StrokeStyle(lineWidth: 40, lineCap: .round, lineJoin: .round))
                    .stroke(AngularGradient(gradient: Gradient(colors: [Color("ManboBlue400").opacity(1), Color("ManboBlue400")]), center: .center, startAngle: .degrees(0), endAngle: .degrees(360)), style: StrokeStyle(lineWidth: 40, lineCap: .round, lineJoin: .round))
                
                    .rotationEffect(.init(degrees: -90))
                    .rotationEffect(.init(degrees: reverseRotation))
                
                // Slider Buttons
                Image(systemName: "moon.fill")
                    .font(.callout)
                    .foregroundColor(Color("ManboBlue400"))
                    .frame(width: 30, height: 30)
                    .rotationEffect(.init(degrees: 90))
                    .rotationEffect(.init(degrees: -startAngle))
                    .background(.white, in: Circle())
                // Moving To Right & Rotating
                    .offset(x:width / 2)
                    .rotationEffect(.init(degrees: startAngle))
                    .gesture(
                        
                        DragGesture()
                            .onChanged({ value in
                                onDrag(value: value)
                            })
                    )
                    .rotationEffect(.init(degrees: -90))
                
                
                Image(systemName:  "alarm")
                    .font(.callout)
                    .foregroundColor(Color("ManboBlue400"))
                    .frame(width:30, height: 30)
                // Rotating Image inside the Circle
                    .rotationEffect(.init(degrees: 90))
                    .rotationEffect(.init(degrees: -toAngle))
                    .background(.white, in: Circle())
                //Moving To Right & Rotating
                    .offset(x: width / 2)
                // To the Current Angle
                    .rotationEffect(.init(degrees: toAngle))
                // For more About Circular Slider
                // Check out my Circular Slider
                // Check out my Circular Slider Video
                // Link in Bio
                    .gesture(
                        
                        DragGesture()
                            .onChanged({ value in
                                onDrag(value: value)
                            })
                    )
                    .rotationEffect(.init(degrees: -90))
                
                
                // MARK: - Hour Text
                VStack(spacing: 6) {
                    HStack(spacing: 5) {
                        makeNumberCard(number: formatTime(getTimeDifference() * 60)[0])
                        makeNumberCard(number: formatTime(getTimeDifference() * 60)[1])
                        Text(":")
                            .font(.system(size: 40).bold())
                            .foregroundColor(Color.white)
                        makeNumberCard(number: formatTime(getTimeDifference() * 60)[2])
                        makeNumberCard(number: formatTime(getTimeDifference() * 60)[3])
                    }
                }
                .scaleEffect(1.1)
                
            }
            
            
        }
        .frame(width: screenBounds().width / 1.3, height: screenBounds().width / 1.3)
    }
    
    //moon.fill 자유롭게 움직임
    func onDrag(value: DragGesture.Value, fromSlider: Bool = false) {
        // MARK: - Converting Translation into Angle
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        // Removing the Button Radius
        // Button Diameter = 30
        // Radius = 15
        let radians = atan2(vector.dy - 15, vector.dx - 15)
        
        // Converting into Angle
        var angle = radians * 180 / .pi
        if angle < 0 { angle = 360 + angle }
        
        //Progress
        let progress = angle / 360
        
        if fromSlider {
            self.startAngle = angle
            self.startProgress = progress
            
        }
        else {
            // Update To Values
            self.toAngle = angle
            self.toProgress = progress
        }
    }
    //moon.fill 고정
    func onDrag(value: DragGesture.Value) {
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        let radians = atan2(vector.dy - 15, vector.dx - 15)
        var angle = radians * 180 / .pi
        if angle < 0 { angle = 360 + angle }
        let progress = angle / 360
        
        self.toAngle = angle
        self.toProgress = progress
        
        if abs(angle - lastHapticAngle) >= 2 {
            HapticManager.instance.impact(style: .light)
            lastHapticAngle = angle
        }
    }
    
    // MARK: - Timer Functions
    func startTimer() {
        timer?.invalidate()
        remainingSeconds = getTimeDifference() * 60
        totalDuration = remainingSeconds
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if remainingSeconds > 0 {
                remainingSeconds -= 1
            } else {
                timer?.invalidate()
                timer = nil
            }
        }
    }
    
    func cancelTimer() {
        timer?.invalidate()
        timer = nil
        remainingSeconds = totalDuration
    }
    // MARK: - Returning Time based on Drag
    
    func getTime(angle: Double) -> Date {
        let progress = angle / 30
        let hour = Int(progress) + 12 % 24
        let remainder = (progress * 60).rounded()
        let minute = Int(remainder) % 60
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        
        if let date = formatter.date(from: "\(hour):\(minute):00") {
            return date
        }
        return .init()
    }
    
    func getMinutes(angle: Double) -> Int {
        let progress = angle / 3
        return Int(progress) % 120
    }
    
    func getTimeDifference() -> Int {
        let startMinutes = getMinutes(angle: startAngle)
        let endMinutes = getMinutes(angle: toAngle)
        return (endMinutes - startMinutes + 120) % 120
    }
    
    func currentKSTTime() -> Date {
        let now = Date()
        let timeZone = TimeZone(identifier: "Asia/Seoul")!
        let secondsFromGMT = timeZone.secondsFromGMT(for: now)
        return now.addingTimeInterval(TimeInterval(secondsFromGMT - TimeZone.current.secondsFromGMT(for: now)))
    }
    
    func wakeupTime() -> Date {
        let now = currentKSTTime()
        let addedMinutes = getTimeDifference()
        return Calendar.current.date(byAdding: .minute, value: addedMinutes, to: now) ?? now
    }
    
    func currentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일 EEEE"  // Korean date format
        formatter.locale = Locale(identifier: "ko_KR")  // Korean locale
        return formatter.string(from: Date())
    }
    
    func formatTime(_ seconds: Int) -> [String] {
        let minutes = seconds / 60
        let largeMinutes = minutes / 10
        let smallMinutes = minutes % 10
        
        let remainingSeconds = seconds % 60
        let largeSeconds = remainingSeconds / 10
        let smallSeconds = remainingSeconds % 10
        return [String(format: "%01d", largeMinutes), String(format: "%01d", smallMinutes), String(format: "%01d", largeSeconds), String(format: "%01d", smallSeconds)]
    }
    
    func makeNumberCard(number: String) -> some View {
        Text(number)
            .font(.system(size: 30).bold())
            .foregroundColor(Color.white)
            .frame(width: 35, height: 50)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 35, height: 45)
            )
    }
}


#Preview {
    Home()
}


// MARK: - Extensions
extension View {
    // MARK: - Screen Bounds Extension
    func screenBounds() -> CGRect {
        return UIScreen.main.bounds
    }
}





