//
//  TaskRepository.swift
//  Smart tasks
//
//  Created by Umair on 21/06/2025.
//
import Foundation

internal typealias DataResponse = (Result<TaskResponse, NSError>)-> Void

protocol TaskRepositoryType {
    func fetchTasks(completion: @escaping DataResponse)
}

class TaskRepository: TaskRepositoryType {
    func fetchTasks(completion: @escaping DataResponse) {
        
    }
}

class MockTaskRepository: AppRepository, TaskRepositoryType {
    func fetchTasks(completion: @escaping DataResponse) {
        mock.loadJson(file: "task_response", completion: completion)
    }
}
