//
//  BackgroundBlur.swift
//  Nap
//
//  Created by YunhakLee on 7/24/24.
//

import SwiftUI

/// A transparent View that blurs its background
struct BackgroundBlur: View {
    let radius: CGFloat
    
    var body: some View {
        ZStack {
            BackdropView().blur(radius: radius, opaque: true)
            Color.black.opacity(0.2)
        }
    }
}

struct BackdropView: UIViewRepresentable {

    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView()
        let blur = UIBlurEffect()
        let animator = UIViewPropertyAnimator()
        animator.addAnimations { view.effect = blur }
        animator.fractionComplete = 0
        animator.stopAnimation(false)
        animator.finishAnimation(at: .current)
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) { }
}

#Preview {
    BackgroundBlur(radius: 5)
}
