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
- Apple Developer Academy @ POSTECH DELIGHTS-CON 발표

<img src="https://github.com/user-attachments/assets/41cf497b-03d6-4b86-830a-c161207e4cfe" width="100%">

</br>

### 프로젝트 기간
- 2024.07.01 ~ 2024.08.13 (7주) - Apple Developer Academy @ POSTECH (MC3 Challenge)</br>
</br>

### 프로젝트 참여 인원
- iOS Developer 2명, Back-end 1명, Design 1명, PM 1명

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
- **2. 잠 모드에 진입하면 친구에게 알림(Notification)을 보내 낮잠 상태를 공유하는 기능**
- **3. 정해진 낮잠시간이 종료되면 CallKit을 통해 알림 전화를 제공하는 기능**</br>
- **4. 일어나기 버튼을 누르면 커스텀 카메라 화면으로 이동하는 기능**</br>
- **5. 친구들의 낮잠 기록과 상태를 확인할 수 있는 피드 기능**</br>
- **6. 다이나믹 아일랜드와 라이브 액티비티를 활용하여 백그라운드 모드에서도 남은 낮잠 시간을 실시간으로 확인하는 기능**</br> 
