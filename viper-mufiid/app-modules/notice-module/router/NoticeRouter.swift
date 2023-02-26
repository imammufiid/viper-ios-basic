//
//  NoticeRouter.swift
//  viper-mufiid
//
//  Created by dios on 26/02/23.
//

import Foundation
import UIKit

class NoticeRouter: PresenterToRouterProtocol {
    static func createModule() -> NoticeVC {
        let view = mainStoryboard.instantiateViewController(withIdentifier: "NoticeVC") as! NoticeVC
        let presenter: ViewToPresenterProtocol & InteractorToPresenterProtocol = NoticePresenter()
        let interactor: PresenterToInteractorProtocol = NoticeInteractor()
        let router: PresenterToRouterProtocol = NoticeRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        return view
    }

    func pushToMovieScreen(navigationController: UINavigationController) {
//        let movieModue = MovieRouter.createMovieModule()
//        navigationController.pushViewController(movieModue,animated: true)
    }

    static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
}
