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
	var activityIndicator: LoadMoreActivityIndicator!
	override func viewDidLoad() {
		super.viewDidLoad()
		self.table.backgroundColor = .systemGray5
		table.dataSource = self
		table.delegate = self
		table.registerCell(cellType: PageViewCell.self, reuseIdentifier: "PageViewCell")
		setAutoLayout()
		setBinding()
		activityIndicator = LoadMoreActivityIndicator(scrollView: table, spacingFromLastCell: 10, spacingFromLastCellWhenLoadMoreActionStart: 30)
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
		viewModel.naverTable.bind { [weak self] books in
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

extension NaverViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if bookList.count >= 20 {
			var index = 1
			var total = viewModel.total.value
			viewModel.page.accept(bookList.count/20 + 1)
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
			let author = bookList[indexPath.row].author
			let pubDate = bookList[indexPath.row].pubDate
			cell.idLabel.text = String(indexPath.row+1)
			cell.contentLabel.text = "[\(title)]/[\(author)] - [\(pubDate)]"
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.present(DetailViewController(naverBook: bookList[indexPath.row]), animated: true, completion: nil)
		print(indexPath.row)
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		activityIndicator.start {
			DispatchQueue.global(qos: .utility).async {
				sleep(1)
				DispatchQueue.main.async {
//					let main = self.parent?.parent as! MainViewController
//					self.viewModel.page.bind { page in
//						print(page+1)
//						main.viewModel.requestNaverBookInfo(query: main.correctText.isEmpty ? main.searchBar.text ?? "" : main.correctText, page: page+1)
						print("invoke")
//					}.disposed(by: self.disposeBag)
					self.activityIndicator.stop()
				}
			}
		}
	}
	
}
