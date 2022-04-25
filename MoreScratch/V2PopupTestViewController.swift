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

class MainView: UIView {
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// ------------------------------------------------
	
	@objc func onLeftAddressTap() {
		print("Left Address Selected")
		leftLabel.isHidden = false
		rightLabel.isHidden = !leftLabel.isHidden
		leftContainerView.layer.borderColor = UIColor.green.cgColor
		rightContainerView.layer.borderColor = UIColor.lightGray.cgColor
	}
	
	@objc func onRightAddressTap() {
		print("Right Address Selected")
		leftLabel.isHidden = true
		rightLabel.isHidden = !leftLabel.isHidden
		rightContainerView.layer.borderColor = UIColor.green.cgColor
		leftContainerView.layer.borderColor = UIColor.lightGray.cgColor
	}
	
	// ------------------------------------------------
	
	let leftLabel = UILabel()
	let rightLabel = UILabel()
	
	let leftContainerView: UIView = {
		let view = UIView(frame: CGRect())
		view.layer.borderWidth = 1.0
		view.layer.borderColor = UIColor.green.cgColor
		return view
	}()
	
	let rightContainerView: UIView = {
		let view = UIView(frame: CGRect())
		view.layer.borderWidth = 1.0
		view.layer.borderColor = UIColor.lightGray.cgColor
		return view
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.backgroundColor = .white
		setupViews()
	}
	
	// ------------------------------------------------
	
	fileprivate func setupAddressStack() -> UIStackView {
		setupLeftAddress()
		setupRightAddress()
		
		// ------------------------------------------------
		// Address StackView:
		
		let addressStackView = UIStackView(arrangedSubviews: [leftContainerView, rightContainerView])
		addressStackView.axis = .horizontal
		addressStackView.spacing = 10
		addressStackView.distribution = .fillEqually
		addressStackView.alignment = .fill
		
		return addressStackView
	}
	
	// ------------------------------------------------
	
	fileprivate func setupViews() {
		// Image Logol
		let ratImageview = UIImageView(image: UIImage(named: "Rat"))
		ratImageview.frame = CGRect(x: 0, y: 0, width: 68, height: 68)
		
		// TitleLabel
		let titleLabel = UILabel(frame: CGRect())
		let titleString = "Where should we send your card?  We'll cancel it and send you a new one."
		titleLabel.text = titleString
		titleLabel.textAlignment = .center
		titleLabel.font = .systemFont(ofSize: 12)
		titleLabel.lineBreakMode = .byWordWrapping
		titleLabel.numberOfLines = 0
		
		// Status Label:
		let statusLabel = UILabel(frame: CGRect())
		let statusString = "Your existing card ending in 0492 will be cancelled and yournew card shoud arrive withi 6 business days via USPS."
		statusLabel.text = statusString
		statusLabel.textAlignment = .center
		statusLabel.font = .systemFont(ofSize: 12)
		statusLabel.lineBreakMode = .byWordWrapping
		statusLabel.numberOfLines = 0
		
		// ------------------------------------------------
		// Container SackView:
		let ContainerStackView = UIStackView(arrangedSubviews: [titleLabel, setupAddressStack(), statusLabel])
		ContainerStackView.axis = .vertical
		//ContainerStackView.distribution = .fillEqually
		ContainerStackView.distribution = .fill
		ContainerStackView.spacing = 20
		
		// Logo:
		addSubview(ratImageview)
		ratImageview.translatesAutoresizingMaskIntoConstraints = false
		ratImageview.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
		ratImageview.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
		
		// StackView:
		addSubview(ContainerStackView)
		
		ContainerStackView.translatesAutoresizingMaskIntoConstraints = false
		ContainerStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
		ContainerStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 75).isActive = true
		ContainerStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
		ContainerStackView.bottomAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true
	}
}

// ==============================================================================================

private extension MainView {
	func setupLeftAddress() {
		// LeftLabel:
		leftLabel.numberOfLines = 0
		leftLabel.text = "Mother had a feeling, I might be too appealing."
		leftLabel.font = UIFont.systemFont(ofSize: 9)
		leftLabel.adjustsFontSizeToFitWidth = true
		leftLabel.isHidden = false
		
		leftContainerView.addSubview(leftLabel)
		
		leftContainerView.heightAnchor.constraint(equalTo: leftContainerView.widthAnchor).isActive = true
		
		leftLabel.translatesAutoresizingMaskIntoConstraints = false
		leftLabel.leftAnchor.constraint(equalTo: leftContainerView.leftAnchor, constant: 10).isActive = true
		leftLabel.rightAnchor.constraint(equalTo: leftContainerView.rightAnchor, constant: -10).isActive = true
		leftLabel.centerYAnchor.constraint(equalTo: leftContainerView.centerYAnchor).isActive = true
		
		let leftButton = UIButton()
		leftButton.addTarget(self, action: #selector(onLeftAddressTap), for: .touchUpInside)
		
		leftContainerView.addSubview(leftButton)
		
		leftButton.translatesAutoresizingMaskIntoConstraints = false
		leftButton.leftAnchor.constraint(equalTo: leftContainerView.leftAnchor).isActive = true
		leftButton.rightAnchor.constraint(equalTo: leftContainerView.rightAnchor).isActive = true
		leftButton.topAnchor.constraint(equalTo: leftContainerView.topAnchor).isActive = true
		leftButton.bottomAnchor.constraint(equalTo: leftContainerView.bottomAnchor).isActive = true
	}
	
	func setupRightAddress() {
		rightLabel.numberOfLines = 0
		rightLabel.text = "This is the right label."
		rightLabel.font = UIFont.systemFont(ofSize: 9)
		rightLabel.adjustsFontSizeToFitWidth = true
		rightLabel.isHidden = true
		
		rightContainerView.addSubview(rightLabel)
		
		rightContainerView.heightAnchor.constraint(equalTo: rightContainerView.widthAnchor).isActive = true

		rightLabel.translatesAutoresizingMaskIntoConstraints = false
		rightLabel.leftAnchor.constraint(equalTo: rightContainerView.leftAnchor, constant: 10).isActive = true
		rightLabel.rightAnchor.constraint(equalTo: rightContainerView.rightAnchor, constant: -10).isActive = true
		rightLabel.centerYAnchor.constraint(equalTo: rightContainerView.centerYAnchor).isActive = true
		
		let rightButton = UIButton()
		rightButton.addTarget(self, action: #selector(onRightAddressTap), for: .touchUpInside)
		rightContainerView.addSubview(rightButton)
		rightButton.translatesAutoresizingMaskIntoConstraints = false
		
		rightButton.leftAnchor.constraint(equalTo: rightContainerView.leftAnchor).isActive = true
		rightButton.rightAnchor.constraint(equalTo: rightContainerView.rightAnchor).isActive = true
		rightButton.topAnchor.constraint(equalTo: rightContainerView.topAnchor).isActive = true
		rightButton.bottomAnchor.constraint(equalTo: rightContainerView.bottomAnchor).isActive = true
	}
}

class MainViewTestVC: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()

		
		//let tv = FloatingLabelTextView.init("Public Bio")
		let tv = FloatingLabelTextView()
		//let tv = GrrView()

		tv.addTitle("Testing 1 2 3")
		tv.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(tv)
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			tv.topAnchor.constraint(equalTo: g.topAnchor, constant: 40.0),
			tv.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 40.0),
			tv.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -40.0),
			tv.heightAnchor.constraint(equalToConstant: 160.0),
		])
	}
}

class GrrView: UIView {

	let textViewBorder = CAShapeLayer()
	let titleLabel = UILabel()

	override func layoutSubviews() {
		super.layoutSubviews()
		print(bounds)
		let bez = UIBezierPath(roundedRect: self.bounds, cornerRadius: 7)
		textViewBorder.path = bez.cgPath
	}
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {
		self.layer.cornerRadius = 7
		self.layer.addSublayer(textViewBorder)
		textViewBorder.strokeColor = UIColor.red.cgColor
		textViewBorder.fillColor = UIColor.clear.cgColor
	}
	
	func addTitle(_ title: String) {
	}

}
class FloatingLabelTextView: UITextView {
	var sTitle: String = "Test"
	let textViewBorder = CAShapeLayer()
	let titleLabel = UILabel()

	override func layoutSubviews() {
		print(#function, bounds)
		super.layoutSubviews()
		let bez = UIBezierPath(roundedRect: self.bounds, cornerRadius: 7)
		textViewBorder.path = bez.cgPath

	}
	override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)
		commonInit()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
//	convenience init(_ title: String) {
//		self.init(frame: .zero, textContainer: nil)
//		self.layer.cornerRadius = 7
//		self.sTitle = title
//		self.layer.addSublayer(textViewBorder)
//		textViewBorder.strokeColor = UIColor.red.cgColor
//		textViewBorder.fillColor = UIColor.clear.cgColor
//		self.createFloatingLabel()
//		self.clipsToBounds = false
//	}

