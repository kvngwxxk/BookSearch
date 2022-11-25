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
	func requestNaverBookInfo(query: String, page: Int) -> Observable<([NaverBook],Int)> {
		let infoDictionary: [String: Any] = Bundle.main.infoDictionary ?? [:]
		let NAVER_CLIENT_ID: String = infoDictionary["NaverClientId"] as! String
		let NAVER_CLIENT_SECRET: String = infoDictionary["NaverClientSecret"] as! String
		let display = 20
		let start = page
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
		return Observable<([NaverBook],Int)>.create { observer  in
			
			let request = AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
				.responseData { response in
					var books = [NaverBook]()
					var total = 0
					switch response.result {
					case .success(_):
						if let data = response.value {
							do {
								let json = try JSONDecoder().decode(NaverResponse.self, from: data)
								total = json.total
								
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
						
						observer.onNext((books, total))
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
	// 성인 검색어 판별 API는 띄어쓰기 기준으로 단어별로 나눈 다음 하나씩 판별
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
	// 오타확인 API의 경우 성인 검색어와 마찬가지로 띄어쓰기 기준으로 단어별로 나눈 다음 하나씩 판별
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
						if !json.errata.isEmpty {
							strings.append(json.errata)
						} else {
							strings.append(separatedText[index])
						}
						
					}
//					print(strings)
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
	func requestKakaoBookInfo(query: String, page: Int) -> Observable<([KakaoBook], Int, Bool)> {
		let infoDictionary: [String: Any] = Bundle.main.infoDictionary ?? [:]
		let KAKAO_API_KEY: String = infoDictionary["KakaoApiKey"] as! String
		let size = 20
		let page = page
		let url = "https://dapi.kakao.com/v3/search/book"
		let parameters: Parameters = [
			"query": query,
			"size": size,
			"page": page
		]
		let headers: HTTPHeaders = [
			"Authorization": "KakaoAK \(KAKAO_API_KEY)"
		]
		return Observable<([KakaoBook], Int, Bool)>.create { observer in
			
			let request = AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
				.responseData { response in
					var books = [KakaoBook]()
					var total = 0
					var isEnd = false
					switch response.result {
					case .success(_):
						if let data = response.value {
							do {
								let json = try JSONDecoder().decode(KakaoResponse.self, from: data)
//								print(json.documents)
								total = json.meta.pageable_count
								isEnd = json.meta.is_end
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
						observer.onNext((books, total, isEnd))
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
