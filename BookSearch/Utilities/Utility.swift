//
//  Utility.swift
//  BookSearch
//
//  Created by Kangwook Lee on 2022/11/24.
//

import Foundation

class Utility {
	static public func measureTime(_ closure: () -> ()) -> TimeInterval {
		let startDate = Date()
		closure()
		return Date().timeIntervalSince(startDate)
	}
}
