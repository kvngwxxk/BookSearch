//
//  NaverViewController.swift
//  BookSearch
//
//  Created by Kangwook Lee on 2022/11/21.
//

import Foundation
import UIKit
import RxSwift

class NaverViewController: UIViewController {
	let viewModel = NaverViewModel()
	let table = UITableView()
	let disposeBag = DisposeBag()
	var bookList = [NaverBook]()
	override func viewDidLoad() {
		super.viewDidLoad()
		self.table.backgroundColor = .systemGray5
		table.dataSource = self
		table.delegate = self
		table.registerCell(cellType: PageViewCell.self, reuseIdentifier: "PageViewCell")
		setAutoLayout()
		setBinding()
	}
	
	private func setAutoLayout() {
		self.view.addSubview(table)
		table.snp.makeConstraints { make in
			make.width.equalTo(self.view)
			make.height.equalTo(self.view)
		}
	}
	
	private func setBinding() {
		viewModel.naverTable.bind { [weak self] books in
			guard let self = self else { return }
			self.bookList = books
			self.table.reloadData()
		}.disposed(by: disposeBag)
	}
}

extension NaverViewController: UITableViewDataSource, UITableViewDelegate {
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
			let author = bookList[indexPath.row].author
			let pubDate = bookList[indexPath.row].pubDate
			cell.idLabel.text = String(indexPath.row+1)
			cell.contentLabel.text = "[\(title)]/[\(author)] - [\(pubDate)]"
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print(indexPath.row)
	}
}
