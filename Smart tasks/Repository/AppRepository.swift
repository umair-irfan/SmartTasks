//
//  AppRepository.swift
//  Smart tasks
//
//  Created by Umair on 21/06/2025.
//

import Foundation
import Combine

class AppRepository {
    
    public lazy var mock: MockDataService = {
        return MockDataService()
    }()
}

final class MockDataService {
    
    func loadJson<T: Decodable>(file: String) -> AnyPublisher<T, Error> {
        Future<T, Error> { promise in
            do {
                guard let path = Bundle.main.url(forResource: file, withExtension: "json") else {
                    return promise(.failure(NSError(domain: "Invalid path", code: -1)))
                }
                
                let data = try Data(contentsOf: path)
                let decoded = try JSONDecoder().decode(T.self, from: data)
                debugPrint("Mock: \(file).json ✅")
                promise(.success(decoded))
            } catch {
                debugPrint("Mock decode error: \(error.localizedDescription)")
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
