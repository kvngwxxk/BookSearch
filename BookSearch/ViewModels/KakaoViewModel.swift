//
//  KakaoViewModel.swift
//  BookSearch
//
//  Created by Kangwook Lee on 2022/11/21.
//

import Foundation
import RxSwift
import RxCocoa

class KakaoViewModel {
	let apiManager = ApiManager.shared
	var kakaoTable: BehaviorRelay<[KakaoBook]> = .init(value: [])
	var page: BehaviorRelay<Int> = .init(value: 1)
	var total: BehaviorRelay<Int> = .init(value: 0)
	var isEnd: BehaviorRelay<Bool> = .init(value: false)
	var searchText: BehaviorRelay<String> = .init(value: "")
	let disposeBag = DisposeBag()
	
	func requestKakaoBookInfo(query: String, page: Int) {
		apiManager.requestKakaoBookInfo(query: query, page: page).subscribe(onNext: { [weak self] (books, total, isEnd) in
			guard let self = self else { return }
			self.kakaoTable.accept(books)
			self.total.accept(total)
			self.isEnd.accept(isEnd)
		}).disposed(by: disposeBag)
	}
}
