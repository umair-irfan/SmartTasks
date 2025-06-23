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
    private let formatter = DateFormatter()
    
   

    init(root: UINavigationController,_ taskRepository: TaskRepositoryType) {
        self.navigation = root
        self.repo = taskRepository
        self.formatter.dateFormat = "yyyy-MM-dd"
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
        var viewModel: TaskViewModelType = TaskViewModel(task: self.repo)
        let vc = TaskViewController()
        vc.viewModel = viewModel
        
        let rightButton = UIBarButtonItem(image:  UIImage(named: "right-arrow"),
                                          style: .plain, target: nil, action: nil)
        rightButton.actionHandler = {
            self.currentDate = Calendar.current.date(byAdding: .day, value: 1, to: self.currentDate) ?? self.currentDate
            vc.navigationItem.title = self.formattedTitle(for: self.currentDate)
            viewModel.input.onTapNextDay?()
        }
        NavigationControllerFactory.configureNavigationItem(for: vc, title: "Today",
                                                            showBackButton: true,
                                                            backButtonImage: UIImage(named: "left-arrow"),
                                                            onBack: {
            self.currentDate = Calendar.current.date(byAdding: .day, value: -1, to: self.currentDate) ?? self.currentDate
            vc.navigationItem.title = self.formattedTitle(for: self.currentDate)
            viewModel.input.onTapPrevioussDay?()
        }, rightButton: rightButton)
        self.navigation?.pushViewController(vc, animated: true)
        viewModel.output.navigateToDetailView = { [unowned self] task  in
            self.navigateToDetailView(task)
        }
    }
    
    private func formattedTitle(for date: Date) -> String {
        if Calendar.current.isDateInToday(date) {
            return "Today"
        } else {
            return formatter.string(from: date)
        }
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
