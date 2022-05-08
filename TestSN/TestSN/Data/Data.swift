//
//  Data.swift
//  TestSN
//
//  Created by Matthew  on 03.05.2022.
//

import UIKit

struct Posts: Decodable {
    let posts: [PostData]
}

struct PostData: Decodable {
    let postId: Int
    let timeshamp: Int
    let title: String
    let preview_text: String
    let likes_count: Int
}
