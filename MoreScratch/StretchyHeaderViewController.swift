//
//  StretchyHeaderViewController.swift
//  MoreScratch
//
//  Created by Don Mag on 4/12/22.
//

import UIKit

class imgStretchyHeaderViewController: UIViewController {

	let scrollView: UIScrollView = {
		let v = UIScrollView()
		return v
	}()
	let stretchyView: UIView = {
		let v = UIView()
		return v
	}()
	let contentView: UIView = {
		let v = UIView()
		return v
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let imgView = UIImageView()
		if let img = UIImage(named: "img80x80") {
			imgView.image = img
		}
		imgView.translatesAutoresizingMaskIntoConstraints = false
		stretchyView.addSubview(imgView)
		NSLayoutConstraint.activate([
			imgView.topAnchor.constraint(equalTo: stretchyView.topAnchor),
			imgView.bottomAnchor.constraint(equalTo: stretchyView.bottomAnchor),
			imgView.centerXAnchor.constraint(equalTo: stretchyView.centerXAnchor),
			imgView.widthAnchor.constraint(equalTo: imgView.heightAnchor),
		])
			
		[scrollView, stretchyView, contentView].forEach { v in
			v.translatesAutoresizingMaskIntoConstraints = false
		}
		[contentView, stretchyView].forEach { v in
			scrollView.addSubview(v)
		}

		view.addSubview(scrollView)
		
		let safeG = view.safeAreaLayoutGuide
		let contentG = scrollView.contentLayoutGuide
		let frameG = scrollView.frameLayoutGuide
		
		let stretchyHeight = stretchyView.heightAnchor.constraint(equalToConstant: 120.0)
		stretchyHeight.priority = .defaultHigh

		let stretchyMinHeight = stretchyView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60.0)
		//stretchyHeight.priority = .defaultHigh
		
		let stretchyTop = stretchyView.topAnchor.constraint(equalTo: frameG.topAnchor, constant: 0.0)
		stretchyTop.priority = .defaultHigh + 1

		let cvTop = contentView.topAnchor.constraint(equalTo: stretchyView.bottomAnchor, constant: 0.0)
		cvTop.priority = .defaultHigh + 1
		
		NSLayoutConstraint.activate([
			
			// scroll view to all 4 sides of safe area
			//	with 20-points "padding" to make it easier to see
			scrollView.topAnchor.constraint(equalTo: safeG.topAnchor, constant: 20.0),
			scrollView.leadingAnchor.constraint(equalTo: safeG.leadingAnchor, constant: 20.0),
			scrollView.trailingAnchor.constraint(equalTo: safeG.trailingAnchor, constant: -20.0),
			scrollView.bottomAnchor.constraint(equalTo: safeG.bottomAnchor, constant: -20.0),

			// constrain stretchy view to scroll view's FRAME
			stretchyTop,
			//stretchyView.topAnchor.constraint(equalTo: frameG.topAnchor, constant: 0.0),
			
			stretchyView.leadingAnchor.constraint(equalTo: frameG.leadingAnchor, constant: 8.0),
			stretchyView.trailingAnchor.constraint(equalTo: frameG.trailingAnchor, constant: -8.0),
			
			cvTop,
			//contentView.topAnchor.constraint(equalTo: stretchyView.bottomAnchor, constant: 0.0),
			
			contentView.leadingAnchor.constraint(equalTo: contentG.leadingAnchor, constant: 20.0),
			contentView.trailingAnchor.constraint(equalTo: contentG.trailingAnchor, constant: -20.0),
			contentView.bottomAnchor.constraint(equalTo: contentG.bottomAnchor, constant: -20.0),
			
			contentView.topAnchor.constraint(equalTo: contentG.topAnchor, constant: 120.0),
			contentView.widthAnchor.constraint(equalTo: frameG.widthAnchor, constant: -40.0),
			
			//stretchyView.heightAnchor.constraint(equalToConstant: 120.0),
			stretchyHeight,
			stretchyMinHeight,
			
			contentView.heightAnchor.constraint(equalToConstant: 600.0),

		])

		
		// background colors, so we can see the view frames
		scrollView.backgroundColor = .systemBlue
		stretchyView.backgroundColor = .systemRed
		contentView.backgroundColor = .systemYellow
		
    }
    

}

class StretchyHeaderViewController: UIViewController {
	
	let scrollView: UIScrollView = {
		let v = UIScrollView()
		return v
	}()
	let stretchyView: UIView = {
		let v = UIView()
		return v
	}()
	let contentView: UIView = {
		let v = UIView()
		return v
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()

		let opts = [UIPageViewController.OptionsKey.interPageSpacing: 4.0]

		let pgVC = SamplePageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: opts)
		self.addChild(pgVC)
		guard let pgv = pgVC.view else { return }
		pgv.translatesAutoresizingMaskIntoConstraints = false
		stretchyView.addSubview(pgv)
		pgVC.didMove(toParent: self)
		
