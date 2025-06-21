//
//  AppCoordinator.swift
//  Smart tasks
//
//  Created by Umair on 21/06/2025.
//

import UIKit
import Combine


@MainActor
final class AppCoordinator: Coordinator<Bool> {
    
    private let window: UIWindow
    private(set) var root: UINavigationController!
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> AnyPublisher<Bool, CoordinatorError> {
        self.root = NavigationControllerFactory.makeTransparentNavigationController()
        self.window.rootViewController = self.root
        self.window.makeKeyAndVisible()
        return coordinate(to: TaskCoordinator(root: self.root)).map { _ in true }.eraseToAnyPublisher()
    }
}