	func commonInit() {
		self.layer.cornerRadius = 7
		self.layer.addSublayer(textViewBorder)
		textViewBorder.strokeColor = UIColor.red.cgColor
		textViewBorder.fillColor = UIColor.clear.cgColor
		//self.createFloatingLabel()
		//self.clipsToBounds = false
	}

	func addTitle(_ title: String) {
		self.sTitle = title
		titleLabel.text = " " + sTitle + " "
	}

	func createFloatingLabel() {
		titleLabel.textColor = .blue
		titleLabel.backgroundColor = .white
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		addSubview(titleLabel)
		NSLayoutConstraint.activate([
			titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0),
			titleLabel.centerYAnchor.constraint(equalTo: topAnchor),
		])
		titleLabel.text = " " + sTitle + " "
		return()

		titleLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		titleLabel.sizeToFit()

		titleLabel.adjustsFontSizeToFitWidth = true
		titleLabel.frame = CGRect(x: 16, y: -7.5, width: 32, height: 15)
		titleLabel.text = "test" //sTitle
		self.addSubview(titleLabel)
		//self.textViewBorder.addSublayer(titleLabel.layer)
		//print(titleLabel.layer.frame)
		return()

		/* some styling code */
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		addSubview(titleLabel)
		NSLayoutConstraint.activate([
			titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20.0),
			titleLabel.centerYAnchor.constraint(equalTo: topAnchor),
		])
//		titleLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//		titleLabel.sizeToFit()
//		titleLabel.adjustsFontSizeToFitWidth = true
//		titleLabel.frame = CGRect(x: 16, y: -7.5, width: 32, height: 15)
		titleLabel.text = sTitle
//		self.layer.insertSublayer(titleLabel.layer, above: textViewBorder)
	}
	
}


class FloraCell: UITableViewCell {
	
	let contentStack: UIStackView = {
		var view = UIStackView()
		view.axis = .horizontal
		view.spacing = 16
		view.distribution = .equalSpacing
		view.alignment = .top
		view.alignment = .center
		view.translatesAutoresizingMaskIntoConstraints  = false
		return view }()
	
	let labelStack: UIStackView = {
		var view = UIStackView()
		view.axis = .vertical
		view.spacing = 5
		view.translatesAutoresizingMaskIntoConstraints = false
		view.distribution = .fill // .fillProportionally
		return view }()
	
	let titleLabel: UILabel = {
		let v = UILabel()
		v.font = .systemFont(ofSize: 15, weight: .bold)
		return v
	}()
	let descriptionLabel: UILabel = {
		let v = UILabel()
		v.numberOfLines = 0
		v.font = .systemFont(ofSize: 13, weight: .light)
		return v
	}()
	let iconView = UIImageView()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupUI()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupUI()
	}
	func setupUI() {
		contentView.addSubview(contentStack)
		labelStack.addArrangedSubview(titleLabel)
		labelStack.addArrangedSubview(descriptionLabel)
		contentStack.addArrangedSubview(labelStack)
		contentStack.addArrangedSubview(iconView)
		
		NSLayoutConstraint.activate([
			
			iconView.heightAnchor.constraint(equalToConstant: 80),
			iconView.widthAnchor.constraint(equalToConstant: 80),
			
			contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
			contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
			contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
			
		])

		titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
		descriptionLabel.setContentCompressionResistancePriority(.required, for: .vertical)
		
		[titleLabel, descriptionLabel].forEach { v in
			v.setContentCompressionResistancePriority(.required, for: .vertical)
			v.backgroundColor = .cyan
		}
		iconView.backgroundColor = .systemYellow
	}
	func fillData(_ d: MyDataStruct) {
		titleLabel.text = d.title
		descriptionLabel.text = d.desc
		if !d.imgName.isEmpty {
			if let img = UIImage(systemName: "\(d.imgName).circle") {
				iconView.image = img
			}
		}
		iconView.isHidden = d.imgName.isEmpty
	}
}

class FloraTableVC: UITableViewController {

	var myData: [MyDataStruct] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		myData = SampleData().getSampleData()

		tableView.register(FloraCell.self, forCellReuseIdentifier: "cell")
		
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return myData.count
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let c = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FloraCell
		c.fillData(myData[indexPath.row])
		return c
	}
}

class RevealView: UIView {
	
	public var image: UIImage? {
		didSet {
			imgLayer.contents = image?.cgImage
		}
	}
	public var duration: TimeInterval = 1.0
	
	private let gradLayer = CAGradientLayer()
	private let imgLayer = CALayer()

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	private func commonInit() {

		clipsToBounds = true

		layer.addSublayer(imgLayer)
		imgLayer.contentsGravity = .resize
		
		// white area shows through, clear area is "hidden"
		gradLayer.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
		// left-to-right gradient
		gradLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
		gradLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
		// start locations so entire layer is masked
		gradLayer.locations = [0.0, 0.0]
		// set the mask
		layer.mask = gradLayer
		
	}
	override func layoutSubviews() {
		super.layoutSubviews()

		// set image layer frame to view bounds
		imgLayer.frame = bounds
		// move it half-way to the right
		imgLayer.position.x = bounds.maxX
		// set gradient layer frame to view bounds
		gradLayer.frame = bounds
	}
	
	public func doAnim() {
		
		let imgAnim = CABasicAnimation(keyPath: "position.x")
		let gradAnim = CABasicAnimation(keyPath: "locations")
		
		// animate image layer from right-to-left
		imgAnim.toValue = bounds.midX
		// animate gradient from left-to-right
		gradAnim.toValue = [NSNumber(value: 1.0), NSNumber(value: 2.0)]

		imgAnim.duration = self.duration
		gradAnim.duration = imgAnim.duration * 2.0
		
		[imgAnim, gradAnim].forEach { anim in
			anim.isRemovedOnCompletion = false
			anim.fillMode = .forwards
			anim.beginTime = CACurrentMediaTime()
		}
		
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		
		imgLayer.add(imgAnim, forKey: nil)
		gradLayer.add(gradAnim, forKey: nil)
		
		CATransaction.commit()

	}
}

class xRevealVC: UIViewController {
	
	let testView = RevealView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		guard let img = UIImage(named: "mt") else {
			fatalError("Could not load image!")
		}
		testView.image = img
		
		// use longer or shorter animation duration if desired (default is 1.0)
		//testView.duration = 3.0
		
		testView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(testView)
		
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			testView.topAnchor.constraint(equalTo: g.topAnchor, constant: 20.0),
			testView.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			testView.widthAnchor.constraint(equalToConstant: img.size.width),
			testView.heightAnchor.constraint(equalToConstant: img.size.height),
		])
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		testView.doAnim()
	}
}


class RevealVC: UIViewController {
	
	let cv = UIView()
	let av = UIView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		cv.backgroundColor = .systemRed
		av.backgroundColor = .systemBlue
		
		cv.frame = CGRect(x: 100, y: 100, width: 80, height: 80)
		av.frame = CGRect(x: 60, y: 200, width: 160, height: 160)
		
		view.addSubview(cv)
		view.addSubview(av)
		
		let g = UILongPressGestureRecognizer(target: self, action: #selector(lp(_:)))
		cv.addGestureRecognizer(g)
		
	}
	
	@objc func lp(_ g: UILongPressGestureRecognizer) {
//		if g.state == .began {
//			av.addSubview(cv)
//		}
		switch g.state {
			
		case .possible:
			()
		case .began:
			cv.removeFromSuperview()
			av.addSubview(cv)
		case .changed:
			print("changed")
		case .ended:
			print("end")
		case .cancelled:
			print("canc")
		case .failed:
			print("fail")
		@unknown default:
			print("un")

		}
	}
}

class MainScrenenViewController: UIViewController {
	
	var currentIndex: Int = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .yellow
		
		let label = UILabel()
		label.text = "\(currentIndex)"
		label.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(label)
		label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
	}
}

class PageViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
	
	var pageControl = UIPageControl.appearance()
	
	var pageController: UIPageViewController!
	
	var controllers = [UIViewController]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		pageController = UIPageViewController(transitionStyle: .scroll,
											  navigationOrientation: .horizontal,
											  options: nil)
		pageController.delegate = self
		pageController.dataSource = self
		
		addChild(pageController)
		view.addSubview(pageController.view)
		pageController.didMove(toParent: self)

		let views = ["pageController": pageController.view] as [String: AnyObject]
		view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[pageController]|", options: [], metrics: nil, views: views))
		view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[pageController]|", options: [], metrics: nil, views: views))
		
		for i in 0..<8 {
			
			let mainScreenViewController = MainScrenenViewController()
			mainScreenViewController.currentIndex = i
			self.controllers.append(mainScreenViewController)
		}
		
		pageController.setViewControllers([controllers[0]], direction: .forward, animated: false)
		
		setupPageControl()
	}
	
	func setupPageControl() {
		
		pageControl = UIPageControl(frame: CGRect(x: 0,y: 100,width: UIScreen.main.bounds.width,height: 50))
		pageControl.numberOfPages = self.controllers.count
		pageControl.tintColor = UIColor.lightGray
		pageControl.pageIndicatorTintColor = UIColor.lightGray
		pageControl.currentPageIndicatorTintColor = UIColor.black
		pageControl.backgroundColor = UIColor.clear
		view.addSubview(pageControl)
		
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

class Row {
	var attributes = [UICollectionViewLayoutAttributes]()
	var spacing: CGFloat = 0
	
	init(spacing: CGFloat) {
		self.spacing = spacing
	}
	
	func add(attribute: UICollectionViewLayoutAttributes) {
		attributes.append(attribute)
	}
	
	func tagLayout(collectionViewWidth: CGFloat) {
		let padding = 0
		var offset = padding
		for attribute in attributes {
			attribute.frame.origin.x = CGFloat(offset)
			offset += Int(attribute.frame.width + spacing)
		}
	}
}

class LeftAlignTagCollectionViewFlowLayout: UICollectionViewFlowLayout {
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		guard let attributes = super.layoutAttributesForElements(in: rect) else {
			return nil
		}
		
		var rows = [Row]()
		var currentRowY: CGFloat = -1
		
		for attribute in attributes {
			if currentRowY != attribute.frame.origin.y {
				currentRowY = attribute.frame.origin.y
				rows.append(Row(spacing: 4))
			}
			rows.last?.add(attribute: attribute)
		}
		
		rows.forEach {
			$0.tagLayout(collectionViewWidth: collectionView?.frame.width ?? 0)
		}
		return rows.flatMap { $0.attributes }
	}
}

class IntrinsicHeightCollectionView: UICollectionView {
	override var intrinsicContentSize: CGSize {
		return contentSize
	}
}
class CollectionTableViewCell: UITableViewCell {
	@IBOutlet weak var collectionView: IntrinsicHeightCollectionView!
//	@IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint! // Required priority (1000)
	
	private var collectionItem: [String] = []
	
	override func awakeFromNib() {
		super.awakeFromNib()
		setupCollectionView()
		collectionView.dataSource = self
		collectionView.delegate = self
		let layout = LeftAlignTagCollectionViewFlowLayout()
		layout.estimatedItemSize = CGSize(width: 140, height: 40)
		collectionView.collectionViewLayout = layout
		
		collectionView.backgroundColor = .yellow
	}

	func setTagCount(n: Int) {

		print("cvw:", collectionView.frame.width)
		
		// some sample "tags" from Stack Overflow
		let sampleTags: [String] = [
			"asp.net-core",
			"asp.net-mvc",
			"asp.net",
			"azure",
			"bash",
			"c",
			"c#",
			"c++",
			"class",
			"codeigniter",
			"cordova",
			"css",
			"csv",
			"dart",
			"database",
			"dataframe",
		]

		let tags = sampleTags.shuffled()

		collectionItem = []
		
		for i in 0..<n {
			//collectionItem.append("\(tags[i % tags.count]) \(i + 1)")
			collectionItem.append(sampleTags[i % sampleTags.count])
		}

	}
	
	func setupCell(showFirstItem: Bool, showSecondItem: Bool)  {
		setupCollectionItem(showFirstItem: showFirstItem, showSecondItem: showSecondItem)
	}
	
	private func setupCollectionItem(showFirstItem: Bool, showSecondItem: Bool) {
		collectionItem = []
		if showFirstItem {
			let data = "TagNumber1"
			collectionItem.append(data)
		}
		
		if showSecondItem {
			let data = "TagNumber2"
			collectionItem.append(data)
		}
		
		for i in 11...15 {
			collectionItem.append("Tag \(i)")
		}
		
	}
	
	override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
		//force layout of all subviews including RectsView, which
		//updates RectsView's intrinsic height, and thus height of a cell
		self.setNeedsLayout()
		self.layoutIfNeeded()
		
		//now intrinsic height is correct, so we can call super method
		return super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
	}

}

extension CollectionTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	private func setupCollectionView() {
		//collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
		collectionView.register(UINib(nibName: "ColViewXibCell", bundle: nil), forCellWithReuseIdentifier: "ColViewXibCell")
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		print(collectionItem.count)
		return collectionItem.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		//let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColViewXibCell", for: indexPath) as! ColViewXibCell
		cell.configCell(model: collectionItem[indexPath.row], maxWidth: collectionView.frame.width - 8)
		cell.setNeedsLayout()
		cell.layoutIfNeeded()
		return cell
	}
}

class CodeCollectionTableViewCell: UITableViewCell {
	
	var collectionView: IntrinsicHeightCollectionView!
	var collectionViewHeightConstraint: NSLayoutConstraint! // Required priority (1000)
	
	private var collectionItem: [String] = []
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		commonInit()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {

		let layout = LeftAlignTagCollectionViewFlowLayout()
		layout.estimatedItemSize = CGSize(width: 140, height: 40)
		collectionView = IntrinsicHeightCollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(collectionView)
		let g = contentView.layoutMarginsGuide
		collectionViewHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 200.0)
		collectionViewHeightConstraint.priority = .required - 1
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: g.topAnchor),
			collectionView.leadingAnchor.constraint(equalTo: g.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: g.trailingAnchor),
			collectionView.bottomAnchor.constraint(equalTo: g.bottomAnchor),
			collectionViewHeightConstraint,
		])

		setupCollectionView()
		collectionView.dataSource = self
		collectionView.delegate = self
		
		collectionView.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0)
	}
	
//	override func awakeFromNib() {
//		super.awakeFromNib()
//		setupCollectionView()
//		collectionView.dataSource = self
//		collectionView.delegate = self
//		let layout = LeftAlignTagCollectionViewFlowLayout()
//		layout.estimatedItemSize = CGSize(width: 140, height: 40)
//		collectionView.collectionViewLayout = layout
//
//		collectionView.backgroundColor = .yellow
//	}
	
	func setTagCount(n: Int) {
		
		print("cvw:", collectionView.frame.width)
		
		// some sample "tags" from Stack Overflow
		let sampleTags: [String] = [
			"asp.net-core",
			"asp.net-mvc",
			"asp.net",
			"azure",
			"bash",
			"c",
			"c#",
			"c++",
			"class",
			"codeigniter",
			"cordova",
			"css",
			"csv",
			"dart",
			"database",
			"dataframe",
		]
		
		collectionItem = []
		
		for i in 0..<n {
			//collectionItem.append("\(tags[i % tags.count]) \(i + 1)")
			collectionItem.append(sampleTags[i % sampleTags.count])
		}
		
	}
	
	func setupCell(showFirstItem: Bool, showSecondItem: Bool)  {
		setupCollectionItem(showFirstItem: showFirstItem, showSecondItem: showSecondItem)
	}
	
	private func setupCollectionItem(showFirstItem: Bool, showSecondItem: Bool) {
		collectionItem = []
		if showFirstItem {
			let data = "TagNumber1"
			collectionItem.append(data)
		}
		
		if showSecondItem {
			let data = "TagNumber2"
			collectionItem.append(data)
		}
		
		for i in 11...15 {
			collectionItem.append("Tag \(i)")
		}
		
	}
	
	override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
		//force layout of all subviews including RectsView, which
		//updates RectsView's intrinsic height, and thus height of a cell
		self.setNeedsLayout()
		self.layoutIfNeeded()
		
		let sz = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
		print("t:", targetSize, "sz:", sz)
		//now intrinsic height is correct, so we can call super method
		return super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
	}
	
}

extension CodeCollectionTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	private func setupCollectionView() {
		//collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
		collectionView.register(UINib(nibName: "ColViewXibCell", bundle: nil), forCellWithReuseIdentifier: "ColViewXibCell")
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		print(collectionItem.count)
		return collectionItem.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		//let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColViewXibCell", for: indexPath) as! ColViewXibCell
		cell.configCell(model: collectionItem[indexPath.row], maxWidth: collectionView.frame.width - 8)
		cell.setNeedsLayout()
		cell.layoutIfNeeded()
		return cell
	}
}

