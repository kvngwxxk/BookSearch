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
	var pageView = UIView()
	var pageViewController = PageViewController()
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
	let naverTab: UIButton = {
		let btn = UIButton()
		btn.translatesAutoresizingMaskIntoConstraints = false
		btn.setTitle("Naver", for: .normal)
		btn.layer.borderWidth = 0.3
		btn.layer.borderColor = UIColor.gray.cgColor
		btn.setTitleColor(.black, for: .normal)
		return btn
	}()
	let kakaoTab: UIButton = {
		let btn = UIButton()
		btn.translatesAutoresizingMaskIntoConstraints = false
		btn.setTitle("Kakao", for: .normal)
		btn.layer.borderWidth = 0.3
		btn.layer.borderColor = UIColor.gray.cgColor
		btn.setTitleColor(.black, for: .normal)
		return btn
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		self.navigationItem.title = "Book Search Demo"
		self.view.backgroundColor = .white
		setAutoLayout()
		setBinding()
	}
	
	private func setAutoLayout() {
		self.view.addSubview(searchBar)
		self.view.addSubview(searchButton)
		self.view.addSubview(checkAdult)
		self.view.addSubview(adultLabel)
		self.view.addSubview(pageView)
		self.view.addSubview(naverTab)
		self.view.addSubview(kakaoTab)
		
		addChild(pageViewController)
		pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
		self.pageView.addSubview(pageViewController.view)
		
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
		pageView.snp.makeConstraints { make in
			make.top.equalTo(self.searchBar.snp.bottom).offset(20)
			make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-10)
			make.leading.equalTo(self.view.safeAreaLayoutGuide).offset(20)
			make.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-20)
		}
		
		pageViewController.view.snp.makeConstraints { make in
			make.top.equalTo(self.naverTab.snp.bottom)
			make.bottom.equalTo(self.pageView)
			make.leading.equalTo(self.pageView)
			make.trailing.equalTo(self.pageView)
		}
		
		naverTab.snp.makeConstraints { make in
			make.top.equalTo(self.pageView.snp.top)
			make.bottom.equalTo(pageViewController.view.snp.top)
			make.leading.equalTo(self.pageView.snp.leading)
			make.width.equalTo(100)
		}
		kakaoTab.snp.makeConstraints { make in
			make.top.equalTo(self.pageView.snp.top)
			make.bottom.equalTo(pageViewController.view.snp.top)
			make.leading.equalTo(self.naverTab.snp.trailing)
			make.width.equalTo(100)
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
		
		self.searchButton.rx.tap.bind { [weak self] _ in
			guard let self = self else { return }
			self.viewModel.query.accept(self.searchBar.text ?? "")
			self.viewModel.requestNaverBookInfo(query: self.viewModel.query.value)
			print(self.viewModel.query.value)
		}.disposed(by: disposeBag)
		
		self.naverTab.rx.tap.bind { [weak self] _ in
			guard let self = self else { return }
			if self.pageViewController.viewModel.currentTable.value == "kakao" {
				self.pageViewController.goToPreviousPage()
			}
			self.pageViewController.viewModel.currentTable.accept("naver")
			
		}.disposed(by: disposeBag)
		
		self.kakaoTab.rx.tap.bind { [weak self] _ in
			guard let self = self else { return }
			if self.pageViewController.viewModel.currentTable.value == "naver" {
				self.pageViewController.goToNextPage()
			}
			self.pageViewController.viewModel.currentTable.accept("kakao")
			
		}.disposed(by: disposeBag)
	}
}


