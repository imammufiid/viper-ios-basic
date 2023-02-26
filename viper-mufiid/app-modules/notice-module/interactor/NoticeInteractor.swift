//
//  NoticeInteractor.swift
//  viper-mufiid
//
//  Created by dios on 26/02/23.
//

import Alamofire
import Foundation

/*
 - All business logic is in here
 - Send result of interactor to presenter
 */
class NoticeInteractor: PresenterToInteractorProtocol {
    var presenter: InteractorToPresenterProtocol?

    func fetchNotice() {
        APIRequest<BaseResponse<NoticeModel>>().execute(
            url: NetConfig.URL.login,
            method: .get,
            parameters: [:],
            success: { _ in
                self.presenter?.noticeFetchedSuccess(notices: [])
            },
            failure: { error in
                print(error)
                self.presenter?.noticeFetchFailed(message: error)
            }
        )
    }
}