class CollectionViewCell: UICollectionViewCell {
	
	@IBOutlet weak var theLabel: UILabel!
	
	func configCell(model: String, maxWidth: CGFloat) {
		theLabel.text = model
	}
	
}

class ColViewXibCell: UICollectionViewCell {
	
	@IBOutlet weak var theLabel: UILabel!
	
	func configCell(model: String, maxWidth: CGFloat) {
		theLabel.text = model
	}
	
}

class CViewInTViewVC: UITableViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.register(CodeCollectionTableViewCell.self, forCellReuseIdentifier: "CodeCollectionTableViewCell")
		
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		tableView.reloadData()
		//tableView.performBatchUpdates(nil, completion: nil)
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 30
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let c = tableView.dequeueReusableCell(withIdentifier: "CollectionTableViewCell", for: indexPath) as! CollectionTableViewCell

//		let c = tableView.dequeueReusableCell(withIdentifier: "CodeCollectionTableViewCell", for: indexPath) as! CodeCollectionTableViewCell

		c.setTagCount(n: indexPath.row + 1)
		
		c.collectionView.reloadData()
		c.collectionView.invalidateIntrinsicContentSize()
		c.setNeedsLayout()
		c.layoutIfNeeded()
		let height = c.collectionView.collectionViewLayout.collectionViewContentSize.height
		//c.collectionViewHeightConstraint.constant = height
		
		return c
	}
}

class TagLabelsView: UIView {
	
	var tagNames: [String] = [] {
		didSet {
			addTagLabels()
		}
	}
	
	let tagHeight:CGFloat = 30
	let tagPadding: CGFloat = 16
	let tagSpacingX: CGFloat = 8
	let tagSpacingY: CGFloat = 8
	
	var intrinsicHeight: CGFloat = 0
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	
	func commonInit() -> Void {
	}
	
	func addTagLabels() -> Void {
		
		// if we already have tag labels (or buttons, etc)
		//  remove any excess (e.g. we had 10 tags, new set is only 7)
		while self.subviews.count > tagNames.count {
			self.subviews[0].removeFromSuperview()
		}
		
		// if we don't have enough labels, create and add as needed
		while self.subviews.count < tagNames.count {
			
			// create a new label
			let newLabel = UILabel()
			
			// set its properties (title, colors, corners, etc)
			newLabel.textAlignment = .center
			newLabel.backgroundColor = UIColor.cyan
			newLabel.layer.masksToBounds = true
			newLabel.layer.cornerRadius = 8
			newLabel.layer.borderColor = UIColor.red.cgColor
			newLabel.layer.borderWidth = 1
			
			addSubview(newLabel)
			
		}
		
		// now loop through labels and set text and size
		for (str, v) in zip(tagNames, self.subviews) {
			guard let label = v as? UILabel else {
				fatalError("non-UILabel subview found!")
			}
			label.text = str
			label.frame.size.width = label.intrinsicContentSize.width + tagPadding
			label.frame.size.height = tagHeight
		}
		
	}
	
	func displayTagLabels() {
		
		var currentOriginX: CGFloat = 0
		var currentOriginY: CGFloat = 0
		
		// for each label in the array
		self.subviews.forEach { v in
			
			guard let label = v as? UILabel else {
				fatalError("non-UILabel subview found!")
			}
			
			// if current X + label width will be greater than container view width
			//  "move to next row"
			if currentOriginX + label.frame.width > bounds.width {
				currentOriginX = 0
				currentOriginY += tagHeight + tagSpacingY
			}
			
			// set the btn frame origin
			label.frame.origin.x = currentOriginX
			label.frame.origin.y = currentOriginY
			
			// increment current X by btn width + spacing
			currentOriginX += label.frame.width + tagSpacingX
			
		}
		
		// update intrinsic height
		intrinsicHeight = currentOriginY + tagHeight
		invalidateIntrinsicContentSize()
		
	}
	
	// allow this view to set its own intrinsic height
	override var intrinsicContentSize: CGSize {
		var sz = super.intrinsicContentSize
		sz.height = intrinsicHeight
		return sz
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		displayTagLabels()
	}
	
}

class TagsCell: UITableViewCell {
	
	let tagsView: TagLabelsView = {
		let v = TagLabelsView()
		return v
	}()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	
	func commonInit() -> Void {
		
		// add the container view
		contentView.addSubview(tagsView)
		
		// give it a background color so we can see it
		tagsView.backgroundColor = .yellow
		
		// use autolayout
		tagsView.translatesAutoresizingMaskIntoConstraints = false
		
		// constrain tagsView top / leading / trailing / bottom to
		//  contentView Layout Margins Guide
		let g = contentView.layoutMarginsGuide
		
		NSLayoutConstraint.activate([
			tagsView.topAnchor.constraint(equalTo: g.topAnchor, constant: 0.0),
			tagsView.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 0.0),
			tagsView.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: 0.0),
			tagsView.bottomAnchor.constraint(equalTo: g.bottomAnchor, constant: 0.0),
		])
		
	}
	
	func fillData(_ tagNames: [String]) -> Void {
		tagsView.tagNames = tagNames
	}
	
	override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
		//force layout of all subviews including RectsView, which
		//updates RectsView's intrinsic height, and thus height of a cell
		self.setNeedsLayout()
		self.layoutIfNeeded()
		
		//now intrinsic height is correct, so we can call super method
		return super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
	}
	
}

class TagLabelsViewController: UIViewController {
	
	var myData: [[String]] = []
	
	let tableView: UITableView = {
		let v = UITableView()
		return v
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// add the table view
		view.addSubview(tableView)
		
		// use autolayout
		tableView.translatesAutoresizingMaskIntoConstraints = false
		
		let g = view.safeAreaLayoutGuide
		
		NSLayoutConstraint.activate([
			// constrain table view safe-area top / leading / trailing / bottom to view with 20-pts padding
			tableView.topAnchor.constraint(equalTo: g.topAnchor, constant: 20.0),
			tableView.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
			tableView.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -20.0),
			tableView.bottomAnchor.constraint(equalTo: g.bottomAnchor, constant: -20.0),
		])
		
		tableView.register(TagsCell.self, forCellReuseIdentifier: "c")
		tableView.dataSource = self
		tableView.delegate = self
		
		// get some sample tag data
		myData = SampleTags().samples()
	}
	
}

extension TagLabelsViewController: UITableViewDataSource, UITableViewDelegate {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return myData.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let c = tableView.dequeueReusableCell(withIdentifier: "c", for: indexPath) as! TagsCell
		c.fillData(myData[indexPath.row])
		return c
	}
}

class SampleTags: NSData {
	func samples() -> [[String]] {
		
		let tmp: [[String]] = [
			[
				".htaccess",
				".net",
				"ajax",
				"algorithm",
			],
			[
				"amazon-web-services",
				"android-layout",
				"android-studio",
				"android",
				"angular",
				"angularjs",
				"apache-spark",
			],
			[
				"apache",
				"api",
				"arrays",
			],
			[
				"asp.net-core",
				"asp.net-mvc",
				"asp.net",
				"azure",
				"bash",
				"c",
				"c#",
				"c++",
				"class",
				"codeigniter",
				"cordova",
				"css",
				"csv",
				"dart",
				"database",
				"dataframe",
			],
			[
				"date",
				"datetime",
				"dictionary",
				"django",
				"docker",
			],
			[
				"eclipse",
				"email",
				"entity-framework",
				"excel",
				"express",
				"facebook",
			],
			[
				"file",
				"firebase",
				"flutter",
				"for-loop",
				"forms",
				"function",
				"git",
				"go",
				"google-chrome",
				"google-maps",
				"hibernate",
				"html",
				"http",
			],
			[
				"image",
				"ios",
				"iphone",
				"java",
				"javascript",
				"jquery",
				"json",
				"kotlin",
				"laravel",
				"linq",
				"linux",
			],
			[
				"list",
				"loops",
				"macos",
				"matlab",
				"matplotlib",
				"maven",
				"mongodb",
				"multithreading",
				"mysql",
				"node.js",
			],
			[
				"numpy",
				"object",
				"objective-c",
				"oop",
				"opencv",
				"oracle",
				"pandas",
				"performance",
				"perl",
				"php",
				"postgresql",
				"powershell",
				"python-2.7",
				"python-3.x",
				"python",
			],
			[
				"qt",
				"r",
				"react-native",
				"reactjs",
				"regex",
				"rest",
				"ruby-on-rails-3",
				"ruby-on-rails",
				"ruby",
				"scala",
				"selenium",
				"shell",
				"sockets",
				"sorting",
				"spring-boot",
				"spring-mvc",
				"spring",
				"sql-server",
				"sql",
			],
			[
				"sqlite",
				"string",
				"swift",
			],
			[
				"swing",
				"symfony",
				"tensorflow",
				"tsql",
				"twitter-bootstrap",
				"typescript",
				"uitableview",
				"unit-testing",
				"unity3d",
				"validation",
				"vb.net",
				"vba",
				"visual-studio",
				"vue.js",
				"web-services",
				"windows",
				"winforms",
				"wordpress",
				"wpf",
				"xaml",
				"xcode",
				"xml",
			],
		]
		
		return tmp
	}
}


