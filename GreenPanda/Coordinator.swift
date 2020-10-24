//
//  Coordinator.swift
//  GreenPanda
//
//  Created by Matthew Mould on 24/10/2020.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
