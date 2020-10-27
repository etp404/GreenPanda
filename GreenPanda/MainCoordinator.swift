//
//  MainCoordinator.swift
//  GreenPanda
//
//  Created by Matthew Mould on 24/10/2020.
//

import UIKit

class MainCoordinator: Coordinator {
    private var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        DiaryEntriesCoordinator(navigationController: navigationController).start()
    }
}
