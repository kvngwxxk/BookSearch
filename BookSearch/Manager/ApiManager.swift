//
//  ApiManager.swift
//  BookSearch
//
//  Created by Kangwook Lee on 2022/11/18.
//

import Foundation
import Alamofire

class ApiManager {
	static let shared = ApiManager()
	
	func requestNaverBookInfo(query: String) {
		
		if let infoDictionary: [String: Any] = Bundle.main.infoDictionary {
			let NAVER_CLIENT_ID: String = infoDictionary["NaverClientId"] as! String
			let NAVER_CLIENT_SECRET: String = infoDictionary["NaverClientSecret"] as! String
			let display = 20
			let start = 1
			let parameters: Parameters = [
				"query": "",
				"display": display,
				"start": start
			]
			let headers: HTTPHeaders = [
				"X-Naver-Client-Id": NAVER_CLIENT_ID,
				"X-Naver-Client-Secret": NAVER_CLIENT_SECRET
			]
			let url = "https://openapi.naver.com/v1/search/book.json"
			
			AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: headers).responseDecodable(of: NaverBook.self) { response in
				switch response.result {
				case .success:
					print(response.value)
				case .failure(let error):
					print(error)
				}
				
			}
		}
		
	}
	
}
