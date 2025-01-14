//
//  DefaultAppCoordinator.swift
//  FogFog-iOS
//
//  Created by 김승찬 on 2022/11/17.
//

import UIKit

final class DefaultAppCoordinator: AppCoordinator {

    weak var finishDelegate: CoordinatorFinishDelegate?
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    var type: CoordinatorCase { .app }

    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        
        // BaseViewController에서 ViewWillAppear에 해당하는 부분인데
        // BaseViewController에서 코드를 지울지, 아래의 코드를 지울지 논의 필요
        navigationController.setNavigationBarHidden(true, animated: true)
    }
    
    func start() {
        
        /// 토큰이 UserDefaults에 저장되어 있을 때, 앱의 시작점을 mapFlow로 아니면 loginFlow로
        /// UserDefaultsManager.token.isEmpty ? showLoginFlow() : showMapFlow()
        /// 일단 MapViewController로 연결
        
        showMapFlow()
    }
    
    func showLoginFlow() {
        
        let loginCoordinator = DefaultLoginCoordinator(self.navigationController)
        loginCoordinator.finishDelegate = self
        loginCoordinator.start()
        childCoordinators.append(loginCoordinator)
    }
    
    func showMapFlow() {
        
        let mapCoordinator = DefaultMapCoordinator(self.navigationController)
        mapCoordinator.finishDelegate = self
        mapCoordinator.start()
        childCoordinators.append(mapCoordinator)
    }
}

extension DefaultAppCoordinator: CoordinatorFinishDelegate {

    func didFinish(childCoordinator: Coordinator) {
        
        self.childCoordinators = self.childCoordinators.filter({ $0.type != childCoordinator.type })
        self.navigationController.viewControllers.removeAll()
        
        switch childCoordinator.type {
        case .login:
            self.showMapFlow()
        case .map:
            self.showLoginFlow()
        default:
            break
        }
    }
}
