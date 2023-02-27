//
//  NoticeProtocols.swift
//  viper-mufiid
//

import Foundation
import UIKit

protocol ViewToPresenterProtocol: AnyObject {
    var view: PresenterToViewProtocol? { get set }
    var interactor: PresenterToInteractorProtocol? { get set }
    var router: PresenterToRouterProtocol? { get set }
    func startFetchingNotice()
    func showMovieController(_ title: String)
}

protocol PresenterToViewProtocol: AnyObject {
    func showNotice(notices: Array<NoticeModel>)
    func showNoticeError(message: String)
}

protocol PresenterToRouterProtocol: AnyObject {
    var viewController: NoticeVC? { get set }
    static func createModule() -> NoticeVC
    func pushToMovieScreen(_ title: String)
}

protocol PresenterToInteractorProtocol: AnyObject {
    var presenter: InteractorToPresenterProtocol? { get set }
    func fetchNotice()
}

protocol InteractorToPresenterProtocol: AnyObject {
    func noticeFetchedSuccess(notices: Array<NoticeModel>)
    func noticeFetchFailed(message: String)
}
