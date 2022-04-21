//
//  GradWorkViewController.swift
//  MoreScratch
//
//  Created by Don Mag on 4/20/22.
//

import UIKit

class GradWorkViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

class GrMkVC: UIViewController {
	
	let fView = UIView()
	
	let rView = RView()
	let fcView = FCView()
	let gView = GView()
	let gmView = GMView()
	let gmmView = GMMView()
	let ocView = OCView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
	
		[fView, rView, fcView, gView, gmView, gmmView, ocView].forEach { v in
			v.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview(v)
		}
		
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			rView.widthAnchor.constraint(equalToConstant: 240.0),
			rView.heightAnchor.constraint(equalTo: rView.widthAnchor),
			rView.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			rView.centerYAnchor.constraint(equalTo: g.centerYAnchor),
		])
		[fView, fcView, gView, gmView, gmmView, ocView].forEach { v in
			NSLayoutConstraint.activate([
				v.topAnchor.constraint(equalTo: rView.topAnchor),
				v.leadingAnchor.constraint(equalTo: rView.leadingAnchor),
				v.trailingAnchor.constraint(equalTo: rView.trailingAnchor),
				v.bottomAnchor.constraint(equalTo: rView.bottomAnchor),
			])
		}
		
		fView.backgroundColor = .green
	}

	var idx: Int = 0
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

		for (i, v) in view.subviews.enumerated() {
			v.isHidden = true
		}
		view.subviews.first?.isHidden = false

		let stp = idx % 10
		switch stp {
		case 0:
			()
		case 1:
			view.subviews[1].isHidden = false
			()
		case 2:
			view.subviews[1].isHidden = false
			view.subviews[2].isHidden = false
			if let v = view.subviews[2] as? FCView {
				v.fc = .red
			}
			()
		case 3:
			view.subviews[1].isHidden = false
			view.subviews[2].isHidden = false
			if let v = view.subviews[2] as? FCView {
				v.fc = .white
			}
			()
		case 4:
			view.subviews[1].isHidden = false
			view.subviews[2].isHidden = false
			view.subviews[3].isHidden = false
			()
		case 5:
			view.subviews[1].isHidden = false
			view.subviews[2].isHidden = false
			view.subviews[3].isHidden = false
			view.subviews[4].isHidden = false
			()
		case 6:
			view.subviews[1].isHidden = false
			view.subviews[2].isHidden = false
			view.subviews[5].isHidden = false
			()
		case 7:
			view.subviews[1].isHidden = false
			view.subviews[2].isHidden = false
			view.subviews[5].isHidden = false
			view.subviews[6].isHidden = false
			()
		default:
			()
		}

		for (i, v) in view.subviews.enumerated() {
			v.setNeedsLayout()
			v.layoutIfNeeded()
		}

		idx += 1
		return()
		
		let n = idx % view.subviews.count
		for (i, v) in view.subviews.enumerated() {
			v.isHidden = i > n
		}
		idx += 1
	}
}
class VBase: UIView {
	var inside: Bool = false
	let v = CAShapeLayer()
	let g = CAGradientLayer()
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
		v.fillColor = UIColor.white.cgColor
		v.strokeColor = UIColor.gray.cgColor
		v.lineWidth = 2
	}
	override func layoutSubviews() {
		super.layoutSubviews()
	}

}
class RView: VBase {
	override func commonInit() {
		super.commonInit()
		layer.addSublayer(v)
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		var b: UIBezierPath!
		let circleDiameter: CGFloat = bounds.width * 0.45
		var rectBounds: CGRect = bounds
		
		if inside {
			rectBounds = rectBounds.insetBy(dx: 1.0, dy: 1.0)
			rectBounds.origin.x += circleDiameter * 0.25
			rectBounds.size.width -= rectBounds.origin.x
		}
		
		b = UIBezierPath(rect: rectBounds)
		v.path = b.cgPath
	}
}
class FCView: VBase {
	var fc: UIColor = .yellow {
		didSet {
			v.fillColor = fc.cgColor
		}
	}
	override func commonInit() {
		super.commonInit()
		layer.addSublayer(v)
		v.lineWidth = 0
		v.fillColor = fc.cgColor
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		var b: UIBezierPath!
		let circleDiameter: CGFloat = bounds.width * 0.45
		var rectBounds: CGRect = bounds
		var circleBounds: CGRect!

		if inside {
			rectBounds = rectBounds.insetBy(dx: 1.0, dy: 1.0)
			rectBounds.origin.x += circleDiameter * 0.25
			rectBounds.size.width -= rectBounds.origin.x
			circleBounds = CGRect(x: bounds.minX, y: bounds.maxY * 0.5, width: circleDiameter, height: circleDiameter)
		} else {
			circleBounds = CGRect(x: bounds.minX - circleDiameter * 0.25, y: bounds.maxY * 0.5, width: circleDiameter, height: circleDiameter)
		}
		
		b = UIBezierPath(ovalIn: circleBounds)
		v.path = b.cgPath
	}
}
class GView: VBase {
	override func commonInit() {
		super.commonInit()
		layer.addSublayer(g)
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		let circleDiameter: CGFloat = bounds.width * 0.45
		var rectBounds: CGRect = bounds
		
		if inside {
			rectBounds = rectBounds.insetBy(dx: 1.0, dy: 1.0)
			rectBounds.origin.x += circleDiameter * 0.25
			rectBounds.size.width -= rectBounds.origin.x
		}
		
		g.frame = rectBounds
		let colorArray: [UIColor] = [
			.blue, .orange, .purple, .yellow
		]
		g.colors = colorArray.map({ $0.cgColor })
		g.startPoint = CGPoint(x: 0.5, y: 0.0)
		g.endPoint = CGPoint(x: 0.5, y: 1.0)
	}
}
class GMView: VBase {
	override func commonInit() {
		super.commonInit()
		layer.addSublayer(v)
		v.lineWidth = 0
		v.fillColor = UIColor.red.cgColor
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		var b: UIBezierPath!
		let circleDiameter: CGFloat = bounds.width * 0.45
		var rectBounds: CGRect = bounds
		var circleBounds: CGRect!
		
		if inside {
			rectBounds = rectBounds.insetBy(dx: 1.0, dy: 1.0)
			rectBounds.origin.x += circleDiameter * 0.25
			rectBounds.size.width -= rectBounds.origin.x
			circleBounds = CGRect(x: bounds.minX, y: bounds.maxY * 0.5, width: circleDiameter, height: circleDiameter)
		} else {
			circleBounds = CGRect(x: bounds.minX - circleDiameter * 0.25, y: bounds.maxY * 0.5, width: circleDiameter, height: circleDiameter)
		}
		
		b = UIBezierPath(ovalIn: circleBounds)
		v.path = b.cgPath
	}
}
class GMMView: VBase {
	override func commonInit() {
		super.commonInit()
		layer.addSublayer(g)
		g.mask = v
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		var b: UIBezierPath!
		let circleDiameter: CGFloat = bounds.width * 0.45
		var rectBounds: CGRect = bounds
		var circleBounds: CGRect!
		
		if inside {
			rectBounds = rectBounds.insetBy(dx: 1.0, dy: 1.0)
			rectBounds.origin.x += circleDiameter * 0.25
			rectBounds.size.width -= rectBounds.origin.x
			circleBounds = CGRect(x: bounds.minX, y: bounds.maxY * 0.5, width: circleDiameter, height: circleDiameter)
		} else {
			circleBounds = CGRect(x: bounds.minX - circleDiameter * 0.25, y: bounds.maxY * 0.5, width: circleDiameter, height: circleDiameter)
		}
		
		g.frame = rectBounds
		let colorArray: [UIColor] = [
			.blue, .orange, .purple, .yellow,
		]
		g.colors = colorArray.map({ $0.cgColor })
		g.startPoint = CGPoint(x: 0.5, y: 0.0)
		g.endPoint = CGPoint(x: 0.5, y: 1.0)

		b = UIBezierPath(ovalIn: circleBounds)
		v.path = b.cgPath
	}
}
class OCView: VBase {
	override func commonInit() {
		super.commonInit()
		v.fillColor = UIColor.clear.cgColor
		layer.addSublayer(v)
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		var b: UIBezierPath!
		let circleDiameter: CGFloat = bounds.width * 0.45
		var rectBounds: CGRect = bounds
		var circleBounds: CGRect!
		
		if inside {
			rectBounds = rectBounds.insetBy(dx: 1.0, dy: 1.0)
			rectBounds.origin.x += circleDiameter * 0.25
			rectBounds.size.width -= rectBounds.origin.x
			circleBounds = CGRect(x: bounds.minX, y: bounds.maxY * 0.5, width: circleDiameter, height: circleDiameter)
		} else {
			circleBounds = CGRect(x: bounds.minX - circleDiameter * 0.25, y: bounds.maxY * 0.5, width: circleDiameter, height: circleDiameter)
		}
		
		b = UIBezierPath(ovalIn: circleBounds)
		v.path = b.cgPath
	}
}

