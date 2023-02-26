//
//  NoticePresenter.swift
//  viper-mufiid
//
//  Created by dios on 26/02/23.
//

import Foundation
import UIKit

/* Getting data from user action and send it to interactor or navigate to other screen */
class NoticePresenter: ViewToPresenterProtocol {
    var view: PresenterToViewProtocol?
    
    var interactor: PresenterToInteractorProtocol?
    
    var router: PresenterToRouterProtocol?
    
    func startFetchingNotice() {
        interactor?.fetchNotice()
    }
    
    func showMovieController(navigationController: UINavigationController) {
        router?.pushToMovieScreen(navigationController: navigationController)
    }
}

/* Getting data from interactor and send it to view */
extension NoticePresenter: InteractorToPresenterProtocol {
    func noticeFetchedSuccess(notices: [NoticeModel]) {
        view?.showNotice(notices: notices)
    }
    
    func noticeFetchFailed(message: String) {
        view?.showNoticeError(message: message)
    }
}
