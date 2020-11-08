//
//  MainCoordinator.swift
//  GreenPanda
//
//  Created by Matthew Mould on 24/10/2020.
//

import UIKit

class MainCoordinator: Coordinator {
    private var navigationController: UINavigationController
    private var model: GreenPandaModel
    
    init(navigationController: UINavigationController,
         model: GreenPandaModel) {
        self.navigationController = navigationController
        self.model = model
    }

    func start() {
        DiaryEntriesCoordinator(navigationController: navigationController, model:model).start()
    }
}
