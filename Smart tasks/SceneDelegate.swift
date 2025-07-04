//
//  SceneDelegate.swift
//  Smart tasks
//
//  Created by Umair on 21/06/2025.
//

import UIKit
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?
    private var cancellables = Set<AnyCancellable>()
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        //MARK: Custom Entry Point for Application
        /// ✅ Dependecies are Injected in Co-ordinators via DIC
        /// ✅ Dependecy Inversion using MocKTaskRepository()
        let tasks: TaskRepositoryType = TaskRepository()
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        
        // Navigations are managed through Co-ordinators(Combine)
        /// ✅ Initialize and start AppCoordinator
        let coordinator = AppCoordinator(window: window, tasks)
        self.appCoordinator = coordinator
        
        /// ✅ Start AppCoordinator
        coordinator.start()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("AppCoordinator failed with error: \(error)")
                }
            }, receiveValue: { result in
                print("AppCoordinator finished with result: \(result)")
            })
            .store(in: &cancellables)
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

