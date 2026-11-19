//
//  TodoModel.swift
//  Assignment 5
//
//  Created by Danny Muñoz on 11/19/26.
//

import Foundation
import FirebaseFirestore

struct TodoModel : Codable, Identifiable {
    @DocumentID var id : String?
    var title : String
    var content : String
    var isDone : Bool

    enum CodingKeys : String, CodingKey {
        case id
        case title = "Title"
        case content = "Content"
        case isDone = "Completed"
    }
}
