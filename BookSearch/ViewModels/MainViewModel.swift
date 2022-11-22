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
	var kakaoBooks: PublishRelay<[KakaoBook]> = PublishRelay()
	let disposeBag = DisposeBag()
	func requestNaverBookInfo(query: String) {
		apiManager.requestNaverBookInfo(query: query).subscribe(onNext: { [weak self] books in
			guard let self = self else { return }
			self.naverBooks.accept(books)
		}).disposed(by: disposeBag)
	}
	
	func requestAdult(query: String) {
		let bool = apiManager.requestAdult(query: query)
		hasAdult.accept(bool)
	}
	
	func requestErrata(query: String) {
		let words = apiManager.requestErrata(query: query)
		correctWords.accept(words)
	}
	
	func requestKakaoBookInfo(query: String) {
		apiManager.requestKakaoBookInfo(query: query).subscribe(onNext: { [weak self] books in
			guard let self = self else { return }
			self.kakaoBooks.accept(books)
		}).disposed(by: disposeBag)
	}
}
