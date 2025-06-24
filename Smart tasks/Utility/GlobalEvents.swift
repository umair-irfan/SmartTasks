//
//  GlobalEvents.swift
//  Smart tasks
//
//  Created by Umair on 24/06/2025.
//
import Foundation

typealias GlobalEvent = Events

public struct Events {
    enum Application: String, UniversalEventProtocol {
        case DidBecomeActive = "ApplicationDidBecomeActive"
        case TaskStatusUpdate = "TaskStatusUpdate"
    }
}

protocol EventProtocol {
    var rawValue:String { get }
}

protocol UniversalEventProtocol : EventProtocol {
    
}

extension UniversalEventProtocol {
    func post(with: Any? = nil) {
        NotificationCenter.default.post(name:  Notification.Name(rawValue: self.rawValue), object: with)
    }
    
    func observe() -> NotificationCenter.Publisher {
        return NotificationCenter.default.publisher(for: Notification.Name(rawValue: self.rawValue))
    }
    
    func remove(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer, name: Notification.Name(rawValue: self.rawValue), object: nil)
    }
}

extension NSNotification.Name: UniversalEventProtocol {
    //Enable GlobalEventProtocol for native notifications
}
