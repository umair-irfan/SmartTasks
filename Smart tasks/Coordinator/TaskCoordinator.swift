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

    init(root: UINavigationController) {
        self.navigation = root
    }

    override func start() -> AnyPublisher<Void, CoordinatorError> {
        return Future<Void, CoordinatorError> { [weak self] promise in
           
            guard let self = self else {
                promise(.failure(.unknown))
                return
            }
            
            let viewModel: TaskViewModelType = TaskViewModel()
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
