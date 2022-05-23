//
//  NavTransViewController.swift
//  MoreScratch
//
//  Created by Don Mag on 4/14/22.
//

import UIKit

class NavTransViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

// Custom Navigation Transition
//	from: https://ordinarycoding.com/articles/simple-custom-uinavigationcontroller-transitions/
/*
final class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
	// 1
	let presenting: Bool
	
	// 2
	init(presenting: Bool) {
		self.presenting = presenting
	}
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		// 3
		return TimeInterval(UINavigationController.hideShowBarDuration)
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		// 4
		guard let fromView = transitionContext.view(forKey: .from) else { return }
		guard let toView = transitionContext.view(forKey: .to) else { return }
		
		// 5
		let duration = transitionDuration(using: transitionContext)
		
		// 6
		let container = transitionContext.containerView
		if presenting {
			container.addSubview(toView)
		} else {
			container.insertSubview(toView, belowSubview: fromView)
		}
		
		// 7
		let toViewFrame = toView.frame
		toView.frame = CGRect(x: presenting ? toView.frame.width : -toView.frame.width, y: toView.frame.origin.y, width: toView.frame.width, height: toView.frame.height)
		
		let animations = {
			UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
				toView.alpha = 1
				if self.presenting {
					fromView.alpha = 0
				}
			}
			
			UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1) {
				toView.frame = toViewFrame
				fromView.frame = CGRect(x: self.presenting ? -fromView.frame.width : fromView.frame.width, y: fromView.frame.origin.y, width: fromView.frame.width, height: fromView.frame.height)
				if !self.presenting {
					fromView.alpha = 0
				}
			}
			
		}
		
		UIView.animateKeyframes(withDuration: duration,
								delay: 0,
								options: .calculationModeCubic,
								animations: animations,
								completion: { finished in
			// 8
			container.addSubview(toView)
			transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
		})
	}
}
*/

// Custom Navigation Transition
//	from: https://ordinarycoding.com/articles/simple-custom-uinavigationcontroller-transitions/
//
final class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
	// 1
	let presenting: Bool
	let fade: Bool
	let overlap: Bool
	
	// 2
	init(presenting: Bool, fade: Bool, overlap: Bool) {
		self.presenting = presenting
		self.fade = fade
		self.overlap = overlap
	}
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		// 3
		return TimeInterval(UINavigationController.hideShowBarDuration)
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		// 4
		guard let fromView = transitionContext.view(forKey: .from) else { return }
		guard let toView = transitionContext.view(forKey: .to) else { return }
		
		// 5
		let duration = transitionDuration(using: transitionContext)
		
		// 6
		let container = transitionContext.containerView
		if presenting {
			container.addSubview(toView)
		} else {
			container.insertSubview(toView, belowSubview: fromView)
		}
		
		// 7
		let toViewFrame = toView.frame
		toView.frame = CGRect(x: presenting ? toView.frame.width : -toView.frame.width * (self.overlap ? 0.5 : 1.0), y: toView.frame.origin.y, width: toView.frame.width, height: toView.frame.height)
		
		let animations = {
			UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
				toView.alpha = 1
				if self.presenting {
					if self.fade {
						fromView.alpha = 0
					}
				}
			}
			
			UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1) {
				toView.frame = toViewFrame
				fromView.frame = CGRect(x: self.presenting ? -fromView.frame.width * (self.overlap ? 0.5 : 1.0) : fromView.frame.width, y: fromView.frame.origin.y, width: fromView.frame.width, height: fromView.frame.height)
				if !self.presenting {
					if self.fade {
						fromView.alpha = 0
					}
				}
			}
			
		}
		
		UIView.animateKeyframes(withDuration: duration,
								delay: 0,
								options: .calculationModeCubic,
								animations: animations,
								completion: { finished in
			// 8
			container.addSubview(toView)
			transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
		})
	}
}


final class TransitionCoordinator: NSObject, UINavigationControllerDelegate {
	// 1
	var interactionController: UIPercentDrivenInteractiveTransition?
	
	// 2
	func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		switch operation {
		case .push:
			return TransitionAnimator(presenting: true, fade: false, overlap: true)
		case .pop:
			return TransitionAnimator(presenting: false, fade: false, overlap: true)
		default:
			return nil
		}
	}
	
	// 3
	func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		return interactionController
	}
}
extension UINavigationController {
	// 1
	static private var coordinatorHelperKey = "UINavigationController.TransitionCoordinatorHelper"
	
	// 2
	var transitionCoordinatorHelper: TransitionCoordinator? {
		return objc_getAssociatedObject(self, &UINavigationController.coordinatorHelperKey) as? TransitionCoordinator
	}
	
