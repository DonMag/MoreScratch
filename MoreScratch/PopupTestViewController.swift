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

class ButtonGridVC: UIViewController {
	
	// vertical axis stack view to hold the "row" stack views
	let outerStack: UIStackView = {
		let v = UIStackView()
		v.axis = .vertical
		v.distribution = .fillEqually
		v.translatesAutoresizingMaskIntoConstraints = false
		return v
	}()

	let promptLabel = UILabel()

	// spacing between buttons
	let gridSpacing: CGFloat = 2.0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// let's add a prompt label and a stepper
		//	for changing the grid size
		let stepperStack = UIStackView()
		stepperStack.spacing = 8
		stepperStack.translatesAutoresizingMaskIntoConstraints = false
		
		let stepper = UIStepper()
		stepper.minimumValue = 2
		stepper.maximumValue = 20
		stepper.addTarget(self, action: #selector(stepperChanged(_:)), for: .valueChanged)
		stepper.setContentCompressionResistancePriority(.required, for: .vertical)
		
		stepperStack.addArrangedSubview(promptLabel)
		stepperStack.addArrangedSubview(stepper)
		
		view.addSubview(stepperStack)
		view.addSubview(outerStack)
		
		let g = view.safeAreaLayoutGuide

		// these constraints at less-than-required priority
		//	will make teh outer stack view as large as will fit
		let cw = outerStack.widthAnchor.constraint(equalTo: g.widthAnchor)
		cw.priority = .required - 1
		let ch = outerStack.heightAnchor.constraint(equalTo: g.heightAnchor)
		ch.priority = .required - 1

		NSLayoutConstraint.activate([
			
			// prompt label and stepper at the top
			stepperStack.topAnchor.constraint(greaterThanOrEqualTo: g.topAnchor, constant: 8.0),
			stepperStack.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			
			// constrain outerStack
			//	square (1:1 ratio)
			outerStack.widthAnchor.constraint(equalTo: outerStack.heightAnchor),

			// don't make it larger than availble space
			outerStack.topAnchor.constraint(greaterThanOrEqualTo: stepperStack.bottomAnchor, constant: gridSpacing),
			outerStack.leadingAnchor.constraint(greaterThanOrEqualTo: g.leadingAnchor, constant: gridSpacing),
			outerStack.trailingAnchor.constraint(lessThanOrEqualTo: g.trailingAnchor, constant: -gridSpacing),
			outerStack.bottomAnchor.constraint(lessThanOrEqualTo: g.bottomAnchor, constant: -gridSpacing),

			// center horizontally and vertically
			outerStack.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			outerStack.centerYAnchor.constraint(equalTo: g.centerYAnchor),
			
			// active width/height constraints created above
			cw, ch,
			
		])

		// spacing between buttons
		outerStack.spacing = gridSpacing
		
		// we'll start with an 11x11 grid
		stepper.value = 11
		makeGrid(11)
	}
	
	@objc func stepperChanged(_ stpr: UIStepper) {
		// stepper changed, so generate new grid
		makeGrid(Int(stpr.value))
	}
	
	func makeGrid(_ n: Int) {
		// grid must be between 2x2 and 20x20
		guard n < 21, n > 1 else {
			print("Invalid grid size: \(n)")
			return
		}
		
		// clear the existing buttons
		outerStack.arrangedSubviews.forEach {
			$0.removeFromSuperview()
		}
		
		// update the prompt label
		promptLabel.text = "Grid Size: \(n)"
		
		// for this example, we'll use a font size of 8 for a 20x20 grid
		//	adjusting it 1-pt larger for each smaller grid size
		let font: UIFont = .systemFont(ofSize: CGFloat(8 + (20 - n)), weight: .light)
		
		// generate grid of buttons
		for _ in 0..<n {
			// create a horizontal "row" stack view
			let rowStack = UIStackView()
			rowStack.spacing = gridSpacing
			rowStack.distribution = .fillEqually
			// add it to the outer stack view
			outerStack.addArrangedSubview(rowStack)
			// create buttons and add them to the row stack view
			for _ in 0..<n {
				let b = UIButton()
				b.backgroundColor = .systemBlue
				b.setTitleColor(.white, for: .normal)
				b.setTitleColor(.lightGray, for: .highlighted)
				b.setTitle("X", for: [])
				b.titleLabel?.font = font
				b.addTarget(self, action: #selector(gotTap(_:)), for: .touchUpInside)
				rowStack.addArrangedSubview(b)
			}
		}
	}
	
	@objc func gotTap(_ btn: UIButton) {
		// if we want a "row, column" reference to the tapped button
		if let rowStack = btn.superview as? UIStackView {
			if let colIdx = rowStack.arrangedSubviews.firstIndex(of: btn),
			   let rowIdx = outerStack.arrangedSubviews.firstIndex(of: rowStack)
			{
				print("Tapped on row: \(rowIdx) column: \(colIdx)")
			}
		}
		
		// animate the tapped button
		UIView.animate(withDuration: 0.5, delay: 0, animations: {
			let rotate = CGAffineTransform(rotationAngle: .pi/2)
			let scale = CGAffineTransform(scaleX: 0.5, y: 0.5)
			btn.transform = rotate.concatenating(scale)
		}, completion: {_ in
			UIView.animate(withDuration: 0.5, animations: {
				btn.transform = CGAffineTransform.identity
			})
		})

	}
	
}

class xShadowPathView: UIView {
	
