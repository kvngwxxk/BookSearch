//
//  NaverBook.swift
//  BookSearch
//
//  Created by Kangwook Lee on 2022/11/21.
//

import Foundation

struct NaverResponse: Codable {
	var lastBuildDate: String
	var total: Int
	var start: Int
	var display: Int
	var items: [NaverBook]
}
