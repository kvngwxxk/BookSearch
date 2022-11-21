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
	var naverBooks: BehaviorRelay<[NaverBook]> = .init(value: [])
	var kakaoBooks: PublishRelay<[KakaoBook]> = PublishRelay()
	let disposeBag = DisposeBag()
	let semaphore = DispatchSemaphore(value: 1)
	func requestNaverBookInfo(query: String) {
		apiManager.requestNaverBookInfo(query: query).subscribe(onNext: { [weak self] books in
			guard let self = self else { return }
			self.semaphore.signal()
			self.naverBooks.accept(books)
		}).disposed(by: disposeBag)
		
		self.semaphore.wait()
	}
	
	func requestKakaoBookInfo(query: String) {
		// TODO: Kakao REST API 호출
	}
}
