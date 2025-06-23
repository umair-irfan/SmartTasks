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

class TaskRepository: TaskRepositoryType {
    func fetchTasks() -> AnyPublisher<TaskResponse, Error> {
        let url = URL(string: "http://demo3809319.mockable.io/")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: TaskResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

class MockTaskRepository: AppRepository, TaskRepositoryType {
    func fetchTasks() -> AnyPublisher<TaskResponse, Error> {
        return mock.loadJson(file: "task_response")
                   .receive(on: DispatchQueue.main)
                   .eraseToAnyPublisher()
    }
}
