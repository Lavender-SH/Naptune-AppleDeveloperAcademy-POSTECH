//
//  WakeUpView.swift
//  Nap
//
//  Created by YunhakLee on 8/4/24.
//

import SwiftUI

struct WakeUpView: View {
    @State var captueredImage: UIImage? = nil
    
    var body: some View {
        if captueredImage == nil {
            CameraViewTest(capturedImage: $captueredImage)
                .ignoresSafeArea()
        } else {
            FeedRegister(capturedImage: $captueredImage)
        }
    }
}

#Preview {
    WakeUpView()
}
