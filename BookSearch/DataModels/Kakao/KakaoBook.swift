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
		case authors
		case contents
		case dateTime = "datetime"
		case isbn
		case price
		case publisher
		case salePrice = "sale_price"
		case status
		case thumbnail
		case title
		case translators
		case url
	}
}
