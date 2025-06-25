//
//  DetailViewModel.swift
//  Smart tasks
//
//  Created by Umair on 22/06/2025.
//
import UIKit
import Combine

internal typealias DetailSnapshot = NSDiffableDataSourceSnapshot<DetailView.Section, AnyCellConfigurable>

protocol DetailViewModelInput {
    func loadData()
}

protocol DetailViewModelOutput {
    var snapshotPublisher: AnyPublisher<DetailSnapshot, Never> { get }
}

protocol DetailViewModelType {
    var input: DetailViewModelInput { get }
    var output: DetailViewModelOutput { get }
}

class DetailViewModel: DetailViewModelInput, DetailViewModelOutput, DetailViewModelType {
    
    private var detailItem = CurrentValueSubject<[AnyCellConfigurable], Never>([])
    private var statusItem = CurrentValueSubject<[AnyCellConfigurable], Never>([])
    
    private(set) var task: Task
    let statusUpdate = GlobalEvent.Application.TaskStatusUpdate.observe()
    private var cancellables = Set<AnyCancellable>()
    
    var input: DetailViewModelInput { self }
    var output:  DetailViewModelOutput { self }
    
    //MARK: Output
    var snapshotPublisher: AnyPublisher<DetailSnapshot, Never> {
        Publishers.CombineLatest(detailItem, statusItem)
            .map { detailItems, statusItems in
                var snapshot = DetailSnapshot()
                snapshot.appendSections([.Main, .Status])
                snapshot.appendItems(detailItems, toSection: .Main)
                snapshot.appendItems(statusItems, toSection: .Status)
                return snapshot
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    init(task: Task) {
        self.task = task
        bindStatusUpdate()
    }
    
    func loadData() {
        let input = AnyCellConfigurable(DetailItem(title: task.title,
                                                   dueDate: task.dueDate ?? "",
                                                   daysLeft: task.calculateDaysLeft(),
                                                   description: task.description,
                                                   status: task.status))
        self.detailItem.send([input])
        self.statusItem.send([AnyCellConfigurable(StatusItem(status: task.status))])
    }
    
    func bindStatusUpdate() {
        statusUpdate.sink(receiveCompletion: { _ in },
                          receiveValue: { [weak self] item in
            guard let self = self else { return }
            if let status = item.object as? StatusType {
                //MARK: Update Task Status
                task.updateTaskStatus(with: status)
                UserDefaults.local.tasks.saveOrUpdate(task)
                self.loadData()
            }
        })
        .store(in: &cancellables)
    }
}
