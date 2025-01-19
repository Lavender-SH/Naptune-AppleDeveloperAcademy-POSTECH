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
  
 - SwiftUI를 활용하여 슬라이더와 프로그레스 바 구성한 코드
 
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
</br>

### 2. 낮잠 모드에 진입하면 친구에게 알림(Notification)을 보내 낮잠 상태를 공유하는 기능
Naptune은 사용자가 낮잠 모드에 진입하면 친구들에게 푸시 알림을 보내 낮잠 상태를 실시간으로 공유하는 기능을 제공합니다. 알림은 Firebase Cloud Messaging(FCM)을 통해 전달되며, 사용자와 친구 간의 소셜 인터랙션을 강화하는 데 중점을 두었습니다. 알림에는 낮잠 시작 및 종료 시간이 포함되어 친구가 사용자에게 전화나 메시지로 알림을 보낼 수 있도록 유도합니다.</br>

<p>
<img src="https://github.com/user-attachments/assets/9188c97b-8c20-4675-a26e-24afb5db5396" width="30%">

 <video src="https://github.com/user-attachments/assets/b1d21365-ecff-4e02-b6ac-9e1c2c3ac828" width="49"></video>
 <p>
 </br>

1. 푸시 알림 설정 및 전송
 - Firebase를 활용해 사용자 인증 및 푸시 알림 토큰 관리
 - Firebase Functions를 사용해 알림 전송 로직 처리

2. 알림 내용 구성
 - 사용자가 설정한 낮잠 종료 시간과 개인화된 메시지를 포함하여 친구들에게 직관적인 정보를 제공
 - 알림 제목: "친구가 잠들었어요!"
 - 알림 내용: "오전 10:30에 전화로 낮잠을 깨워주세요!"
 
 3. 사용자 경험 개선
  - 낮잠 모드 진입 시 무음 모드 해제를 유도하여 알림을 놓치지 않도록 안내
  - 알림 전송 성공 여부를 실시간으로 확인하여 사용자 신뢰도 증대</br>
</br>

  - 푸시 알림 전송 로직
``` swift
func sendPushNotification(authToken: String?) {
    guard let authToken = authToken else {
        resultMessage = "No auth token available"
        return
    }
    
    let functions = Functions.functions(region: "asia-northeast3")
    let data: [String: Any] = [
        "token": "사용자 고유 FCM 토큰", 
        "title": "친구가 잠들었어요!",
        "body": "\(wakeupTime().formatted(date: .omitted, time: .shortened))에 전화로 낮잠을 깨워주세요!"
    ]
    
    functions.httpsCallable("sendPushNotification").call(data) { result, error in
        if let error = error as NSError? {
            print("Error sending push notification: \(error.localizedDescription)")
            DispatchQueue.main.async {
                resultMessage = "Error sending push notification: \(error.localizedDescription)"
            }
            return
        }
        
        if let response = result?.data as? [String: Any], let responseMessage = response["response"] as? String {
            DispatchQueue.main.async {
                resultMessage = responseMessage
            }
        } else {
            DispatchQueue.main.async {
                resultMessage = "Unknown response"
            }
        }
    }
}

```
</br>

 - 낮잠 모드 진입 시 알림 트리거
```swift
func moveNextAndNoti() {
    moveNext = true
    fetchAuthToken { token in
        self.authToken = token
        sendPushNotification(authToken: token)
    }
}

```
</br>

 - 알림을 위한 Firebase 인증 토큰 획득
 
```swift
func fetchAuthToken(completion: @escaping (String?) -> Void) {
    if let currentUser = Auth.auth().currentUser {
        currentUser.getIDToken { token, error in
            if let error = error {
                print("Error fetching ID token: \(error.localizedDescription)")
                completion(nil)
            } else {
                completion(token)
            }
        }
    } else {
        print("No user is signed in")
        completion(nil)
    }
}

```
</br>

### 3. 정해진 낮잠 시간이 종료되면 CallKit을 통해 알림 전화를 제공하는 기능
Naptune 앱의 독특한 기능 중 하나는 낮잠 시간이 종료되었을 때 `CallKit`을 사용하여 알림 전화를 제공하는 것입니다. 이 기능은 사용자가 낮잠에서 깨어나야 할 시간을 놓치지 않도록 돕는 동시에, 사용자 경험을 풍부하게 만듭니다.
</br>

