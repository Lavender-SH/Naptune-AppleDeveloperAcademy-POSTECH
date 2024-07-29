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
    @Binding var isRequestSuccess: Bool
    
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
            .offset(y: 10)
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
            .font(.napCaption1)
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
            .multilineTextAlignment(.center)
            .focused($focusField, equals: .code)
            .onChange(of: codeText) { _, _ in
                if codeText.count > textLimit {
                    codeText = String(codeText.prefix(textLimit))
                }
            }
            .onSubmit {
                makeFriendRequest()
            }
            Spacer()
        }
        .padding(.vertical, 18)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.napWhite10)
        }
        .overlay(alignment: .trailing) {
            RequestFriendButton
                .padding(.trailing, 20)
        }
        .padding(.horizontal, 20)
        .onAppear {
            focusField = .code
        }
    }
    
    var RequestFriendButton: some View {
        Button {
            makeFriendRequest()
        } label: {
            BlueButtonLabel(text: "요청")
        }
        .disabled(isRequestSuccess)
    }
    
    var CloseButton: some View {
        Button {
            closeFriendAddView()
        } label: {
            Image(.X_2)
                .frame(width: 30, height: 30)
                .background {
                    Circle()
                        .foregroundStyle(.napWhite10)
                }
        }
    }
    
    // MARK: Action
    
    func closeFriendAddView() {
        focusField = nil
        isFriendAdding = false
    }
    
    func makeFriendRequest() {
        isRequestSuccess = true
        closeFriendAddView()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isRequestSuccess = false
        }
    }
}

#Preview {
    FriendAdd(isFriendAdding: .constant(false), isRequestSuccess: .constant(false))
}

enum Field {
    case code
}