class TapVC: UIViewController {
	
	@IBAction func didTap(_ sender: Any?) {
		print("Tapped!")
	}
	
}

class RenderView: UIView {

	let myLabel = UILabel()
	let mySub = UIView()

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {
		mySub.translatesAutoresizingMaskIntoConstraints = false
		mySub.backgroundColor = .red
		myLabel.translatesAutoresizingMaskIntoConstraints = false
		myLabel.backgroundColor = .yellow
		mySub.addSubview(myLabel)
		addSubview(mySub)
		NSLayoutConstraint.activate([
			myLabel.centerXAnchor.constraint(equalTo: mySub.centerXAnchor),
			myLabel.centerYAnchor.constraint(equalTo: mySub.centerYAnchor),
			
			mySub.topAnchor.constraint(equalTo: topAnchor, constant: 12.0),
			mySub.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.0),
			mySub.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.0),
			mySub.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12.0),
		])
	}
	
	func toImage(_ targetScale: CGFloat) -> UIImage {
		
		var b = bounds
		b.size.width *= targetScale
		b.size.height *= targetScale
		
		self.layer.transform = CATransform3DMakeScale(targetScale, targetScale, 1.0)

		var csf: CGFloat = UIScreen.main.scale * targetScale
		//self.contentScaleFactor = csf
		subviews.forEach { v in
			v.contentScaleFactor = csf
		}

		let renderer = UIGraphicsImageRenderer(size: b.size)
		let image = renderer.image { _ in
			self.drawHierarchy(in: b, afterScreenUpdates: true)
		}

		csf = UIScreen.main.scale
		//self.contentScaleFactor = csf
		subviews.forEach { v in
			v.contentScaleFactor = csf
		}
		self.layer.transform = CATransform3DIdentity
		
		return image
		
//		let contentsScale: CGFloat = 1.0
//		let format = UIGraphicsImageRendererFormat()
//		format.scale = contentsScale
//
//		self.contentScaleFactor = contentsScale
//		layer.contentsScale = contentsScale
//		myLabel.layer.contentsScale = contentsScale
//
//		let b = bounds.insetBy(dx: -bounds.width * 0.5, dy: -bounds.height * 0.5)
//
//		let renderer = UIGraphicsImageRenderer(size: b.size, format: format)
//		let image = renderer.image { ctx in
//			self.drawHierarchy(in: b, afterScreenUpdates: true)
//		}
//		return image
	}
	
	func toImageA() -> UIImage? {
		var b = self.frame
		print(b, self.frame)

		b.origin.x = 0
		b.origin.y = 0
		
		let renderer = UIGraphicsImageRenderer(size: b.size)
		let image = renderer.image { _ in
			self.drawHierarchy(in: b, afterScreenUpdates: true)
		}

		return image
	}
}

class RenderTestVC: UIViewController {
	
	let myView = RenderView()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		myView.backgroundColor = .systemBlue
		
		myView.translatesAutoresizingMaskIntoConstraints = false
		
		view.addSubview(myView)
		
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			
			myView.topAnchor.constraint(equalTo: g.topAnchor, constant: 20.0),
			myView.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			myView.widthAnchor.constraint(equalToConstant: 240.0),
			myView.heightAnchor.constraint(equalToConstant: 160.0),
			
		])

		myView.myLabel.text = "This is a test"
		
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		let imgx = myView.getImage(scale: 10.0)
		print("x:", imgx.size)
		print()
		return()
		
		let v: CGFloat = 10.0
		myView.layer.transform = CATransform3DMakeScale(v, v, 1.0)
		myView.layer.contentsScale = v * 2.0
		//myView.contentScaleFactor = v * 2.0
		myView.myLabel.contentScaleFactor = v * 2.0
		let img1 = myView.toImageA()
		print("1:", img1?.size)
		print()
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
			let img2 = self.myView.toImageA()
			print("2:", img2?.size)
			print()
		})
//		DispatchQueue.main.asyncAfter(.now() + 0.1) {
//			self.myView.toImageA()
//			let img2 = self.myView.toImageA()
//			print("2:", img2?.size)
//			print()
//		})
		return()
		
		let imgA = myView.toImage(2)
		let imgB = myView.toImage(10)
		print("a:", imgA.size, "b:", imgB.size)
		print()
	}
}

extension UIView {
	func scale(by scale: CGFloat) {
		self.contentScaleFactor = scale
		for subview in self.subviews {
			subview.scale(by: scale)
		}
	}
	
	func getImage(scale: CGFloat? = nil) -> UIImage {
		let newScale = scale ?? UIScreen.main.scale
		self.scale(by: newScale)
		
		let format = UIGraphicsImageRendererFormat()
		format.scale = newScale
		
		let renderer = UIGraphicsImageRenderer(size: self.bounds.size, format: format)
		
		let image = renderer.image { rendererContext in
			self.layer.render(in: rendererContext.cgContext)
		}
		
		return image
	}
}

class TextViewCapVC: UIViewController {
	let textView = UITextView()
	let resultLabel = UILabel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// add a stack view with buttons
		let stack = UIStackView()
		stack.axis = .vertical
		stack.spacing = 12
		
		[1, 2, 5, 10].forEach { i in
			let btn = UIButton()
			btn.setTitle("Create Image at \(i)x scale", for: [])
			btn.setTitleColor(.white, for: .normal)
			btn.setTitleColor(.lightGray, for: .highlighted)
			btn.backgroundColor = .systemBlue
			btn.tag = i
			btn.addTarget(self, action: #selector(gotTap(_:)), for: .touchUpInside)
			stack.addArrangedSubview(btn)
		}
		
		[textView, stack, resultLabel].forEach { v in
			v.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview(v)
		}
		
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			
			// text view 280x240, 20-points from top, centered horizontally
			textView.topAnchor.constraint(equalTo: g.topAnchor, constant: 20.0),
			textView.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			textView.widthAnchor.constraint(equalToConstant: 240.0),
			textView.heightAnchor.constraint(equalToConstant: 129.0),
			
			// stack view, 20-points from text view, same width, centered horizontally
			stack.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20.0),
			stack.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			stack.widthAnchor.constraint(equalTo: textView.widthAnchor),
			
			// result label, 20-points from stack view
			//	20-points from leading/trailing
			resultLabel.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 20.0),
			resultLabel.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
			resultLabel.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -20.0),
			
		])
		
		let string = "Test"
		
		let attributes: [NSAttributedString.Key: Any] = [
			.foregroundColor: UIColor.blue,
			.font: UIFont.italicSystemFont(ofSize: 104.0),
		]
		
		let attributedString = NSMutableAttributedString(string: string, attributes: attributes)
		textView.attributedText = attributedString
		
		resultLabel.font = .systemFont(ofSize: 14, weight: .light)
		resultLabel.numberOfLines = 0
		resultLabel.text = "Results:"
		
		// so we can see the view frames
		textView.backgroundColor = .yellow
		resultLabel.backgroundColor = .cyan
		
	}
	
	@objc func gotTap(_ sender: Any?) {
		guard let btn = sender as? UIButton else { return }
		
		let scaleFactor = CGFloat(btn.tag)
		
		let img = textView.getImage(scale: scaleFactor)
		
		var s: String = "Results:\n\n"
		
		let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
		let fName: String = "\(btn.tag)xScale-\(img.size.width * img.scale)x\(img.size.height * img.scale).png"
		let url = documents.appendingPathComponent(fName)
		if let data = img.pngData() {
			do {
				try data.write(to: url)
			} catch {
				s += "Unable to Write Image Data to Disk"
				resultLabel.text = s
				return
			}
		} else {
			s += "Could not get png data"
			resultLabel.text = s
			return
		}
		s += "Logical Size: \(img.size)\n\n"
		s += "Scale: \(img.scale)\n\n"
		s += "Pixel Size: \(CGSize(width: img.size.width * img.scale, height: img.size.height * img.scale))\n\n"
		s += "File \"\(fName)\"\n\nsaved to Documents folder\n"
		resultLabel.text = s
		
		// print the path to documents in debug console
		//	so we can copy/paste into Finder to get to the files
		print(documents.path)
	}

}


