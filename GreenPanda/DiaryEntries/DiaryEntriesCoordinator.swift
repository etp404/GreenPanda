//
//  DiaryEntriesCoordinator.swift
//  GreenPanda
//
//  Created by Matthew Mould on 27/10/2020.
//

import UIKit

class DiaryEntriesCoordinator: Coordinator, DiaryViewModelCoordinatorDelegate {
    
    private var navigationController: UINavigationController
    private var model: GreenPandaModel
    
    init(navigationController: UINavigationController, model: GreenPandaModel) {
        self.navigationController = navigationController
        self.model = model
    }
    
    func start() {
        let vc = DiaryViewController(nibName: "DiaryViewController", bundle: nil)
        vc.configure(with: ModelBackedDiaryViewModel(model: model,
                                          timezone: TimeZone.current,
                                          coordinatorDelegate: self))
        navigationController.pushViewController(vc, animated: false)
    }
    
    func openComposeView() {
        ComposeDiaryEntryCoordinator(navigationController: navigationController, model: model).start()
    }
    
}
