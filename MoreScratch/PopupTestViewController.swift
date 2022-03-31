//
//  PopupTestViewController.swift
//  MoreScratch
//
//  Created by Don Mag on 3/30/22.
//

import UIKit

class PopupTestViewController: UIViewController {

	let wv: UIView = {
		let v = UIView()
		v.layer.borderColor = UIColor.green.cgColor
		v.layer.borderWidth = 2
		return v
	}()
	
	let mv: UIView = {
		let v = UIView()
		v.layer.borderColor = UIColor.red.cgColor
		v.layer.borderWidth = 2
		return v
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()

		wv.frame = CGRect(x: 10, y: 300, width: 50, height: 20)
		view.addSubview(wv)
		mv.frame = CGRect(x: 10, y: 300, width: 50, height: 20)
		view.addSubview(mv)
		
    }
	
	@IBAction func tapped(_ sender: Any) {
//		let scenes = UIApplication.shared.connectedScenes
//		guard let windowScene = scenes.first as? UIWindowScene,
//			  let window = windowScene.windows.first
//		else {
//			return
//		}
//		print(window.frame)
//		return
		
		if let img = UIImage(systemName: "checkmark.circle") {
			let v = NewPopupView()
			v.showPopup(title: "Test Title", message: "Test Message that is long enough it will need to wrap.", symbol: img)
		}
		return()
		
		if let img = UIImage(systemName: "checkmark.circle") {
			let v = PopupView()
			
			v.showPopup(title: "Title", message: "msg", symbol: img)
		}
		
	}
	
}

class NewPopupTestViewController: UIViewController {

	let popupView = PopupView()
	
	let testMessages: [String] = [
		"Short Message",
		"A Longer Message",
		"A Sample Message that is long enough it will need to wrap onto multiple lines.",
	]
	var testIDX: Int = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .systemBackground
		
		// a button to show the popup
		let btn: UIButton = {
			let b = UIButton()
			b.backgroundColor = .systemRed
			b.setTitle("Show Popup", for: [])
			b.setTitleColor(.white, for: .normal)
			b.setTitleColor(.lightGray, for: .highlighted)
			b.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
			return b
		}()
		
		// a couple labels at the top so we can see the popup blur effect
		let label1: UILabel = {
			let v = UILabel()
			v.text = "Just some text to put near the top of the view"
			v.backgroundColor = .yellow
			v.textColor = .red
			return v
		}()
		
		let label2: UILabel = {
			let v = UILabel()
			v.text = "so we can see that the popup covers it."
			v.backgroundColor = .systemBlue
			v.textColor = .white
			return v
		}()
		[label1, label2].forEach { v in
			v.font = .systemFont(ofSize: 24.0, weight: .light)
			v.textAlignment = .center
			v.numberOfLines = 0
		}
		[btn, label1, label2].forEach { v in
			v.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview(v)
		}
		
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			
			label1.topAnchor.constraint(equalTo: g.topAnchor, constant: 8.0),
			label1.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 16.0),

			label2.topAnchor.constraint(equalTo: g.topAnchor, constant: 8.0),
			label2.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -16.0),
			
			label2.leadingAnchor.constraint(equalTo: label1.trailingAnchor, constant: 12.0),
			label2.widthAnchor.constraint(equalTo: label1.widthAnchor),

			btn.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			btn.centerYAnchor.constraint(equalTo: g.centerYAnchor),
			btn.widthAnchor.constraint(equalToConstant: 200.0),
			btn.heightAnchor.constraint(equalToConstant: 50.0),
			
		])
		
	}
	
	@objc func tapped(_ sender: Any) {

		if popupView.superview != nil {
			print("popup is already showing!")
			return
		}
		
		// make sure we can load an image
		if let img = UIImage(systemName: "checkmark.circle") {
			let msg = testMessages[testIDX % testMessages.count]
			popupView.showPopup(title: "Test \(testIDX)", message: msg, symbol: img)
			testIDX += 1
		}
		
	}
	
}

class NewPopupView: UIView {
	
	private var symbol: UIImageView = {
		let v = UIImageView()
		return v
	}()
	private var titleLabel: UILabel = {
		let v = UILabel()
		v.font = .systemFont(ofSize: 15.0, weight: .regular)
		v.textAlignment = .center
		return v
	}()
	private var descriptionLabel: UILabel = {
		let v = UILabel()
		v.font = .systemFont(ofSize: 15.0, weight: .regular)
		v.textAlignment = .center
		v.numberOfLines = 0
		return v
	}()

