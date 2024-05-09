//
//  UINavigationController+.swift
//  NanaLand
//
//  Created by 정현우 on 5/9/24.
//
import UIKit

extension UINavigationController: UIGestureRecognizerDelegate {
	override open func viewDidLoad() {
		super.viewDidLoad()
		// 뒤로 가기 제스쳐 활성화
		interactivePopGestureRecognizer?.delegate = self
	}

	public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		// stack에 view가 1개 보다 많은경우만 pop
		return viewControllers.count > 1
	}
}
