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
    private var currentDate: Date = Date()
    private var cancellables = Set<AnyCancellable>()

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
            self.showTaskListView()
        }
        .eraseToAnyPublisher()
    }
    
    private func showTaskListView() {
        //MARK: ✅ Task Dependecy Injected(into: ViewModel)
        let viewModel: TaskViewModelType = TaskViewModel(task: self.repo)
        let vc = TaskViewController()
        vc.viewModel = viewModel
        
        let rightButton = UIBarButtonItem(image:  UIImage(named: "right-arrow"),
                                          style: .plain, target: nil, action: nil)
        rightButton.actionHandler = { [weak self] in
            guard let self = self else { return }
            self.currentDate = Calendar.current.date(byAdding: .day, value: 1, to: self.currentDate) ?? self.currentDate
            let day = NavigationControllerFactory.formattedTitle(for: self.currentDate)
            vc.navigationItem.title = day.1
            viewModel.input.onTapNextDaySubject.send(day.0)
        }
        
        NavigationControllerFactory.configureNavigationItem(for: vc, title: "Today",
                                                            showBackButton: true,
                                                            backButtonImage: UIImage(named: "left-arrow"),
                                                            onBack: {
            self.currentDate = Calendar.current.date(byAdding: .day, value: -1, to: self.currentDate) ?? self.currentDate
            let day = NavigationControllerFactory.formattedTitle(for: self.currentDate)
            vc.navigationItem.title = day.1
            viewModel.input.onTapPreviousDaySubject.send(day.0)
        }, rightButton: rightButton)
        
        self.navigation?.pushViewController(vc, animated: true)
       
        viewModel.output.navigateToDetailView.sink(receiveCompletion: { _ in },
                                                   receiveValue: { [unowned self] task  in
            self.navigateToDetailView(task)
        }).store(in: &cancellables)
    }
    
    private func navigateToDetailView(_ task: Task) {
        let viewModel: DetailViewModelType = DetailViewModel(task: task)
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
