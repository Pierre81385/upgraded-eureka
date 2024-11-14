//
//  AuthModel.swift
//  swiftui_upgraded_eureka
//
//  Created by m1_air on 11/13/24.
//

import Foundation

//firebase authenticated user object
struct AuthModel: Codable, Equatable {
    var uid: String
    var displayName: String
    var email: String
    var password: String
    var avatar: String
    

    private enum CodingKeys: String, CodingKey {
        case uid
        case displayName
        case email
        case password
        case avatar
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uid = try container.decode(String.self, forKey: .uid)
        displayName = try container.decode(String.self, forKey: .displayName)
        email = try container.decode(String.self, forKey: .email)
        password = try container.decode(String.self, forKey: .password)
        avatar = try container.decode(String.self, forKey: .avatar)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uid, forKey: .uid)
        try container.encode(displayName, forKey: .displayName)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
        try container.encode(avatar, forKey: .avatar)
    }
    
    init(uid: String = "", displayName: String = "", email: String = "", password: String = "", avatar: String = "") {
        self.uid = uid
        self.displayName = displayName
        self.email = email
        self.password = password
        self.avatar = avatar
    }
}
