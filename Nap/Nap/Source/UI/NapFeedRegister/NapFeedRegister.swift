//
//  WakeUpView.swift
//  Nap
//
//  Created by YunhakLee on 8/4/24.
//

import SwiftUI

struct NapFeedRegister: View {
    @State var captueredImage: UIImage? = nil
    @Binding var showHome: Bool
    
    var body: some View {
        if captueredImage == nil {
            NapPhotoView(capturedImage: $captueredImage)
                .ignoresSafeArea()
        } else {
            FeedRegister(capturedImage: $captueredImage, showHome: $showHome)
        }
    }
}

#Preview {
    NapFeedRegister(showHome: .constant(false))
}
