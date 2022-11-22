//
//  NaverViewModel.swift
//  BookSearch
//
//  Created by Kangwook Lee on 2022/11/21.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class NaverViewModel {
	var naverTable: BehaviorRelay<[NaverBook]> = .init(value: [])
	var detail: PublishRelay<NaverBook> = PublishRelay()
	var page: BehaviorRelay<Int> = .init(value: 1)
	var total: BehaviorRelay<Int> = .init(value: 0)
	
}
