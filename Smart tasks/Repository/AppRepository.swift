//
//  AppRepository.swift
//  Smart tasks
//
//  Created by Umair on 21/06/2025.
//

import Foundation

class AppRepository {
    
    public lazy var mock: MockDataService = {
        return MockDataService()
    }()
}

final class MockDataService {
    func loadJson<T:Decodable>(file: String,
                               completion: @escaping (Result<T, NSError>)-> Void) {
        do {
            guard let path = Bundle.main.url(forResource: file, withExtension: "json") else { return }
            debugPrint("Mock: \(file).json ✅")
            let data = try NSData(contentsOf: path) as Data
            let mockData = try JSONDecoder().decode(T.self, from: data)
            completion(.success(mockData))
        } catch let error {
            debugPrint("Error\(error.localizedDescription)")
        }
    }
}