class GradientMaskingViewController: UIViewController {
	
	let gradView = MultiLayeredGradView()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = UIColor(white: 0.9, alpha: 1.0)

		gradView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(gradView)
		
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			gradView.widthAnchor.constraint(equalToConstant: 240.0),
			gradView.heightAnchor.constraint(equalTo: gradView.widthAnchor),
			gradView.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			gradView.centerYAnchor.constraint(equalTo: g.centerYAnchor),
		])
		
	}
	
}

class MultiLayeredGradView: UIView {
	
	private let rectLayer = CAShapeLayer()
	private let filledCircleLayer = CAShapeLayer()
	private let gradLayer = CAGradientLayer()
	private let maskLayer = CAShapeLayer()
	private let outlineCircleLayer = CAShapeLayer()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	private func commonInit() {
		
		// add filled-bordered rect layer as a sublayer
		layer.addSublayer(rectLayer)
		
		// add filled circle layer as a sublayer
		layer.addSublayer(filledCircleLayer)
		
		// add gradient layer as a sublayer
		layer.addSublayer(gradLayer)
		
		// mask it
		gradLayer.mask = maskLayer
		
		// add outline circle layer as a sublayer
		layer.addSublayer(outlineCircleLayer)
		
		let bColor: CGColor = UIColor.gray.cgColor
		let fColor: CGColor = UIColor.white.cgColor
		
		// filled-outlined
		rectLayer.strokeColor = bColor
		rectLayer.fillColor = fColor
		rectLayer.lineWidth = 2
		
		// filled
		filledCircleLayer.fillColor = fColor
		
		// clear-outlined
		outlineCircleLayer.strokeColor = bColor
		outlineCircleLayer.fillColor = UIColor.clear.cgColor
		outlineCircleLayer.lineWidth = 2

		// gradient layer properties
		let colorArray: [UIColor] = [
			.blue, .orange, .purple, .yellow
		]
		gradLayer.colors = colorArray.map({ $0.cgColor })
		gradLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
		gradLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
		
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		// circle diameter is 45% of the width of the view
		let circleDiameter: CGFloat = bounds.width * 0.45
		
		// circle Top is at vertical midpoint
		// circle is moved Left by 25% of the circle diameter
		let circleBounds: CGRect = CGRect(x: bounds.minX - circleDiameter * 0.25,
										  y: bounds.maxY * 0.5,
										  width: circleDiameter,
										  height: circleDiameter)
		
		// gradient layer fills the bounds
		gradLayer.frame = bounds
		
		let rectPath = UIBezierPath(rect: bounds).cgPath
		rectLayer.path = rectPath
		
		let circlePath = UIBezierPath(ovalIn: circleBounds).cgPath
		filledCircleLayer.path = circlePath
		outlineCircleLayer.path = circlePath
		maskLayer.path = circlePath
		
	}

}


