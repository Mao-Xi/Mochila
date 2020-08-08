//
//  Schedule.swift
//  Mochila
//
//  Created by Victor Zhu on 2020/8/8.
//

import Foundation

public typealias Task = (_ cancel: Bool) -> ()

@discardableResult
public func delay(_ delay: TimeInterval, closure: @escaping () -> Void) -> Task? {
    var task: (() -> Void)? = closure
    var result: Task?
    let delayedClosure: Task = { cancel in
        if let internalClosure = task {
            if cancel == false {
                foreground(internalClosure)
            }
        }
        task = nil
        result = nil
    }
    result = delayedClosure
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(delay * 1000))) {
        result?(false)
    }
    return result
}

public func cancel(_ task: Task?) {
    task?(true)
}

public func background(_ closure: @escaping () -> Void) {
    DispatchQueue.global(qos: .background).async(execute: closure)
}

public func foreground(_ closure: @escaping () -> Void) {
    DispatchQueue.main.async(execute: closure)
}
