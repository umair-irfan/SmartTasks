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
    var onTapNextDay: LoadingCallback? { get set }
    var onTapPrevioussDay: LoadingCallback? { get set }
}

//MARK: Output
protocol TaskTaskViewModelOutput {
    var onUpdate: SimpleCallback? { get set }
    var showEmptyView: SimpleCallback? { get set }
    func defaultSnapshot()-> DataSnapshot
    var onTapTaskDetail: DemoItemCallback? { get set }
    var navigateToDetailView: NavigateToDetail? { get set }
    func emptySnapshot() -> DataSnapshot
}

protocol TaskViewModelType {
    var input: TaskTaskViewModelInput { get }
    var output: TaskTaskViewModelOutput { get set }
}

class TaskViewModel: TaskTaskViewModelInput, TaskTaskViewModelOutput, TaskViewModelType {
    
    private(set) var repo: TaskRepositoryType!
    @Published private(set) var items: [AnyCellConfigurable] = []
    private var cancellables = Set<AnyCancellable>()
    private var tasks: [Task] = []
    
    var input: TaskTaskViewModelInput { self }
    var output:  TaskTaskViewModelOutput {
        get { self }
        set { }
    }
    
    //MARK: Input
    var onTapNextDay: LoadingCallback?
    var onTapPrevioussDay: LoadingCallback?
    
    //MARK: Output
    var onUpdate: SimpleCallback?
    var showEmptyView: SimpleCallback?
    var onTapTaskDetail: DemoItemCallback?
    var navigateToDetailView: NavigateToDetail?
    
    
    init(task: TaskRepositoryType) {
        self.repo = task
        processDaySelection()
        processTaskSelection()
    }
    
    func loadData() {
        repo.fetchTasks()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                if case .failure(_) = completion {
                    self.showEmptyView?()
                }
            }, receiveValue: { [weak self] response in
                guard let self = self else { return }
                if response.tasks.isEmpty {
                    self.showEmptyView?()
                } else {
                    self.tasks = response.tasks
                    self.items = response.tasks.map {
                        let demoItem = DemoItem(taskId: $0.id,
                                                title: $0.title,
                                                dueDate: $0.dueDate ?? "",
                                                daysLeft: $0.calculateDaysLeft())
                        return AnyCellConfigurable(demoItem)
                    }
                    self.onUpdate?()
                }
            })
            .store(in: &cancellables)
    }
    
    private func processTaskSelection() {
        onTapTaskDetail = { task in
            let selected = self.tasks.filter {
                return task.taskId == $0.id
            }.first
            guard let selected else { return }
            self.navigateToDetailView?(selected)
        }
    }
    
    private func processDaySelection() {
        onTapNextDay = {
            $0 ? self.onUpdate?() :
            self.showEmptyView?()
        }
        
        onTapPrevioussDay = {
            $0 ? self.onUpdate?() :
            self.showEmptyView?()
        }
    }
    
    func defaultSnapshot() -> DataSnapshot {
        var snapshot = DataSnapshot()
        snapshot.appendSections([.Main])
        snapshot.appendItems(items, toSection: .Main)
        return snapshot
    }
    
    func emptySnapshot() -> DataSnapshot {
        var snapshot = DataSnapshot()
        snapshot.appendSections([.Main])
        snapshot.appendItems([], toSection: .Main)
        return snapshot
    }
    
}
