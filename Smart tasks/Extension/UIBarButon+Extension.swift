//
//  UIBarButon+Extension.swift
//  Smart tasks
//
//  Created by Umair on 21/06/2025.
//
import UIKit
import ObjectiveC

@MainActor private var ActionKey: UInt8 = 0

extension UIBarButtonItem {
    private class ActionWrapper {
        let handler: () -> Void
        init(_ handler: @escaping () -> Void) { self.handler = handler }
        @objc func invoke() { handler() }
    }

    var actionHandler: (() -> Void)? {
        get {
            guard let wrapper = objc_getAssociatedObject(self, &ActionKey) as? ActionWrapper else { return nil }
            return wrapper.handler
        }
        set {
            if let newValue = newValue {
                let wrapper = ActionWrapper(newValue)
                target = wrapper
                action = #selector(ActionWrapper.invoke)
                objc_setAssociatedObject(self, &ActionKey, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            } else {
                target = nil
                action = nil
                objc_setAssociatedObject(self, &ActionKey, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
}
