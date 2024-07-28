//
//  BlueButtonLabel.swift
//  Nap
//
//  Created by YunhakLee on 7/28/24.
//

import SwiftUI

struct BlueButtonLabel: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.napCaption2)
            .foregroundStyle(.napBlue100)
            .padding(.vertical, 6)
            .padding(.horizontal, 14)
            .background {
                Capsule()
                    .foregroundStyle(.napBlue20)
            }
    }
}

#Preview {
    BlueButtonLabel(text: "Test")
}
