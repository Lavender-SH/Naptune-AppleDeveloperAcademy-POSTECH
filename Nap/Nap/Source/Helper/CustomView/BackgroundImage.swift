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
    }
}

#Preview {
    BackgroundImage(image: Image(.feedBackground))
}
