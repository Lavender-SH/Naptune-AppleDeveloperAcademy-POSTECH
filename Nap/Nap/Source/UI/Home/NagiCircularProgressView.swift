//
//  NagiCircularProgressView.swift
//  Nap
//
//  Created by YunhakLee on 8/4/24.
//

import SwiftUI
import KDCircularProgress

struct NagiCircularProgressView: UIViewRepresentable {
    @Binding var progress: Double

    func makeUIView(context: Context) -> KDCircularProgress {
        let progressView = KDCircularProgress(frame: .zero)
        progressView.startAngle = -90
        progressView.progressThickness = 0.37
        progressView.trackThickness = 0.4
        progressView.clockwise = true
        progressView.gradientRotateSpeed = 1
        progressView.roundedCorners = true
        progressView.glowMode = .forward
        progressView.glowAmount = 0.8
        progressView.set(colors: UIColor(.napBlue200), UIColor(.napBlue201))
        progressView.trackColor = UIColor.clear
        return progressView
    }

    func updateUIView(_ uiView: KDCircularProgress, context: Context) {
        uiView.angle = progress + 5 // Convert percentage to degrees (100% = 360 degrees)
    }
}
