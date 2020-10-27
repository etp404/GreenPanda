//
//  DiaryEntriesCoordinator.swift
//  GreenPanda
//
//  Created by Matthew Mould on 27/10/2020.
//

import UIKit

class DiaryEntriesCoordinator: Coordinator {
    
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = DiaryViewController(nibName: "DiaryViewController", bundle: nil)
        vc.configure(with: DiaryViewModel(model: StubbedGreenPandaModel(),
                                          timezone: TimeZone.current))
        navigationController.pushViewController(vc, animated: false)
    }
    

}
