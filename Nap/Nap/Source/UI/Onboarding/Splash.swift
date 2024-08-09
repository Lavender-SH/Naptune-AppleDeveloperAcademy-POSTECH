//
//  Splash.swift
//  Nap
//
//  Created by YunhakLee on 8/8/24.
//

import SwiftUI

struct Splash: View {
    var body: some View {
        ZStack {
            BackgroundImage(image: Image(.basicBackground))
            VStack {
                Spacer()
                Spacer()
                Image(.splashlogo)
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
            }
        }
    }
}

#Preview {
    Splash()
}
