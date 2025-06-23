//
//  TaskModel.swift
//  Smart tasks
//
//  Created by Umair on 21/06/2025.
//

import Foundation

struct TaskResponse: Codable {
    let tasks: [Task]

    enum CodingKeys: String, CodingKey {
        case tasks
    }
}

struct Task: Codable, Identifiable {
    let id: String
    let targetDate: String
    let dueDate: String?
    let title: String
    let description: String
    let priority: Int?
    var status: StatusType = .unresolved

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case targetDate = "TargetDate"
        case dueDate = "DueDate"
        case title = "Title"
        case description = "Description"
        case priority = "Priority"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.targetDate = try container.decode(String.self, forKey: .targetDate)
        self.dueDate = try container.decodeIfPresent(String.self, forKey: .dueDate)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.priority = try container.decodeIfPresent(Int.self, forKey: .priority)
    }
    
    func calculateDaysLeft() -> String {
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

}
