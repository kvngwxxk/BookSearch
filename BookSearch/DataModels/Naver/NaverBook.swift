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
		case title
		case link
		case author
		case image
		case discount
		case publisher
		case isbn
		case description
		case pubDate = "pubdate"
	}
}

