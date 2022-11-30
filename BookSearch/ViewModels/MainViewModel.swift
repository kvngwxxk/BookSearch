//
//  MainViewModel.swift
//  BookSearch
//
//  Created by Kangwook Lee on 2022/11/18.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class MainViewModel {
	let apiManager = ApiManager.shared
	let userDefaultsManager = UserDefaultsManager.shared
	
	var isAdult: BehaviorRelay<Bool> = .init(value: false)
	var hasAdult: BehaviorRelay<[Bool]> = .init(value: [])
	var correctWords: BehaviorRelay<[String]> = .init(value: [])
	
	var searchTextList: BehaviorRelay<[String]> = .init(value: [])
	
	var books: BehaviorRelay<[Book]> = .init(value: [])
	
	var naverTotal: BehaviorRelay<Int> = .init(value: 0)
	var kakaoTotal: BehaviorRelay<Int> = .init(value: 0)
	var kakaoIsEnd: BehaviorRelay<Bool> = .init(value: false)
	let disposeBag = DisposeBag()
	
	func requestBookInfo(query: String) {
		var mashUpBooks: [Book] = []
		let (naverBooks, naverTotal) = apiManager.requestNaverBookInfo(query: query)
		let (kakaoBooks, kakaoTotal) = apiManager.requestKakaoBookInfo(query: query)
		for book in naverBooks {
			let newBook = convertBook(naverBook: book)
			mashUpBooks.append(newBook!)
		}
		for book in kakaoBooks {
			let newBook = convertBook(kakaoBook: book)
			mashUpBooks.append(newBook!)
		}
		let new = removeDuplicatedBooks(books: mashUpBooks)
		books.accept(new)
		self.naverTotal.accept(naverTotal)
		self.kakaoTotal.accept(kakaoTotal)
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
	
	func removeDuplicatedBooks(books: [Book]) -> [Book]  {
		var newBooks = [Book]()
		let isbnArr = books.map{ book -> String in
			var isbn = ""
			if book.isbn.contains(" ") {
				isbn = book.isbn.components(separatedBy: " ").last ?? ""
			} else {
				isbn = book.isbn
			}
			return isbn
		}
		
		let dup = Array(Set(isbnArr))
		
		for i in 0..<dup.count {
			for j in 0..<books.count {
				if books[j].isbn.contains(dup[i]) {
					newBooks.append(books[j])
					break
				}
			}
		}
		return newBooks
	}
	
	func initializeUserDefaultsManager() {
		let list = userDefaultsManager.initializeUserDefaultsManager()
		searchTextList.accept(list)
	}
	
	func saveSearchText(searchText: String) {
		let list = userDefaultsManager.saveSearchText(searchText: searchText)
		searchTextList.accept(list)
	}
	
	private func convertBook(naverBook: NaverBook? = nil, kakaoBook: KakaoBook? = nil) -> Book? {
		if let naverBook = naverBook {
			let title = naverBook.title.isEmpty ? "제목 없음" : naverBook.title
			let description = naverBook.description.isEmpty ? "소개 없음" : naverBook.description
			let url = naverBook.link.isEmpty ? "https://about:blank" : naverBook.link
			let isbn = naverBook.isbn.isEmpty ? "isbn 없음" : naverBook.isbn
			let publishDate = naverBook.pubDate.isEmpty ? "출판년도 미상" : naverBook.pubDate
			let authors = naverBook.author.isEmpty ? ["작자 미상"] : naverBook.author.components(separatedBy: "^")
			let publisher = naverBook.publisher.isEmpty ? "출판사 없음" : naverBook.publisher
			let salePrice = Int(naverBook.discount) ?? 0
			let image = naverBook.image.isEmpty ? "https://about:blank" : naverBook.image
			let translators = [String]()
			let price = salePrice
			let status = ""
			let dataSource = "Naver"
			
			return Book.init(title: title, description: description, url: url, isbn: isbn, publishDate: publishDate, authors: authors, publisher: publisher, salePrice: salePrice, image: image, translators: translators, price: price, status: status, dataSource: dataSource)
		}
		if let kakaoBook = kakaoBook {
			let title = kakaoBook.title.isEmpty ? "제목 없음" : kakaoBook.title
			let description = kakaoBook.contents.isEmpty ? "소개 없음" : kakaoBook.contents
			let url = kakaoBook.url.isEmpty ? "https://about:blank" : kakaoBook.url
			let isbn = kakaoBook.isbn.isEmpty ? "isbn 없음" : kakaoBook.isbn
			let publishDate = kakaoBook.dateTime.isEmpty ? "출판년도 미상" : kakaoBook.dateTime
			let authors = kakaoBook.authors.isEmpty ? ["작자 미상"] : kakaoBook.authors
			let publisher = kakaoBook.publisher.isEmpty ? "출판사 없음" : kakaoBook.publisher
			let salePrice = kakaoBook.salePrice
			let image = kakaoBook.thumbnail.isEmpty ? "https://about:blank" : kakaoBook.thumbnail
			let translators = kakaoBook.translators.isEmpty ? ["번역가 없음"] : kakaoBook.translators
			let price = kakaoBook.price
			let status = kakaoBook.status.isEmpty ? "상태 없음" : kakaoBook.status
			let dataSource = "Kakao"
			
			return Book.init(title: title, description: description, url: url, isbn: isbn, publishDate: publishDate, authors: authors, publisher: publisher, salePrice: salePrice, image: image, translators: translators, price: price, status: status, dataSource: dataSource)
		}
		
		return nil
	}
}
