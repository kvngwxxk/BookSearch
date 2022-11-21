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
	var isAdult: BehaviorRelay<Bool> = .init(value: false)
	var query: BehaviorRelay<String> = .init(value: "")
	
	func requestNaverBookInfo(query: String) {
		// TODO: Naver REST API 호출
	}
	
	func requestKakaoBookInfo(query: String) {
		// TODO: Kakao REST API 호출
	}
}
