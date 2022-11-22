//
//  DetailViewController.swift
//  BookSearch
//
//  Created by Kangwook Lee on 2022/11/18.
//

import Foundation
import UIKit
import SnapKit

class DetailViewController: UIViewController {
	let naverBook: NaverBook?
	let kakaoBook: KakaoBook?
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white
	}
	
	init(naverBook: NaverBook? = nil, kakaoBook: KakaoBook? = nil) {
		self.naverBook = naverBook
		self.kakaoBook = kakaoBook
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