	// use a Timer instead of chainging animation blocks
	private var timer: Timer?
	
	// anim in/out duration
	private var animDuration: TimeInterval = 0.3
	
	// we'll swap these for the vertical position
	private var topConstraint: NSLayoutConstraint!
	private var botConstraint: NSLayoutConstraint!

	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		configure()
	}
	
	private func configure() {
		
		// stack view for the two labels
		let stack: UIStackView = {
			let v = UIStackView()
			v.axis = .vertical
			v.spacing = 2
			return v
		}()
		
		// add the labels
		stack.addArrangedSubview(titleLabel)
		stack.addArrangedSubview(descriptionLabel)
		
		// create the VFX view
		let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
		let blurView = UIVisualEffectView(effect: blurEffect)
		
		[blurView, symbol, stack].forEach { v in
			v.translatesAutoresizingMaskIntoConstraints = false
			self.addSubview(v)
		}

		NSLayoutConstraint.activate([
			
			// constrain blurView to fill self
			blurView.topAnchor.constraint(equalTo: topAnchor, constant: 0.0),
			blurView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.0),
			blurView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0.0),
			blurView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0.0),
			
			// constrain symbol Leading: 20, CenterY, 25x25
			symbol.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0),
			symbol.centerYAnchor.constraint(equalTo: centerYAnchor),
			symbol.widthAnchor.constraint(equalToConstant: 25.0),
			symbol.heightAnchor.constraint(equalTo: symbol.widthAnchor),
			
			// constrain stack view
			//	Top / Bottom with 10-pts "padding"
			stack.topAnchor.constraint(equalTo: topAnchor, constant: 10.0),
			stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.0),
			// Leading to symbol Trailing + 8
			stack.leadingAnchor.constraint(equalTo: symbol.trailingAnchor, constant: 8.0),
			// Trailing with 20-pts "padding"
			stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20.0),
			
			// min stack view width: 160
			stack.widthAnchor.constraint(greaterThanOrEqualToConstant: 160.0),
			// max stack view width: 240
			stack.widthAnchor.constraint(lessThanOrEqualToConstant: 240.0),

		])
		
	}

	func findWindow() -> UIWindow? {
		let scenes = UIApplication.shared.connectedScenes
		guard let windowScene = scenes.first as? UIWindowScene,
			  let window = windowScene.windows.first
		else {
			return nil
		}
		return window
	}
	
	func showPopup(title: String, message: String, symbol: UIImage) {
		titleLabel.text = title
		descriptionLabel.text = message
		self.symbol.image = symbol
		
		// make sure background is clear so the VFX view works
		self.backgroundColor = .clear

		self.layer.cornerRadius = 20
		self.clipsToBounds = true

		configurePopup()
		configureSwipeGesture()

		// need to trigger animateIn *after* layout
		DispatchQueue.main.async {
			self.animateIn()
		}
	}

	@objc private func animateOut() {
		guard let sv = self.superview else { return }
		self.topConstraint.isActive = false
		self.botConstraint.isActive = true
		UIView.animate(withDuration: animDuration, delay: 0.0, options: .curveEaseInOut) {
			sv.layoutIfNeeded()
		} completion: { [weak self] _ in
			guard let self = self else { return }
			self.removeFromSuperview()
		}
	}
	private func animateIn() {
		guard let sv = self.superview else { return }
		self.botConstraint.isActive = false
		self.topConstraint.isActive = true
		UIView.animate(withDuration: animDuration, delay: 0.0, options: .curveEaseInOut) {
			sv.layoutIfNeeded()
		} completion: { [weak self] _ in
			guard let self = self else { return }
			self.timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.animateOut), userInfo: nil, repeats: false)
		}
	}

	private func configurePopup() {
		guard let window = findWindow() else { return }
		
		self.translatesAutoresizingMaskIntoConstraints = false
		window.addSubview(self)
		
		// center horizontally
		self.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true

		// self.bottom above the top of the window (so, out of view)
		botConstraint = self.bottomAnchor.constraint(equalTo: window.topAnchor, constant: -2.0)

		// self.top 32-pts below the top of the window
		topConstraint = self.topAnchor.constraint(equalTo: window.topAnchor, constant: 32.0)
		
		// we start "out of view"
		botConstraint.isActive = true
		
		self.setNeedsLayout()
		self.layoutIfNeeded()
	}
	
	private func configureSwipeGesture() {
		
		let pg = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
		self.addGestureRecognizer(pg)
		
	}
	
	@objc private func handlePan(_ sender: UIPanGestureRecognizer) {
//		if sender.translation(in: self).y < 0 {
			// to avoid multiple calls to animateOut,
			//	only execute if the timer is still running
			if sender.translation(in: self).y < 0, let t = timer, t.isValid {
				t.invalidate()
				animateOut()
			}
//		}
	}
	
}

