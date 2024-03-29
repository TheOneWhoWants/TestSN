//
//  Data.swift
//  TestSN
//
//  Created by Matthew  on 03.05.2022.
//

import UIKit

struct Posts: Codable {
    let posts: [PostData]
}

struct PostData: Codable {
    let postId: Int
    let timeshamp: Int
    let title: String
    let preview_text: String
    let likes_count: Int
}

struct MoreInfoJson: Codable {
    let post: MoreInfoData
}

struct MoreInfoData: Codable {
    let postId: Int
    let timeshamp: Int
    let title: String
    let text: String
    let postImage: String
    let likes_count: Int
}

