# Naptune - 낮잠을 공유하는 공간 프라이빗 SNS

<img src="https://github.com/user-attachments/assets/e463b810-f008-44c5-acbd-dadf557f5e18" width="25%">

- [News Article - Apple Developer Academy @ POSTECH 공식 링크드인 기사](https://www.linkedin.com/posts/dannyhhan_%EC%96%B4%EC%A0%9C%EB%8A%94-delights-con%EC%9D%B4%EB%9D%BC%EB%8A%94-%EC%95%A0%ED%94%8C%EB%94%94%EB%B2%A8%EB%A1%9C%ED%8D%BC%EC%95%84%EC%B9%B4%EB%8D%B0%EB%AF%B8-%EB%82%B4%EB%B6%80-%ED%96%89%EC%82%AC%EA%B0%80-%EC%9E%88%EC%97%88%EC%8A%B5%EB%8B%88%EB%8B%A4-ugcPost-7229307555297042433-Fh-y?utm_source=share&utm_medium=member_ios)</br>

- [Naptune - 유튜브 영상 ](https://youtube.com/shorts/w3ANBDRh94c?feature=share)</br>

## Naptune 프로젝트 소개
### 앱 설명
- Naptune 앱은 피로한 현대인들을 위해 설계된 프라이빗 소셜 서비스로, 낮잠 시간을 설정하고 친구들과 함께 공유하며 피로를 회복할 수 있도록 돕습니다. 사용자는 낮잠 타이머와 알림 기능을 통해 효율적으로 휴식을 취하고, 낮잠 후에는 친구들과의 피드백을 통해 긍정적인 경험을 만들어갈 수 있습니다. Naptune은 일상의 에너지를 되찾고, 낮잠 문화를 새롭게 정의합니다.</br>

<img src="https://github.com/user-attachments/assets/770c3224-4bd7-414e-9d58-34df2fc6711b" width="100%">

<img src="https://github.com/user-attachments/assets/5043e167-89c6-4864-92c6-c136279820eb" width="100%">
</br>

### 성과
- Apple Developer Academy @ POSTECH   DELIGHTS-CON 발표

<img src="https://github.com/user-attachments/assets/41cf497b-03d6-4b86-830a-c161207e4cfe" width="100%">

</br>

### 프로젝트 기간
- 2024.07.01 ~ 2024.08.13 (7주) - Apple Developer Academy @ POSTECH (MC3 Challenge)</br>
</br>

### 프로젝트 참여 인원
- iOS Developer 2명, Back-end 1명, Design 2명

</br>

## 기술 스택
- **Framework**
`SwiftUI`, `UIKit`, `WidgetKit`, `ActivityKit`, `CallKit`, `AVFoundation`, `PhotosUI`, `UserNotifications`, `Combine`, `Haptic`, `SnapKit`, `KDCircularProgress`, `AuthenticationService`, `FirebaseFireStore`, `FirebaseStorage`

- **Design Pattern**
`MVVM`

- **Naptune앱의 전체적인 플로우를 표현한 구성도**
 <img src="https://github.com/user-attachments/assets/83b5fd5c-917d-4b3a-8cba-a8231d3ad920" width="100%"></br>

</br>


## Naptune 핵심 기능과 코드 설명

- **1. 낮잠 시간을 설정하는 타이머 기능**</br>
- **2. 낮잠 모드에 진입하면 친구에게 알림(Notification)을 보내 낮잠 상태를 공유하는 기능**
- **3. 정해진 낮잠시간이 종료되면 CallKit을 통해 알림 전화를 제공하는 기능**</br>
- **4. 일어나기 버튼을 누르면 커스텀 카메라 화면으로 이동하는 기능**</br>
- **5. 친구들의 낮잠 기록과 상태를 확인할 수 있는 피드 기능**</br>
- **6. 다이나믹 아일랜드와 라이브 액티비티를 활용하여 백그라운드 모드에서도 남은 낮잠 시간을 실시간으로 확인하는 기능**</br> 

</br>

### 1. 낮잠 시간을 설정하는 타이머 기능
Naptune의 낮잠 타이머 기능은 사용자가 원하는 낮잠 시간을 직관적으로 설정하고, 설정된 시간 동안 남은 시간을 실시간으로 확인할 수 있도록 지원합니다. 이 기능은 인터랙티브한 슬라이더와 프로그레스 바를 통해 사용자 경험을 극대화했으며, 시각적 피드백과 햅틱 피드백을 결합해 편리하고 몰입감 있는 타이머 설정 환경을 제공합니다.</br>

<img src="https://github.com/user-attachments/assets/bfd9ec12-e2e1-46ce-a152-4e3f03bbf6d7" width="100%">

타이머 User Flow

 1. 타이머 설정 및 시각적 피드백
 - 슬라이더 인터페이스를 활용해 사용자가 드래그로 시작 및 종료 시간을 설정
 - 현재 설정된 낮잠 시간을 실시간으로 계산하고 화면에 표시
 - 햅틱 피드백을 추가하여 슬라이더 조작 시 사용자 경험 향상
 </br>
 
 2. 실시간 프로그레스 바
 - KDCircularProgress 라이브러리를 사용하여 남은 시간을 시각적으로 표시
 - 애니메이션 효과를 통해 진행률이 자연스럽게 업데이트
  </br>
  
 - SwiftUI를 활용하여 슬라이더와 프로그레스 바 구성
 
``` swift
@ViewBuilder
func sleepTimeSlider() -> some View {
    GeometryReader { proxy in
        let width = proxy.size.width
        ZStack {
            // 슬라이더 디자인과 시계 표시
            ForEach(1...60, id: \.self) { index in
                Rectangle()
                    .fill(index % 5 == 0 ? .white : .gray)
                    .frame(width: 2, height: index % 5 == 0 ? 10 : 5)
                    .offset(y: (width - 60) / 2)
                    .rotationEffect(.init(degrees: Double(index) * 6))
            }
            // 남은 시간을 나타내는 프로그레스 바
            KDCircularProgressView(progress: $progress)
                .frame(width: width - 40, height: width - 40)
        }
    }
}

```
</br>

 - 타이머 시작과 종료 관리
 
``` swift
func startTimer() {
    timer?.invalidate()
    remainingSeconds = getTimeDifference() * 60
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
        if remainingSeconds > 0 {
            remainingSeconds -= 1
        } else {
            timer?.invalidate()
            timer = nil
            // 타이머 종료 후 행동
        }
    }
}

```

 - 남은 시간 실시간 업데이트
 
``` swift
func startProgress() {
    let duration = Double(remainingSeconds)
    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
        if self.remainingSeconds > 0 {
            self.progress = (1 - Double(self.remainingSeconds) / duration) * 360
        } else {
            timer.invalidate()
        }
    }
}

```
</br>

 - `KDCircularProgress` 라이브러리 사용 방법
 
```swift
import SwiftUI
import KDCircularProgress

struct KDCircularProgressView: UIViewRepresentable {
    @Binding var progress: Double

    func makeUIView(context: Context) -> KDCircularProgress {
        let progressView = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        progressView.startAngle = -90
        progressView.progressThickness = 0.37
        progressView.trackThickness = 0.4
        progressView.clockwise = true
        progressView.gradientRotateSpeed = 1
        progressView.roundedCorners = true
        progressView.glowMode = .forward
        progressView.glowAmount = 0.8
        progressView.set(colors: UIColor(named: "ManboBlue400")!)
        
        progressView.trackColor = UIColor.gray.withAlphaComponent(0.3)
        return progressView
    }

    func updateUIView(_ uiView: KDCircularProgress, context: Context) {
        uiView.angle = progress + 5 // Convert percentage to degrees (100% = 360 degrees)
    }
}

```
