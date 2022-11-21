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
	var sale_price: Int
	var status: String
	var thumbnail: String
	var title: String
	var translators: [String]
	var url: String
}
