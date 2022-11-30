//
//  DetailViewModel.swift
//  BookSearch
//
//  Created by Kangwook Lee on 2022/11/18.
//

import Foundation
import RxSwift
import RxCocoa

class DetailViewModel {
	var topData: BehaviorRelay<[String:String]> = .init(value: [:])
	var bottomKeyData: BehaviorRelay<[String]> = .init(value: [])
	var bottomValueData: BehaviorRelay<[String]> = .init(value: [])
	
	
	private var topDataDic = [String:String]()
	private var bottomKeyDataArr = [String]()
	private var bottomValueDataArr = [String]()
	
	func setData(book: Book) {
		
		
		let image = book.image
		let title = book.title
		let authors = book.authors.joined(separator: ", ")
		let publisher = book.publisher
		topDataDic.updateValue(image, forKey: "image")
		topDataDic.updateValue(title, forKey: "title")
		topDataDic.updateValue(authors, forKey: "authors")
		topDataDic.updateValue(publisher, forKey: "publisher")
		
		topData.accept(topDataDic)
		
		// 하단 항목
		bottomKeyDataArr.append("description")
		bottomKeyDataArr.append("publishDate")
		bottomKeyDataArr.append("isbn")
		bottomKeyDataArr.append("price")
		bottomKeyDataArr.append("sale_price")
		bottomKeyDataArr.append("status")
		bottomKeyDataArr.append("translators")
		bottomKeyDataArr.append("url")
		
		bottomKeyData.accept(bottomKeyDataArr)
		
		let description = book.description
		let dateTime = book.publishDate
		let isbn = book.isbn
		let price = String(book.price)
		let salePrice = String(book.salePrice)
		let status = book.status
		let translators = book.translators.joined(separator: ", ")
		let url = book.url
		bottomValueDataArr.append(description)
		bottomValueDataArr.append(dateTime)
		bottomValueDataArr.append(isbn)
		bottomValueDataArr.append(price)
		bottomValueDataArr.append(salePrice)
		bottomValueDataArr.append(status)
		bottomValueDataArr.append(translators)
		bottomValueDataArr.append(url)
		
		bottomValueData.accept(bottomValueDataArr)
	}
	
	func setThumbnail(book: Book) {
		
	}
}