	let radius: CGFloat = 10
	
	let shadowLayer = CALayer()
	let maskLayer = CAShapeLayer()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {
		
		// these properties don't change
		backgroundColor = .white
		
		layer.cornerRadius = radius
		
		layer.shadowColor = UIColor.red.cgColor
		layer.shadowOpacity = 1.0
		layer.shadowOffset = .zero
		
		// set the layer mask
		layer.mask = maskLayer
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()

		// create a rect bezier path, large enough to exceed the shadow bounds
		let bez = UIBezierPath(rect: bounds.insetBy(dx: -radius * 2.0, dy: -radius * 2.0))
		
		// create a path for the "hole" in the layer
		let holePath = UIBezierPath(rect: bounds.insetBy(dx: radius, dy: radius))
		
		// this "cuts a hole" in the path
		bez.append(holePath)
		bez.usesEvenOddFillRule = true
		maskLayer.fillRule = .evenOdd

		// set the path of the mask layer
		maskLayer.path = bez.cgPath
		
		let w: CGFloat = 5
		// make the shadow rect larger than bounds
		let shadowRect = bounds.insetBy(dx: -w, dy: -w)
		// set the shadow path
		//	make the corner radius larger to make the curves look correct
		layer.shadowPath = UIBezierPath(roundedRect: shadowRect, cornerRadius: radius + w).cgPath

	}
	
}

class ShadowPathView: UIView {
	
	let radius: CGFloat = 10
	
	let shadowLayer = CAShapeLayer()
	let maskLayer = CAShapeLayer()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {
		
		// these properties don't change
		backgroundColor = .clear
		
		layer.addSublayer(shadowLayer)
		
		shadowLayer.fillColor = UIColor.white.cgColor
		shadowLayer.shadowColor = UIColor.red.cgColor
		shadowLayer.shadowOpacity = 1.0
		shadowLayer.shadowOffset = .zero
		
		// set the layer mask
		shadowLayer.mask = maskLayer
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		shadowLayer.frame = bounds
		shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: radius).cgPath
		
		// create a rect bezier path, large enough to exceed the shadow bounds
		let bez = UIBezierPath(rect: bounds.insetBy(dx: -radius * 2.0, dy: -radius * 2.0))
		
		// create a path for the "hole" in the layer
		let holePath = UIBezierPath(rect: bounds.insetBy(dx: radius, dy: radius))
		
		// this "cuts a hole" in the path
		bez.append(holePath)
		bez.usesEvenOddFillRule = true
		maskLayer.fillRule = .evenOdd
		
		// set the path of the mask layer
		maskLayer.path = bez.cgPath
		
		let w: CGFloat = 5
		// make the shadow rect larger than bounds
		let shadowRect = bounds.insetBy(dx: -w, dy: -w)
		// set the shadow path
		//	make the corner radius larger to make the curves look correct
		shadowLayer.shadowPath = UIBezierPath(roundedRect: shadowRect, cornerRadius: radius + w).cgPath
		
	}
	
}

class zShadowPathVC: UIViewController {

	// two of our custom ShadowPathView
	let v1 = ShadowPathView()
	let v2 = ShadowPathView()
	
	// a label to put UNDER the second view
	let underLabel = UILabel()
	
	// a label to add as a SUVBVIEW of the second view
	let subLabel = UILabel()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = UIColor(red: 0.8, green: 0.92, blue: 0.97, alpha: 1.0)
		
		[underLabel, subLabel].forEach { v in
			v.textAlignment = .center
			v.backgroundColor = .green
		}
		[v1, v2, underLabel, subLabel].forEach { v in
			v.translatesAutoresizingMaskIntoConstraints = false
		}
		[v1, underLabel, v2].forEach { v in
			view.addSubview(v)
		}
		v2.addSubview(subLabel)
		underLabel.text = "This label is Under the shadow view"
		subLabel.text = "This label is a subview of the shadow view"
		subLabel.numberOfLines = 0

		let g = view.safeAreaLayoutGuide
		
		NSLayoutConstraint.activate([
			
			v1.topAnchor.constraint(equalTo: g.topAnchor, constant: 40.0),
			v1.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 40.0),
			v1.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -40.0),
			v1.heightAnchor.constraint(equalToConstant: 120.0),

