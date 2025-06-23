//
//  TaskViewModel.swift
//  Smart tasks
//
//  Created by Umair on 21/06/2025.
//
import UIKit

//MARK: Input
protocol TaskTaskViewModelInput {
    func loadData()
    var onTapNextDay: SimpleCallback? { get set }
    var onTapPrevioussDay: SimpleCallback? { get set }
}

//MARK: Output
protocol TaskTaskViewModelOutput {
    var onUpdate: SimpleCallback? { get set }
    var showEmptyView: SimpleCallback? { get set }
    func defaultSnapshot()-> DataSnapshot
    var onTapTaskDetail: DemoItemCallback? { get set }
    var navigateToDetailView: NavigateToDetail? { get set }
}

protocol TaskViewModelType {
    var input: TaskTaskViewModelInput { get }
    var output: TaskTaskViewModelOutput { get set }
}

class TaskViewModel: TaskTaskViewModelInput, TaskTaskViewModelOutput, TaskViewModelType {
    
    private(set) var repo: TaskRepositoryType!
    private(set) var items: [AnyCellConfigurable] = []
    private var tasks: [Task] = []
    
    var input: TaskTaskViewModelInput { self }
    var output:  TaskTaskViewModelOutput {
        get { self }
        set { }
    }
    
    //MARK: Input
    var onTapNextDay: SimpleCallback?
    var onTapPrevioussDay: SimpleCallback?
    
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
        repo.fetchTasks { resposse in
            switch resposse {
            case .success(let resp):
                if resp.tasks.isEmpty {
                    self.showEmptyView?()
                } else {
                    self.tasks = resp.tasks
                    self.items = resp.tasks.map {
                        let demoItem = DemoItem(taskId: $0.id,
                                                title: $0.title,
                                                dueDate: $0.dueDate ?? "",
                                                daysLeft: self.calculateDaysLeft(from: $0.dueDate))
                        return AnyCellConfigurable(demoItem)
                    }
                    self.onUpdate?()
                }
            case .failure(_):
                print("Failure")
            }
        }
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
            debugPrint("Next Day")
        }
        
        onTapPrevioussDay = {
            debugPrint("Previous Day")
        }
    }
    
    private func calculateDaysLeft(from dueDate: String?) -> String {
        guard let dueDate,
              let date = DateFormatter.taskDateFormatter.date(from: dueDate) else {
            return ""
        }

        let today = Calendar.current.startOfDay(for: Date())
        let due = Calendar.current.startOfDay(for: date)

        let components = Calendar.current.dateComponents([.day], from: today, to: due)
        guard let days = components.day else {
            return ""
        }
        return String(days)
    }

    func defaultSnapshot() -> DataSnapshot {
        var snapshot = DataSnapshot()
        snapshot.appendSections([.Main])
        snapshot.appendItems(items, toSection: .Main)
        return snapshot
    }
    
}
