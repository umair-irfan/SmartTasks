//
//  Coordinator.swift
//  Smart tasks
//
//  Created by Umair on 21/06/2025.
//

import UIKit
import Combine

public enum CoordinatorError: Error {
    case unknown
}

open class Coordinator<ResultType>: NSObject {
    
    private let identifier = UUID()
    private var childCoordinators = [UUID: Any]()
    private var cancellables = Set<AnyCancellable>()

    public override init() {}

    private func store<T>(coordinator: Coordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }

    private func free<T>(coordinator: Coordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }

    // MARK: - Coordination

    @MainActor
    public func coordinate<T>(to coordinator: Coordinator<T>) -> AnyPublisher<T, CoordinatorError> {
        store(coordinator: coordinator)

        return coordinator
            .start()
            .handleEvents(receiveCompletion: { [weak self] _ in
                self?.free(coordinator: coordinator)
            })
            .eraseToAnyPublisher()
    }

    @MainActor
    open func start() -> AnyPublisher<ResultType, CoordinatorError> {
        fatalError("Start method should be implemented.")
    }

    open func freeAll() {
        childCoordinators.removeAll()
        cancellables.removeAll()
    }
}

