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
	
	static func stringToDate(dateFormat: DateFormatter, string: String) -> Date? {
		return dateFormat.date(from: string)
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
