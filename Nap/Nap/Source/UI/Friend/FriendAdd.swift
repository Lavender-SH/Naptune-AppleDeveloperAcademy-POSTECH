//
//  FriendAdd.swift
//  Nap
//
//  Created by YunhakLee on 7/28/24.
//

import SwiftUI

struct FriendAdd: View {
    
    @State var codeText: String = ""
    @FocusState private var focusField: Field?
    @State var showPlaceholder: Bool = true
    @Binding var isFriendAdding: Bool
    
    var textLimit: Int = 5
    
    // MARK: Body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.napBlack50
                .ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer().frame(height: 40)
                Header
                Spacer().frame(height: 20)
                CodeField
                Spacer().frame(height: 40)
            }
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.napBlack600)
            }
            .overlay(alignment: .bottom) {
                Rectangle().frame(height: 0.33)
                    .foregroundStyle(.napBlack200)
            }
            .overlay(alignment: .topTrailing) {
                CloseButton
                    .padding(16)
            }
        }
    }
}

private extension FriendAdd {
    
    // MARK: View
    
    var Header: some View {
        VStack(spacing: 8) {
            Title
            Description
        }
    }
    
    var Title: some View {
        Text("친구 추가하기")
            .font(.napTitle1)
            .foregroundStyle(.napBlue100)
    }
    
    var Description: some View {
        Text("친구코드로 낮잠 친구를 추가해보세요")
            .font(.napCaption4)
            .foregroundStyle(.napWhite60)
    }
    
    var CodeField: some View {
        HStack {
            Spacer()
            TextField(text: $codeText) {
                Text("친구 코드를 입력하세요")
                    .font(.napTitle2)
                    .foregroundStyle(.napWhite40)
            }
            .font(.napTitle2)
            .foregroundStyle(.napWhite100)
            .focused($focusField, equals: .code)
            .onChange(of: codeText) { _, _ in
                if codeText.count > textLimit {
                    codeText = String(codeText.prefix(textLimit))
                }
            }
            //            .overlay {
            //                if showPlaceholder {
            //                    Text("친구 코드를 입력하세요")
            //                        .font(.napCaption5)
            //                        .foregroundStyle(.napWhite40)
            //                        .onTapGesture {
            //                            showPlaceholder = false
            //                            focusField = .code
            //                        }
            //                }
            //            }
            //            .onChange(of: focusField) { _, _ in
            //                showPlaceholder = focusField == nil && codeText == ""
            //            }
            .multilineTextAlignment(.center)
            Spacer()
        }
        .padding(.vertical, 18)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.napWhite10)
        }
        .overlay(alignment: .trailing) {
            Button {
                print("친구 요청")
            } label: {
                BlueButtonLabel(text: "요청")
            }
            .padding(.trailing, 20)
        }
        .padding(.horizontal, 20)
        .onAppear {
            focusField = .code
        }
    }
    
    var CloseButton: some View {
        Button {
            isFriendAdding = false
        } label: {
            Image(.X_2)
                .padding(10)
                .background {
                    Circle()
                        .foregroundStyle(.napWhite10)
                }
        }
    }
}

#Preview {
    FriendAdd(isFriendAdding: .constant(false))
}

enum Field {
    case code
}
