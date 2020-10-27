//
//  ComposeDiaryEntryCoordinator.swift
//  GreenPanda
//
//  Created by Matthew Mould on 27/10/2020.
//

import UIKit

class ComposeDiaryEntryCoordinator: Coordinator {
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = ComposeDiaryEntryViewController(nibName: "ComposeDiaryEntryViewController", bundle: nil)
      
        navigationController.pushViewController(vc, animated: false)
    }
}
