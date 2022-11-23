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
			if books.isEmpty {
				self.bookList = books
			} else {
				self.bookList += books
			}
			
			self.table.reloadData()
		}.disposed(by: disposeBag)
	}
}

extension KakaoViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if bookList.count >= 20 {
			viewModel.page.accept(bookList.count/20 + 1)
			return bookList.count
		} else {
			return bookList.count
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: PageViewCell = tableView.dequeueCell(reuseIdentifier: "PageViewCell", indexPath: indexPath)
		var convertedDate = ""
		if bookList.isEmpty {
			return cell
		} else {
			if bookList[indexPath.row].dateTime == "" {
				convertedDate = "출판 년도 미상"
			} else {
				var date = bookList[indexPath.row].dateTime.replacingOccurrences(of: "-", with: "")
				date = String(Array(date)[0...7])
				let year = String(Array(date)[0...3])
				let month = String(Array(date)[4...5])
				let day = String(Array(date)[6...7])
				convertedDate = "\(year)년 \(month)월 \(day)일"
			}
			
			let title = bookList[indexPath.row].title
			let author = bookList[indexPath.row].authors.first ?? "작자 미상"
			let pubDate = convertedDate
			cell.idLabel.text = String(indexPath.row+1)
			cell.titleLabel.text = title
			cell.contentLabel.text = "[\(author)] - [\(pubDate)]"
			return cell
		}
		
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.present(DetailViewController(kakaoBook: bookList[indexPath.row]), animated: true, completion: nil)
		print(indexPath.row)
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let lastIndex = self.bookList.count - 1
		if indexPath.row == lastIndex {
			let page = viewModel.page.value
			let isEnd = viewModel.isEnd.value
			let total = viewModel.total.value
			if isEnd && total == bookList.count {
				print("끝")
			} else {
				let main = self.parent?.parent as! MainViewController
				print("페이지 : \(self.viewModel.page.value)")
				main.viewModel.requestKakaoBookInfo(query: main.correctText.isEmpty ? main.searchBar.text ?? "" : main.correctText, page: page)
			}
			
		}
	}
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 40
	}
}