		NSLayoutConstraint.activate([
			pgv.topAnchor.constraint(equalTo: stretchyView.topAnchor),
			pgv.bottomAnchor.constraint(equalTo: stretchyView.bottomAnchor),
			pgv.centerXAnchor.constraint(equalTo: stretchyView.centerXAnchor),
			pgv.widthAnchor.constraint(equalTo: pgv.heightAnchor, multiplier: 2.0),
			//pgv.widthAnchor.constraint(equalToConstant: 300.0),
		])

		[scrollView, stretchyView, contentView].forEach { v in
			v.translatesAutoresizingMaskIntoConstraints = false
		}
		[contentView, stretchyView].forEach { v in
			scrollView.addSubview(v)
		}
		
		view.addSubview(scrollView)
		
		let safeG = view.safeAreaLayoutGuide
		let contentG = scrollView.contentLayoutGuide
		let frameG = scrollView.frameLayoutGuide
		
		let stretchyHeight = stretchyView.heightAnchor.constraint(equalToConstant: 120.0)
		stretchyHeight.priority = .defaultHigh
		
		let stretchyMinHeight = stretchyView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60.0)
		
		let stretchyTop = stretchyView.topAnchor.constraint(equalTo: frameG.topAnchor, constant: 0.0)
		stretchyTop.priority = .defaultHigh + 1
		
		let cvTop = contentView.topAnchor.constraint(equalTo: stretchyView.bottomAnchor, constant: 0.0)
		cvTop.priority = .defaultHigh + 1
		
		NSLayoutConstraint.activate([
			
			// scroll view to all 4 sides of safe area
			//	with 20-points "padding" to make it easier to see
			scrollView.topAnchor.constraint(equalTo: safeG.topAnchor, constant: 20.0),
			scrollView.leadingAnchor.constraint(equalTo: safeG.leadingAnchor, constant: 20.0),
			scrollView.trailingAnchor.constraint(equalTo: safeG.trailingAnchor, constant: -20.0),
			scrollView.bottomAnchor.constraint(equalTo: safeG.bottomAnchor, constant: -20.0),
			
			// constrain stretchy view to scroll view's FRAME
			stretchyTop,
			//stretchyView.topAnchor.constraint(equalTo: frameG.topAnchor, constant: 0.0),
			
			stretchyView.leadingAnchor.constraint(equalTo: frameG.leadingAnchor, constant: 8.0),
			stretchyView.trailingAnchor.constraint(equalTo: frameG.trailingAnchor, constant: -8.0),
			
			cvTop,
			//contentView.topAnchor.constraint(equalTo: stretchyView.bottomAnchor, constant: 0.0),
			
			contentView.leadingAnchor.constraint(equalTo: contentG.leadingAnchor, constant: 20.0),
			contentView.trailingAnchor.constraint(equalTo: contentG.trailingAnchor, constant: -20.0),
			contentView.bottomAnchor.constraint(equalTo: contentG.bottomAnchor, constant: -20.0),
			
			contentView.topAnchor.constraint(equalTo: contentG.topAnchor, constant: 120.0),
			contentView.widthAnchor.constraint(equalTo: frameG.widthAnchor, constant: -40.0),
			
			//stretchyView.heightAnchor.constraint(equalToConstant: 120.0),
			stretchyHeight,
			stretchyMinHeight,
			
			contentView.heightAnchor.constraint(equalToConstant: 600.0),
			
		])
		
		
		// background colors, so we can see the view frames
		scrollView.backgroundColor = .systemBlue
		stretchyView.backgroundColor = .systemRed
		contentView.backgroundColor = .systemYellow
		
	}
	
	
}

class OnePageVC: UIViewController {
	
	var currentIndex: Int = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .yellow
		
		let label = UILabel()
		label.text = "\(currentIndex)"
		label.backgroundColor = .orange
		label.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(label)
		NSLayoutConstraint.activate([
			label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			label.topAnchor.constraint(equalTo: view.topAnchor, constant: 8.0),
			label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8.0),
		])
	}
}

class SamplePageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
	
	var controllers: [UIViewController] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		for i in 0..<8 {
			let aViewController = OnePageVC()
			aViewController.currentIndex = i
			self.controllers.append(aViewController)
		}

		self.dataSource = self
		self.delegate = self
		
		self.setViewControllers([controllers[0]], direction: .forward, animated: false)
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		
		if let index = controllers.firstIndex(of: viewController) {
			if index > 0 {
				
				return controllers[index - 1]
				
			} else {
				return nil
			}
		}
		return nil
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		if let index = controllers.firstIndex(of: viewController) {
			if index < controllers.count - 1 {
				
				return controllers[index + 1]
				
			} else {
				return nil
			}
		}
		return nil
	}

}
