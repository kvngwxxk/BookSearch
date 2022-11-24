//
//  PageViewController.swift
//  BookSearch
//
//  Created by Kangwook Lee on 2022/11/18.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class PageViewController: UIPageViewController {
	let naverViewController: NaverViewController
	let kakaoViewController: KakaoViewController
	var tableViewControllers: [UIViewController]
	var viewModel: PageViewModel
	let disposeBag = DisposeBag()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.dataSource = self
		self.delegate = self
		if let firstViewController = tableViewControllers.first {
			self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
		}
	}
	
	init(viewModel: PageViewModel) {
		self.viewModel = viewModel
		naverViewController = NaverViewController(viewModel: NaverViewModel())
		kakaoViewController = KakaoViewController(viewModel: KakaoViewModel())
		tableViewControllers = [naverViewController, kakaoViewController]
		super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
		self.view.layer.borderColor = UIColor.gray.cgColor
		self.view.layer.borderWidth = 0.3
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}



extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		guard let index = tableViewControllers.firstIndex(of: viewController) else {return nil}
		if tableViewControllers[index] is NaverViewController {
			viewModel.currentTable.accept("naver")
		} else {
			viewModel.currentTable.accept("kakao")
		}
		let previousIndex = index - 1
		
		if(previousIndex < 0){
			return nil
			
		}
		else{
			
			return tableViewControllers[previousIndex]
		}
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		guard let index = tableViewControllers.firstIndex(of: viewController) else {return nil}
		if tableViewControllers[index] is NaverViewController {
			viewModel.currentTable.accept("naver")
		} else {
			viewModel.currentTable.accept("kakao")
		}
		let nextIndex = index + 1
		
		if(nextIndex >= tableViewControllers.count){
			return nil
		}
		else{
			
			
			return tableViewControllers[nextIndex]
		}
		
	}
	
	
}

extension UIPageViewController {
	func goToNextPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
		if let currentViewController = viewControllers?[0] {
			if let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentViewController) {
				setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
			}
		}
	}

	func goToPreviousPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
		if let currentViewController = viewControllers?[0] {
			if let previousPage = dataSource?.pageViewController(self, viewControllerBefore: currentViewController){
				setViewControllers([previousPage], direction: .reverse, animated: true, completion: completion)
			}
		}
	}
}
