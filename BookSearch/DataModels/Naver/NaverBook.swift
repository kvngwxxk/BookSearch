//
//  NaverItem.swift
//  BookSearch
//
//  Created by Kangwook Lee on 2022/11/21.
//

import Foundation

struct NaverBook: Codable {
	var title: String
	var link: String
	var author: String
	var image: String
	var discount: String
	var publisher: String
	var pubDate: String
	var isbn: String
	var description: String
	
	enum CodingKeys: String, CodingKey {
		case title = "title"
		case link = "link"
		case author = "author"
		case image = "image"
		case discount = "discount"
		case publisher = "publisher"
		case isbn = "isbn"
		case description = "description"
		case pubDate = "pubdate"
	}
}