// MARK: Pan Gesture subclass
// from: https://stackoverflow.com/a/19145354/6257435
//	triggers Pan Gesture Began without waiting for "minimum distance" movement
class ImmediatePanG: UIPanGestureRecognizer {
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
		super.touchesBegan(touches, with: event)
		self.state = .began
	}
}

class PopupView: UIView {
	
	@IBOutlet weak var popupView: UIVisualEffectView!
	@IBOutlet weak var symbol: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	
	// use a Timer instead of chainging animation blocks
	private var timer: Timer?
	
	// anim in/out duration
	private var animDuration: TimeInterval = 0.3
	
	// we'll swap these for the vertical position
	private var topConstraint: NSLayoutConstraint!
	private var botConstraint: NSLayoutConstraint!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		configure()
	}
	
	private func configure() {
		if let views = Bundle.main.loadNibNamed("PopupView", owner: self) {
			guard let view = views.first as? UIView else { return }
			view.translatesAutoresizingMaskIntoConstraints = false
			addSubview(view)
			
			NSLayoutConstraint.activate([
				
				// constrain view loaded from xib to fill self
				view.topAnchor.constraint(equalTo: topAnchor, constant: 0.0),
				view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.0),
				view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0.0),
				view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0.0),
				
			])
		}
	}
	
	func findWindow() -> UIWindow? {
		let scenes = UIApplication.shared.connectedScenes
		guard let windowScene = scenes.first as? UIWindowScene,
			  let window = windowScene.windows.first
		else {
			return nil
		}
		return window
	}
	
	func showPopup(title: String, message: String, symbol: UIImage) {
		self.titleLabel.text = title
		self.descriptionLabel.text = message
		self.symbol.image = symbol
		
		// make sure background is clear so the VFX view works
		self.backgroundColor = .clear
		
		self.layer.cornerRadius = 20
		self.clipsToBounds = true
		
		configurePopup()
		configureSwipeGesture()
		
		// need to trigger animateIn *after* layout
		DispatchQueue.main.async {
			self.animateIn()
		}
	}
	
	@objc private func animateOut() {
		guard let sv = self.superview else { return }
		self.topConstraint.isActive = false
		self.botConstraint.isActive = true
		UIView.animate(withDuration: animDuration, delay: 0.0, options: .curveEaseInOut) {
			sv.layoutIfNeeded()
		} completion: { [weak self] _ in
			guard let self = self else { return }
			self.removeFromSuperview()
		}
	}
	private func animateIn() {
		guard let sv = self.superview else { return }
		self.botConstraint.isActive = false
		self.topConstraint.isActive = true
		UIView.animate(withDuration: animDuration, delay: 0.0, options: .curveEaseInOut) {
			sv.layoutIfNeeded()
		} completion: { [weak self] _ in
			guard let self = self else { return }
			self.timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.animateOut), userInfo: nil, repeats: false)
		}
	}
	
	private func configurePopup() {
		guard let window = findWindow() else { return }
		
		self.translatesAutoresizingMaskIntoConstraints = false
		window.addSubview(self)
		
		// center horizontally
		self.centerXAnchor.constraint(equalTo: window.centerXAnchor).isActive = true
		
		// self.bottom above the top of the window (so, out of view)
		botConstraint = self.bottomAnchor.constraint(equalTo: window.topAnchor, constant: -2.0)
		
		// self.top 32-pts below the top of the window
		topConstraint = self.topAnchor.constraint(equalTo: window.topAnchor, constant: 32.0)
		
		// we start "out of view"
		botConstraint.isActive = true
		
		self.setNeedsLayout()
		self.layoutIfNeeded()
	}
	
	private func configureSwipeGesture() {
		
		// let's use a Pan Gesture instead of Swipe
		//	to make it more responsive
		let pg = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
		self.addGestureRecognizer(pg)
		
	}
	
	@objc private func handlePan(_ sender: UIPanGestureRecognizer) {
		// to avoid multiple calls to animateOut,
		//	only execute if the timer is still running
		if sender.translation(in: self).y < 0, let t = timer, t.isValid {
			t.invalidate()
			animateOut()
		}
	}
	
}

