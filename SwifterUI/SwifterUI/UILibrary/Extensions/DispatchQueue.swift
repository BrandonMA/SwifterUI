//
//  DispatchQueue.swift
//  SwifterUI
//
//  Created by Brandon Maldonado Alonso on 19/12/17.
//  Copyright © 2017 Brandon Maldonado Alonso. All rights reserved.
//

import UIKit

public extension DispatchQueue {

    // DispatchLevel: Enum for easier access to DispatchQueues types
    enum DispatchLevel {
        case main
        case userInteractive
        case userInitiated
        case utility
        case background

        // dispatchQueue: correspondent DispatchQueue
        public var dispatchQueue: DispatchQueue {
            switch self {
            case .main: return .main
            case .userInteractive: return .global(qos: .userInteractive)
            case .userInitiated: return .global(qos: .userInitiated)
            case .utility: return .global(qos: .utility)
            case .background: return .global(qos: .background)
            }
        }
    }

    // MARK: - Static Methods

    // delay: Creates a delay for an action to be done
    // - Parameters:
    //   seconds: Time in seconds to wait
    //   dispatchLevel: Dispatch queue where your code is going to be executed
    //   handler: Action to be executed after the delay
    static func delay(by seconds: Double, dispatchLevel: DispatchLevel = .background, handler: @escaping () -> Void) {
        // Create a DispatchTime in seconds since now + the number of seconds added
        // Add the action to be executed after the delay to the corresponding DispatchQueue
        dispatchLevel.dispatchQueue.asyncAfter(deadline: .now() + seconds, execute: handler)
    }

}
