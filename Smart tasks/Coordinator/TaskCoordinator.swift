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
            var viewModel: TaskViewModelType = TaskViewModel(task: self.repo)
            let vc = TaskViewController()
            vc.viewModel = viewModel
            let date = Date()
            let rightButton = UIBarButtonItem(image:  UIImage(named: "right-arrow"), style: .plain, target: nil, action: nil)
            NavigationControllerFactory.configureNavigationItem(for: vc, title: "\(date)",
                                                                showBackButton: true,
                                                                backButtonImage: UIImage(named: "left-arrow"),
                                                                onBack: {
                
            }, rightButton: rightButton)
            self.navigation?.pushViewController(vc, animated: true)
            viewModel.output.navigateToDetailView = { [unowned self] task  in
                self.navigateToDetailView(task.title)
            }
        }
        .eraseToAnyPublisher()
    }

    
    func navigateToDetailView(_ task: String) {
        let viewModel: DetailViewModelType = DetailViewModel()
        let detailVC = DetailViewController()
        detailVC.viewModel = viewModel
        NavigationControllerFactory.configureNavigationItem(for: detailVC, title: "Task Detail",
                                                            showBackButton: true,
                                                            backButtonImage: UIImage(named: "left-arrow")) {
            self.navigation?.popViewController(animated: true)
        }
        navigation?.pushViewController(detailVC, animated: true)
    }
}
