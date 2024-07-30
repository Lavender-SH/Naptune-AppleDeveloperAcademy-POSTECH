//
//  Home.swift
//  Nap
//
//  Created by YunhakLee on 7/24/24.
//

import SwiftUI

struct Home: View {
    var body: some View {
        ZStack{
            Color.clear
            Text("Home")
        }
        .background(BackgroundImage(image: Image(.basicBackground)))
    }
}

#Preview {
    Home()
}
