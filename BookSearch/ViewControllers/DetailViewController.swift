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
	
	let viewModel: DetailViewModel
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white
	}
	
	init(book: Book) {
		viewModel = DetailViewModel(book: book)
		super.init(nibName: nil, bundle: nil)
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
