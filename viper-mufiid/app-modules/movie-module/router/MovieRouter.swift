//
//  MovieRouter.swift
//  viper-mufiid
//
//  Created by dios on 27/02/23.
//

import Foundation
import UIKit

class MovieRouter: PresenterToRouterMovieProtocol {
    static func createModule() -> MovieVC {
        let view = MovieRouter.mainstoryboard.instantiateViewController(withIdentifier: "MovieVC") as! MovieVC
        return view
    }
    
    static var mainstoryboard: UIStoryboard{
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
    
}