class ColorCycleView: UIView {
	
	var colors: [UIColor] = [
		.purple, .blue, .green, .yellow, .orange
	]
	
	let v = UILabel()
	var st: Date!
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {
		addSubview(v)
		v.backgroundColor = .lightGray
		v.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			v.topAnchor.constraint(equalTo: topAnchor),
			v.leadingAnchor.constraint(equalTo: leadingAnchor),
		])
	}
	
	override func didMoveToSuperview() {
		startAnim()
	}
	func xstartAnim() {
		// total duration is number of colors (so, 1-second per color change)
		//	if we want 2-seconds per color change, for example, use TimeInterval(colors.count * 2)
		let totalDuration: TimeInterval = TimeInterval(colors.count)
		
		// relative duration is a percentage of the whole
		//	so with 5 colors, for example, it will be 0.2
		let relDuration: CGFloat = 1.0 / CGFloat(colors.count)
		
		// we want each change to start in sequence, so
		//	we'll increment this in our loop below
		//	for example, with 5 colors, the relative start times will be:
		//		0.0, 0.2, 0.4, 0.6, 0.8
		var relStartTime: TimeInterval = 0.0
		
//		UIView.animateKeyframes(withDuration: totalDuration, delay: 0.0, options: [.repeat, .autoreverse, .calculationModeCubicPaced], animations: {
		UIView.animateKeyframes(withDuration: totalDuration, delay: 0.0, options: [.repeat, .autoreverse], animations: {
			self.colors.forEach { c in
				UIView.addKeyframe(withRelativeStartTime: relStartTime, relativeDuration: relDuration, animations: {
					self.backgroundColor = c
				})
				relStartTime += relDuration
			}
		})
	}

	func startAnim() {
		st = Date()
		Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
			let e = Date().timeIntervalSince(self.st)
			let s = String(format: "%0.2f", e)
			self.v.text = s
		})
		
		// total duration is number of colors (so, 1-second per color change)
		//	if we want 2-seconds per color change, for example, use TimeInterval(colors.count * 2)
		let totalDuration: TimeInterval = 10.0 // TimeInterval(colors.count)
		
		// relative duration is a percentage of the whole
		//	so with 5 colors, for example, it will be 0.2
		let relDuration: CGFloat = 1.0 / CGFloat(colors.count)
		
		// we want each change to start in sequence, so
		//	we'll increment this in our loop below
		//	for example, with 5 colors, the relative start times will be:
		//		0.0, 0.2, 0.4, 0.6, 0.8
		var relStartTime: TimeInterval = 0.0
		
		UIView.animateKeyframes(withDuration: totalDuration, delay: 0.0, options: [.repeat, .autoreverse, .calculationModeCubicPaced], animations: {
		//UIView.animateKeyframes(withDuration: totalDuration, delay: 0.0, options: [.repeat, .autoreverse], animations: {
			self.colors.forEach { c in
				UIView.addKeyframe(withRelativeStartTime: relStartTime, relativeDuration: relDuration, animations: {
					self.backgroundColor = c
				})
				relStartTime += relDuration
			}
		}, completion: { b in
			print("complete:", b)
		})
	}
	

}

class ISLabel: UILabel {
	var myID: Int = -1
	
	override var intrinsicContentSize: CGSize {
		let sz = super.intrinsicContentSize
		print("l", myID, sz)
		return sz
	}
	
}
class ISView: UIView {
	
	var myID: Int = -1
	var h: CGFloat = 40

	override var intrinsicContentSize: CGSize {
		let sz = super.intrinsicContentSize
		print(myID, sz, h)
		if let sv = superview {
			if myID == 4 {
				print("sv", myID, sv.frame.width)
				h = sv.frame.width < 380 ?  120 : 60
			}
		}
		return CGSize(width: 100, height: h)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		invalidateIntrinsicContentSize()
//		if let sv = superview {
//			if myID == 4 {
//				print("sv", myID, sv.frame.width)
//				h = sv.frame.width < 380 ?  120 : 60
//			}
//		}
	}

}

class ISCell: UITableViewCell {
	let label = ISLabel()
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {
		label.backgroundColor = .yellow
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(label)
		let g = contentView.layoutMarginsGuide
		NSLayoutConstraint.activate([
			label.topAnchor.constraint(equalTo: g.topAnchor),
			label.leadingAnchor.constraint(equalTo: g.leadingAnchor),
			label.trailingAnchor.constraint(equalTo: g.trailingAnchor),
			label.bottomAnchor.constraint(equalTo: g.bottomAnchor),
		])
	}
	func fillData(_ d: MyDataStruct, n: Int) {
		label.myID = n
		label.text = d.title + " - " + d.desc
	}

}
class ISVCell: UITableViewCell {
	let label = ISView()
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {
		label.backgroundColor = .cyan
		//label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(label)
		let g = contentView.layoutMarginsGuide
		NSLayoutConstraint.activate([
			label.topAnchor.constraint(equalTo: g.topAnchor),
			label.leadingAnchor.constraint(equalTo: g.leadingAnchor),
			label.trailingAnchor.constraint(equalTo: g.trailingAnchor),
			label.bottomAnchor.constraint(equalTo: g.bottomAnchor),
		])
	}
	func fillData(_ d: MyDataStruct, n: Int) {
		label.myID = n
		//label.text = d.title + " - " + d.desc
	}
	var w: CGFloat = 0
//	override func layoutSubviews() {
//		super.layoutSubviews()
//		if w != contentView.frame.width {
//			label.invalidateIntrinsicContentSize()
//		}
//	}
	override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
		//force layout of all subviews including RectsView, which
		//updates RectsView's intrinsic height, and thus height of a cell
		self.setNeedsLayout()
		self.layoutIfNeeded()
		
		//now intrinsic height is correct, so we can call super method
		return super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
	}

}

class ISTableVC: UITableViewController {
	
	var myData: [MyDataStruct] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		myData = SampleData().getSampleData()
		
		tableView.register(ISCell.self, forCellReuseIdentifier: "c")
		tableView.register(ISVCell.self, forCellReuseIdentifier: "cv")

	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 6 // myData.count
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if indexPath.row < 3 {
			let c = tableView.dequeueReusableCell(withIdentifier: "c", for: indexPath) as! ISCell
			c.fillData(myData[indexPath.row], n: indexPath.row)
			return c
		}
		let c = tableView.dequeueReusableCell(withIdentifier: "cv", for: indexPath) as! ISVCell
		c.fillData(myData[indexPath.row], n: indexPath.row)
		return c
	}

}


class DemoVC: UIViewController {

	var containerViews: [UIView] = []
	var heightConstraints: [NSLayoutConstraint] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let g = view.safeAreaLayoutGuide

		// create 4 container views, each with a label as a subview
		let colors: [UIColor] = [
			.systemRed, .systemGreen, .systemBlue, .systemYellow,
		]
		colors.forEach { bkgColor in
			let thisContainer = UIView()
			thisContainer.translatesAutoresizingMaskIntoConstraints = false
			
			let thisLabel = UILabel()
			thisLabel.translatesAutoresizingMaskIntoConstraints = false

			thisContainer.backgroundColor = bkgColor
			thisLabel.backgroundColor = UIColor(red: 0.75, green: 0.9, blue: 1.0, alpha: 1.0)

			thisLabel.numberOfLines = 0
			//thisLabel.font = .systemFont(ofSize: 20.0, weight: .light)
			thisLabel.font = .systemFont(ofSize: 12.0, weight: .light)
			thisLabel.text = "We want to animate compressing the \"container\" view vertically, without it squeezing or moving this label."

			// add label to container view
			thisContainer.addSubview(thisLabel)
			
			// add container view to array
			containerViews.append(thisContainer)
			
			// add container view to view
			view.addSubview(thisContainer)
			
			NSLayoutConstraint.activate([

				// each example gets the label constrained
				//	Top / Leading / Trailing to its container view
				thisLabel.topAnchor.constraint(equalTo: thisContainer.topAnchor, constant: 8.0),
				thisLabel.leadingAnchor.constraint(equalTo: thisContainer.leadingAnchor, constant: 8.0),
				thisLabel.trailingAnchor.constraint(equalTo: thisContainer.trailingAnchor, constant: -8.0),
				
				// we'll be using different bottom constraints for the examples,
				//	so don't set it here
				//thisLabel.bottomAnchor.constraint(equalTo: thisContainer.bottomAnchor, constant: -8.0),
				
				// each container view gets constrained to the top
				thisContainer.topAnchor.constraint(equalTo: g.topAnchor, constant: 60.0),

			])

			// setup the container view height constraints, but don't activate them
			let hc = thisContainer.heightAnchor.constraint(equalToConstant: 0.0)
			
			// add the constraint to the constraints array
			heightConstraints.append(hc)

		}
		
