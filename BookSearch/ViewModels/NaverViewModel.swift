//
//  NaverViewModel.swift
//  BookSearch
//
//  Created by Kangwook Lee on 2022/11/21.
//

import Foundation
import RxSwift
import RxCocoa

class NaverViewModel {
	var naverTable: BehaviorRelay<[NaverBook]> = .init(value: [])
	var detail: PublishRelay<NaverBook> = PublishRelay()
}
