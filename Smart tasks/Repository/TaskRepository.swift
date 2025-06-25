//
//  TaskRepository.swift
//  Smart tasks
//
//  Created by Umair on 21/06/2025.
//
import Foundation
import Combine

internal typealias DataResponse = (Result<TaskResponse, NSError>)-> Void

protocol TaskRepositoryType {
    func fetchTasks() -> AnyPublisher<TaskResponse, Error>
}

extension TaskRepositoryType {
    func syncLocalTaskStatus() { }
}

class TaskRepository: TaskRepositoryType {
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchTasks() -> AnyPublisher<TaskResponse, Error> {
        return Future<TaskResponse, Error> { [weak self] promise in
            guard let self = self else {
                promise(.failure(NSError()))
                return
            }
            let url = URL(string: "http://demo3809319.mockable.io/")!
            let result = URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .decode(type: TaskResponse.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
            result.sink(receiveCompletion: { _  in }, receiveValue: { response in
                var modifiedResponse = response
                let localTasks = UserDefaults.local.tasks.array()
                modifiedResponse.tasks = response.tasks.map { task in
                    var updatedTask = task
                    if let local = localTasks.first(where: { $0.id == task.id }) {
                        updatedTask.status = local.status
                        return updatedTask
                    }
                    return updatedTask
                }
                promise(.success(modifiedResponse))
            }).store(in: &cancellables)
        }.eraseToAnyPublisher()
    }
    
    func syncLocalTaskStatus() {
        
    }
}

class MockTaskRepository: AppRepository, TaskRepositoryType {
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchTasks() -> AnyPublisher<TaskResponse, Error> {
        return Future<TaskResponse, Error> { [weak self] promise in
            
            guard let self = self else {
                promise(.failure(NSError()))
                return
            }
            let result: AnyPublisher<TaskResponse, Error> = mock.loadJson(file: "task_response")
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
            result.sink(receiveCompletion: { _  in }, receiveValue: { response in
                var modifiedResponse = response
                let localTasks = UserDefaults.local.tasks.array()
                modifiedResponse.tasks = response.tasks.map { task in
                    var updatedTask = task
                    if let local = localTasks.first(where: { $0.id == task.id }) {
                        updatedTask.status = local.status
                        return updatedTask
                    }
                    return updatedTask
                }
                promise(.success(modifiedResponse))
            }).store(in: &cancellables)
        }.eraseToAnyPublisher()
    }
}
