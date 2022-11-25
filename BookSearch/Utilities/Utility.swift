//
//  Utility.swift
//  BookSearch
//
//  Created by Kangwook Lee on 2022/11/24.
//

import Foundation

class Utility {
	static func measureTime(_ closure: () -> ()) -> TimeInterval {
		let startDate = Date()
		closure()
		return Date().timeIntervalSince(startDate)
	}
	
	static func stringToDate(type: String, string: String) -> Date? {
		if type == "naver" {
			let dateFormatter: DateFormatter = {
				let formatter = DateFormatter()
				formatter.dateFormat = "yyyyMMdd"
				return formatter
			}()
			return dateFormatter.date(from: string)
		} else {
			let dateFormatter: DateFormatter = {
				let formatter = DateFormatter()
				formatter.dateFormat = "yyyy-MM-dd"
				return formatter
			}()
			return dateFormatter.date(from: string)
		}
	}
	
	static func dateToString(date: Date) -> String {
		let dateFormatter: DateFormatter = {
			let formatter = DateFormatter()
			formatter.dateFormat = "yyyy년 MM월 dd일"
			return formatter
		}()
		return dateFormatter.string(from: date)
	}
}
