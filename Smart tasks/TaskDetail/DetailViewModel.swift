//
//  DetailViewModel.swift
//  Smart tasks
//
//  Created by Umair on 22/06/2025.
//

protocol DetailViewModelInput {
    func loadData()
}

protocol DetailViewModelOutput {
    var onUpdate: SimpleCallback? { get set }
    func defaultSnapshot() -> DetailSnapshot
}

protocol DetailViewModelType {
    var input: DetailViewModelInput { get }
    var output: DetailViewModelOutput { get set }
}

class DetailViewModel: DetailViewModelInput, DetailViewModelOutput, DetailViewModelType {
    
    private(set) var detailItem: [AnyCellConfigurable] = []
    private(set) var statusItem: [AnyCellConfigurable] = []
    private(set) var task: Task
    
    var input: DetailViewModelInput { self }
    var output:  DetailViewModelOutput {
        get { self }
        set { }
    }
    
    //MARK: Output
    var onUpdate: SimpleCallback?
    
    init(task: Task) {
        self.task = task
    }
    
    func loadData() {
        self.detailItem = [
            AnyCellConfigurable(DetailItem(title: task.title,
                                           dueDate: task.dueDate ?? "",
                                           daysLeft: task.calculateDaysLeft(),
                                           description: task.description,
                                           status: task.status))
        ]
        
        self.statusItem = [
            AnyCellConfigurable(StatusItem(status: task.status))
        ]
        
        self.onUpdate?()
    }
    
    func defaultSnapshot() -> DetailSnapshot {
        var snapshot = DetailSnapshot()
        snapshot.appendSections([.Main, .Status])
        snapshot.appendItems(detailItem, toSection: .Main)
        snapshot.appendItems(statusItem, toSection: .Status)
        return snapshot
    }
    
}
