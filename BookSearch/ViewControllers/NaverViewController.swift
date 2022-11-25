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
	let viewModel: NaverViewModel
	let table = UITableView()
	let disposeBag = DisposeBag()
	var bookList = [NaverBook]()
	var searchText = ""
	override func viewDidLoad() {
		super.viewDidLoad()
		self.table.backgroundColor = .systemGray5
		table.dataSource = self
		table.delegate = self
		table.registerCell(cellType: PageViewCell.self, reuseIdentifier: "PageViewCell")
		setAutoLayout()
		setBinding()
	}
	
	init(viewModel: NaverViewModel) {
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
		viewModel.naverTable
			.bind { [weak self] books in
			guard let self = self else { return }
			if books.isEmpty {
				self.bookList = books
			} else {
				self.bookList += books
			}
			
			self.table.reloadData()
		}.disposed(by: disposeBag)
		
		viewModel.searchText
			.subscribe(onNext: { [weak self] text in
			guard let self = self else { return }
			self.searchText = text
		}).disposed(by: disposeBag)
	}
	
}

extension NaverViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if bookList.count >= 20 {
			viewModel.page.accept(bookList.count + 1)
			return bookList.count
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
			var author = bookList[indexPath.row].author
			var pubDate = bookList[indexPath.row].pubDate
			if bookList[indexPath.row].author == "" {
				author = "작자 미상"
			}
			if bookList[indexPath.row].pubDate == "" {
				pubDate = "출판 년도 미상"
			} else {
				let year = String(Array(bookList[indexPath.row].pubDate)[0...3])
				let month = String(Array(bookList[indexPath.row].pubDate)[4...5])
				let day = String(Array(bookList[indexPath.row].pubDate)[6...7])
				pubDate = "\(year)년 \(month)월 \(day)일"
			}
			cell.selectionStyle = .none
			cell.idLabel.text = String(indexPath.row+1)
			cell.titleLabel.text = title
			cell.contentLabel.text = "[\(author)] - [\(pubDate)]"
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.present(DetailViewController(naverBook: bookList[indexPath.row]), animated: true, completion: nil)
		print(indexPath.row)
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 40
	}
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let lastIndex = self.bookList.count - 1
		if indexPath.row == lastIndex {
			let page = viewModel.page.value
			let total = viewModel.total.value
			if total == bookList.count && viewModel.naverTable.value.count <= 20 {
				print("끝")
			} else {
				print("검색어 : \(searchText)")
				print("네이버 start : \(self.viewModel.page.value)")
				viewModel.requestNaverBookInfo(query: searchText, page: page)
			}
		}
	}
}
