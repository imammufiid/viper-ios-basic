//
//  NoticeModel.swift
//  viper-mufiid
//
//  Created by dios on 26/02/23.
//

import Foundation

class NoticeModel: Codable {
    var id: String?
    var title: String?
    var brief: String?
    var fileSource: String?

    enum CodingKeys: String, CodingKey {
        case id = "email"
        case title = "first_name"
        case brief = "last_name"
        case fileSource = "avatar"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        brief = try values.decodeIfPresent(String.self, forKey: .brief)
        fileSource = try values.decodeIfPresent(String.self, forKey: .fileSource)
    }
}
