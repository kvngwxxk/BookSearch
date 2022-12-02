//
//  DetailViewController.swift
//  BookSearch
//
//  Created by Kangwook Lee on 2022/11/18.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
class DetailViewController: UIViewController {
	let book: Book
	let viewModel: DetailViewModel
	let disposeBag = DisposeBag()
	var bottomKeyData: [String] = []
	var bottomValueData: [String] = []
	let closeButton: UIButton = {
		let btn = UIButton(type: .close)
		btn.translatesAutoresizingMaskIntoConstraints = false
		return btn
	}()
	let thumbnail: UIButton = {
		let btn = UIButton()
		return btn
	}()
	let titleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		label.lineBreakMode = .byTruncatingTail
		label.font = UIFont.boldSystemFont(ofSize: 15)
		return label
	}()
	let authorLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		label.lineBreakMode = .byTruncatingTail
		label.font = UIFont.systemFont(ofSize: 12)
		return label
	}()
	let publisherLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		label.lineBreakMode = .byTruncatingTail
		label.font = UIFont.systemFont(ofSize: 12)
		return label
	}()
	
	
	var tableView = UITableView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white
		tableView.delegate = self
		tableView.dataSource = self
		tableView.registerCell(cellType: DetailViewCell.self, reuseIdentifier: "DetailViewCell")
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 200
		closeButton.addTarget(self, action: #selector(closeView), for: .touchUpInside)
		setData()
		setAutoLayout()
		setBinding()
	}
	
	init(viewModel: DetailViewModel, book: Book) {
		self.book = book
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setData() {
		viewModel.setData(book: book)
		
	}
	private func setThumbnail(dic: Dictionary<String, String>) {
		DispatchQueue.main.async {
			if let imgUrl = dic["image"] {
				if let url = URL(string: imgUrl) {
					self.thumbnail.rx.tap.bind {
						if UIApplication.shared.canOpenURL(url) {
							UIApplication.shared.open(url, options: [:], completionHandler: nil)
						}
					}.disposed(by: self.disposeBag)
					let data = try? Data(contentsOf: url)
					if let data = data {
						self.thumbnail.setImage(UIImage(data: data), for: .normal)
					} else {
						print("data is nil")
					}
				}
			} else {
				print("img url is nil")
			}
			self.thumbnail.layer.borderColor = UIColor.black.cgColor
			self.thumbnail.layer.borderWidth = 0.5
		}
	}
	private func setLabels(dic: Dictionary<String, String>) {
		let title = dic["title"]
		let author = dic["authors"]!
		let publisher = dic["publisher"]!
		
		DispatchQueue.main.async {
			self.titleLabel.text = title
			self.authorLabel.text = "저자 : \(author)"
			self.publisherLabel.text = "출판사 : \(publisher)"
		}
	}
	private func setAutoLayout() {
		self.view.addSubview(tableView)
		self.view.addSubview(thumbnail)
		self.view.addSubview(closeButton)
		self.view.addSubview(titleLabel)
		self.view.addSubview(authorLabel)
		self.view.addSubview(publisherLabel)
		thumbnail.translatesAutoresizingMaskIntoConstraints = false
		
		tableView.snp.makeConstraints { make in
			make.top.equalTo(self.view.snp.centerY).offset(-80)
			make.bottom.equalTo(self.view)
			make.leading.equalTo(self.view)
			make.trailing.equalTo(self.view)
		}
		
		thumbnail.snp.makeConstraints { make in
			make.top.equalTo(closeButton.snp.bottom).offset(20)
			make.bottom.equalTo(tableView.snp.top)
			make.leading.equalTo(self.view).offset(20)
			make.width.equalTo(self.view.frame.width * 2 / 5)
		}
		closeButton.snp.makeConstraints { make in
			make.top.equalTo(self.view).offset(20)
			make.trailing.equalTo(self.view).offset(-20)
			make.width.equalTo(20)
			make.height.equalTo(20)
		}
		titleLabel.snp.makeConstraints { make in
			make.top.equalTo(closeButton.snp.bottom).offset(15)
			make.bottom.equalTo(authorLabel.snp.top).offset(-20)
			make.leading.equalTo(thumbnail.snp.trailing).offset(20)
			make.trailing.equalTo(self.view).offset(-20)
			make.height.lessThanOrEqualTo(120)
		}
		
		authorLabel.snp.makeConstraints { make in
			make.top.equalTo(titleLabel.snp.bottom).offset(30)
			make.bottom.equalTo(publisherLabel.snp.top).offset(-20)
			make.leading.equalTo(thumbnail.snp.trailing).offset(20)
			make.trailing.equalTo(self.view).offset(-20)
			make.height.lessThanOrEqualTo(60)
		}
		
		publisherLabel.snp.makeConstraints { make in
			make.top.equalTo(authorLabel.snp.bottom).offset(30)
			make.height.equalTo(30)
			make.bottom.equalTo(thumbnail).offset(-30)
			make.leading.equalTo(thumbnail.snp.trailing).offset(20)
			make.trailing.equalTo(self.view).offset(-20)
			make.height.lessThanOrEqualTo(60)
			
		}
	}
	
	private func setBinding() {
		viewModel.topData.bind { [weak self] dic in
			guard let self = self else { return }
			DispatchQueue.main.async {
				self.setThumbnail(dic: dic)
				self.setLabels(dic: dic)
			}
		}.disposed(by: disposeBag)
		
		viewModel.bottomKeyData.bind { [weak self] arr in
			guard let self = self else { return }
			DispatchQueue.main.async {
				self.bottomKeyData = arr
				self.tableView.reloadData()
			}
		}.disposed(by: disposeBag)
		
		viewModel.bottomValueData.bind { [weak self] arr in
			guard let self = self else { return }
			DispatchQueue.main.async {
				self.bottomValueData = arr
				self.tableView.reloadData()
			}
		}.disposed(by: disposeBag)
	}
	// Button Event
	@objc func closeView() {
		self.presentingViewController?.dismiss(animated: true, completion: nil)
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
		cell.selectionStyle = .none
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
		
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let lastIndex = self.bottomKeyData.count - 1
		if indexPath.row == lastIndex {
			let url = URL(string: bottomValueData[lastIndex])
			if let url = url {
				if UIApplication.shared.canOpenURL(url) {
					UIApplication.shared.open(url, options: [:], completionHandler: nil)
				}
			}
			
		}
	}
}
