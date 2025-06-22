//
//  TaskViewModel.swift
//  Smart tasks
//
//  Created by Umair on 21/06/2025.
//

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
                    AnyCellConfigurable(DemoItem(name: $0.title))
                }
                self.onUpdate?()
            case .failure(_):
                print("Failure")
            }
        }
    }

    func defaultSnapshot() -> DataSnapshot {
        var snapshot = DataSnapshot()
        snapshot.appendSections([.Main])
        snapshot.appendItems(items, toSection: .Main)
        return snapshot
    }
    
}
