//
//  ComposeDiaryEntryCoordinator.swift
//  GreenPanda
//
//  Created by Matthew Mould on 27/10/2020.
//

import UIKit

protocol ComposeDiaryEntryCoordinatorDelegate {
    func composeFinished()
}

class ComposeDiaryEntryCoordinator: Coordinator {
    private var navigationController: UINavigationController
    private var model: GreenPandaModel
    private var viewController: ComposeDiaryEntryViewController?
    
    init(navigationController: UINavigationController, model: GreenPandaModel) {
        self.navigationController = navigationController
        self.model = model
    }
    
    func start() {
        viewController = ComposeDiaryEntryViewController(nibName: "ComposeDiaryEntryViewController", bundle: nil)
        guard let viewController = viewController else { return }
        viewController.configure(with: ComposeDiaryEntryViewModel(model: model, coordinatorDelegate: self))
        navigationController.present(viewController, animated: true)
    }
    
}

extension ComposeDiaryEntryCoordinator: ComposeDiaryEntryCoordinatorDelegate {
    func composeFinished() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
