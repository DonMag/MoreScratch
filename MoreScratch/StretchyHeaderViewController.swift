//
//  StretchyHeaderViewController.swift
//  MoreScratch
//
//  Created by Don Mag on 4/12/22.
//

import UIKit

class StretchyHeaderViewController: UIViewController {
	
	let scrollView: UIScrollView = {
		let v = UIScrollView()
		v.contentInsetAdjustmentBehavior = .never
		return v
	}()
	let stretchyView: UIView = {
		let v = UIView()
		return v
	}()
	let contentView: UIView = {
		let v = UIView()
		v.backgroundColor = .systemYellow
		return v
	}()
	
	let stretchyViewHeight: CGFloat = 350.0
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// set to a greter-than-zero value if you want spacing between the "pages"
		let opts = [UIPageViewController.OptionsKey.interPageSpacing: 0.0]
		// instantiate the Page View controller
		let pgVC = SamplePageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: opts)
		// add it as a child controller
		self.addChild(pgVC)
		// safe unwrap
		guard let pgv = pgVC.view else { return }
		pgv.translatesAutoresizingMaskIntoConstraints = false
		// add the page controller view to stretchyView
		stretchyView.addSubview(pgv)
		pgVC.didMove(toParent: self)
		
		NSLayoutConstraint.activate([
			// constrain page view controller's view on all 4 sides
			pgv.topAnchor.constraint(equalTo: stretchyView.topAnchor),
			pgv.bottomAnchor.constraint(equalTo: stretchyView.bottomAnchor),
			pgv.centerXAnchor.constraint(equalTo: stretchyView.centerXAnchor),
			pgv.widthAnchor.constraint(equalTo: stretchyView.widthAnchor),
		])
		
		[scrollView, stretchyView, contentView].forEach { v in
			v.translatesAutoresizingMaskIntoConstraints = false
		}
		
		// add contentView and stretchyView to the scroll view
		[stretchyView, contentView].forEach { v in
			scrollView.addSubview(v)
		}
		
		// add scroll view to self.view
		view.addSubview(scrollView)
		
		let safeG = view.safeAreaLayoutGuide
		let contentG = scrollView.contentLayoutGuide
		let frameG = scrollView.frameLayoutGuide
		
		// keep stretchyView's Top "pinned" to the Top of the scroll view FRAME
		//	so its Height will "stretch" when scroll view is pulled down
		let stretchyTop = stretchyView.topAnchor.constraint(equalTo: frameG.topAnchor, constant: 0.0)
		// priority needs to be less-than-required so we can "push it up" out of view
		stretchyTop.priority = .defaultHigh
		
		NSLayoutConstraint.activate([
			
			// scroll view Top to view Top
			scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0),

			// scroll view Leading/Trailing/Bottom to safe area
			scrollView.leadingAnchor.constraint(equalTo: safeG.leadingAnchor, constant: 0.0),
			scrollView.trailingAnchor.constraint(equalTo: safeG.trailingAnchor, constant: 0.0),
			scrollView.bottomAnchor.constraint(equalTo: safeG.bottomAnchor, constant: 0.0),
			
			// constrain stretchy view Top to scroll view's FRAME
			stretchyTop,
			
			// stretchyView to Leading/Trailing of scroll view FRAME
			stretchyView.leadingAnchor.constraint(equalTo: frameG.leadingAnchor, constant: 0.0),
			stretchyView.trailingAnchor.constraint(equalTo: frameG.trailingAnchor, constant: 0.0),
			
			// stretchyView Height - greater-than-or-equal-to
			//	so it can "stretch" vertically
			stretchyView.heightAnchor.constraint(greaterThanOrEqualToConstant: stretchyViewHeight),
			
			// content view Leading/Trailing/Bottom to scroll view's CONTENT GUIDE
			contentView.leadingAnchor.constraint(equalTo: contentG.leadingAnchor, constant: 0.0),
			contentView.trailingAnchor.constraint(equalTo: contentG.trailingAnchor, constant: 0.0),
			contentView.bottomAnchor.constraint(equalTo: contentG.bottomAnchor, constant: 0.0),

			// content view Width to scroll view's FRAME
			contentView.widthAnchor.constraint(equalTo: frameG.widthAnchor, constant: 0.0),

			// content view Top to scroll view's CONTENT GUIDE
			//	plus Height of stretchyView
			contentView.topAnchor.constraint(equalTo: contentG.topAnchor, constant: stretchyViewHeight),

			// content view Top to stretchyView Bottom
			contentView.topAnchor.constraint(equalTo: stretchyView.bottomAnchor, constant: 0.0),
	
		])
		
		// add some content to the content view so we have something to scroll
		addSomeContent()
				
	}
	
	func addSomeContent() {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.spacing = 32
		stack.backgroundColor = .gray
		stack.translatesAutoresizingMaskIntoConstraints = false
		for i in 1...20 {
			let v = UILabel()
			v.text = "Label \(i)"
			v.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
			v.heightAnchor.constraint(equalToConstant: 48.0).isActive = true
			stack.addArrangedSubview(v)
		}
		contentView.addSubview(stack)
		NSLayoutConstraint.activate([
			stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
			stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
			stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
			stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0),
		])
	}
	
}

class OnePageVC: UIViewController {
	
	var image: UIImage = UIImage() {
		didSet {
			imgView.image = image
		}
	}
	let imgView: UIImageView = {
		let v = UIImageView()
		v.backgroundColor = .systemBlue
		v.contentMode = .scaleAspectFill
		v.clipsToBounds = true
		v.translatesAutoresizingMaskIntoConstraints = false
		return v
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .systemBackground
		
		view.addSubview(imgView)
		NSLayoutConstraint.activate([
			// constrain image view to all 4 sides
			imgView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0),
			imgView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
			imgView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
			imgView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0),
		])
	}
}

class SamplePageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
	
	var controllers: [UIViewController] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let imgNames: [String] = [
			"ex1", "ex2", "ex3",
		]
		for i in 0..<imgNames.count {
			let aViewController = OnePageVC()
			if let img = UIImage(named: imgNames[i]) {
				aViewController.image = img
			}
			self.controllers.append(aViewController)
		}

		self.dataSource = self
		self.delegate = self
		
		self.setViewControllers([controllers[0]], direction: .forward, animated: false)
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		if let index = controllers.firstIndex(of: viewController), index > 0 {
			return controllers[index - 1]
		}
		return nil
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		if let index = controllers.firstIndex(of: viewController), index < controllers.count - 1 {
			return controllers[index + 1]
		}
		return nil
	}

}

