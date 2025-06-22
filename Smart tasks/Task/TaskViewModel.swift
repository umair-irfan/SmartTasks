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
}

//MARK: Output
protocol TaskTaskViewModelOutput {
    var onUpdate: SimpleCallback? { get set }
    func defaultSnapshot()-> DataSnapshot
}

protocol TaskViewModelType {
    var input: TaskTaskViewModelInput { get }
    var output: TaskTaskViewModelOutput { get set }
}

class TaskViewModel: TaskTaskViewModelInput, TaskTaskViewModelOutput, TaskViewModelType {
    
    private(set) var repo: TaskRepositoryType!
    private(set) var items: [AnyCellConfigurable] = []
    
    var input: TaskTaskViewModelInput { self }
    var output:  TaskTaskViewModelOutput {
        get { self }
        set { }
    }
    
    //MARK: Output
    var onUpdate: SimpleCallback?

    
    init(task: TaskRepositoryType) {
        self.repo = task
    }
    
    func loadData() {
        repo.fetchTasks { resposse in
            switch resposse {
            case .success(let resp):
                self.items = resp.tasks.map {
                    let demoItem = DemoItem(title: $0.title,
                                            dueDate: $0.dueDate ?? "",
                                            daysLeft: self.calculateDaysLeft(from: $0.dueDate))
                    return AnyCellConfigurable(demoItem)
                }
                self.onUpdate?()
            case .failure(_):
                print("Failure")
            }
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
