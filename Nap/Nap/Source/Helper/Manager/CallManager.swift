//
//  CallManager.swift
//  Nap
//
//  Created by YunhakLee on 8/5/24.
//

import Foundation
import CallKit

final class CallManager: NSObject, CXProviderDelegate {
    let provider = CXProvider(configuration: CXProviderConfiguration())
    let callController = CXCallController()
    
    override private init() {
        super.init()
        provider.setDelegate(self, queue: nil)
    }
    static let shared = CallManager()
    
    func reportIncomingCall(id: UUID, handle: String) {
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .generic, value: handle)
        
        provider.reportNewIncomingCall(with: id, update: update) { error in
            if let error = error {
                print(String(describing: error))
            } else {
                print("Call Reported")
            }
        }
    }

    func startCall(id: UUID, handle: String){
        let handle = CXHandle(type: .generic, value: handle)
        let action = CXStartCallAction(call: id, handle: handle)
        let transaction = CXTransaction(action: action)
        
        callController.requestTransaction(with: action) { error in
            if let error = error {
                print(String(describing: error))
            } else {
                print("Call Started")
            }
        }
        
    }
    
    func providerDidReset(_ provider: CXProvider) {
        
    }
    
    
}