<img src="https://github.com/user-attachments/assets/40a7033e-822f-4b6e-a2e9-4d82bdeef769" width="30%">

 1. 타이머 시간 종료 이벤트 감지
 - 앱은 설정된 낮잠 시간이 종료되었을 때 startCall() 메서드를 실행
 - 남은 시간이 0 이하가 되면 CallManager가 호출
 </br>
 
 2. CallKit을 통한 전화 알림
 - CallManager는 `CallKit`을 활용하여 가상 전화를 생성
 - 사용자 디바이스에서 실제 전화가 온 것처럼 알림이 표시되며, 이를 통해 사용자가 확실히 알림을 받을 수 있습니다.
 </br>
 
 3. CXProvider를 사용한 전화 생성
 - CXProvider와 CXCallController를 사용하여 가상 전화를 생성하고 관리
 - UUID를 활용하여 각 전화 호출을 고유하게 식별
 - CXCallUpdate를 사용하여 전화의 세부 정보(예: 발신자 이름, 핸들)를 설정
 
 ``` swift
 final class CallManager: NSObject, CXProviderDelegate {
    let provider = CXProvider(configuration: CXProviderConfiguration())
    let callController = CXCallController()

    static let shared = CallManager()

    private override init() {
        super.init()
        provider.setDelegate(self, queue: nil)
    }

    func reportIncomingCall(id: UUID, handle: String) {
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: handle)

        provider.reportNewIncomingCall(with: id, update: update) { error in
            if let error = error {
                print("Error reporting incoming call: \(error.localizedDescription)")
            } else {
                print("Call Reported")
            }
        }
    }
}

```
</br>

 - NapProgress의 타이머 종료 이벤트
``` swift
 func startCall() {
    DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
        let callManager = CallManager.shared
        let id = UUID()
        callManager.reportIncomingCall(id: id, handle: "여우")
    })
}

```
</br>

### 4. 일어나기 버튼을 누르면 커스텀 카메라 화면으로 이동하는 기능
Naptune 앱은 낮잠 후 사용자가 기상 상태를 기록할 수 있도록 커스텀 카메라 화면으로 이동하는 기능을 제공합니다. 이 기능은 사용자가 기상 사진을 촬영하고 이를 앱 피드에 업로드하여 친구들과 공유할 수 있는 독특한 경험을 제공합니다.
</br>

<img src="https://github.com/user-attachments/assets/e489700f-17c5-4452-a63d-180582c161f3" width="30%">

### 4-1. 일어나기 버튼을 누르면 카메라 화면으로 전환
 - `SwiftUI`의 UIViewControllerRepresentable을 사용하여 `UIKit`의 UIViewController를 `SwiftUI` 뷰에 통합
 - NapPhotoView가 커스텀 카메라 화면을 제공하며, 카메라 제어는 CameraCoordinator에서 관리
 
 ``` swift
 struct NapPhotoView: UIViewControllerRepresentable {
    @Binding var capturedImage: UIImage?

    func makeUIViewController(context: Context) -> UIViewController {
        let containerVC = UIViewController()
        let overlayView = createOverlayView(context: context, containerVC: containerVC)
        containerVC.view.addSubview(overlayView)
        return containerVC
    }
    
    func createOverlayView(context: Context, containerVC: UIViewController) -> UIView {
        // 카메라 미리보기 및 커스텀 UI 구성
        let cameraView = CameraPreview()
        let shutterButton = UIButton(type: .system)
        shutterButton.addTarget(context.coordinator, action: #selector(CameraCoordinator.shutterButtonTapped), for: .touchUpInside)
        // SnapKit을 사용하여 레이아웃 구성
        return cameraView
    }
}

```
</br>
 
### 4-2. 카메라 초기화 및 세션 구성
 - `AVFoundation`을 사용하여 전면/후면 카메라를 설정하고, 사진 캡처 및 실시간 미리보기 화면 제공
 - 사용자 편의를 위한 커스텀 UI(셔터 버튼, 카메라 전환 버튼 등) 제공
 - CameraCoordinator는 카메라 제어 로직을 담당
 
