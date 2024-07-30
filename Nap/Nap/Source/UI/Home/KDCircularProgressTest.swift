//
//  KDCircularProgressTest.swift
//  Nap
//
//  Created by 이승현 on 7/30/24.
//

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
        
        //if let color = UIColor(named: "ManboBlue400") {
//                    progressView.set(colors: color.withAlphaComponent(0.5))
//                }
        progressView.trackColor = UIColor.gray.withAlphaComponent(0.3)
        return progressView
    }

    func updateUIView(_ uiView: KDCircularProgress, context: Context) {
        uiView.angle = progress + 5 // Convert percentage to degrees (100% = 360 degrees)
    }
}
