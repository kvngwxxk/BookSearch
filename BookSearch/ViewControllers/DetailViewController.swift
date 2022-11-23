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
	var thumbnail = UIImageView()
	var topData = [String: String]()
	var bottomKeyData = [String]()
	var bottomValueData = [String]()
	var tableView = UITableView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white
		tableView.delegate = self
		tableView.dataSource = self
		tableView.registerCell(cellType: DetailViewCell.self, reuseIdentifier: "DetailViewCell")
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 200
		setData()
		setAutoLayout()
		setThumbnail()
	}
	
	init(naverBook: NaverBook? = nil, kakaoBook: KakaoBook? = nil) {
		self.naverBook = naverBook
		self.kakaoBook = kakaoBook
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setData() {
		if let kakaoBook = kakaoBook {
			// MARK: Kakao Book Data
			// 상단 항목
			let thumbnail = kakaoBook.thumbnail.isEmpty ? "" : kakaoBook.thumbnail
			let title = kakaoBook.title.isEmpty ? "제목 없음" : kakaoBook.title
			let authors: String = {
				if kakaoBook.authors.count == 0 {
					return "작자 미상"
				} else {
					let author = kakaoBook.authors.count == 1 ? kakaoBook.authors[0] : kakaoBook.authors.joined(separator: ", ")
					return author
				}
			}()
			let publisher = kakaoBook.publisher.isEmpty ? "출판사 없음" : kakaoBook.publisher
			topData.updateValue(thumbnail, forKey: "thumbnail")
			topData.updateValue(title, forKey: "title")
			topData.updateValue(authors, forKey: "authors")
			topData.updateValue(publisher, forKey: "publisher")
			
			
			// 하단 항목
			bottomKeyData.append("contents")
			bottomKeyData.append("datetime")
			bottomKeyData.append("isbn")
			bottomKeyData.append("price")
			bottomKeyData.append("sale_price")
			bottomKeyData.append("status")
			bottomKeyData.append("translators")
			bottomKeyData.append("url")
			
			let contents = kakaoBook.contents.isEmpty ? "소개 없음" : kakaoBook.contents
			let dateTime = kakaoBook.dateTime.isEmpty ? "출판 년도 미상" : kakaoBook.dateTime
			let isbn = kakaoBook.isbn.isEmpty ? "isbn 없음" : kakaoBook.isbn
			let price = kakaoBook.price == 0 ? "절판으로 인한 가격 미표기" : String(kakaoBook.price)
			let salePrice = kakaoBook.salePrice == 0 ? "절판으로 인한 가격 미표기" : String(kakaoBook.salePrice)
			let status = kakaoBook.status.isEmpty ? "상태 미상" : kakaoBook.status
			let translators: String = {
				if kakaoBook.translators.count == 0 {
					return "번역가 없음"
				} else {
					let translator = kakaoBook.translators.count == 1 ? kakaoBook.translators[0] : kakaoBook.translators.joined(separator: ", ")
					return translator
				}
			}()
			let url = kakaoBook.url.isEmpty ? "url 없음" : kakaoBook.url
			bottomValueData.append(contents)
			bottomValueData.append(dateTime)
			bottomValueData.append(isbn)
			bottomValueData.append(price)
			bottomValueData.append(salePrice)
			bottomValueData.append(status)
			bottomValueData.append(translators)
			bottomValueData.append(url)
			
			
		}  else if let naverBook = naverBook {
			// MARK: Naver Book Data
			
		}
	}
	private func setThumbnail() {
		let imgUrl = topData["thumbnail"]
		if let imgUrl = imgUrl {
			let url = URL(string: imgUrl)
			if let url = url {
				let data = try? Data(contentsOf: url)
				if let data = data {
					thumbnail.image = UIImage(data: data)
				} else {
					print("data is nil")
				}
			} else {
				print("URL is nil")
			}
		} else {
			print("img url is nil")
		}
	}
	private func setAutoLayout() {
		self.view.addSubview(tableView)
		self.view.addSubview(thumbnail)
		
		tableView.snp.makeConstraints { make in
			make.top.equalTo(self.view.snp.centerY).offset(-100)
			make.bottom.equalTo(self.view)
			make.leading.equalTo(self.view)
			make.trailing.equalTo(self.view)
		}
		thumbnail.snp.makeConstraints { make in
			make.top.equalTo(self.view).offset(20)
			make.bottom.equalTo(tableView.snp.top)
			make.leading.equalTo(self.view).offset(20)
			make.width.equalTo(self.view.frame.width * 2 / 5)
		}
		
	}
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return "Key - Value"
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return bottomKeyData.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: DetailViewCell = tableView.dequeueCell(reuseIdentifier: "DetailViewCell", indexPath: indexPath)
		cell.keyLabel.text = bottomKeyData[indexPath.row]
		cell.valueLabel.text = bottomValueData[indexPath.row]
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return 200
	}
	
}
