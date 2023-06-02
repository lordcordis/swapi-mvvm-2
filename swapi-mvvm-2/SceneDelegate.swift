//
//  SceneDelegate.swift
//  swapi-mvvm-2
//
//  Created by Wheatley on 19.05.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 250, height: 60)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        
//        func createBasicListLayout() -> UICollectionViewLayout {
//            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                 heightDimension: .fractionalHeight(1.0))
//            let item = NSCollectionLayoutItem(layoutSize: itemSize)
//
//            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                  heightDimension: .absolute(44))
//            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
//                                                             subitems: [item])
//
//            let section = NSCollectionLayoutSection(group: group)
//
//            let layout = UICollectionViewCompositionalLayout(section: section)
//            return layout
//        }
        
        
        let mainCollectionViewController = MainCollectionViewController(collectionViewLayout: layout)
//        let mainCollectionViewController = DetailTableViewControllerDiff()

        
        let navController = UINavigationController(rootViewController: mainCollectionViewController)
        navController.navigationBar.tintColor = .systemPink
        
        
        navController.navigationBar.prefersLargeTitles = true
        navController.topViewController?.navigationController?.navigationBar.prefersLargeTitles = false
        
        self.window!.rootViewController = navController
        self.window!.makeKeyAndVisible()
        
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
    }
    
    
}

