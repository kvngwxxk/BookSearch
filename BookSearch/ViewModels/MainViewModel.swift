//
//  MainViewModel.swift
//  BookSearch
//
//  Created by Kangwook Lee on 2022/11/18.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel {
	var isAdult: BehaviorRelay<Bool> = .init(value: false)
}