	func addCustomTransitioning() {
		// 3
		var object = objc_getAssociatedObject(self, &UINavigationController.coordinatorHelperKey)
		
		guard object == nil else {
			return
		}
		
		object = TransitionCoordinator()
		let nonatomic = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC
		objc_setAssociatedObject(self, &UINavigationController.coordinatorHelperKey, object, nonatomic)
		
		// 4
		delegate = object as? TransitionCoordinator
		
		
		// 5
		let edgeSwipeGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleSwipe(_:)))
		edgeSwipeGestureRecognizer.edges = .left
		view.addGestureRecognizer(edgeSwipeGestureRecognizer)
	}
	
	// 6
	@objc func handleSwipe(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
		guard let gestureRecognizerView = gestureRecognizer.view else {
			transitionCoordinatorHelper?.interactionController = nil
			return
		}
		
		let percent = gestureRecognizer.translation(in: gestureRecognizerView).x / gestureRecognizerView.bounds.size.width
		
		if gestureRecognizer.state == .began {
			transitionCoordinatorHelper?.interactionController = UIPercentDrivenInteractiveTransition()
			popViewController(animated: true)
		} else if gestureRecognizer.state == .changed {
			transitionCoordinatorHelper?.interactionController?.update(percent)
		} else if gestureRecognizer.state == .ended {
			if percent > 0.5 && gestureRecognizer.state != .cancelled {
				transitionCoordinatorHelper?.interactionController?.finish()
			} else {
				transitionCoordinatorHelper?.interactionController?.cancel()
			}
			transitionCoordinatorHelper?.interactionController = nil
		}
	}
}

class NavSubVC: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .systemBackground
		
		guard let img = UIImage(named: "navBKG") else {
			DispatchQueue.main.async {
				let a = UIAlertController(title: "Alert", message: "Could not load \"navBKG\" image", preferredStyle: .alert)
				self.present(a, animated: true, completion: nil)
			}
			return
		}
		let imgView = UIImageView(image: img)
		imgView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(imgView)
		
		let rvc = Page1VC()
		let navC = UINavigationController(rootViewController: rvc)
		self.addChild(navC)
		guard let navView = navC.view else { return }
		view.addSubview(navView)
		navC.didMove(toParent: self)
		navView.translatesAutoresizingMaskIntoConstraints = false
		
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([

			imgView.topAnchor.constraint(equalTo: g.topAnchor, constant: 0.0),
			imgView.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 0.0),
			imgView.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: 0.0),
			imgView.bottomAnchor.constraint(equalTo: g.bottomAnchor, constant: 0.0),

			navView.topAnchor.constraint(equalTo: g.topAnchor, constant: 40.0),
			navView.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 40.0),
			navView.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -40.0),
			navView.bottomAnchor.constraint(equalTo: g.bottomAnchor, constant: -40.0),
			
		])

		// let's have a gray nav bar always showing
		let navigationBarAppearance = UINavigationBarAppearance()
		navigationBarAppearance.configureWithTransparentBackground()
		navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
		navigationBarAppearance.backgroundColor = .systemGray
		
		UINavigationBar.appearance().standardAppearance = navigationBarAppearance
		UINavigationBar.appearance().compactAppearance = navigationBarAppearance
		UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
		
		// let's add a border to the navigation controller view
		//	so we can see its frame (since the controllers have clear backgrounds)
		navView.layer.borderWidth = 2
		navView.layer.borderColor = UIColor.yellow.cgColor
		
		// un-comment this line to see the custom transition
		//navC.addCustomTransitioning()
	}
}

class PageBaseVC: UIViewController {
	
	var labels: [UILabel] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .clear
		
		for i in 1...6 {
			let v = UILabel()
			v.text = "\(i)"
			v.textAlignment = .center
			v.textColor = .white
			v.translatesAutoresizingMaskIntoConstraints = false
			v.widthAnchor.constraint(equalToConstant: 80.0).isActive = true
			v.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
			labels.append(v)
			view.addSubview(v)
		}
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			
			labels[0].topAnchor.constraint(equalTo: g.topAnchor, constant: 0.0),
			labels[0].leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 0.0),
			
			labels[1].centerYAnchor.constraint(equalTo: g.centerYAnchor, constant: 0.0),
			labels[1].leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 0.0),
			
			labels[2].bottomAnchor.constraint(equalTo: g.bottomAnchor, constant: 0.0),
			labels[2].leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 0.0),
			
			labels[3].topAnchor.constraint(equalTo: g.topAnchor, constant: 0.0),
			labels[3].trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: 0.0),
			
			labels[4].centerYAnchor.constraint(equalTo: g.centerYAnchor, constant: 0.0),
			labels[4].trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: 0.0),
			
			labels[5].bottomAnchor.constraint(equalTo: g.bottomAnchor, constant: 0.0),
			labels[5].trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: 0.0),
			
		])
		
	}
	
}

class Page1VC: PageBaseVC {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "Page 1"
		
		labels.forEach { v in
			v.backgroundColor = .systemBlue
		}
		
		let b = UIButton()
		b.backgroundColor = .systemGreen
		b.setTitle("Push to Page 2", for: [])
		b.setTitleColor(.white, for: .normal)
		b.setTitleColor(.lightGray, for: .highlighted)
		b.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(b)
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			b.topAnchor.constraint(equalTo: g.topAnchor, constant: 100.0),
			b.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			b.widthAnchor.constraint(equalTo: g.widthAnchor, multiplier: 0.75),
			b.heightAnchor.constraint(equalToConstant: 60.0),
		])
		b.addTarget(self, action: #selector(doPush(_:)), for: .touchUpInside)
	}
	
	@objc func doPush(_ sender: Any?) {
		let vc = Page2VC()
		self.navigationController?.pushViewController(vc, animated: true)
	}
	
}

