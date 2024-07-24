//
//  View+.swift
//  Nap
//
//  Created by YunhakLee on 7/24/24.
//

import SwiftUI

extension View {
    func dismissKeyboard() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
