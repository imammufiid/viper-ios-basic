//
//  NoticeRouter.swift
//  viper-mufiid
//
//  Created by dios on 26/02/23.
//

import Foundation
import UIKit

class NoticeRouter: PresenterToRouterProtocol {
    var viewController: NoticeVC?
    
    static func createModule() -> NoticeVC {
        let view = mainStoryboard.instantiateViewController(withIdentifier: "NoticeVC") as! NoticeVC
        let presenter: ViewToPresenterProtocol & InteractorToPresenterProtocol = NoticePresenter()
        let interactor: PresenterToInteractorProtocol = NoticeInteractor()
        let router: PresenterToRouterProtocol = NoticeRouter()

        view.presenter = presenter
        router.viewController = view
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        return view
    }

    func pushToMovieScreen(_ title: String) {
        let movieModule = MovieRouter.createModule()
        movieModule.myTitle = title
        viewController?.navigationController?.pushViewController(movieModule, animated: true)
    }

    static var mainStoryboard: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: Bundle.main)
    }
}
