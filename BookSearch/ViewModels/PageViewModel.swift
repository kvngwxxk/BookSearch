//
//  PageViewModel.swift
//  BookSearch
//
//  Created by Kangwook Lee on 2022/11/21.
//

import Foundation
import RxRelay

class PageViewModel {
	var currentTable: BehaviorRelay<String> = .init(value: "naver")
}