class Page2VC: PageBaseVC {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "Page 2"
		
		labels.forEach { v in
			v.backgroundColor = .systemRed
		}
		let scrollView = UIScrollView()
		let image = UIImageView()
		let label = UILabel()
		let button = UIButton()
		
		NSLayoutConstraint.activate([
			scrollView.topAnchor.constraint(equalTo: view.topAnchor),
			scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

			image.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
			
			image.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
			image.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
			image.heightAnchor.constraint(equalToConstant: 100),
			
			// make the image view the Width of the scroll view
			image.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
			
			label.topAnchor.constraint(equalTo: image.bottomAnchor),
			label.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
			label.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
			label.heightAnchor.constraint(equalToConstant: 1000),

			// make the label the Width of the scroll view
			label.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

			button.topAnchor.constraint(equalTo: label.bottomAnchor),
			button.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
			button.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),

			// make the button the Width of the scroll view
			button.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
			
			button.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
			
		])
	}
	
}

class AnimTestVC: UIViewController {
	
	let cView = MyCustomView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		if #available(iOS 13.0, *) {
			view.backgroundColor = .systemBackground
		} else {
			// Fallback on earlier versions
		}
		
		cView.backgroundColor = .systemBlue
		cView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(cView)
		
		NSLayoutConstraint.activate([
			cView.widthAnchor.constraint(equalToConstant: 100.0),
			cView.heightAnchor.constraint(equalTo: cView.widthAnchor),
			cView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			cView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
		])
		
		cView.alpha = 0.0
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		cView.showPointOfInterestA(at: cView.center, hideViewAfterAnimation: true)
	}
}
class MyCustomView: UIView {
	
	func showPointOfInterestA(at point: CGPoint, hideViewAfterAnimation: Bool) {
		
		let durations: [Double] = [
			0.20, 0.3, 0.1, 1.5, 0.5
		]
		
		let totalDuration = durations.reduce(0, +)
		
		var relStart: Double = 0.0
		var relDur: Double = 0.0
		var i: Int = 0
		
		self.center = point
		
		UIView.animateKeyframes(withDuration: totalDuration, delay: 0, options: .calculationModeCubic, animations: {
			
			relStart = 0.0
			relDur = durations[i] / totalDuration
			i += 1
			UIView.addKeyframe(withRelativeStartTime: relStart, relativeDuration: relDur) {
				self.alpha = 1.0
				self.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
			}
			
			relStart += relDur
			relDur = durations[i] / totalDuration
			i += 1
			UIView.addKeyframe(withRelativeStartTime: relStart, relativeDuration: relDur) {
				self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
			}
			
			relStart += relDur
			relDur = durations[i] / totalDuration
			i += 1
			UIView.addKeyframe(withRelativeStartTime: relStart, relativeDuration: relDur) {
				self.transform = .identity
			}
			
			relStart += relDur
			relDur = durations[i] / totalDuration
			i += 1
			UIView.addKeyframe(withRelativeStartTime: relStart, relativeDuration: relDur) {
				self.alpha = 0.5
			}
			
			relStart += relDur
			relDur = durations[i] / totalDuration
			i += 1
			UIView.addKeyframe(withRelativeStartTime: relStart, relativeDuration: relDur) {
				self.alpha = hideViewAfterAnimation ? 0.0 : 0.5
			}
		})
		
		//		CATransaction.begin()
		//
		//		let animA = CABasicAnimation(keyPath: "transform.scale")
		//		animA.fromValue = 1.0
		//		animA.toValue = 1.5
		//
		//
		//		let group = CAAnimationGroup()
		//		group.duration = 0.75
		//		group.timingFunction = CAMediaTimingFunction(name: .linear)
		//		group.beginTime = CACurrentMediaTime() + 0.2
		//		group.animations = [animA]
		//		layer.add(group, forKey: "borderChangeAnimationGroup")
		//
		//		CATransaction.commit()
		
	}
	
	func showPointOfInterest(at point: CGPoint, hideViewAfterAnimation: Bool) {
		
		//if isPreviousAnimationPresenting() { layer.removeAllAnimations() }
		
		layer.removeAllAnimations()
		
		
		
		center = point
		transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
		self.alpha = 1
		
		UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut]) {
			self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
		} completion: { animated in
			if !animated {
				return
			} else {
				UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut]) {
					self.transform = .identity
				} completion: { animated in
					if !animated {
						return
					} else {
						UIView.animate(withDuration: 1.5, delay: 0, options: [.curveEaseInOut]) {
							self.alpha = 0.5
						} completion: { animated in
							if !animated {
								return
							} else {
								UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut]) {
									self.alpha = hideViewAfterAnimation ? 0 : 0.5
								}
							}
						}
					}
				}
			}
		}
	}
}

