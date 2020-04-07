//
//  Follower.swift
//  GithubAPI
//
//  Created by sania zafar on 06/04/2020.
//  Copyright © 2020 sania zafar. All rights reserved.
//

import Foundation

class Follower: Codable {
    
    var name: String
    var avatarUrl: String

    enum CodingKeys: String, CodingKey {
        case name = "login"
        case avatarUrl = "avatar_url"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name) ?? ""
        avatarUrl = try values.decodeIfPresent(String.self, forKey: .avatarUrl) ?? ""
    }
    
}
