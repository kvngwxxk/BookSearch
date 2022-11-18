//
//  ViewController.swift
//  BookSearch
//
//  Created by Kangwook Lee on 2022/11/18.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
	let disposeBag = DisposeBag()
	let viewModel = MainViewModel()
	var isChecked = false
	let searchBar: UITextField = {
		let textField = UITextField()
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.backgroundColor = .systemGray5
		textField.layer.cornerRadius = 5
		textField.addLeftPadding()
		return textField
	}()
	
	let searchButton: UIButton = {
		let btn = UIButton(type: .system)
		btn.translatesAutoresizingMaskIntoConstraints = false
		btn.setTitle("검색", for: .normal)
		return btn
	}()
	
	let checkAdult: UIButton = {
		let checkBox = UIButton()
		checkBox.translatesAutoresizingMaskIntoConstraints = false
		checkBox.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
		return checkBox
	}()
	
	let adultLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Adult"
		label.font = label.font.withSize(12)
		
		return label
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		self.view.backgroundColor = .white
		setAutoLayout()
		setBinding()
	}
	
	private func setAutoLayout() {
		self.view.addSubview(searchBar)
		self.view.addSubview(searchButton)
		self.view.addSubview(checkAdult)
		self.view.addSubview(adultLabel)
		
		searchBar.snp.makeConstraints { make in
			make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
			make.leading.equalTo(self.view).offset(20)
			make.width.equalTo((self.view.frame.width / 20) * 11)
			make.height.equalTo(40)
		}
		searchButton.snp.makeConstraints { make in
			make.centerY.equalTo(searchBar)
			make.leading.equalTo(self.searchBar.snp.trailing).offset(10)
			make.width.equalTo(40)
			make.height.equalTo(40)
		}
		adultLabel.snp.makeConstraints { make in
			make.centerY.equalTo(searchButton)
			make.leading.equalTo(self.searchButton.snp.trailing).offset(20)
			make.width.equalTo(30)
			make.height.equalTo(17)
		}
		checkAdult.snp.makeConstraints { make in
			make.centerY.equalTo(self.adultLabel)
			make.leading.equalTo(self.adultLabel.snp.trailing).offset(5)
			make.width.equalTo(15)
			make.height.equalTo(17)
		}
	}
	
	private func setBinding() {
		self.checkAdult.rx.tap.bind { [weak self] _ in
			guard let self = self else { return }
			if self.isChecked {
				self.isChecked = false
				self.checkAdult.setBackgroundImage(UIImage(systemName: "square"), for: .normal)
				print(self.isChecked)
			} else {
				self.isChecked = true
				self.checkAdult.setBackgroundImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
				print(self.isChecked)
			}
			self.viewModel.isAdult.accept(self.isChecked)
		}.disposed(by: disposeBag)
	}

	
}


extension UITextField {
	func addLeftPadding() {
		let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
		self.leftView = paddingView
		self.leftViewMode = ViewMode.always
	}
}
