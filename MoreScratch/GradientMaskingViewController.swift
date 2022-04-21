//
//  GradientMaskingViewController.swift
//  MoreScratch
//
//  Created by Don Mag on 4/19/22.
//

import UIKit

class GradientMaskingViewController: UIViewController {

	let gradView = MaskedGradView()
	
    override func viewDidLoad() {
        super.viewDidLoad()

		gradView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(gradView)
		
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			gradView.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 60.0),
			gradView.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -60.0),
			gradView.heightAnchor.constraint(equalTo: gradView.widthAnchor),
			gradView.centerYAnchor.constraint(equalTo: g.centerYAnchor),
		])
		
		gradView.colorArray = [
			.blue, .orange, .purple, .yellow
		]

    }
    
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
		//	frame
		//	colors
		//	locations
		
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
		
		CATransaction.commit()	}
}


class xMaskedGradView: UIView {

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
		layer.addSublayer(gLayer)
		gLayer.mask = maskLayer
		
		// so we can see this view's frame
		layer.borderColor = UIColor.red.cgColor
		layer.borderWidth = 1
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		maskLayer.frame = bounds
		maskLayer.path = UIBezierPath(ovalIn: CGRect(x: 0.0, y: 0.0, width: 160.0, height: 160.0)).cgPath
		
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
	var curPos: CGPoint = .zero
	var lPos: CGPoint = .zero
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

		CATransaction.commit()	}
}

class MyGradientView: UIView {
	
	var colorArray: [UIColor] = [] {
		didSet {
			setNeedsLayout()
		}
	}
	var locationsArray: [NSNumber] = [] {
		didSet {
			setNeedsLayout()
		}
	}
	var vertical: Bool = true {
		didSet {
			setNeedsLayout()
		}
	}
	
	static override var layerClass: AnyClass {
		return CAGradientLayer.self
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		guard let layer = layer as? CAGradientLayer else { return }
		layer.colors = colorArray.map({ $0.cgColor })
		if locationsArray.count > 0 {
			layer.locations = locationsArray
		}
		if vertical {
			// top-down gradient
			layer.startPoint = CGPoint(x: 0.5, y: 0.0)
			layer.endPoint = CGPoint(x: 0.5, y: 1.0)
		} else {
			// diagonal gradient
			layer.startPoint = CGPoint(x: 0.0, y: 0.0)
			layer.endPoint = CGPoint(x: 1.0, y: 1.0)
		}
	}
	
}
