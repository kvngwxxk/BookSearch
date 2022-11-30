//
//  DetailViewCell.swift
//  BookSearch
//
//  Created by Kangwook Lee on 2022/11/23.
//

import Foundation
import UIKit
import SnapKit

class DetailViewCell: UITableViewCell {
	let keyLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = UIFont.boldSystemFont(ofSize: 14)
		return label
	}()
	let valueLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = label.font.withSize(14)
		label.numberOfLines = 0
		label.lineBreakMode = .byTruncatingTail
		return label
	}()
	
	let containerView: UIView = {
		let view = UIView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.backgroundColor = .white
		return view
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setAutoLayout()
	}
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setAutoLayout() {
		contentView.addSubview(containerView)
		
		containerView.addSubview(keyLabel)
		containerView.addSubview(valueLabel)
		
		containerView.snp.makeConstraints { make in
			make.top.equalTo(contentView).offset(15)
			make.leading.equalTo(contentView)
			make.trailing.equalTo(contentView)
			make.bottom.equalTo(contentView).offset(-15)
		}
		keyLabel.snp.makeConstraints { make in
			make.leading.equalTo(containerView).offset(10)
			make.width.equalTo(100)
			make.top.equalTo(containerView)
			make.bottom.equalTo(containerView)
		}
		valueLabel.snp.makeConstraints { make in
			make.trailing.equalTo(containerView).offset(-10)
			make.leading.equalTo(keyLabel.snp.trailing)
			make.top.equalTo(containerView)
			make.bottom.equalTo(containerView)
		}
	}
}
