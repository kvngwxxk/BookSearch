//
//  PageViewCell.swift
//  BookSearch
//
//  Created by Kangwook Lee on 2022/11/18.
//

import Foundation
import UIKit
import SnapKit

class PageViewCell: UITableViewCell {
	let idLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = label.font.withSize(13)
		return label
	}()
	let contentLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = label.font.withSize(14)
		return label
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setAutoLayout()
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setAutoLayout() {
		self.addSubview(idLabel)
		self.addSubview(contentLabel)
		
		idLabel.snp.makeConstraints { make in
			make.leading.equalTo(self).offset(10)
			make.centerY.equalTo(self)
			make.width.equalTo(self.frame.width/10)
			make.height.equalTo(30)
		}
		contentLabel.snp.makeConstraints { make in
			make.leading.equalTo(self.idLabel.snp.trailing).offset(10)
			make.centerY.equalTo(self)
			make.width.equalTo((self.frame.width/10) * 9 )
			make.height.equalTo(30)
		}
	}
}
