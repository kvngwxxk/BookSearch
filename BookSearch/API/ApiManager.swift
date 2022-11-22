//
//  ApiManager.swift
//  BookSearch
//
//  Created by Kangwook Lee on 2022/11/18.
//

import Foundation
import Alamofire
import RxSwift

class ApiManager {
	static let shared = ApiManager()
	// MARK: NAVER 책 검색 API Request
	func requestNaverBookInfo(query: String) -> Observable<[NaverBook]> {
		let infoDictionary: [String: Any] = Bundle.main.infoDictionary ?? [:]
		let NAVER_CLIENT_ID: String = infoDictionary["NaverClientId"] as! String
		let NAVER_CLIENT_SECRET: String = infoDictionary["NaverClientSecret"] as! String
		let display = 20
		let start = 1
		let url = "https://openapi.naver.com/v1/search/book.json"
		let parameters: Parameters = [
			"query": query,
			"display": display,
			"start": start
		]
		let headers: HTTPHeaders = [
			"X-Naver-Client-Id": NAVER_CLIENT_ID,
			"X-Naver-Client-Secret": NAVER_CLIENT_SECRET
		]
		return Observable<[NaverBook]>.create { observer in
			
			let request = AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
				.responseData { response in
					var books = [NaverBook]()
					switch response.result {
					case .success(_):
						if let data = response.value {
							do {
								print(query)
								print(String(data: data, encoding: .utf8))
								let json = try JSONDecoder().decode(NaverResponse.self, from: data)
								print(json.items)
								if json.items.isEmpty {
									books = []
								} else {
									for i in 0..<json.items.count {
										books.append(json.items[i])
									}
								}
							} catch {
								print(error)
							}
						}
						
						observer.onNext(books)
					case .failure(let error):
						observer.onError(error)
					}
					observer.onCompleted()
				}
			return Disposables.create {
				request.cancel()
			}
		}
	}
	
	// MARK: NAVER 성인 검색어 판별 API Request
	func requestAdult(query: String) -> [Bool] {
		let infoDictionary: [String: Any] = Bundle.main.infoDictionary ?? [:]
		let NAVER_CLIENT_ID: String = infoDictionary["NaverClientId"] as! String
		let NAVER_CLIENT_SECRET: String = infoDictionary["NaverClientSecret"] as! String
		let url = "https://openapi.naver.com/v1/search/adult.json"
		let separatedText = query.components(separatedBy: " ")
		let headers: HTTPHeaders = [
			"X-Naver-Client-Id": NAVER_CLIENT_ID,
			"X-Naver-Client-Secret": NAVER_CLIENT_SECRET
		]
		var bool = [Bool]()
		for index in 0..<separatedText.count {
			let runLoop = CFRunLoopGetCurrent()
			AF.request(url, method: .get, parameters: ["query": separatedText[index]], encoding: URLEncoding.queryString, headers: headers).responseData { response in
				do {
					if let data = response.value {
						let json = try JSONDecoder().decode(Adult.self, from: data)
						if json.adult == "0" {
							bool.append(false)
						} else {
							bool.append(true)
						}
					}
					print(bool)
					CFRunLoopStop(runLoop)
				} catch {
					print(error)
				}
			}
			CFRunLoopRun()
		}
		return bool
	}
	
	// MARK: NAVER 오타 변환 API Request
	func requestErrata(query: String) -> [String] {
		let infoDictionary: [String: Any] = Bundle.main.infoDictionary ?? [:]
		let NAVER_CLIENT_ID: String = infoDictionary["NaverClientId"] as! String
		let NAVER_CLIENT_SECRET: String = infoDictionary["NaverClientSecret"] as! String
		let url = "https://openapi.naver.com/v1/search/errata.json"
		let separatedText = query.components(separatedBy: " ")
		let headers: HTTPHeaders = [
			"X-Naver-Client-Id": NAVER_CLIENT_ID,
			"X-Naver-Client-Secret": NAVER_CLIENT_SECRET
		]
		var strings = [String]()
		for index in 0..<separatedText.count {
			let runLoop = CFRunLoopGetCurrent()
			AF.request(url, method: .get, parameters: ["query": separatedText[index]], encoding: URLEncoding.queryString, headers: headers).responseData { response in
				do {
					if let data = response.value {
						let json = try JSONDecoder().decode(Errata.self, from: data)
						strings.append(json.errata)
					}
					print(strings)
					CFRunLoopStop(runLoop)
				} catch {
					print(error)
				}
			}
			CFRunLoopRun()
		}
		return strings
	}
	
	// MARK: KAKAO 책 검색 API Request
	func requestKakaoBookInfo(query: String) -> Observable<[KakaoBook]> {
		let infoDictionary: [String: Any] = Bundle.main.infoDictionary ?? [:]
		let KAKAO_API_KEY: String = infoDictionary["KakaoApiKey"] as! String
		let size = 20
		let page = 1
		let url = "https://dapi.kakao.com/v3/search/book"
		let parameters: Parameters = [
			"query": query,
			"size": size,
			"page": page
		]
		let headers: HTTPHeaders = [
			"Authorization": "KakaoAK \(KAKAO_API_KEY)"
		]
		return Observable<[KakaoBook]>.create { observer in
			
			let request = AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
				.responseData { response in
					var books = [KakaoBook]()
					switch response.result {
					case .success(_):
						if let data = response.value {
							do {
								let json = try JSONDecoder().decode(KakaoResponse.self, from: data)
								print(json.documents)
								if json.documents.isEmpty {
									books = []
								} else {
									for i in 0..<json.documents.count {
										books.append(json.documents[i])
									}
								}
							} catch {
								print(error)
							}
						}
						
						print(books)
						observer.onNext(books)
					case .failure(let error):
						observer.onError(error)
					}
					observer.onCompleted()
				}
			return Disposables.create {
				request.cancel()
			}
		}
	}
}