			v2.topAnchor.constraint(equalTo: v1.bottomAnchor, constant: 80.0),
			v2.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 40.0),
			v2.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -40.0),
			v2.heightAnchor.constraint(equalToConstant: 160.0),
			
			underLabel.leadingAnchor.constraint(equalTo: v2.leadingAnchor, constant: -20.0),
			underLabel.topAnchor.constraint(equalTo: v2.topAnchor, constant: -20.0),
			underLabel.heightAnchor.constraint(equalToConstant: 80.0),
			
			subLabel.bottomAnchor.constraint(equalTo: v2.bottomAnchor, constant: -12.0),
			subLabel.trailingAnchor.constraint(equalTo: v2.trailingAnchor, constant: -40.0),
			subLabel.widthAnchor.constraint(equalToConstant: 120.0),
			
		])
		
	}
}

class ShadowPathVC: UIViewController {

	let sampleTitles: [[String]] = [
		["Left", "Right"],
		["Left", "Right title is longer"],
		["Left title is longer", "Right"],
		["Left title", "Right button has longer title"],

	]
	
	let b1 = UIButton()
	let b2 = UIButton()
	
	var wConstraint: NSLayoutConstraint!
	var idx: Int = 0

	let b3 = UIButton()
	let b4 = UIButton()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		b1.setTitle("Short title", for: [])
		b2.setTitle("This is a long title", for: [])
		
		let g = view.safeAreaLayoutGuide
		
		[b1, b2, b3, b4].forEach { b in
			b.backgroundColor = .red
			b.titleLabel?.font = .systemFont(ofSize: 30.0, weight: .regular)
			b.titleLabel?.adjustsFontSizeToFitWidth = true
			b.titleLabel?.minimumScaleFactor = 0.5
			b.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview(b)
		}

		let maxWidth: CGFloat = 200.0
		let sp: CGFloat = 8.0
		
		b1.sizeToFit()
		b2.sizeToFit()
		let factor = b1.frame.width / b2.frame.width

		wConstraint = b1.widthAnchor.constraint(equalTo: b2.widthAnchor, multiplier: factor)
		
		let stackView = UIStackView()
		stackView.distribution = .fillProportionally
		stackView.spacing = 20 // change space betwenn buttons
		stackView.translatesAutoresizingMaskIntoConstraints = false
		
		stackView.addArrangedSubview(b3)
		stackView.addArrangedSubview(b4)

		view.addSubview(stackView)

		
		NSLayoutConstraint.activate([

			b1.topAnchor.constraint(equalTo: g.topAnchor, constant: 20.0),
			b2.topAnchor.constraint(equalTo: g.topAnchor, constant: 20.0),

			b1.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 40.0),
			b2.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -40.0),
			b2.leadingAnchor.constraint(equalTo: b1.trailingAnchor, constant: 8.0),
			
			wConstraint,

			stackView.topAnchor.constraint(equalTo: g.topAnchor, constant: 100),
			stackView.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 40),
			stackView.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -40),
			stackView.heightAnchor.constraint(equalToConstant: 50),

		])
		
		
		print(b1.frame, b2.frame)
		
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

		let titles = sampleTitles[idx % sampleTitles.count]
		idx += 1
		
		b1.setTitle(titles[0], for: [])
		b2.setTitle(titles[1], for: [])

		b1.sizeToFit()
		b2.sizeToFit()

		print(b1.frame, b2.frame)

		let factor = b1.frame.width / b2.frame.width

		wConstraint.isActive = false
		wConstraint = b1.widthAnchor.constraint(equalTo: b2.widthAnchor, multiplier: factor)
		wConstraint.isActive = true

		b3.setTitle(titles[0], for: [])
		b4.setTitle(titles[1], for: [])
		

	}
	
}

@objc protocol MQTTDelegate {
	@objc optional func didStart()
	@objc optional func didFinish()
}
class MQTTObject {
	var delegate: MQTTDelegate?
	
	var localTimer: Timer!
	var localCounter = 1
	var isRunning: Bool = false
	
	static let sharedInstance: MQTTObject = {
		let instance = MQTTObject()
		return instance
	}()
	
	func startTimer() {
		self.localCounter = 1
		self.localTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
	}
	@objc func timerFired() {
		self.localCounter += 1
		print(self.localCounter)
		if localCounter % 5 == 0 {
			isRunning.toggle()
			if isRunning {
				delegate?.didStart?()
			} else {
				delegate?.didFinish?()
			}
		}
	}
	private init() {}
	
}

class MenuVC: UIViewController, MQTTDelegate {
	
	let mqtt = MQTTObject.sharedInstance
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// set mqtt delegate to self
		mqtt.delegate = self
		mqtt.startTimer()
	}
	
	// mqtt sends a "player started playing" to its delegate (which is self)
	func didStart() {
		performSegue(withIdentifier: "didStart", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let vc = segue.destination as? NowPlayingVC {
			// set mqtt delegate to the segue destination controller
			mqtt.delegate = vc
		}
	}
	
	@IBAction func unwind( _ seg: UIStoryboardSegue) {
		// set mqtt delegate to self again
		mqtt.delegate = self
	}
}

class NowPlayingVC: UIViewController, MQTTDelegate {
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	// mqtt sends a "player started playing" to its delegate (which is self)
	func didFinish() {
		performSegue(withIdentifier: "unwind", sender: self)
	}
}
