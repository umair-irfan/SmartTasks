//
//  TaskViewModel.swift
//  Smart tasks
//
//  Created by Umair on 21/06/2025.
//
import UIKit
import Combine

//MARK: Input
protocol TaskTaskViewModelInput {
    func loadData()
    var onTapDaysSubject: PassthroughSubject<Date, Never> { get }
    var onTapTaskDetailSubject: PassthroughSubject<DemoItem, Never> { get }
}

//MARK: Output
protocol TaskTaskViewModelOutput {
    var snapshotPublisher: AnyPublisher<TasksSnapshot, Never> { get }
    var navigateToDetailView: AnyPublisher<Task, Never> { get }
}

protocol TaskViewModelType {
    var input: TaskTaskViewModelInput { get }
    var output: TaskTaskViewModelOutput { get }
}

class TaskViewModel: TaskTaskViewModelInput, TaskTaskViewModelOutput, TaskViewModelType {
    
    private(set) var repo: TaskRepositoryType!
    private var tasks: [Task] = []
    
    var input: TaskTaskViewModelInput { self }
    var output:  TaskTaskViewModelOutput { self }
    
    //MARK: Combine Subjects
    private var items = CurrentValueSubject<[AnyCellConfigurable], Never>([])
    var onTapDaysSubject = PassthroughSubject<Date, Never>()
    var onTapTaskDetailSubject = PassthroughSubject<DemoItem, Never>()
    private var cancellables = Set<AnyCancellable>()
    private var detailTaskSubject = PassthroughSubject<Task, Never>()
    
    //MARK: Input
    var onTapDay: AnyPublisher<Date, Never> { onTapDaysSubject.eraseToAnyPublisher() }

    //MARK: Output
    var navigateToDetailView: AnyPublisher<Task, Never> { detailTaskSubject.eraseToAnyPublisher() }
    var snapshotPublisher: AnyPublisher<TasksSnapshot, Never> {
        items.map { items in
            var snapshot = TasksSnapshot()
            snapshot.appendSections([.Main])
            snapshot.appendItems(items, toSection: .Main)
            return snapshot
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    init(task: TaskRepositoryType) {
        self.repo = task
        bindDayNavigation()
        bindDetailNavigation()
    }
    
    func loadData() {
        repo.fetchTasks()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                if case .failure(_) = completion {
                    self.items.send([])
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                if response.tasks.isEmpty {
                    self.items.send([])
                } else {
                    setTasks(with: response.tasks)
                    self.items.send(prioritiseTasks())
                }
            })
            .store(in: &cancellables)
    }

    func prioritiseTasks(with today:
                         String = DateFormatter.serverDateFormat.string(from: Date())) -> [AnyCellConfigurable] {
        return tasks.filter{ task in
            //MARK: Filter the Task based on Current Day
            return today == task.targetDate
        }.sorted {
            //MARK: Sort the Task based on Priority & Due Date
            if let firstTaskPriority = $0.priority,
               let secondTaskPriority = $1.priority {
                return firstTaskPriority == secondTaskPriority ?
                $0.dueDate ?? "" < $1.dueDate ?? "" : firstTaskPriority > secondTaskPriority
            }
            return 1 > 0
        }
        .map {
            let demoItem = DemoItem(taskId: $0.id,
                                    title: $0.title,
                                    dueDate: $0.dueDate ?? "",
                                    daysLeft: $0.calculateDaysLeft())
            return AnyCellConfigurable(demoItem)
        }
    }
    
    private func bindDetailNavigation() {
        onTapTaskDetailSubject.sink(receiveCompletion: {_ in }) { [weak self] task in
            guard let self = self else { return }
            let selected = self.tasks.filter {
                return task.taskId == $0.id
            }.first
            guard let selected else { return }
            self.detailTaskSubject.send(selected)
        }.store(in: &cancellables)
    }
    
    private func bindDayNavigation() {
        onTapDaysSubject
            .sink { [weak self] date in
                guard let self = self else { return }
                let convertedDate = DateFormatter.serverDateFormat.string(from: date)
                self.items.send(self.prioritiseTasks(with: convertedDate))
            }
            .store(in: &cancellables)
    }
    
    func setTasks(with tasks: [Task]) {
        self.tasks = tasks
    }
}