``` swift
class CameraCoordinator: NSObject, AVCapturePhotoCaptureDelegate {
    func setupCameraSession() {
        guard let frontCamera = getCameraDevice(position: .front) else { return }
        let frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
        captureSession.addInput(frontCameraInput)
        setupPhotoOutput()
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let data = photo.fileDataRepresentation(), let image = UIImage(data: data) {
            capturedImage = image // 캡처된 이미지를 저장
        }
    }
}

```
</br>
  
 
 ### 4-3. 사진 촬영 및 캡처 결과 처리
 - AVCapturePhotoOutput을 통해 사진을 촬영하고, 전면 카메라의 좌우 반전된 이미지는 적절히 수정하여 저장
 - CameraPreview 클래스는 실시간 카메라 화면과 사진 캡처 후 결과를 표시
 
```swift
class CameraPreview: UIView {
    let captureSession = AVCaptureSession()
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCamera()
    }
    
    private func setupCamera() {
        // 전면 카메라로 세션 구성
        let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        let input = try? AVCaptureDeviceInput(device: frontCamera!)
        captureSession.addInput(input!)
        captureSession.startRunning()
    }
}

```
</br>

 ### 4-4. 왜 카메라 구현에 UIKit을 선택했는가?
 1. 정교한 카메라 제어 필요
 - SwiftUI는 기본적으로 카메라 기능을 제공하지 않습니다. 반면, UIKit의 `AVFoundation`은 카메라 세션, 사진 촬영, 전환 등 복잡한 기능을 완벽히 지원합니다.
 </br>
 
 2. 성능 최적화 및 유연성
 - AVCaptureSession과 AVCapturePhotoOutput을 통해 실시간 미리보기와 사진 캡처를 효율적으로 구현 가능
 - 복잡한 커스텀 레이아웃(셔터 버튼, 전환 버튼 등)을 구성하기 위해 UIKit의 UIView와 SnapKit을 사용
</br>

 3. SwiftUI와의 완벽한 통합
 - UIViewControllerRepresentable을 사용하여 SwiftUI의 장점(데이터 바인딩, 선언형 UI)과 UIKit의 강력한 기능을 결합
</br>

### 5. 친구들의 낮잠 기록과 상태를 확인할 수 있는 피드 기능
Naptune 앱은 친구들의 낮잠 기록과 상태를 한눈에 확인할 수 있는 소셜 피드 기능을 제공합니다. 사용자는 친구들의 낮잠 시간, 상태, 그리고 관련 코멘트를 확인하며 서로의 경험을 공유할 수 있습니다. 이 기능은 Firebase Firestore와 Storage를 기반으로 데이터를 관리하며, SwiftUI로 사용자 친화적인 UI를 구현했습니다.
</br>

<img src="https://github.com/user-attachments/assets/72cfc865-434f-4dec-969b-2760edc308d9" width="100%">
</br>

### 5-1. FireStore 데이터 연동
 - FeedViewModel에서 Firebase Firestore의 posts 컬렉션 데이터를 실시간으로 가져와 SwiftUI 뷰에 반영
 - 데이터는 @Published 변수를 통해 자동 업데이트되어 사용자에게 최신 정보를 제공
 
``` swift
struct Post: Codable {
    let id: String
    let nickname: String
    let profileImageUrl: String
    let imageUrl: String
    let sleepComent: String
    let sleepStatusLevel: Double
    let sleepTime: Double
    let date: Date
}
```
</br>

- FeedViewModel은 Firestore에서 데이터를 가져와 posts 배열로 관리
 
``` swift
class FeedViewModel: ObservableObject {
    @Published var posts: [Post] = []

    init() {
        fetchPosts()
    }

    func fetchPosts() {
        let db = Firestore.firestore()
        db.collection("posts")
          .order(by: "date", descending: true)
          .getDocuments { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                return
            }
            self.posts = snapshot?.documents.compactMap { document -> Post? in
                try? document.data(as: Post.self)
            } ?? []
        }
    }
}

```

### 5-2. 포스트 등록 및 업로드
- FeedRegisterViewModel은 사용자가 등록한 데이터를 Firebase에 업로드하는 로직을 관리

