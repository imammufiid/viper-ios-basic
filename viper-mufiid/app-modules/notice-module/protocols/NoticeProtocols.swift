//
//  NoticeProtocols.swift
//  viper-mufiid
//
//  Created by dios on 26/02/23.
//

import Foundation
import UIKit

protocol ViewToPresenterProtocol: AnyObject {
    var view: PresenterToViewProtocol? { get set }
    var interactor: PresenterToInteractorProtocol? { get set }
    var router: PresenterToRouterProtocol? { get set }
    func startFetchingNotice()
    func showMovieController(navigationController: UINavigationController)
}

protocol PresenterToViewProtocol: AnyObject {
    func showNotice(notices: Array<NoticeModel>)
    func showNoticeError(message: String)
}

protocol PresenterToRouterProtocol: AnyObject {
    static func createModule() -> NoticeVC
    func pushToMovieScreen(navigationController: UINavigationController)
}

protocol PresenterToInteractorProtocol: AnyObject {
    var presenter: InteractorToPresenterProtocol? { get set }
    func fetchNotice()
}

protocol InteractorToPresenterProtocol: AnyObject {
    func noticeFetchedSuccess(notices: Array<NoticeModel>)
    func noticeFetchFailed(message: String)
}
