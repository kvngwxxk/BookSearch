//
//  MainViewModel.swift
//  BookSearch
//
//  Created by Kangwook Lee on 2022/11/18.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel {
	let apiManager = ApiManager.shared
	var isAdult: BehaviorRelay<Bool> = .init(value: false)
	var query: BehaviorRelay<String> = .init(value: "")
	var books: PublishRelay<[Book]> = PublishRelay()
	
	func requestNaverBookInfo(query: String) {
		// TODO: Naver REST API 호출
		apiManager.requestNaverBookInfo(query: query)
	}
	
	func requestKakaoBookInfo(query: String) {
		// TODO: Kakao REST API 호출
	}
}