		// couple vars to reuse
		var prevContainer: UIView!
		var aContainer: UIView!
		var itsLabel: UIView!
		var bc: NSLayoutConstraint!
		
		// -------------------------------------------------------------------
		// first example
		//	we don't add a bottom constraint for the label
		//	that means we'll never see its container view
		//	and changing its height constraint won't do anything to the label
		
		// -------------------------------------------------------------------
		// second example
		aContainer = containerViews[1]
		itsLabel = aContainer.subviews.first
		
		// we'll add a "standard" bottom constraint
		//	so now we see its container view
		bc = itsLabel.bottomAnchor.constraint(equalTo: aContainer.bottomAnchor, constant: -8.0)
		bc.isActive = true
		
		// -------------------------------------------------------------------
		// third example
		aContainer = containerViews[2]
		itsLabel = aContainer.subviews.first
		
		// add the same bottom constraint, but give it a
		//	less-than-required Priority so it won't "squeeze"
		bc = itsLabel.bottomAnchor.constraint(equalTo: aContainer.bottomAnchor, constant: -8.0)
		bc.priority = .defaultHigh
		bc.isActive = true
		
		// -------------------------------------------------------------------
		// fourth example
		aContainer = containerViews[3]
		itsLabel = aContainer.subviews.first
		
		// same less-than-required Priority bottom constraint,
		bc = itsLabel.bottomAnchor.constraint(equalTo: aContainer.bottomAnchor, constant: -8.0)
		bc.priority = .defaultHigh
		bc.isActive = true
		
		// we'll also set clipsToBounds on the container view
		//	so it will "hide / reveal" the label
		aContainer.clipsToBounds = true
		
		
		// now we need to layout the views
		
		// constrain first example leading
		aContainer = containerViews[0]
		aContainer.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 8.0).isActive = true
		
		prevContainer = aContainer
		
		for i in 1..<containerViews.count {
			aContainer = containerViews[i]
			aContainer.leadingAnchor.constraint(equalTo: prevContainer.trailingAnchor, constant: 8.0).isActive = true
			aContainer.widthAnchor.constraint(equalTo: prevContainer.widthAnchor).isActive = true
			prevContainer = aContainer
		}
		
		// constrain last example trailing
		prevContainer.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -8.0).isActive = true
	
		// and, let's add labels above the 4 examples
		for (i, v) in containerViews.enumerated() {
			let label = UILabel()
			label.translatesAutoresizingMaskIntoConstraints = false
			label.text = "Example \(i + 1)"
			label.font = .systemFont(ofSize: 14.0, weight: .light)
			view.addSubview(label)
			NSLayoutConstraint.activate([
				label.bottomAnchor.constraint(equalTo: v.topAnchor, constant: -4.0),
				label.centerXAnchor.constraint(equalTo: v.centerXAnchor),
			])

		}
		
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		heightConstraints.forEach { c in
			c.isActive = !c.isActive
		}
		UIView.animate(withDuration: 1.0, animations: {
			self.view.layoutIfNeeded()
		})
	}
	
}

class SomeView: UIView {

	var focusImageView: UIImageView!

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupImageViews()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupImageViews()
	}
	private func setupImageViews() {
		
		focusImageView = UIImageView()
		//focusImageView.image = UIImage(named: "scan_qr_focus")
		focusImageView.image = UIImage(named: "testing.a")
		focusImageView.backgroundColor = .cyan
		addSubview(focusImageView)
		focusImageView.translatesAutoresizingMaskIntoConstraints = false
		
//		// can't set Top equal to a percentage of Height, so use a Layout Guide
//		let g = UILayoutGuide()
//		addLayoutGuide(g)
//		NSLayoutConstraint.activate([
//			g.topAnchor.constraint(equalTo: topAnchor),
//			g.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.191),
//
//			focusImageView.topAnchor.constraint(equalTo: g.bottomAnchor),
//			focusImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
//			focusImageView.heightAnchor.constraint(equalTo: focusImageView.widthAnchor),
//			focusImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
//		])

		// can't set Top equal to a percentage of Height, so use a Layout Guide
		let c = NSLayoutConstraint(item: focusImageView as Any,
								   attribute: .top,
								   relatedBy: .equal,
								   toItem: self,
								   attribute: .bottom,
								   multiplier: 0.191,
								   constant: 0.0)
		
		NSLayoutConstraint.activate([
//			focusImageView.topAnchor.constraint(equalTo: g.bottomAnchor),
			focusImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
			focusImageView.heightAnchor.constraint(equalTo: focusImageView.widthAnchor),
			focusImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
			
			c,
		])

	}
	
}

typealias DidSelectClosure = ((_ cell: UITableViewCell, _ collectionIndex: Int?) -> Void)

struct Task {
	var name: String = ""
}
struct TaskList {
	var name: String = ""
	var tasks: [Task] = []
}
class TaskListViewController: UITableViewController {

	var taskLists: [TaskList] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		var aTaskList: TaskList!
		
		let sampleTaskNames: [[String]] = [
			["January", "February", "March", "April", "May"],
			["One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"],
			["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K"],
		]
		for (i, a) in sampleTaskNames.enumerated() {
			aTaskList = TaskList()
			aTaskList.name = "Task List \(i)"
			var someTasks: [Task] = []
			a.forEach { str in
				someTasks.append(Task(name: str))
			}
			aTaskList.tasks = someTasks
			taskLists.append(aTaskList)
		}
		
		tableView.register(NewTableViewCell.self, forCellReuseIdentifier: "newCell")
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return taskLists.count
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let c = tableView.dequeueReusableCell(withIdentifier: "newCell", for: indexPath) as! NewTableViewCell
		
		c.configure(with: taskLists[indexPath.row])
		
		c.didSelectClosure = {[weak self] tableCell, cIdx in
			guard let self = self,
				  let tableIdx = self.tableView.indexPath(for: tableCell),
				  let collIdx = cIdx
			else {
				return
			}
			let thisTaskList = self.taskLists[tableIdx.row]
			let selectedItem = thisTaskList.tasks[collIdx]
			print("Selected item: \(selectedItem.name) from \(thisTaskList.name)")
		}
		
		return c
	}
}

class NewTableViewCell: UITableViewCell {

	let taskNameLabel = UILabel()
	var tasksCollection: UICollectionView!
	
	var didSelectClosure: DidSelectClosure?
	
	var taskList: TaskList = TaskList()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {
		
		let fl = UICollectionViewFlowLayout()
		fl.scrollDirection = .horizontal
		tasksCollection = UICollectionView(frame: .zero, collectionViewLayout: fl)
		fl.estimatedItemSize = CGSize(width: 120, height: 60)

		taskNameLabel.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(taskNameLabel)

		tasksCollection.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(tasksCollection)

		let g = contentView.layoutMarginsGuide
		NSLayoutConstraint.activate([
			taskNameLabel.topAnchor.constraint(equalTo: g.topAnchor),
			taskNameLabel.leadingAnchor.constraint(equalTo: g.leadingAnchor),
			taskNameLabel.trailingAnchor.constraint(equalTo: g.trailingAnchor),
			
			tasksCollection.topAnchor.constraint(equalTo: taskNameLabel.bottomAnchor, constant: 4.0),
			tasksCollection.leadingAnchor.constraint(equalTo: g.leadingAnchor),
			tasksCollection.trailingAnchor.constraint(equalTo: g.trailingAnchor),
			tasksCollection.bottomAnchor.constraint(equalTo: g.bottomAnchor),
			
			tasksCollection.heightAnchor.constraint(equalToConstant: 80.0),
		])
		
		tasksCollection.register(NewCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionCell")
		tasksCollection.dataSource = self
		tasksCollection.delegate = self
	}
	func configure(with taskList: TaskList) {
		taskNameLabel.text = taskList.name
		self.taskList = taskList
	}
}

extension NewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		taskList.tasks.count == 0 ? 0 : taskList.tasks.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as! NewCollectionViewCell
		
