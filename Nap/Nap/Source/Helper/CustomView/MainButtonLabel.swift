//
//  MainButtonLabel.swift
//  Nap
//
//  Created by YunhakLee on 8/2/24.
//

import SwiftUI

struct MainButtonLabel: View {
    let text: String
    
    var body: some View {
        HStack {
            Spacer()
            Text(text)
                .font(.napTitle2)
                .foregroundStyle(.napBlack600)
            Spacer()
        }
        .padding(.vertical, 18)
        .background(.napBlue100)
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

#Preview {
    MainButtonLabel(text: "Text")
}
