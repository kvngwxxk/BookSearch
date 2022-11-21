//
//  NaverViewController.swift
//  BookSearch
//
//  Created by Kangwook Lee on 2022/11/21.
//

import Foundation
import UIKit

class NaverViewController: UIViewController {
	let table = UITableView()
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

extension NaverViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 20
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let title = "naver title"
		let author = "naver author"
		let pubDate = "20220101"
		let cell: PageViewCell = tableView.dequeueCell(reuseIdentifier: "PageViewCell", indexPath: indexPath)
		cell.idLabel.text = String(indexPath.row+1)
		cell.contentLabel.text = "[\(title)]/[\(author)] - [\(pubDate)]"
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print(indexPath.row)
	}
}
