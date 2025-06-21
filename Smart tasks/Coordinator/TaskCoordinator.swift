//
//  TaskCoordinator.swift
//  Smart tasks
//
//  Created by Umair on 21/06/2025.
//
import UIKit
import Combine

@MainActor
final class TaskCoordinator: Coordinator<Void> {

    private let navigation: UINavigationController?
    private(set) var repo: TaskRepositoryType!

    init(root: UINavigationController,_ taskRepository: TaskRepositoryType) {
        self.navigation = root
        self.repo = taskRepository
    }

    override func start() -> AnyPublisher<Void, CoordinatorError> {
        return Future<Void, CoordinatorError> { [weak self] promise in
           
            guard let self = self else {
                promise(.failure(.unknown))
                return
            }
            //MARK: ✅ Task Dependecy Injected(into: ViewModel)
            let viewModel: TaskViewModelType = TaskViewModel(task: self.repo)
            let vc = TaskViewController()
            vc.viewModel = viewModel
            NavigationControllerFactory.configureNavigationItem(for: vc, title: "\(Date())")
            self.navigation?.pushViewController(vc, animated: true)
            //promise(.success(()))
        }
        .eraseToAnyPublisher()
    }

    
    func navigateToDetailView(_ task: String) {
        //let detailVC = DetailViewController(task: task)
        //navigation.pushViewController(detailVC, animated: true)
    }
}
