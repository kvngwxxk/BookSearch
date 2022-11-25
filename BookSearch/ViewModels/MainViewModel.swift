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
	var hasAdult: BehaviorRelay<[Bool]> = .init(value: [])
	
	var correctWords: BehaviorRelay<[String]> = .init(value: [])
	
	var naverBooks: BehaviorRelay<[NaverBook]> = .init(value: [])
	var naverTotal: BehaviorRelay<Int> = .init(value: 0)
	var kakaoBooks: PublishRelay<[KakaoBook]> = PublishRelay()
	var kakaoTotal: BehaviorRelay<Int> = .init(value: 0)
	var kakaoIsEnd: BehaviorRelay<Bool> = .init(value: false)
	let disposeBag = DisposeBag()
	
	// ApiManager의 Naver 도서검색 API 요청
	func requestNaverBookInfo(query: String, page: Int) {
		apiManager.requestNaverBookInfo(query: query, page: page).subscribe(onNext: { [weak self] (books, total) in
			guard let self = self else { return }
			self.naverBooks.accept(books)
			self.naverTotal.accept(total)
		}).disposed(by: disposeBag)
	}
	
	// ApiManager의 Naver 성인 검색어 API 요청
	func requestAdult(query: String) {
		let bool = apiManager.requestAdult(query: query)
		hasAdult.accept(bool)
	}
	
	// ApiManager의 Naver 오타 변환 API 요청
	func requestErrata(query: String) {
		let words = apiManager.requestErrata(query: query)
		correctWords.accept(words)
	}
	
	// ApiManager의 Kakao 도서검색 API 요청
	func requestKakaoBookInfo(query: String, page: Int) {
		apiManager.requestKakaoBookInfo(query: query, page: page).subscribe(onNext: { [weak self] (books, total, isEnd) in
			guard let self = self else { return }
			self.kakaoBooks.accept(books)
			self.kakaoTotal.accept(total)
			self.kakaoIsEnd.accept(isEnd)
		}).disposed(by: disposeBag)
	}
}
