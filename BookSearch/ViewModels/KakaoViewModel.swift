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
	var kakaoTable: BehaviorRelay<[KakaoBook]> = .init(value: [])
}
