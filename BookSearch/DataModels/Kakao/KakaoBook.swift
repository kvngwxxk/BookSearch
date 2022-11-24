//
//  KakaoBook.swift
//  BookSearch
//
//  Created by Kangwook Lee on 2022/11/21.
//

import Foundation

struct KakaoBook: Codable {
	var authors: [String]
	var contents: String
	var dateTime: String
	var isbn: String
	var price: Int
	var publisher: String
	var salePrice: Int
	var status: String
	var thumbnail: String
	var title: String
	var translators: [String]
	var url: String
	
	enum CodingKeys: String, CodingKey {
		case authors = "authors"
		case contents = "contents"
		case dateTime = "datetime"
		case isbn = "isbn"
		case price = "price"
		case publisher = "publisher"
		case salePrice = "sale_price"
		case status = "status"
		case thumbnail = "thumbnail"
		case title = "title"
		case translators = "translators"
		case url = "url"
	}
}
