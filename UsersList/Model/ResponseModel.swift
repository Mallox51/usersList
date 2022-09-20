//
//  ResponseModel.swift
//  UsersList
//
//  Created by Emmanuel Digiaro on 13/09/2022.
//

import Foundation

class ResponseModel: Codable {
    var count: Int? = 0
    var data: [UserModel] = []
}

class UserModel: Codable, Identifiable {
    var defaultPictureUrl: String? = ""
    var firstName: String? = ""
    var lastName: String? = ""
    var averageReviewScore: Double?
    
    enum CodingKeys: String, CodingKey {
        case defaultPictureUrl = "default_picture_url"
        case lastName = "last_name"
        case firstName = "first_name"
        case averageReviewScore = "average_review_score"
    }
}
