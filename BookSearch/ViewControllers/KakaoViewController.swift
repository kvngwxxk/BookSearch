//
//  KakaoViewController.swift
//  BookSearch
//
//  Created by Kangwook Lee on 2022/11/21.
//

import Foundation
import UIKit
import RxSwift

class KakaoViewController: UIViewController {
	let viewModel: KakaoViewModel
	let table = UITableView()
	let disposeBag = DisposeBag()
	var bookList = [KakaoBook]()
	override func viewDidLoad() {
		super.viewDidLoad()
		self.table.backgroundColor = .systemGray5
		table.dataSource = self
		table.delegate = self
		table.registerCell(cellType: PageViewCell.self, reuseIdentifier: "PageViewCell")
		setAutoLayout()
		setBinding()
	}
	
	init(viewModel: KakaoViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setAutoLayout() {
		self.view.addSubview(table)
		table.snp.makeConstraints { make in
			make.width.equalTo(self.view)
			make.height.equalTo(self.view)
		}
	}
	
	private func setBinding() {
		viewModel.kakaoTable.bind { [weak self] books in
			guard let self = self else { return }
			self.bookList = books
			self.table.reloadData()
		}.disposed(by: disposeBag)
	}
}

extension KakaoViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if bookList.count > 20 {
			return 20
		} else {
			return bookList.count
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: PageViewCell = tableView.dequeueCell(reuseIdentifier: "PageViewCell", indexPath: indexPath)
		if bookList.isEmpty {
			return cell
		} else {
			let title = bookList[indexPath.row].title
			let author = bookList[indexPath.row].authors.first ?? ""
			let pubDate = bookList[indexPath.row].dateTime
			cell.idLabel.text = String(indexPath.row+1)
			cell.contentLabel.text = "[\(title)]/[\(String(describing: author))] - [\(pubDate)]"
			return cell
		}
		
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print(indexPath.row)
	}
}