class MultiMaskedGradView: UIView {
	
	enum Direction {
		case horizontal, vertical, diagnal
	}
	public var colorArray: [UIColor] = [] {
		didSet {
			setNeedsLayout()
		}
	}
	public var locationsArray: [NSNumber] = [] {
		didSet {
			setNeedsLayout()
		}
	}
	public var direction: Direction = .vertical {
		didSet {
			setNeedsLayout()
		}
	}
	public var borderColor: UIColor = .gray {
		didSet {
			setNeedsLayout()
		}
	}
	public var fillColor: UIColor = .white {
		didSet {
			setNeedsLayout()
		}
	}
	public var borderWidth: CGFloat = 1 {
		didSet {
			setNeedsLayout()
		}
	}

	private let rectLayer = CAShapeLayer()
	private let filledCircleLayer = CAShapeLayer()
	private let gradLayer = CAGradientLayer()
	private let maskLayer = CAShapeLayer()
	private let outlineCircleLayer = CAShapeLayer()

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	private func commonInit() {

		// add rect layer as a sublayer
		layer.addSublayer(rectLayer)

		// add inner circle layer as a sublayer
		layer.addSublayer(filledCircleLayer)

		// add gradient layer as a sublayer
		layer.addSublayer(gradLayer)
		
		// mask it
		gradLayer.mask = maskLayer
		
		// add outer circle layer as a sublayer
		layer.addSublayer(outlineCircleLayer)
		
		rectLayer.strokeColor = self.borderColor.cgColor
		rectLayer.fillColor = self.fillColor.cgColor
		rectLayer.lineWidth = self.borderWidth

		filledCircleLayer.fillColor = self.fillColor.cgColor
		
		outlineCircleLayer.strokeColor = self.borderColor.cgColor
		outlineCircleLayer.fillColor = UIColor.clear.cgColor
		outlineCircleLayer.lineWidth = self.borderWidth
		
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()

		// these can be changed after view has been shown
		rectLayer.strokeColor = self.borderColor.cgColor
		rectLayer.fillColor = self.fillColor.cgColor
		rectLayer.lineWidth = self.borderWidth
		
		filledCircleLayer.fillColor = self.fillColor.cgColor
		
		outlineCircleLayer.strokeColor = self.borderColor.cgColor
		outlineCircleLayer.lineWidth = self.borderWidth

		let circleDiameter: CGFloat = bounds.width * 0.45
		
		var rectBounds: CGRect = bounds
		rectBounds.origin.x = circleDiameter * 0.25
		rectBounds.size.width -= rectBounds.origin.x
		
		let circleBounds: CGRect = CGRect(x: bounds.minX, y: bounds.maxY * 0.5, width: circleDiameter, height: circleDiameter)
		
		gradLayer.frame = rectBounds
		
		var bez: UIBezierPath!

		bez = UIBezierPath(rect: rectBounds)
		rectLayer.path = bez.cgPath
		
		bez = UIBezierPath(ovalIn: circleBounds)
		filledCircleLayer.path = bez.cgPath
		
		outlineCircleLayer.path = bez.cgPath
		
		bez = UIBezierPath(ovalIn: circleBounds.offsetBy(dx: -rectBounds.minX, dy: 0.0))
		maskLayer.path = bez.cgPath
		
		gradLayer.colors = colorArray.map({ $0.cgColor })
		
		if locationsArray.count > 0 {
			gradLayer.locations = locationsArray
		}
		
		switch direction {
		case .horizontal:
			gradLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
			gradLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
		case .vertical:
			gradLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
			gradLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
		case .diagnal:
			gradLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
			gradLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
		}
		
	}
	
