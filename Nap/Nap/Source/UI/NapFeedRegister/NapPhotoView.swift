//
//  CameraViewTest.swift
//  Nap
//
//  Created by 이승현 on 8/3/24.
//

import SwiftUI
import AVFoundation
import SnapKit

struct NapPhotoView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var capturedImage: UIImage?
    
    let cameraView = CameraPreview()
    
    // 뷰 업데이트 메서드 (여기서는 사용하지 않음, 필수 메서드 프로토콜)
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
    
    // MARK: - 카메라 조작 버튼을 위한 Coordinator 생성
    func makeCoordinator() -> CameraCoordinator {
        CameraCoordinator(parent: self, cameraView: cameraView) // CameraCoordinator 초기화 시 CameraPreview 전달
    }
    
    // MARK: - 커스텀 된 카메라를 올리기 위한 UIViewController 생성
    func makeUIViewController(context: Context) -> UIViewController {
        // 1. UIViewController 생성
        let containerVC = UIViewController()
        containerVC.view.backgroundColor = UIColor.purple
        
        // 2. 오버레이 뷰 생성 및 설정
        let overlayView = createOverlayView(context: context, containerVC: containerVC)
        containerVC.view.addSubview(overlayView) // 오버레이 뷰를 컨테이너 뷰에 추가
        overlayView.snp.makeConstraints { make in
            make.edges.equalToSuperview() // 오버레이 뷰의 제약 조건 설정
        }
        
        return containerVC
    }
    // MARK: - 카메라 커스텀 오버레이 뷰 설정
    func createOverlayView(context: Context, containerVC: UIViewController) -> UIView {
        let overlayView = UIView()
        
        // 1.배경 이미지 설정
        let backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "Background")
        backgroundImageView.contentMode = .scaleAspectFill
        overlayView.addSubview(backgroundImageView)
        overlayView.sendSubviewToBack(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        // 2. 카메라 미리보기 설정
        cameraView.clipsToBounds = true
        cameraView.layer.cornerRadius = 20
        backgroundImageView.addSubview(cameraView)
        
        cameraView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(cameraView.snp.width).multipliedBy(4.0 / 3.0)
            make.top.equalToSuperview().inset(UIScreen.isSE ? 53 : 133)
        }
        
        // 사용자 정의 셔터 버튼 추가
        let cancelSwitchButtonHeight: CGFloat = 67
        let shutterButtonHeight: CGFloat = 85
        
        // 커스텀 취소 버튼 (왼쪽 하단)
        let cancelButton = UIButton(type: .system)
        cancelButton.backgroundColor = .napWhite10
        cancelButton.setImage(UIImage(resource: .X).withTintColor(.napWhite100, renderingMode: .alwaysTemplate), for: .normal)
        cancelButton.tintColor = .napWhite100
        cancelButton.layer.cornerRadius = cancelSwitchButtonHeight / 2
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.napWhite10.cgColor
        cancelButton.addTarget(context.coordinator, action: #selector(CameraCoordinator.cancelButtonTapped), for: .touchUpInside)
        
        // SnapKit으로 취소 버튼 레이아웃 설정
        cancelButton.snp.makeConstraints { make in
            make.width.height.equalTo(cancelSwitchButtonHeight)
        }
        
        // 커스텀 셔터 버튼 (중앙 하단)
        let shutterButton = UIButton(type: .system)
        shutterButton.backgroundColor = .clear
        shutterButton.tintColor = .white
        shutterButton.setImage(UIImage(named: "shutter"), for: .normal)
        shutterButton.imageView?.contentMode = .scaleAspectFill
        shutterButton.layer.cornerRadius = shutterButtonHeight / 2
        shutterButton.addTarget(context.coordinator, action: #selector(CameraCoordinator.shutterButtonTapped), for: .touchUpInside)
        
        // SnapKit으로 셔터 버튼 레이아웃 설정
        shutterButton.snp.makeConstraints { make in
            make.width.height.equalTo(shutterButtonHeight)
        }
        
        // 카메라 전환 버튼 추가 (오른쪽 하단)
        let switchCameraButton = UIButton(type: .system)
        switchCameraButton.backgroundColor = .napWhite10
        switchCameraButton.setImage(UIImage(resource: .refreshCw), for: .normal)
        switchCameraButton.tintColor = .napWhite100
        switchCameraButton.layer.cornerRadius = cancelSwitchButtonHeight / 2
        switchCameraButton.layer.borderWidth = 1
        switchCameraButton.layer.borderColor = UIColor.napWhite10.cgColor
        switchCameraButton.addTarget(context.coordinator, action: #selector(CameraCoordinator.switchCameraButtonTapped), for: .touchUpInside)
        
        // SnapKit으로 카메라 전환 버튼 레이아웃 설정
        switchCameraButton.snp.makeConstraints { make in
            make.width.height.equalTo(cancelSwitchButtonHeight)
        }
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 40
        stackView.alignment = .center
        overlayView.addSubview(stackView)
        [cancelButton, shutterButton, switchCameraButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(cameraView.snp.bottom).offset(UIScreen.isSE ? 30 : 36)
            make.centerX.equalToSuperview()
        }
        
        return overlayView
    }
    
}

// MARK: - 카메라 조작에 관한 로직을 담당하는 Coordinator 클래스
class CameraCoordinator: NSObject, AVCapturePhotoCaptureDelegate {
    var parent: NapPhotoView // 부모 뷰(UIViewRepresentable) 참조
    var cameraView: CameraPreview // 카메라 프리뷰 뷰 참조
    var capturedImage: UIImage? // 캡처된 이미지를 저장할 변수
    
    // 초기화 메서드
    init(parent: NapPhotoView, cameraView: CameraPreview) {
        self.parent = parent
        self.cameraView = cameraView
        super.init()
        setupCameraSession()
        //setupPhotoOutput() // 사진 출력을 설정하는 메서드 호출
    }
    
    private func setupCameraSession() {
        guard let frontCamera = getCameraDevice(position: .front) else {
            print("Front camera is not available.")
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            do {
                let frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
                
                self?.cameraView.captureSession.beginConfiguration()
                
                if self?.cameraView.captureSession.canAddInput(frontCameraInput) == true {
                    self?.cameraView.captureSession.addInput(frontCameraInput)
                }
                
                self?.setupPhotoOutput()
                
                self?.cameraView.captureSession.commitConfiguration()
                
                self?.cameraView.captureSession.startRunning()
            } catch {
                print("Error setting up front camera: \(error)")
            }
        }
    }
    
    // 사진 출력을 설정하는 메서드
    private func setupPhotoOutput() {
        cameraView.captureSession.beginConfiguration() // 캡처 세션 구성 시작
        
        let photoOutput = AVCapturePhotoOutput() // 사진 출력을 위한 AVCapturePhotoOutput 생성
        if cameraView.captureSession.canAddOutput(photoOutput) {
            cameraView.captureSession.addOutput(photoOutput) // 캡처 세션에 사진 출력 추가
            cameraView.photoOutput = photoOutput // CameraPreview의 photoOutput 설정
        }
        
        cameraView.captureSession.commitConfiguration() // 캡처 세션 구성 완료
    }
    
    // 셔터 버튼이 눌렸을 때 호출되는 메서드
    @objc func shutterButtonTapped() {
        let settings = AVCapturePhotoSettings() // 사진 촬영 설정 생성
        cameraView.photoOutput?.capturePhoto(with: settings, delegate: self) // 사진 촬영 요청
    }
    
    // 카메라 전환 버튼이 눌렸을 때 호출되는 메서드
    @objc func switchCameraButtonTapped() {
        // 현재 사용 중인 카메라 장치 가져오기
        guard let currentInput = cameraView.captureSession.inputs.first as? AVCaptureDeviceInput else { return }
        
        // 사용할 새로운 카메라 장치 선택 (현재 사용 중인 장치가 전면 카메라라면 후면 카메라를, 후면 카메라라면 전면 카메라를 선택)
        let newCameraDevice = (currentInput.device.position == .back) ? getCameraDevice(position: .front) : getCameraDevice(position: .back)
        
        // 새로운 카메라 장치로 입력 설정
        guard let newCamera = newCameraDevice else { return }
        
        do {
            let newInput = try AVCaptureDeviceInput(device: newCamera)
            
            cameraView.captureSession.beginConfiguration() // 캡처 세션 구성 시작
            cameraView.captureSession.removeInput(currentInput) // 기존 입력 제거
            if cameraView.captureSession.canAddInput(newInput) {
                cameraView.captureSession.addInput(newInput) // 새로운 입력 추가
            } else {
                // 만약 새로운 입력을 추가할 수 없다면 기존 입력을 다시 추가
                cameraView.captureSession.addInput(currentInput)
            }
            cameraView.captureSession.commitConfiguration() // 캡처 세션 구성 완료
        } catch {
            print("Failed to switch cameras: \(error)") // 카메라 전환 실패 시 에러 출력
        }
    }
    
    // 주어진 위치에 맞는 카메라 장치를 반환하는 메서드
    private func getCameraDevice(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        return AVCaptureDevice.devices(for: .video).first { $0.position == position }
    }
    
    // 취소 버튼이 눌렸을 때 호출되는 메서드
    @objc func cancelButtonTapped() {
        parent.presentationMode.wrappedValue.dismiss() // 부모 뷰를 닫음
    }
    
    // MARK: - 사진 찍고 프리뷰에 보여주는 로직
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil, let data = photo.fileDataRepresentation(), let image = UIImage(data: data) else {
            print("Error capturing photo: \(String(describing: error))")
            return
        }

        var finalImage = image

        // 전면 카메라에서 촬영된 이미지인지 확인 후, 좌우 대칭 처리
        if let currentInput = cameraView.captureSession.inputs.first as? AVCaptureDeviceInput, currentInput.device.position == .front {
            if let cgImage = image.cgImage {
                finalImage = UIImage(cgImage: cgImage, scale: image.scale, orientation: .leftMirrored)
            }
        }

        // 최종 이미지를 설정
        capturedImage = finalImage
        parent.capturedImage = finalImage

        DispatchQueue.main.async {
            self.cameraView.capturedImageView.image = finalImage
        }
    }

    
}