class origPopupView: UIView {
	
	var cb: ((CGRect, CGRect) -> ())?
	
	@IBOutlet weak var popupView: UIVisualEffectView!
	@IBOutlet weak var symbol: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	
	private var isRemovedByTap = false
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		configure()
	}
	
	private func configure() {
		if let views = Bundle.main.loadNibNamed("PopupView", owner: self) {
			guard let view = views.first as? UIView else { return }
			//self.frame = CGRect(x: 10, y: 10, width: 300, height: 120)
			//self.backgroundColor = .red
			view.frame = bounds
			addSubview(view)
		}
	}
	
	private func configurePopup() {
		guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else { return }
		popupView.layer.cornerRadius = 20
		popupView.clipsToBounds = true
		popupView.center.x = window.frame.midX
		popupView.translatesAutoresizingMaskIntoConstraints = true
		popupView.isUserInteractionEnabled = false
		window.addSubview(popupView)
		//print(popupView.frame)
	}
	
	var yAdjustment: CGFloat = 0
	
	private func animatePopup() {
		UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveLinear) {
			self.popupView.center.y += 34
			// save the top of the popupView frame
			self.yAdjustment = self.popupView.frame.origin.y
		} completion: { _ in
			UIView.animate(withDuration: 0.15, delay: 1000.0, options: .curveLinear) {
				self.popupView.center.y -= 50
			} completion: { _ in
				if !self.isRemovedByTap {
					self.popupView.removeFromSuperview()
				}
			}
		}
	}
	
	private func configureTapGesture() {
		guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else { return }

		//let swipe = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipes(_:)))
		let swipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(_:)))
		swipe.direction = .up
		window.addGestureRecognizer(swipe)

		let t = UITapGestureRecognizer(target: self, action: #selector(handleTaps(_:)))
		window.addGestureRecognizer(t)
	}

	@objc private func handleTaps(_ sender: UITapGestureRecognizer) {
		
		guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else { return }
		let tappedArea = sender.location(in: popupView)
		let popupFrame = CGRect(x: tappedArea.x, y: tappedArea.y, width: popupView.frame.width, height: popupView.frame.height)
		let b = window.frame.contains(popupFrame)
		print(#function, tappedArea, b)
		cb?(popupFrame, window.frame)
		return()
		
		var loc = sender.location(in: popupView)
		// adjust the touch y
		loc.y -= (yAdjustment - popupView.frame.origin.y)
		print("y tap:", loc, popupView.bounds)
		print(popupView.frame)
//		let r = popupView.frame.offsetBy(dx: -popupView.frame.origin.x, dy: (popupView.frame.size.height * 0.5) + 50.0)
//		print(loc, r)
		print(popupView.bounds.contains(loc))
	}
	
	@objc private func handleSwipes(_ sender:UISwipeGestureRecognizer) {

		// get location of swipe
		var loc = sender.location(in: popupView)

		// adjust the touch y
		loc.y -= (yAdjustment - popupView.frame.origin.y)

		// get the view bounds
		let r = popupView.bounds
		
		// only do this if
		//	swipe direct is up
		//	AND
		//	swipe location is inside popupView
		if sender.direction == .up, r.contains(loc) {
			UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveLinear) {
				self.popupView.center.y -= 50
			} completion: { _ in
				self.popupView.removeFromSuperview()
			}
			self.isRemovedByTap = true
		}
		
	}
	
	@objc private func didSwipe(_ sender:UISwipeGestureRecognizer) {
		guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else { return }
		let tappedArea = sender.location(in: popupView)
		let popupFrame = CGRect(x: tappedArea.x, y: tappedArea.y, width: popupView.frame.width, height: popupView.frame.height)
		print(#function, tappedArea)
		if sender.direction == .up, window.frame.contains(popupFrame) {
			UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveLinear) {
				self.popupView.center.y -= 50
			} completion: { _ in
				self.popupView.removeFromSuperview()
			}
			//self.isRemovedBySwipe = true
		}
	}
	
	func showPopup(title: String, message: String, symbol: UIImage) {
		titleLabel.text = title
		descriptionLabel.text = message
		self.symbol.image = symbol
		
		configurePopup()
		animatePopup()
		configureTapGesture()
	}
}
