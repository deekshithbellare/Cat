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