		if taskList.tasks.count != 0 {
			cell.taskNameLabel.text = taskList.tasks[indexPath.row].name
		}
		cell.backgroundColor = UIColor(ciColor: CIColor(red: 147/255, green: 211/255, blue: 4/255, alpha: 0.4))
		cell.layer.cornerRadius = 20
		
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		didSelectClosure?(self, indexPath.item)
	}
	
}
class NewCollectionViewCell: UICollectionViewCell {
	let taskNameLabel = UILabel()
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {
		taskNameLabel.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(taskNameLabel)
		let g = contentView.layoutMarginsGuide
		NSLayoutConstraint.activate([
			taskNameLabel.topAnchor.constraint(equalTo: g.topAnchor),
			taskNameLabel.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 32.0),
			taskNameLabel.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -32.0),
			taskNameLabel.bottomAnchor.constraint(equalTo: g.bottomAnchor),
			taskNameLabel.heightAnchor.constraint(equalToConstant: 40.0),
		])
	}
	func configure(with task: Task) {
		taskNameLabel.text = task.name
	}
}

struct SortingSection {
	var title: String = ""
	var subtitle: String = ""
	var options: [String] = []
	var isOpened: Bool = false
}
class ExpandCell: UITableViewCell {
	let titleLabel = UILabel()
	let subtitleLabel = UILabel()
	let chevronImageView = UIImageView()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {
		
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(titleLabel)
		
		subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(subtitleLabel)
		
		chevronImageView.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(chevronImageView)
		
		let g = contentView.layoutMarginsGuide
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: g.topAnchor),
			titleLabel.leadingAnchor.constraint(equalTo: g.leadingAnchor),
			
			subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4.0),
			subtitleLabel.leadingAnchor.constraint(equalTo: g.leadingAnchor),
			
			chevronImageView.trailingAnchor.constraint(equalTo: g.trailingAnchor),
			chevronImageView.widthAnchor.constraint(equalToConstant: 40.0),
			chevronImageView.heightAnchor.constraint(equalTo: chevronImageView.widthAnchor),
			chevronImageView.centerYAnchor.constraint(equalTo: g.centerYAnchor),
			
			subtitleLabel.bottomAnchor.constraint(equalTo: g.bottomAnchor),
			
		])
	
		subtitleLabel.font = .systemFont(ofSize: 12.0, weight: .regular)
		subtitleLabel.textColor = .gray
		
		chevronImageView.contentMode = .center
		let cfg = UIImage.SymbolConfiguration(pointSize: 24.0, weight: .regular)
		if let img = UIImage(systemName: "chevron.right", withConfiguration: cfg) {
			chevronImageView.image = img
		}
		
	}
}
class SubCell: UITableViewCell {
	
	let titleLabel = UILabel()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {
		
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(titleLabel)
		
		let g = contentView.layoutMarginsGuide
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: g.topAnchor),
			titleLabel.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
			titleLabel.bottomAnchor.constraint(equalTo: g.bottomAnchor),
		])
		
		titleLabel.font = .italicSystemFont(ofSize: 15.0)
		
	}
}

class ExpandSectionTableViewController: UITableViewController {
	
	var sections: [SortingSection] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let optCounts: [Int] = [
			2, 3, 2, 5, 4, 2, 2, 3, 3, 4, 2, 1, 2, 3, 4, 3, 2
		]
		for (i, val) in optCounts.enumerated() {
			var opts: [String] = []
			for n in 1...val {
				opts.append("Section \(i) - Option \(n)")
			}
			sections.append(SortingSection(title: "Title \(i)", subtitle: "Subtitle \(i)", options: opts, isOpened: false))
		}
		
		tableView.register(ExpandCell.self, forCellReuseIdentifier: "expCell")
		tableView.register(SubCell.self, forCellReuseIdentifier: "subCell")
	}
	override func numberOfSections(in tableView: UITableView) -> Int {
		return sections.count * 2
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		let virtualSection: Int = section / 2
		let secItem = sections[virtualSection]
		if section % 2 == 0 {
			return 1
		}
		if secItem.isOpened {
			return secItem.options.count
		}
		return 0

	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		let virtualSection: Int = indexPath.section / 2
		let secItem = sections[virtualSection]
		if indexPath.section % 2 == 0 {
			let c = tableView.dequeueReusableCell(withIdentifier: "expCell", for: indexPath) as! ExpandCell
			c.titleLabel.text = secItem.title
			c.subtitleLabel.text = secItem.subtitle
			c.chevronImageView.transform = secItem.isOpened ? CGAffineTransform(rotationAngle: .pi/2) : .identity
			c.selectionStyle = .none
			return c
		}
		let c = tableView.dequeueReusableCell(withIdentifier: "subCell", for: indexPath) as! SubCell
		c.titleLabel.text = secItem.options[indexPath.row]
		return c

	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		let virtualSection: Int = indexPath.section / 2
		// if it's a "header row"
		if indexPath.section % 2 == 0 {
			sections[virtualSection].isOpened.toggle()
			guard let c = tableView.cellForRow(at: indexPath) as? ExpandCell else { return }
			UIView.animate(withDuration: 0.3) {
				if self.sections[virtualSection].isOpened {
					c.chevronImageView.transform = CGAffineTransform(rotationAngle: .pi/2)
				} else {
					c.chevronImageView.transform = .identity
				}
				// reload the NEXT section
				tableView.reloadSections([indexPath.section + 1], with: .automatic)
			}
		}

	}
	
}

struct MySortingSection {
	var isHeader: Bool = false
	var sectionData: SortingSection = SortingSection()
}

class xExpandSectionTableViewController: UITableViewController {

	var mySections: [MySortingSection] = []
	var sections: [SortingSection] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		for i in 0..<5 {
			let opts: [String] = [
				"Option \(i) - 1",
				"Option \(i) - 2",
			]
			sections.append(SortingSection(title: "Title \(i)", subtitle: "Subtitle \(i)", options: opts))
		}
		sections.forEach { s in
			mySections.append(MySortingSection(isHeader: true, sectionData: s))
			mySections.append(MySortingSection(isHeader: false, sectionData: s))
		}
		
		tableView.register(ExpandCell.self, forCellReuseIdentifier: "expCell")
		tableView.register(SubCell.self, forCellReuseIdentifier: "subCell")
	}
	override func numberOfSections(in tableView: UITableView) -> Int {
		return mySections.count
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if mySections[section].isHeader {
			return 1
		}
		if mySections[section].sectionData.isOpened {
			return mySections[section].sectionData.options.count
		}
		return 0
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let sec = mySections[indexPath.section]
		if sec.isHeader {
			let c = tableView.dequeueReusableCell(withIdentifier: "expCell", for: indexPath) as! ExpandCell
			c.titleLabel.text = sec.sectionData.title
			c.subtitleLabel.text = sec.sectionData.subtitle
			c.chevronImageView.transform = sec.sectionData.isOpened ? CGAffineTransform(rotationAngle: .pi/2) : .identity
			return c
		}
		let c = tableView.dequeueReusableCell(withIdentifier: "subCell", for: indexPath) as! SubCell
		c.titleLabel.text = sec.sectionData.options[indexPath.row]
		return c
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let sec = mySections[indexPath.section]
		if sec.isHeader {
			mySections[indexPath.section].sectionData.isOpened.toggle()
			mySections[indexPath.section + 1].sectionData.isOpened.toggle()

			guard let c = tableView.cellForRow(at: indexPath) as? ExpandCell else { return }

			UIView.animate(withDuration: 0.3) {
				if self.mySections[indexPath.section].sectionData.isOpened {
					c.chevronImageView.transform = CGAffineTransform(rotationAngle: .pi/2)
				} else {
					c.chevronImageView.transform = .identity
				}
				tableView.reloadSections([indexPath.section + 1], with: .automatic)
			}
		}
	}
}

struct User: Codable {
//	let userID: String
//	let idNumber: String
	let firstName: String
	let middleName: String?
//	let lastName: String
//	let emailAddress: String
//	let mobileNumber: String
//	let landline: String?
}

class CheckOutletsVC: UIViewController {

	@IBOutlet var button: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let v = UIView()
		v.backgroundColor = .red
		button.configuration?.background.customView = v
		
	}
	
	@IBAction func buttonTouched(_ sender: UIButton) {
		if let v = sender.configuration?.background.customView {
			UIView.animate(withDuration: 0.4, delay: 0.5) {
				v.backgroundColor = v.backgroundColor == .red ? .systemMint : .red
			}
		}
	}
}
class ProfileViewController: UIViewController {
	
	@IBOutlet weak var fullNameLabel: UILabel!

	var user: User!

	override func viewDidLoad() {
		super.viewDidLoad()
		
		if fullNameLabel == nil { fatalError("@IBOutlet fullNameLabel is not connected !!!!") }
//		if fullNameLabel == nil {
//			// crash with message to debug console
//			fatalError("@IBOutlet fullNameLabel is not connected !!!!")
//		}
		
		self.fullNameLabel.text = self.user.firstName
		
	}
}
