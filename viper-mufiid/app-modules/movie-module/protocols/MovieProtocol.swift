//
//  MovieProtocols.swift
//  viper-mufiid
//
//  Created by dios on 27/02/23.
//

import Foundation

protocol PresenterToRouterMovieProtocol: AnyObject {
    static func createModule() -> MovieVC
}
