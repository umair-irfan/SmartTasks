//
//  UserDefaults+Extension.swift
//  Smart tasks
//
//  Created by Umair on 24/06/2025.
//

import Foundation

public protocol UserDefaultsKey {
    var rawValue: String { get }
}

extension UserDefaultsKey {
    func save(_ value: [Task]) {
        if let encoded = try? JSONEncoder().encode(value) {
            UserDefaults.standard.set(encoded, forKey:self.rawValue)
        }
        UserDefaults.standard.synchronize()
    }
    
    func array() -> [Task] {
        if let data = UserDefaults.standard.data(forKey: self.rawValue),
           let tasks = try? JSONDecoder().decode([Task].self, from: data) {
            return tasks
        }
        return []
    }
    
    func append(_ value: Task) {
        if alreadyExist(value) {
            return
        }
        var array = self.array()
        array.append(value)
        self.save(array)
    }
    
    func alreadyExist(_ value: Task) -> Bool {
        return self.array().contains { $0.id == value.id }
    }
    
    func saveOrUpdate(_ value: Task) {
        var array = self.array()
        if let index = array.firstIndex(where: { $0.id == value.id }) {
            array[index] = value
        } else {
            array.append(value)
        }
        self.save(array)
    }
}

extension UserDefaults {
    
    enum local: String, UserDefaultsKey {
        case tasks = "kLocalTasks"
    }
    
    static func remove(keys: [UserDefaultsKey]) {
        for key in keys {
            UserDefaults.standard.removeObject(forKey: key.rawValue)
        }
        UserDefaults.standard.synchronize()
    }
}
