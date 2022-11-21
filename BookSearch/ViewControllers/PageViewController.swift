//
//  PageViewController.swift
//  BookSearch
//
//  Created by Kangwook Lee on 2022/11/18.
//

import Foundation
import UIKit

class PageViewController: UIPageViewController {
	let naverTableViewController: NaverViewController
	let kakaoTableViewController: KakaoViewController
	var tableViewControllers: [UIViewController]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.dataSource = self
		self.delegate = self
		if let firstViewController = tableViewControllers.first {
			self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
		}
	}
	
	init() {
		naverTableViewController = NaverViewController()
		kakaoTableViewController = KakaoViewController()
		tableViewControllers = [naverTableViewController, kakaoTableViewController]
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
		
		let nextIndex = index + 1
		
		if(nextIndex >= tableViewControllers.count){
			return nil
		}
		else{
			
			
			return tableViewControllers[nextIndex]
		}
		
	}
	
	
}

