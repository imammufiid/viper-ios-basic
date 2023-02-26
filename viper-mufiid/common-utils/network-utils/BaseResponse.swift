//
//  BaseResponse.swift
//  viper-mufiid
//
//  Created by dios on 26/02/23.
//

import Foundation

class BaseResponse<T: Codable>: Codable {
    let success: Int?
    let error_code: String?
    let message: String?
    let data: T?

    enum CodingKeys: String, CodingKey {
        case data
        case success
        case error_code
        case message
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Int.self, forKey: .success)
        error_code = try values.decodeIfPresent(String.self, forKey: .error_code)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(T.self, forKey: .data)
    }

    func isSuccess()->Bool {
        return success == 1
    }
}

class BaseResponseList<T: Codable>: Codable {
    let success: Int?
    let error_code: String?
    let message: String?
    let data: [T]?

    enum CodingKeys: String, CodingKey {
        case data
        case success
        case error_code
        case message
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Int.self, forKey: .success)
        error_code = try values.decodeIfPresent(String.self, forKey: .error_code)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([T].self, forKey: .data)
    }

    func isSuccess()->Bool {
        return success == 1
    }
}

class DefaultResponse: Codable {
    let success: Int?
    let error_code: String?
    let message: String?

    enum CodingKeys: String, CodingKey {
        case success
        case error_code
        case message
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        success = try values.decodeIfPresent(Int.self, forKey: .success)
        error_code = try values.decodeIfPresent(String.self, forKey: .error_code)
        message = try values.decodeIfPresent(String.self, forKey: .message)
    }

    func isSuccess()->Bool {
        return success == 1
    }
}
