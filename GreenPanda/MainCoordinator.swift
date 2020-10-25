//
//  MainCoordinator.swift
//  GreenPanda
//
//  Created by Matthew Mould on 24/10/2020.
//

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vc = DiaryViewController(nibName: "DiaryViewController", bundle: nil)
        vc.configure(with: DiaryViewModel(model: StubbedGreenPandaModel()))
        navigationController.pushViewController(vc, animated: false)
    }
}

class StubbedGreenPandaModel : GreenPandaModel{
    var entries: [DiaryEntry] = [DiaryEntry(timestamp: Date(), entryText: "Blah blah", score: 4),
                                 DiaryEntry(timestamp: Date(), entryText: "Blah blah", score: 4),
                                 DiaryEntry(timestamp: Date(), entryText: "Blah blah", score: 4),
                                 DiaryEntry(timestamp: Date(), entryText: "Blah blah", score: 4),
                                 DiaryEntry(timestamp: Date(), entryText: "Blah blah", score: 4),
                                 DiaryEntry(timestamp: Date(), entryText: "Blah blah", score: 4),
                                 DiaryEntry(timestamp: Date(), entryText: "Blah blah", score: 4)]

    
}
