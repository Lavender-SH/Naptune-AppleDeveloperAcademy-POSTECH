//
//  CheckSilentModeView.swift
//  Nap
//
//  Created by 이승현 on 8/3/24.
//

import SwiftUI

struct CheckSilentModeView: View {
    
    @Environment(\.presentationMode) var presentationMode
    var confirmAction: () -> Void
    
    var body: some View {
        ZStack {
            Image("Background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("친구들의 전화 알림을 받기 위해\n   무음모드를 꼭 해제해주세요")
                    .foregroundColor(.white)
                    .font(.system(size: 25).bold())
                
                Image("BellCheck")
                    .resizable()
                    .scaledToFill()
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                
                GeometryReader { geometry in
                    HStack(spacing: 12) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("취소")
                                .foregroundColor(.white)
                            
                        })
                        .frame(width: 105, height: 56)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray).opacity(0.3))
                        
                        Button(action: {
                            confirmAction()
                        }, label: {
                            Text("확인했어요")
                                .foregroundColor(.black)
                        })
                        .frame(width: geometry.size.width - 105 - 12 - 20 - 20, height: 56)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color("ManboBlue400")))
                    }
                    .padding(.top, 60)
                    .padding(.horizontal, 20)
                }
                
            }
            .padding(.top, 100)
            .padding(.bottom, 33)
        }
    }
}

#Preview {
    CheckSilentModeView(confirmAction: {})
}
