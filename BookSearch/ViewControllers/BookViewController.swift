//
//  BookViewController.swift
//  BookSearch
//
//  Created by Kangwook Lee on 2022/11/28.
//

import UIKit
import SnapKit
import RxSwift

class BookViewController: UIViewController {
	let viewModel: BookViewModel!
	let table = UITableView()
	let disposeBag = DisposeBag()
	var bookList = [Book]()
	var searchText = ""
	var data = [Book]()
	
	var index = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setAutoLayout()
		setBinding()
		table.registerCell(cellType: PageViewCell.self, reuseIdentifier: "PageViewCell")
		table.dataSource = self
		table.delegate = self
		table.backgroundColor = .systemGray5
		// Do any additional setup after loading the view.
	}
	
	init(viewModel: BookViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setAutoLayout() {
		view.addSubview(table)
		table.snp.makeConstraints { make in
			make.width.equalTo(self.view.safeAreaLayoutGuide.snp.width)
			make.height.equalTo(self.view.safeAreaLayoutGuide.snp.height)
		}
	}
	
	private func setBinding() {
		viewModel.bookTable
			.bind { [weak self] books in
				guard let self = self else { return }
				if books.isEmpty {
					self.bookList = books
				} else {
					self.bookList += books
				}
				print("1. :\(books.map{$0.title}), count: \(books.count)")
				if !self.bookList.isEmpty{
					self.data.append(contentsOf: Array(self.bookList[0..<20]))
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

extension BookViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		return data.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: PageViewCell = tableView.dequeueCell(reuseIdentifier: "PageViewCell", indexPath: indexPath)
		var date = Date()
		var stringDate = ""
		if data.isEmpty {
			return cell
		} else {
			if data[indexPath.row].dataSource == "Kakao" {
				if data[indexPath.row].publishDate == "출판년도 미상" {
					stringDate = data[indexPath.row].publishDate
				} else {
					stringDate = data[indexPath.row].publishDate.components(separatedBy: "T").first!
					let dateFormatter: DateFormatter = {
						let formatter = DateFormatter()
						formatter.dateFormat = "yyyy-MM-dd"
						return formatter
					}()
					date = Utility.stringToDate(dateFormat: dateFormatter, string: stringDate)!
					stringDate = Utility.dateToString(date: date)
				}
			} else {
				if data[indexPath.row].publishDate == "출판년도 미상" {
					stringDate = data[indexPath.row].publishDate
				} else {
					stringDate = data[indexPath.row].publishDate
					let dateFormatter: DateFormatter = {
						let formatter = DateFormatter()
						formatter.dateFormat = "yyyyMMdd"
						return formatter
					}()
					date = Utility.stringToDate(dateFormat: dateFormatter, string: stringDate)!
					stringDate = Utility.dateToString(date: date)
				}
			}
			
			
			let title = data[indexPath.row].title
			var author = data[indexPath.row].authors.first ?? "작자 미상"
			if data[indexPath.row].authors.count > 1 {
				author = "\(String(describing: data[indexPath.row].authors.first!)) 외 \(data[indexPath.row].authors.count - 1)명"
			}
			cell.selectionStyle = .none
			cell.idLabel.text = String(data[indexPath.row].dataSource.first!)
			cell.titleLabel.text = title
			cell.contentLabel.text = "[\(String(describing: author))] - [\(stringDate)]"
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		//		self.present(DetailViewController(kakaoBook: bookList[indexPath.row]), animated: true, completion: nil)
		print(indexPath.row)
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let lastIndex = self.data.count - 1
		print(indexPath.row)
		if indexPath.row == lastIndex && bookList.count + 20 > index {
			data.append(contentsOf: Array(bookList[index..<index+20]))
			tableView.reloadData()
			index += 20
			if index + 20 > bookList.count {
				index = bookList.count - 20
			}
			print("검색어 : \(searchText)")
			print("카카오 page : \(self.viewModel.kakaoPage.value)")
			print("네이버 page : \(self.viewModel.naverPage.value)")
			
		}
	}
	
}
