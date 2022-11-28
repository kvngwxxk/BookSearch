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
	let semaphore = DispatchSemaphore(value: 1)
	let disposeBag = DisposeBag()
	let viewModel: MainViewModel!
	var isChecked = false
	var pageView = UIView()
	var pageViewController = PageViewController(viewModel: PageViewModel())
	private var tableHeightConstraint: Constraint?
	let searchTable = UITableView()
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
	
	
	var correctText: String = ""
	var isAdult = false
	var searchTextList = [String]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		self.navigationItem.title = "Book Search Demo"
		self.view.backgroundColor = .white
		searchTable.backgroundColor = .white
		searchTable.registerCell(cellType: UITableViewCell.self, reuseIdentifier: "MainCell")
		searchTable.dataSource = self
		searchTable.delegate = self
		searchTable.layer.borderColor = UIColor.systemGray5.cgColor
		searchTable.layer.borderWidth = 0.5
		searchTable.layer.cornerRadius = 5
		
		print(self.viewModel.hasAdult.value)
		
		setAutoLayout()
		setBinding()
		viewModel.initializeUserDefaultsManager()
		
		let gestureRecongnizer = UITapGestureRecognizer(target: self, action: #selector(focusOff))
		gestureRecongnizer.cancelsTouchesInView = false
		gestureRecongnizer.delegate = self
		view.addGestureRecognizer(gestureRecongnizer)
		
		searchTable.isHidden = true
	}
	
	init(viewModel: MainViewModel) {
		self.viewModel = viewModel
		super.init(nibName: nil, bundle: nil)
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func setAutoLayout() {
		self.view.addSubview(searchBar)
		self.view.addSubview(searchButton)
		self.view.addSubview(checkAdult)
		self.view.addSubview(adultLabel)
		self.view.addSubview(pageView)
		self.view.addSubview(naverTab)
		self.view.addSubview(kakaoTab)
		self.view.addSubview(searchTable)
		
		addChild(pageViewController)
		pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
		self.pageView.addSubview(pageViewController.view)
		
		
		searchTable.snp.makeConstraints { make in
			make.top.equalTo(self.searchBar.snp.bottom)
			make.width.equalTo(self.searchBar)
			make.leading.equalTo(self.searchBar)
			make.trailing.equalTo(self.searchBar)
			make.height.equalTo(150)
		}
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
		self.searchBar.rx.text
			.orEmpty
			.map { $0 as String }
			.bind { [weak self] newText in
				guard let self = self else { return }
				self.searchTable.isHidden = false
				print(newText)
				self.viewModel.searchTextList.subscribe(onNext: { list in
					self.searchTextList = list.filter{ $0.hasPrefix(newText)}
					if !newText.isEmpty {
						if self.searchTextList.count >= 3 {
							let arr = Array(self.searchTextList[0..<3])
							self.searchTextList = arr
						}
					} else {
						if self.searchTextList.count >= 5 {
							let arr = Array(self.searchTextList[0..<5])
							self.searchTextList = arr
						}
					}
					self.searchTable.reloadData()
					self.tableHeightConstraint?.update(offset: self.searchTextList.count * 30)
				}).disposed(by: self.disposeBag)
				
			}.disposed(by: disposeBag)
		
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
			self.searchTable.isHidden = true
		}.disposed(by: disposeBag)
		
		self.searchButton.rx.tap
			.throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
			.bind { [weak self] _ in
				guard let self = self else { return }
				self.searchProcess()
				self.searchTable.isHidden = true
			}.disposed(by: disposeBag)
		
		self.viewModel.hasAdult
			.throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
			.subscribe(onNext: { [weak self] bool in
				guard let self = self else { return }
				if bool.contains(true) {
					self.isAdult = true
				} else {
					self.isAdult = false
				}
			}).disposed(by: self.disposeBag)
		
		self.viewModel.correctWords
			.throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
			.subscribe(onNext: { [weak self] words in
				guard let self = self else { return }
				let correctText = words.joined(separator: " ")
				self.correctText = correctText
			}).disposed(by: self.disposeBag)
		
		self.viewModel.naverBooks
			.observe(on: MainScheduler.instance)
			.subscribe(onNext: { [weak self] books in
				guard let self = self else { return }
				self.pageViewController.naverViewController.viewModel.naverTable.accept(books)
			}).disposed(by: disposeBag)
		
		self.viewModel.naverTotal
			.observe(on: MainScheduler.instance)
			.subscribe(onNext: { [weak self] total in
				guard let self = self else { return }
				self.pageViewController.naverViewController.viewModel.total.accept(total)
				print("Naver Total : \(total)")
			}).disposed(by: disposeBag)
		
		self.viewModel.kakaoBooks
			.observe(on: MainScheduler.instance)
			.subscribe(onNext: { [weak self] books in
				guard let self = self else { return }
				self.pageViewController.kakaoViewController.viewModel.kakaoTable.accept(books)
			}).disposed(by: disposeBag)
		
		self.viewModel.kakaoTotal
			.observe(on: MainScheduler.instance)
			.subscribe(onNext: { [weak self] total in
				guard let self = self else { return }
				self.pageViewController.kakaoViewController.viewModel.total.accept(total)
				print("Kakao Total : \(total)")
			}).disposed(by: disposeBag)
		
		self.viewModel.kakaoIsEnd
			.observe(on: MainScheduler.instance)
			.subscribe(onNext: { [weak self] isEnd in
				guard let self = self else { return }
				self.pageViewController.kakaoViewController.viewModel.isEnd.accept(isEnd)
			}).disposed(by: disposeBag)
		
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
	
	private func searchProcess() {
		// 결과 초기화
		self.searchBar.endEditing(true)
		isAdult = false
		correctText = ""
		
		self.viewModel.naverBooks.accept([])
		self.viewModel.kakaoBooks.accept([])
		while searchBar.text?.last == " " {
			searchBar.text?.removeLast()
		}
		while searchBar.text?.first == " " {
			searchBar.text?.removeFirst()
		}
		// 검색어 입력 여부
		if let text = self.searchBar.text, !text.isEmpty {
			if !self.isChecked {
				// 성인 단어 API 호출
				self.viewModel.requestAdult(query: text)
				if isAdult {
					self.showToast(message: "성인 단어 포함")
				} else {
					// 오타 확인
					self.viewModel.requestErrata(query: text)
					
					// 책 검색
					self.viewModel.requestNaverBookInfo(query: correctText.isEmpty ? text : correctText, page: 1)
					self.viewModel.requestKakaoBookInfo(query: correctText.isEmpty ? text : correctText, page: 1)
					
					// UserDefaults에 저장
					correctText.isEmpty ? viewModel.saveSearchText(searchText: text) : viewModel.saveSearchText(searchText: correctText)
					
					correctText.isEmpty ? pageViewController.naverViewController.viewModel.searchText.accept(text) : pageViewController.naverViewController.viewModel.searchText.accept(correctText)
					correctText.isEmpty ? pageViewController.kakaoViewController.viewModel.searchText.accept(text) : pageViewController.kakaoViewController.viewModel.searchText.accept(correctText)
					print(UserDefaults.standard.array(forKey: "searchText")!)
				}
			} else {
				self.viewModel.requestErrata(query: text)
				self.viewModel.requestNaverBookInfo(query: correctText.isEmpty ? text : correctText, page: 1)
				self.viewModel.requestKakaoBookInfo(query: correctText.isEmpty ? text : correctText, page: 1)
				
				// UserDefaults에 저장
				correctText.isEmpty ? viewModel.saveSearchText(searchText: text) : viewModel.saveSearchText(searchText: correctText)
				
				correctText.isEmpty ? pageViewController.naverViewController.viewModel.searchText.accept(text) : pageViewController.naverViewController.viewModel.searchText.accept(correctText)
				correctText.isEmpty ? pageViewController.kakaoViewController.viewModel.searchText.accept(text) : pageViewController.kakaoViewController.viewModel.searchText.accept(correctText)
				print(UserDefaults.standard.array(forKey: "searchText")!)
				
			}
		} else {
			self.showToast(message: "검색어를 입력해주세요")
		}
	}
	
	@objc private func focusOff() {
		self.searchBar.endEditing(true)
		self.searchTable.isHidden = true
	}
	
	func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 14.0)) {
		let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
		toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
		toastLabel.textColor = UIColor.white
		toastLabel.font = font
		toastLabel.textAlignment = .center;
		toastLabel.text = message
		toastLabel.alpha = 1.0
		toastLabel.layer.cornerRadius = 10;
		toastLabel.clipsToBounds  =  true
		self.view.addSubview(toastLabel)
		UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
			toastLabel.alpha = 0.0
		}, completion: {(isCompleted) in
			toastLabel.removeFromSuperview()
		})
	}
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		//		if searchBar.text != nil {
		//			return 5
		//		} else {
		//			return 3
		//		}
		return searchTextList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: UITableViewCell = tableView.dequeueCell(reuseIdentifier: "MainCell", indexPath: indexPath)
		cell.textLabel?.text = searchTextList[indexPath.row]
		return cell
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 30
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.searchBar.text = searchTextList[indexPath.row]
		self.searchProcess()
		self.searchBar.endEditing(true)
		self.searchTable.isHidden = true
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
	}
}

extension MainViewController: UIGestureRecognizerDelegate {
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
						   shouldReceive touch: UITouch) -> Bool {
		return (touch.view === self.view)
	}
}
