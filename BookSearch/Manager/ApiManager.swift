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
					switch response.response?.statusCode {
					case 200:
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
					case 400:
						print(response.error?.errorDescription ?? "")
					case 404:
						print(response.error?.errorDescription ?? "")
					case 500:
						print(response.error?.errorDescription ?? "")
					default:
						print(response.response?.statusCode ?? 999)
					}
					
					observer.onCompleted()
				}
			return Disposables.create {
				request.cancel()
			}
		}
	}
	
	func requestNaverBookInfo(query: String) -> ([NaverBook], Int) {
		let infoDictionary: [String: Any] = Bundle.main.infoDictionary ?? [:]
		let NAVER_CLIENT_ID: String = infoDictionary["NaverClientId"] as! String
		let NAVER_CLIENT_SECRET: String = infoDictionary["NaverClientSecret"] as! String
		let display = 100
		var start = 1
		let url = "https://openapi.naver.com/v1/search/book.json"
		
		let headers: HTTPHeaders = [
			"X-Naver-Client-Id": NAVER_CLIENT_ID,
			"X-Naver-Client-Secret": NAVER_CLIENT_SECRET
		]
		var books = [NaverBook]()
		var total = 0
		while true {
			if start > 1000 {
				break
			}
			
			let parameters: Parameters = [
				"query": query,
				"display": display,
				"start": start
			]
			let runLoop = CFRunLoopGetCurrent()
			AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
				.responseData { response in
					switch response.response?.statusCode {
					case 200:
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
									CFRunLoopStop(runLoop)
								} catch {
									print(error)
								}
							}
							
						case .failure(let error):
							print(error)
						}
					case 400:
						print(response.error?.errorDescription ?? "")
					case 404:
						print(response.error?.errorDescription ?? "")
					case 500:
						print(response.error?.errorDescription ?? "")
					default:
						print(response.response?.statusCode ?? 999)
					}
				}
			CFRunLoopRun()
			start += 100
			if start > total {
				break
			}
			if start > 1000 {
				start -= 1
			}
		}
		return (books, total)
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
				switch response.response?.statusCode {
				case 200:
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
				case 400:
					print(response.error ?? "")
				case 401:
					print(String(data: response.value!, encoding: .utf8)!)
				case 404:
					print(response.error?.errorDescription ?? "")
				case 500:
					print(response.error?.errorDescription ?? "")
				default:
					print(response.response?.statusCode ?? 999)
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
	
	func requestKakaoBookInfo(query: String) -> ([KakaoBook], Int) {
		let infoDictionary: [String: Any] = Bundle.main.infoDictionary ?? [:]
		let KAKAO_API_KEY: String = infoDictionary["KakaoApiKey"] as! String
		let size = 50
		var page = 1
		let url = "https://dapi.kakao.com/v3/search/book"
		
		let headers: HTTPHeaders = [
			"Authorization": "KakaoAK \(KAKAO_API_KEY)"
		]
		var books = [KakaoBook]()
		var total = 0
		var isEnd = false
		while !isEnd {
			let runLoop = CFRunLoopGetCurrent()
			let parameters: Parameters = [
				"query": query,
				"size": size,
				"page": page
			]
			AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
				.responseData { response in
					switch response.response?.statusCode {
					case 200:
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
									CFRunLoopStop(runLoop)
								} catch {
									print(error)
								}
							}
						case .failure(let error):
							print(error)
						}
					case 400:
						print(response.error?.errorDescription ?? "")
					case 404:
						print(response.error?.errorDescription ?? "")
					case 500:
						print(response.error?.errorDescription ?? "")
					default:
						print(response.response?.statusCode ?? 999)
					}
				}
			CFRunLoopRun()
			page += 1
			if page > 50 {
				break
			}
		}
		return (books, total)
	}
}