//import SwiftUI
//import AVFoundation
//import SnapKit
//
//struct NapPhotoView: UIViewControllerRepresentable {
//    @Environment(\.presentationMode) var presentationMode
//    @Binding var capturedImage: UIImage?
//
//    let cameraView = CameraPreview()
//
//    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
//
//    func makeCoordinator() -> CameraCoordinator {
//        CameraCoordinator(parent: self, cameraView: cameraView)
//    }
//
//    func makeUIViewController(context: Context) -> UIViewController {
//        let containerVC = UIViewController()
//        containerVC.view.backgroundColor = UIColor.purple
//
//        let overlayView = createOverlayView(context: context, containerVC: containerVC)
//        containerVC.view.addSubview(overlayView)
//        overlayView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//
//        return containerVC
//    }
//
//    func createOverlayView(context: Context, containerVC: UIViewController) -> UIView {
//        let overlayView = UIView()
//
//        let backgroundImageView = UIImageView()
//        backgroundImageView.image = UIImage(named: "Background")
//        backgroundImageView.contentMode = .scaleAspectFill
//        overlayView.addSubview(backgroundImageView)
//        overlayView.sendSubviewToBack(backgroundImageView)
//        backgroundImageView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//
//        cameraView.clipsToBounds = true
//        cameraView.layer.cornerRadius = 20
//        backgroundImageView.addSubview(cameraView)
//
//        cameraView.snp.makeConstraints { make in
//            make.horizontalEdges.equalToSuperview().inset(20)
//            make.height.equalTo(cameraView.snp.width).multipliedBy(4.0 / 3.0)
//            make.top.equalToSuperview().inset(UIScreen.isSE ? 53 : 133)
//        }
//
//        let cancelSwitchButtonHeight: CGFloat = 67
//        let shutterButtonHeight: CGFloat = 85
//
//        let cancelButton = UIButton(type: .system)
//        cancelButton.backgroundColor = .napWhite10
//        cancelButton.setImage(UIImage(resource: .X).withTintColor(.napWhite100, renderingMode: .alwaysTemplate), for: .normal)
//        cancelButton.tintColor = .napWhite100
//        cancelButton.layer.cornerRadius = cancelSwitchButtonHeight / 2
//        cancelButton.layer.borderWidth = 1
//        cancelButton.layer.borderColor = UIColor.napWhite10.cgColor
//        cancelButton.addTarget(context.coordinator, action: #selector(CameraCoordinator.cancelButtonTapped), for: .touchUpInside)
//
//        cancelButton.snp.makeConstraints { make in
//            make.width.height.equalTo(cancelSwitchButtonHeight)
//        }
//
//        let shutterButton = UIButton(type: .system)
//        shutterButton.backgroundColor = .clear
//        shutterButton.tintColor = .white
//        shutterButton.setImage(UIImage(named: "shutter"), for: .normal)
//        shutterButton.imageView?.contentMode = .scaleAspectFill
//        shutterButton.layer.cornerRadius = shutterButtonHeight / 2
//        shutterButton.addTarget(context.coordinator, action: #selector(CameraCoordinator.shutterButtonTapped), for: .touchUpInside)
//
//        shutterButton.snp.makeConstraints { make in
//            make.width.height.equalTo(shutterButtonHeight)
//        }
//
//        let switchCameraButton = UIButton(type: .system)
//        switchCameraButton.backgroundColor = .napWhite10
//        switchCameraButton.setImage(UIImage(resource: .refreshCw), for: .normal)
//        switchCameraButton.tintColor = .napWhite100
//        switchCameraButton.layer.cornerRadius = cancelSwitchButtonHeight / 2
//        switchCameraButton.layer.borderWidth = 1
//        switchCameraButton.layer.borderColor = UIColor.napWhite10.cgColor
//        switchCameraButton.addTarget(context.coordinator, action: #selector(CameraCoordinator.switchCameraButtonTapped), for: .touchUpInside)
//
//        switchCameraButton.snp.makeConstraints { make in
//            make.width.height.equalTo(cancelSwitchButtonHeight)
//        }
//
//        let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.spacing = 40
//        stackView.alignment = .center
//        overlayView.addSubview(stackView)
//        [cancelButton, shutterButton, switchCameraButton].forEach {
//            stackView.addArrangedSubview($0)
//        }
//
//        stackView.snp.makeConstraints { make in
//            make.top.equalTo(cameraView.snp.bottom).offset(UIScreen.isSE ? 30 : 36)
//            make.centerX.equalToSuperview()
//        }
//
//        return overlayView
//    }
//
//}
//
//class CameraCoordinator: NSObject, AVCapturePhotoCaptureDelegate {
//    var parent: NapPhotoView
//    var cameraView: CameraPreview
//    var capturedImage: UIImage?
//
//    init(parent: NapPhotoView, cameraView: CameraPreview) {
//        self.parent = parent
//        self.cameraView = cameraView
//        super.init()
//        setupCameraSession()
//    }
//
//    private func setupCameraSession() {
//        guard let frontCamera = getCameraDevice(position: .front) else {
//            print("Front camera is not available.")
//            return
//        }
//
//        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//            do {
//                let frontCameraInput = try AVCaptureDeviceInput(device: frontCamera)
//
//                self?.cameraView.captureSession.beginConfiguration()
//
//                if self?.cameraView.captureSession.canAddInput(frontCameraInput) == true {
//                    self?.cameraView.captureSession.addInput(frontCameraInput)
//                }
//
//                self?.setupPhotoOutput()
//
//                self?.cameraView.captureSession.commitConfiguration()
//
//                self?.cameraView.captureSession.startRunning()
//            } catch {
//                print("Error setting up front camera: \(error)")
//            }
//        }
//    }
//
//    private func setupPhotoOutput() {
//        let photoOutput = AVCapturePhotoOutput()
//        if cameraView.captureSession.canAddOutput(photoOutput) {
//            cameraView.captureSession.addOutput(photoOutput)
//            cameraView.photoOutput = photoOutput
//        }
//    }
//
//    @objc func shutterButtonTapped() {
//        let settings = AVCapturePhotoSettings()
//        cameraView.photoOutput?.capturePhoto(with: settings, delegate: self)
//    }
//
//    @objc func switchCameraButtonTapped() {
//        guard let currentInput = cameraView.captureSession.inputs.first as? AVCaptureDeviceInput else { return }
//
//        let newCameraDevice = (currentInput.device.position == .back) ? getCameraDevice(position: .front) : getCameraDevice(position: .back)
//
//        guard let newCamera = newCameraDevice else { return }
//
//        do {
//            let newInput = try AVCaptureDeviceInput(device: newCamera)
//
//            cameraView.captureSession.beginConfiguration()
//            cameraView.captureSession.removeInput(currentInput)
//            if cameraView.captureSession.canAddInput(newInput) {
//                cameraView.captureSession.addInput(newInput)
//            } else {
//                cameraView.captureSession.addInput(currentInput)
//            }
//            cameraView.captureSession.commitConfiguration()
//        } catch {
//            print("Failed to switch cameras: \(error)")
//        }
//    }
//
//    private func getCameraDevice(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
//        return AVCaptureDevice.devices(for: .video).first { $0.position == position }
//    }
//
//    @objc func cancelButtonTapped() {
//        parent.presentationMode.wrappedValue.dismiss()
//    }
//
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        guard error == nil, let data = photo.fileDataRepresentation(), let image = UIImage(data: data) else {
//            print("Error capturing photo: \(String(describing: error))")
//            return
//        }
//
//        capturedImage = image
//        parent.capturedImage = image
//        DispatchQueue.main.async {
//            self.cameraView.capturedImageView.image = image
//        }
//    }
//}
