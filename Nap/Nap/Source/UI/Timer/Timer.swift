//
//  Home.swift
//  Nap
//
//  Created by YunhakLee on 7/24/24.
//

import SwiftUI

struct Timer: View {
    
    // MARK: - Properties
    @State var startAngle: Double = 0
    // Since our to progress is 0.5
    // 0.5 * 360 = 180
    @State var toAngle: Double = 180
    @State var startProgress: CGFloat = 0
    @State var toProgress: CGFloat = 0.5
    
    var body: some View {
        
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(currentDateString())
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text("타이머")
                        .font(.title.bold())
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Button {
                    
                } label: {
                    Image(systemName: "person.2.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                    //.clipShape(Circle())
                }
            }
            VStack {
                sleepTimeSlider()
                    .padding(.top, 0)
                
                    .padding(.top, 30)
                
                HStack(spacing: 25) {
                    VStack(alignment: .leading, spacing: 8) {
                        Label {
                            Text("잠드는 시간")
                                .foregroundColor(.gray)
                        } icon: {
                            Image(systemName: "moon.fill")
                                .foregroundColor(Color.gray)
                        }
                        .font(.callout)
                        
                        Text(getTime(angle: startAngle).formatted(date: .omitted, time: .shortened))
                            .font(.title2.bold())
                            .foregroundColor(Color.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Label {
                            Text("일어날 시간")
                                .foregroundColor(.gray)
                        } icon: {
                            Image(systemName: "alarm")
                                .foregroundColor(Color.gray)
                        }
                        .font(.callout)
                        
                        Text(getTime(angle: toAngle).formatted(date: .omitted, time: .shortened))
                            .font(.title2.bold())
                            .foregroundColor(Color.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding()
                //.background(.gray.opacity(0.2), in: RoundedRectangle(cornerRadius: 15))
                .padding(.top, 35)
            }
            .background(.gray.opacity(0.2), in: RoundedRectangle(cornerRadius: 15))
            
            VStack {
                Text("Alarm Setting")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)
                    .padding(.top, 10)
                
                List {
                    Section {
                        HStack {
                            Text("반복")
                                .foregroundColor(.white)
                            Spacer()
                            Text("안 함")
                                .foregroundColor(.gray)
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        //.padding(.vertical, 10)
                        .contentShape(Rectangle())
                        .listRowBackground(Color.gray.opacity(0.2))
                        .onTapGesture {
                            // Handle tap
                        }
                        
                        HStack {
                            Text("사운드")
                                .foregroundColor(.white)
                            Spacer()
                            Text("래디얼")
                                .foregroundColor(.gray)
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        //.padding(.vertical, 10)
                        .contentShape(Rectangle())
                        .listRowBackground(Color.gray.opacity(0.2))
                        .onTapGesture {
                            // Handle tap
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .background(Color.black)
                .scrollContentBackground(.hidden)
                .cornerRadius(15)
                .padding(.horizontal, -15)
                .padding(.top, -10)
            }

            
            
            Button {
                
            } label: {
                Text("낮잠 자러가기")
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.horizontal, 130)
                    .padding(.vertical, 15)
                    .background(Color("낮잠 자러가기"))
                    .cornerRadius(10)
            }
            .padding(.top, 0)
            .frame(maxWidth: .infinity, maxHeight: 50)
            //.padding(.horizontal, 10)
        }
        .padding()
        // Moving To Top Without Spacer
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color.black)
        
    }
    // MARK: - Sleep Time Circular Slider
    @ViewBuilder
    func sleepTimeSlider() -> some View {
        
        GeometryReader{ proxy in
            
            let width = proxy.size.width
            
            ZStack {
                
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
                    let texts = [6, 9, 12, 3]
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
                    .stroke(AngularGradient(gradient: Gradient(colors: [Color("낮잠 자러가기"), Color.purple]), center: .center, startAngle: .degrees(0), endAngle: .degrees(360)), style: StrokeStyle(lineWidth: 40, lineCap: .round, lineJoin: .round))
                
                    .rotationEffect(.init(degrees: -90))
                    .rotationEffect(.init(degrees: reverseRotation))
                
                // Slider Buttons
                Image(systemName: "moon.fill")
                    .font(.callout)
                    .foregroundColor(.purple)
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
                                onDrag(value: value, fromSlider: true)
                            })
                    )
                    .rotationEffect(.init(degrees: -90))
                
                
                Image(systemName:  "alarm")
                    .font(.callout)
                    .foregroundColor(Color.purple)
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
                    Text("\(getTimeDifference().0)시간")
                        .font(.largeTitle.bold())
                        .foregroundColor(Color.white)
                    Text("\(getTimeDifference().1)분")
                        .foregroundColor(.gray)
                        .foregroundColor(Color.white)
                }
                .scaleEffect(1.1)
                
            }
            
            
        }
        .frame(width: screenBounds().width / 1.6, height: screenBounds().width / 1.6)
    }
    
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
    
    func getTimeDifference() -> (Int, Int) {
        let calendar = Calendar.current
        
        let result = calendar.dateComponents([.hour, .minute], from: getTime(angle: startAngle), to: getTime(angle: toAngle))
        
        return (result.hour ?? 0, result.minute ?? 0 )
    }
    
    func currentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일 EEEE"  // Korean date format
        formatter.locale = Locale(identifier: "ko_KR")  // Korean locale
        return formatter.string(from: Date())
    }
}


struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Timer()
    }
}

// MARK: - Extensions
extension View {
    // MARK: - Screen Bounds Extension
    func screenBounds() -> CGRect {
        return UIScreen.main.bounds
    }
}
