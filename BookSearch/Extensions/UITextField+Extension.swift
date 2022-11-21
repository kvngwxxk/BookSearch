//
//  UITextField+Extension.swift
//  BookSearch
//
//  Created by Kangwook Lee on 2022/11/21.
//

import Foundation
import UIKit

extension UITextField {
	func addLeftPadding() {
		let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
		self.leftView = paddingView
		self.leftViewMode = ViewMode.always
	}
}

