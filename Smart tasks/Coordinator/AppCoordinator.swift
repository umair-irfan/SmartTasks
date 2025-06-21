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
    private(set) var repo: TaskRepositoryType!
    
    init(window: UIWindow,_ taskRepository: TaskRepositoryType) {
        self.window = window
        self.repo = taskRepository
    }
    
    override func start() -> AnyPublisher<Bool, CoordinatorError> {
        self.root = NavigationControllerFactory.makeTransparentNavigationController()
        self.window.rootViewController = self.root
        self.window.makeKeyAndVisible()
        
        //MARK: ✅ Task Dependecy Injected(into: Coordinator)
        return coordinate(to: TaskCoordinator(root: self.root, self.repo)).map { _ in true }.eraseToAnyPublisher()
    }
}

