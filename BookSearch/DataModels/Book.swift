//
//  Book.swift
//  BookSearch
//
//  Created by Kangwook Lee on 2022/11/28.
//

import Foundation

struct Book: Codable {
	var title: String
	var description: String
	var url: String
	var isbn: String
	var publishDate: String
	var authors: [String]
	var publisher: String
	var salePrice: Int
	var image: String
	var translators: [String]
	var price: Int
	var status: String
	var dataSource: String
	var duplicated = false
}
