//
//  Coordinator.swift
//  Smart tasks
//
//  Created by Umair on 21/06/2025.
//

import UIKit

public enum CoordinatorError: Error {
    case unknown
}

open class Coordinator<ResultType>: NSObject {
    
    typealias CompletionHandler = (Result<ResultType, CoordinatorError>) -> Void
    
    private let identifier = UUID()
    private var childCoordinators = [UUID: Any]()
    
    public override init() {}

    private func store<T>(coordinator: Coordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }

    private func free<T>(coordinator: Coordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }

    // MARK: - Coordination

    public func coordinate<T>(
        to coordinator: Coordinator<T>,
        completion: @escaping (Result<T, CoordinatorError>) -> Void) {
            
        store(coordinator: coordinator)
        coordinator.start { [weak self] result in
            self?.free(coordinator: coordinator)
            completion(result)
        }
    }

    open func start(completion: @escaping (Result<ResultType, CoordinatorError>) -> Void) {
        fatalError("Start method should be implemented.")
    }

    open func freeAll() {
        childCoordinators.removeAll()
    }
}
