//
//  CameraPreview.swift
//  Nap
//
//  Created by 이승현 on 8/3/24.
//

import UIKit
import AVFoundation

class CameraPreview: UIView {
    let captureSession = AVCaptureSession() // AVCaptureSession 인스턴스 생성, 카메라 세션을 관리
    let previewLayer = AVCaptureVideoPreviewLayer() // AVCaptureVideoPreviewLayer 인스턴스 생성, 카메라 미리보기를 위한 레이어
    var photoOutput: AVCapturePhotoOutput? // 사진 출력을 처리하기 위한 변수 추가
    let capturedImageView = UIImageView() // 캡처된 이미지를 표시할 UIImageView 추가
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCamera()
        setupCapturedImageView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCamera()
        setupCapturedImageView()
    }
    
    
    private func setupCamera() {
        captureSession.sessionPreset = .photo // 세션 프리셋을 사진 촬영으로 설정
        
        // 기본 비디오 입력 장치(카메라)를 가져옴
        guard let camera = AVCaptureDevice.default(for: .video) else {
            return // 카메라가 없는 경우 반환
        }
        
        do {
            // 카메라를 세션 입력으로 추가
            let input = try AVCaptureDeviceInput(device: camera)
            captureSession.addInput(input)
        } catch {
            // 카메라 입력 생성 실패 시 에러 출력
            print("Failed to create camera input: \(error)")
            return
        }
        
        previewLayer.session = captureSession // 미리보기 레이어에 세션 할당
        previewLayer.videoGravity = .resizeAspectFill // 비디오 미리보기의 비율을 유지하며 뷰의 크기에 맞게 조정
        layer.addSublayer(previewLayer) // 레이어에 미리보기 레이어 추가
        
        //captureSession.startRunning()이 메인 스레드에서 실행되면 UI가 차단될 수 있기 때문에 비동기 실행
        DispatchQueue.global(qos: .background).async {
            self.captureSession.startRunning() //카메라 세션 시작
        }
    }
    
    // MARK: - 사진 찍힌 결과물을 보여주기 위한 ImageView
    private func setupCapturedImageView() {
        capturedImageView.contentMode = .scaleAspectFill
        capturedImageView.clipsToBounds = true
        //capturedImageView.alpha = 1 // 반투명하게 설정하여 프리뷰와 함께 보이도록 설정
        addSubview(capturedImageView)
        capturedImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    // 레이아웃 서브뷰를 설정하는 메서드
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer.frame = bounds // 미리보기 레이어의 프레임을 뷰의 경계에 맞게 설정
    }
}
