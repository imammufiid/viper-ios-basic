//
//  AppConstants.swift
//  viper-mufiid
//
//  Created by dios on 26/02/23.
//

import Foundation

let PROGRESS_INDICATOR_VIEW_TAG: Int = 10

let API_SINGLE_USER = "https://reqres.in/api/users/2"

let NO_INTERNET_MSG = "Tidak dapat terhubung ke server, mohon cek koneksi internet anda atau coba lagi nanti"

let BASE_URL = "https://app.yagasu.or.id/api/"

enum NetConfig {
    enum URL {
        static let login = BASE_URL + "v2/auth/login"
    }
}