	// touch code to drag the circular mask around
	private var curPos: CGPoint = .zero
	private var lPos: CGPoint = .zero
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		curPos = touch.location(in: self)
		lPos = maskLayer.position
	}
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		let newPos = touch.location(in: self)
		let diffX = newPos.x - curPos.x
		let diffY = newPos.y - curPos.y
		
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		
		[maskLayer, filledCircleLayer, outlineCircleLayer].forEach { l in
			l.position = CGPoint(x: lPos.x + diffX, y: lPos.y + diffY)
		}

		CATransaction.commit()  }
}

class MaskedGradView: UIView {
	
	enum Direction {
		case horizontal, vertical, diagnal
	}
	public var colorArray: [UIColor] = [] {
		didSet {
			setNeedsLayout()
		}
	}
	public var locationsArray: [NSNumber] = [] {
		didSet {
			setNeedsLayout()
		}
	}
	public var direction: Direction = .vertical {
		didSet {
			setNeedsLayout()
		}
	}

	private let gLayer = CAGradientLayer()
	private let maskLayer = CAShapeLayer()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	private func commonInit() {
		// add gradient layer as a sublayer
		layer.addSublayer(gLayer)
		
		// mask it
		gLayer.mask = maskLayer
		
		// we'll use a 120-point diameter circle for the mask
		maskLayer.path = UIBezierPath(ovalIn: CGRect(x: 0.0, y: 0.0, width: 120.0, height: 120.0)).cgPath
		
		// so we can see this view's frame
		layer.borderColor = UIColor.black.cgColor
		layer.borderWidth = 1
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		// update gradient layer
		//  frame
		//  colors
		//  locations
		
		gLayer.frame = bounds
		
		gLayer.colors = colorArray.map({ $0.cgColor })
		
		if locationsArray.count > 0 {
			gLayer.locations = locationsArray
		}
		
		switch direction {
		case .horizontal:
			gLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
			gLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
		case .vertical:
			gLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
			gLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
		case .diagnal:
			gLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
			gLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
		}
		
	}
	
	// touch code to drag the circular mask around
	private var curPos: CGPoint = .zero
	private var lPos: CGPoint = .zero
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		curPos = touch.location(in: self)
		lPos = maskLayer.position
	}
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		let newPos = touch.location(in: self)
		let diffX = newPos.x - curPos.x
		let diffY = newPos.y - curPos.y
		
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		
		maskLayer.position = CGPoint(x: lPos.x + diffX, y: lPos.y + diffY)
		
		CATransaction.commit()  }
}
