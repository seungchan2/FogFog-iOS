//
//  DefaultLoginCoordinator.swift
//  FogFog-iOS
//
//  Created by 김승찬 on 2022/11/17.
//

import UIKit

final class DefaultLoginCoordinator: LoginCoordinator {
    
    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var type: CoordinatorCase { .login }
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        
        showLoginViewController()
    }
    
    func showLoginViewController() {
    }
    
    func connectMapCoordinator() {
        
        let mapCoordinator = DefaultMapCoordinator(self.navigationController)
        mapCoordinator.start()
        self.childCoordinators.append(mapCoordinator)
        let locationService = DefaultLocationService()
        let mapViewModel = MapViewModel(coordinator: self, locationService: locationService)
        let mapViewController = MapViewController(viewModel: mapViewModel)
        changeAnimation()
        navigationController.viewControllers = [mapViewController]
    }
    
    func finish() {
        
        finishDelegate?
            .didFinish(childCoordinator: self)
    }
}
