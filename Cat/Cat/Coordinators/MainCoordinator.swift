//
//  MainCoordinator.swift
//  Cat
//
//  Created by Deekshith Bellare on 04/08/20.
//  Copyright © 2020 Deekshith Bellare. All rights reserved.
//

import UIKit

//Coordinator patten is used for routing. Every Coordinator class responsible for routing should implement the protocol
protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}

// Coordinator responsible for the navigation from Scene delegate.
// MainCoordinator is the parent of all coordinators
class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let storyboard = UIStoryboard(.main)
        let catsViewController:CatsViewController = storyboard.instantiateViewController()
        catsViewController.coordinator = self
        navigationController.pushViewController(catsViewController, animated: false)
    }
}

// A protocol to be implemented by Coordinator responsible for Favourites screen routing.
protocol ViewFavourites {
    func showFavourites()
}

// Currently MainCoordinator handles routing for Favourites. When functioanlity grows we should create separate Coodinator for Favourites scene
extension MainCoordinator:ViewFavourites {
    func showFavourites() {
        let storyboard = UIStoryboard(.main)
        let favouritesViewController:FavouritesViewController = storyboard.instantiateViewController()
        navigationController.pushViewController(favouritesViewController, animated: false)
    }
}
