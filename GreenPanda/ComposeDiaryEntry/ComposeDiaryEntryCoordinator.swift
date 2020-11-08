//
//  ComposeDiaryEntryCoordinator.swift
//  GreenPanda
//
//  Created by Matthew Mould on 27/10/2020.
//

import UIKit

class ComposeDiaryEntryCoordinator: Coordinator {
    private var navigationController: UINavigationController
    private var model: GreenPandaModel
    
    init(navigationController: UINavigationController, model: GreenPandaModel) {
        self.navigationController = navigationController
        self.model = model
    }
    
    func start() {
        let vc = ComposeDiaryEntryViewController(nibName: "ComposeDiaryEntryViewController", bundle: nil)
        vc.configure(with: ComposeDiaryEntryViewModel(model: model))
        navigationController.pushViewController(vc, animated: false)
    }
}
