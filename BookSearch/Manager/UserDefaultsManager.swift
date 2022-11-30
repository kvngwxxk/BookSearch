//
//  SearchTextManager.swift
//  BookSearch
//
//  Created by Kangwook Lee on 2022/11/28.
//

import Foundation

class UserDefaultsManager {
	static let shared = UserDefaultsManager()
	let userDefaults = UserDefaults.standard
	
	func initializeUserDefaultsManager() -> [String] {
		if let searchTextList = (userDefaults.array(forKey: "searchText") ?? [String]()) as? [String] {
			if searchTextList.isEmpty {
				userDefaults.set([String](), forKey: "searchText")
				return []
			} else {
				print("not empty")
				return searchTextList
			}
		}
		return []
	}
	
	func saveSearchText(searchText: String) -> [String] {
		if var searchTextList = (userDefaults.array(forKey: "searchText") ?? [String]()) as? [String] {
			if searchTextList.count > 100 {
				searchTextList.removeLast()
				searchTextList.insert(searchText, at: 0)
				userDefaults.set(searchTextList, forKey: "searchText")
				return searchTextList
			} else {
				searchTextList.insert(searchText, at: 0)
				userDefaults.set(searchTextList, forKey: "searchText")
				return searchTextList
			}
		} else {
			return []
		}
	}
}
