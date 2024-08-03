//
//  BackgroundImage.swift
//  Nap
//
//  Created by YunhakLee on 7/26/24.
//

import SwiftUI

struct BackgroundImage: View {
    let image: Image
    
    var body: some View {
        image
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .frame(width: UIScreen.size.width,
                   height: UIScreen.size.height)
            .clipped()
    }
}

#Preview {
    BackgroundImage(image: Image(.feedBackground))
}