``` swift
class FeedRegisterViewModel {
    var selectedImage: UIImage?
    var sleepComent: String? = ""
    var sleepStatusLevel: Double?

    func uploadPost(capturedImage: UIImage?, sleepComent: String, sleepStatusLevel: Double, sleepTime: Double) async {
        let nickname = UserDefaults.standard.string(forKey: "nickname") ?? "Unknown"
        let profileImageUrl = UserDefaults.standard.string(forKey: "profileImageUrl") ?? ""
        
        guard let capturedImage = capturedImage else { return }
        guard let imageUrl = await uploadImage(uiImage: capturedImage) else { return }
        
        // 현재 로그인된 사용자의 UID 가져오기
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Error: No current user ID found.")
            return
        }
        
        // Firestore에 저장할 Post 객체 생성
        let post = Post(id: UUID().uuidString, nickname: nickname, profileImageUrl: profileImageUrl, imageUrl: imageUrl, sleepComent: sleepComent, sleepStatusLevel: sleepStatusLevel, sleepTime: sleepTime, date: Date())
        
        // Firestore에 문서 ID를 사용자 UID로 설정하고 데이터 저장
        let postReference = Firestore.firestore().collection("posts").document(UUID().uuidString)
        
        do {
            let encodedData = try Firestore.Encoder().encode(post)
            try await postReference.setData(encodedData)
        } catch {
            print("DEBUG: Failed to upload post with error \(error.localizedDescription)")
        }
    }
    
    func uploadImage(uiImage: UIImage) async -> String? {
        guard let imageData = uiImage.jpegData(compressionQuality: 0.5) else { return nil }
        let fileName = UUID().uuidString
        let reference = Storage.storage().reference(withPath: "/images/\(fileName).jpg")
        
        do {
            let _ = try await reference.putDataAsync(imageData)
            let url = try await reference.downloadURL()
            return url.absoluteString
        } catch {
            print("DEBUG: Failed to upload image with error \(error.localizedDescription)")
            return nil
        }
    }
}

```
</br>

### 6. 다이나믹 아일랜드와 라이브 액티비티를 활용하여 백그라운드 모드에서도 남은 낮잠 시간을 실시간으로 확인하는 기능
Naptune 앱은 Dynamic Island와 Live Activities를 활용하여 앱이 백그라운드 상태에서도 남은 낮잠 시간을 실시간으로 확인할 수 있는 기능을 제공합니다. 사용자는 잠자는 동안 iPhone 화면을 볼 필요 없이 Dynamic Island나 잠금 화면에서 바로 남은 시간을 확인할 수 있습니다.
</br>

<img src="https://github.com/user-attachments/assets/b67d7427-0881-4140-86b7-62ff22c60159" width="30%">


### 6-1. ActivityKit의 Activity 객체를 사용해 남은 낮잠 시간을 실시간으로 업데이트합니다.
 - NapStatusAttributes와 ContentState를 통해 상태 데이터를 관리
 
 ``` swift
 struct NapStatusAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var remainingTime: Int = 0
    }
}

 ```

### 6-2. Live Activity 구현
 - NapStatusLiveActivity는 Dynamic Island와 잠금 화면에서 표시될 UI를 정의
 
 ``` swift
struct NapStatusLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: NapStatusAttributes.self) { context in
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color("상단네이비"), Color("하단네이비")]),
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    .opacity(0.5)
                
                VStack {
                    Text("남은 낮잠 시간")
                        .font(.headline)
                        .foregroundColor(.white)
                    Text("\(context.state.remainingTime / 3600)시간 \((context.state.remainingTime % 3600) / 60)분 \((context.state.remainingTime % 3600) % 60)초")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
            }
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.center) {
                    Text("Nap - \(context.state.remainingTime / 60)분 남음")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("시간이 다 되면 알람이 울립니다.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            } compactLeading: {
                Image(systemName: "bolt.fill")
            } compactTrailing: {
                Text("\(context.state.remainingTime / 60)분")
            } minimal: {
                Image(systemName: "bolt.fill")
            }
        }
    }
}

 ```
</br>

### 6-3. 데이터 업데이트
 - Activity.update(using:)를 사용하여 라이브 상태를 실시간으로 변경
 
``` swift
func updateLiveActivity(remainingTime: Int) {
    guard let activity = Activity<NapStatusAttributes>.activities.first else { return }
    let updatedContentState = NapStatusAttributes.ContentState(remainingTime: remainingTime)
    Task {
        await activity.update(using: updatedContentState)
    }
}
 
```
