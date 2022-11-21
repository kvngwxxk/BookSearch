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
	let viewModel = KakaoViewModel()
	let table = UITableView()
	let disposeBag = DisposeBag()
	let bookList = [KakaoBook]()
	override func viewDidLoad() {
		super.viewDidLoad()
		self.table.backgroundColor = .systemGray5
		table.dataSource = self
		table.delegate = self
		table.registerCell(cellType: PageViewCell.self, reuseIdentifier: "PageViewCell")
		setAutoLayout()
	}
	
	private func setAutoLayout() {
		self.view.addSubview(table)
		table.snp.makeConstraints { make in
			make.width.equalTo(self.view)
			make.height.equalTo(self.view)
		}
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
			let author = bookList[indexPath.row].authors
			let pubDate = bookList[indexPath.row].dateTime
			cell.idLabel.text = String(indexPath.row+1)
			cell.contentLabel.text = "[\(title)]/[\(author)] - [\(pubDate)]"
			return cell
		}
		
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print(indexPath.row)
	}
}
