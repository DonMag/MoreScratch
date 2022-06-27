//
//  FollowPathViewController.swift
//  MoreScratch
//
//  Created by Don Mag on 4/13/22.
//

import UIKit

import PDFKit
import SwiftUI

class LoadPlistVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
	
	let pickerA = UIPickerView()
	
	var plistData: [[String : String]] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		guard let url = Bundle.main.url(forResource: "firedata", withExtension: "plist") else {
			fatalError("Invalid URL")
		}
		
		do {
			let data = try Data(contentsOf: url)
			plistData = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [[String : String]]
		} catch {
			fatalError("Could not load plist as [[String : Any]]")
		}
		
		// debugging
		//print(plistData)
		
		// successfully loaded the plist, so setup the UI
		
		pickerA.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(pickerA)
		
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			pickerA.topAnchor.constraint(equalTo: g.topAnchor, constant: 20.0),
			pickerA.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
			pickerA.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -20.0),
		])
		
		pickerA.dataSource = self
		pickerA.delegate = self
		
	}
	
	// MARK: Picker View Methods
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
		return plistData.count
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		let d = plistData[row]
		return d["Occupancy Code"] ?? "No Code"
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		print("Picker selection - Row: \(row)")
	}
	
}


class xLoadPlistVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
	
	let pickerA = UIPickerView()
	
	var plistData: [[String : String]] = []
	var filteredData: [String] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		guard let url = Bundle.main.url(forResource: "firedata", withExtension: "plist") else {
			fatalError("Invalid URL")
		}
		
		do {
			let data = try Data(contentsOf: url)
			plistData = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [[String : String]]
		} catch {
			fatalError("Could not load plist as [[String : Any]]")
		}

		// debugging
		//print(plistData)

		// successfully loaded the plist, so setup the UI
		
		pickerA.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(pickerA)
		
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			pickerA.topAnchor.constraint(equalTo: g.topAnchor, constant: 20.0),
			pickerA.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
			pickerA.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -20.0),
		])

		pickerA.dataSource = self
		pickerA.delegate = self
		
		var fd = Set<String>()
		
		_ = plistData.filter { fd.insert($0["Occupancy Code"] ?? "No Code").inserted }
		
		filteredData = Array(fd).sorted()

		print()
	}
	
	// MARK: Picker View Methods
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
		return filteredData.count
	}

	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return filteredData[row]
		
		let d = plistData[row]
		let s: String = d["Occupancy Code"] as? String ?? "Bad data"
		return s
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		print("Picker selection - Row: \(row)")
	}
	
}


class DottedBreakVC: UIViewController {
	var x: Int = 1
	override func viewDidLoad() {
		super.viewDidLoad()
		return()
		x = 2
	}
}

class DocumentViewController: UIViewController, UIScrollViewDelegate {
	
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return scrollViewContainer
	}
	
	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		let scrollViewSize = scrollView.bounds.size
		let scrollViewContainerSize = scrollViewContainer.frame.size
		let verticalPadding = scrollViewContainerSize.height < scrollViewSize.height ? (scrollViewSize.height - scrollViewContainerSize.height) / 2 : 0
		let horizontalPadding = scrollViewContainerSize.width < scrollViewSize.width ? (scrollViewSize.width - scrollViewContainerSize.width) / 2 : 0
		scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
	}
	
	let scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.minimumZoomScale = 0.1
		scrollView.maximumZoomScale = 4.0
		scrollView.zoomScale = 1.0
		return scrollView
	}()
	
	let scrollViewContainer: UIStackView = {
		let view = UIStackView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.axis = .vertical
		view.spacing = 15
		view.alignment = .center
		return view
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		scrollView.delegate = self
		view.backgroundColor = .gray
		view.addSubview(scrollView)
		scrollView.addSubview(scrollViewContainer)
		
		let uiview1 = UIView(frame: .zero)
		uiview1.heightAnchor.constraint(equalToConstant: 1000).isActive = true
		uiview1.widthAnchor.constraint(equalToConstant: 1000).isActive = true
		scrollViewContainer.addArrangedSubview(uiview1)
		uiview1.backgroundColor = .white
		
		let uiview2 = UIView(frame: .zero)
		uiview2.heightAnchor.constraint(equalToConstant: 1000).isActive = true
		uiview2.widthAnchor.constraint(equalToConstant: 1000).isActive = true
		scrollViewContainer.addArrangedSubview(uiview2)
		uiview2.backgroundColor = .white
		
		let uiview3 = UIView(frame: .zero)
		uiview3.heightAnchor.constraint(equalToConstant: 1000).isActive = true
		uiview3.widthAnchor.constraint(equalToConstant: 1000).isActive = true
		scrollViewContainer.addArrangedSubview(uiview3)
		uiview3.backgroundColor = .white
		
		let uiview4 = UIView(frame: .zero)
		uiview4.heightAnchor.constraint(equalToConstant: 1000).isActive = true
		uiview4.widthAnchor.constraint(equalToConstant: 1000).isActive = true
		scrollViewContainer.addArrangedSubview(uiview4)
		uiview4.backgroundColor = .white
		
		let uiview5 = UIView(frame: .zero)
		uiview5.heightAnchor.constraint(equalToConstant: 1000).isActive = true
		uiview5.widthAnchor.constraint(equalToConstant: 2000).isActive = true
		scrollViewContainer.addArrangedSubview(uiview5)
		uiview5.backgroundColor = .white
		
		showBounds()
		setConstraints()
	}
	
	func setConstraints() {
		scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
		scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
		scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
		scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
	}
	
	func showBounds() {
		view.layer.borderWidth = 5.0
		view.layer.borderColor = UIColor.blue.cgColor
		scrollViewContainer.layer.borderWidth = 5.0
		scrollViewContainer.layer.borderColor = UIColor.red.cgColor
		scrollView.layer.borderWidth = 3.0
		scrollView.layer.borderColor = UIColor.yellow.cgColor
	}
	
}

class Page: UIView {
	
	var bezierMemory = [BezierRecord]()
	var currentBezier: UIBezierPath = UIBezierPath()
	
	var firstPoint: CGPoint = CGPoint()
	var previousPoint: CGPoint = CGPoint()
	var morePreviousPoint: CGPoint = CGPoint()
	var previousCALayer: CALayer = CALayer()
	
	var pointCounter = 0
	
	//var selectedPen: Pen = Pen(width: 3.0, strokeOpacity: 1, strokeColor: .red, fillColor: .init(gray: 0, alpha: 0.5), isPencil: true, connectsToStart: true, fillPencil: true)
	
	enum StandardPageSizes {
		case A4, LEGAL, LETTER
	}
	
	var firstCALayer = true
	var pointsTotal = 0
	
	override init(frame: CGRect) {
		super.init(frame: .zero)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {
		self.clipsToBounds = true
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		guard let touch = touches.first else { return }
		let point = touch.location(in: self)
		firstPoint = point
		
		pointCounter = 1
		
		currentBezier = UIBezierPath()
		currentBezier.lineWidth = 2 //selectedPen.width
		UIColor.red.setStroke()
		//selectedPen.getStroke().setStroke()
		currentBezier.move(to: point)
		
		previousPoint = point
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesMoved(touches, with: event)
		guard let touch = touches.first else { return }
		let point = touch.location(in: self)
		pointCounter += 1
		
		if (pointCounter == 3) {
			let midpoint = CGPoint(x: (morePreviousPoint.x + point.x)/2.0, y: (morePreviousPoint.y + point.y)/2.0)
			currentBezier.addQuadCurve(to: midpoint, controlPoint: morePreviousPoint)
			let updatedCALayer = CAShapeLayer()
			updatedCALayer.path = currentBezier.cgPath
			updatedCALayer.lineWidth = 2 // selectedPen.width
			updatedCALayer.opacity = 0.5 //selectedPen.strokeOpacity
			updatedCALayer.strokeColor = UIColor.red.cgColor // selectedPen.getStroke().cgColor
			updatedCALayer.fillColor = UIColor.blue.cgColor // selectedPen.getFill()
			if (firstCALayer) {
				layer.addSublayer(updatedCALayer)
				firstCALayer = false
			} else {
				layer.replaceSublayer(previousCALayer, with: updatedCALayer)
			}
			previousCALayer = updatedCALayer
			pointCounter = 1
		}
		
		morePreviousPoint = previousPoint
		previousPoint = point
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
		guard let touch = touches.first else { return }
		let point = touch.location(in: self)
		
		if (pointCounter != 3) {
			if true { //} (selectedPen.connectsToStart) {
				currentBezier.addQuadCurve(to: firstPoint, controlPoint: previousPoint)
			} else {
				currentBezier.addQuadCurve(to: point, controlPoint: previousPoint)
			}
			let updatedCALayer = CAShapeLayer()
			updatedCALayer.path = currentBezier.cgPath
			updatedCALayer.lineWidth = 2 // selectedPen.width
			updatedCALayer.opacity = 0.5 //selectedPen.strokeOpacity
			updatedCALayer.strokeColor = UIColor.red.cgColor // selectedPen.getStroke().cgColor
			updatedCALayer.fillColor = UIColor.blue.cgColor // selectedPen.getFill()
			if (firstCALayer) {
				layer.addSublayer(updatedCALayer)
				firstCALayer = false
			} else {
				// layer.setNeedsDisplay()
				layer.replaceSublayer(previousCALayer, with: updatedCALayer)
			}
		}
		
		firstCALayer = true
//		let bezierRecord = BezierRecord(bezier: currentBezier, strokeColor: selectedPen.getStroke(), fillColor: selectedPen.getFill(), strokeWidth: selectedPen.width)
		let bezierRecord = BezierRecord(bezier: currentBezier, strokeColor: .red, fillColor: UIColor.blue.cgColor, strokeWidth: 2)
		bezierMemory.append(bezierRecord)
	}
	
	private func normPoint(point: CGPoint) -> CGPoint {
		return CGPoint(x: point.x/frame.width, y: point.y/frame.height)
	}
	
	public class BezierRecord {
		var bezier: UIBezierPath
		var strokeColor: UIColor
		var strokeWidth: CGFloat
		var fillColor: CGColor
		
		init(bezier: UIBezierPath, strokeColor: UIColor, fillColor: CGColor, strokeWidth: CGFloat) {
			self.bezier = bezier
			self.strokeColor = strokeColor
			self.strokeWidth = strokeWidth
			self.fillColor = fillColor
		}
	}
	
}

class AlphaFillVC: UIViewController {
	
	let imgView = UIImageView()
	var origImage: UIImage!
	
	let layerView = TranslucentLayerImageView(frame: .zero)
	
	var b: Bool = false
	let logo = UIImageView()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		guard let img = UIImage(named: "test") else { return }
		origImage = img
		
		let stack = UIStackView()
		stack.axis = .vertical
		stack.spacing = 8
		stack.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(stack)
		
		[imgView, layerView].forEach { v in
			stack.addArrangedSubview(v)
			v.heightAnchor.constraint(equalTo: v.widthAnchor, multiplier: img.size.height / img.size.width).isActive = true
		}
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			stack.centerYAnchor.constraint(equalTo: g.centerYAnchor),
			stack.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
			stack.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -20.0),
		])
		
		imgView.image = origImage
		layerView.image = origImage
		
		stack.isHidden = true

//		logo.translatesAutoresizingMaskIntoConstraints = false
//		view.addSubview(logo)
//		//logo.image = UIImage(named: "cafelogo")
//		logo.image = UIImage(named: "80x80")
//		logo.layer.cornerRadius = 25
//		NSLayoutConstraint.activate([
//			logo.widthAnchor.constraint(equalToConstant: 150.0),
//			logo.heightAnchor.constraint(equalToConstant: 150.0),
//			logo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//			logo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//		])

	}
	func configure() {
		//MARK: Logo Image
		view.addSubview(logo)
		//logo.image = UIImage(named: "cafelogo")
		logo.image = UIImage(named: "80x80")
		logo.layer.cornerRadius = 25
		logo.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
		logo.center = view.center
	}
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
//		configure()
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
	
		//guard let img = imgView.image else { return }
		guard let img = origImage else { return }
		
		b.toggle()

		// let's create 3 bezier paths
		//	add them separated, and
		//	add them overlapping
		
		if b {
			
			let clr = UIColor(hue: 0.2, saturation: 1, brightness: 1, alpha: 1)
			
			// drawing to the image is relative to the image size
			var r = img.size
			
			var w = r.width * 0.25
			var h = r.height * 0.25
			
			var bez: UIBezierPath!
			var paths: [UIBezierPath] = []
			
			var thisR: CGRect = CGRect(origin: .zero, size: CGSize(width: w, height: h))
			
			thisR.origin.x = r.width * 0.10
			thisR.origin.y = r.height * 0.10
			bez = UIBezierPath(rect: thisR)
			paths.append(bez)
			
			thisR.origin.x = r.width * 0.9 - w
			bez = UIBezierPath(roundedRect: thisR, cornerRadius: 24.0)
			paths.append(bez)
			
			thisR.origin.x = r.width * 0.5 - w * 0.5
			thisR.origin.y = r.height * 0.25 - h * 0.5
			bez = UIBezierPath(ovalIn: thisR)
			paths.append(bez)
			
			thisR.origin.x = r.width * 0.20
			thisR.origin.y = r.height * 0.90 - h
			bez = UIBezierPath(rect: thisR)
			paths.append(bez)
			
			thisR.origin.x = r.width * 0.80 - w
			bez = UIBezierPath(roundedRect: thisR, cornerRadius: 24.0)
			paths.append(bez)
			
			thisR.origin.x = r.width * 0.5 - w * 0.5
			thisR.origin.y = r.height * 0.65 - h * 0.5
			bez = UIBezierPath(ovalIn: thisR)
			paths.append(bez)
			
			
			let imgA = img.translucentPaths(arrayOfPaths: paths, usingColor: clr, andAlpha: 0.5)
			imgView.image = imgA
			
			
			// setting path of shape layer is relative to view size
			r = self.layerView.frame.size
			
			w = r.width * 0.25
			h = r.height * 0.25
			
			paths = []
			
			thisR = CGRect(origin: .zero, size: CGSize(width: w, height: h))
			
			thisR.origin.x = r.width * 0.10
			thisR.origin.y = r.height * 0.10
			bez = UIBezierPath(rect: thisR)
			paths.append(bez)
			
			thisR.origin.x = r.width * 0.9 - w
			bez = UIBezierPath(roundedRect: thisR, cornerRadius: 12.0)
			paths.append(bez)
			
			thisR.origin.x = r.width * 0.5 - w * 0.5
			thisR.origin.y = r.height * 0.25 - h * 0.5
			bez = UIBezierPath(ovalIn: thisR)
			paths.append(bez)
			
			thisR.origin.x = r.width * 0.20
			thisR.origin.y = r.height * 0.90 - h
			bez = UIBezierPath(rect: thisR)
			paths.append(bez)
			
			thisR.origin.x = r.width * 0.80 - w
			bez = UIBezierPath(roundedRect: thisR, cornerRadius: 12.0)
			paths.append(bez)
			
			thisR.origin.x = r.width * 0.5 - w * 0.5
			thisR.origin.y = r.height * 0.65 - h * 0.5
			bez = UIBezierPath(ovalIn: thisR)
			paths.append(bez)
			
			layerView.translucentPaths(arrayOfPaths: paths, usingColor: clr, andAlpha: 0.5)
			
		} else {
			imgView.image = origImage
			self.layerView.translucentPaths(arrayOfPaths: [], usingColor: .clear, andAlpha: 0.5)
		}
	}
}
class TranslucentLayerImageView: UIImageView {
	let shapeLayer = CAShapeLayer()
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {
		layer.addSublayer(shapeLayer)
	}
	func translucentPaths(arrayOfPaths paths: [UIBezierPath], usingColor color: UIColor, andAlpha alpha: Float) {
		if paths.count == 0 {
			shapeLayer.path = nil
			return
		}
		// disable layer implicit animation
		//	to avoid a "flash" the first time this is set
		CATransaction.begin()
		CATransaction.setDisableActions(true)
		shapeLayer.fillColor = color.cgColor
		shapeLayer.opacity = alpha
		let p = paths[0]
		for i in 1..<paths.count {
			p.append(paths[i])
		}
		shapeLayer.path = p.cgPath
		CATransaction.commit()
	}
}
extension UIImage {
	func doubleRect(_ r: CGRect) -> UIImage {
		let renderer = UIGraphicsImageRenderer(size: size)
		let image = renderer.image { (context) in
			// draw the full image
			draw(at: .zero)

			context.cgContext.setAlpha(0.5)
			
			UIColor(hue: 0.2, saturation: 1, brightness: 1, alpha: 1).setFill()
			let p = UIBezierPath(roundedRect: CGRect(x: 100, y: 100, width: 200, height: 200), cornerRadius: 10)
			let q = UIBezierPath(roundedRect: CGRect(x: 150, y: 150, width: 200, height: 200), cornerRadius: 10)
			p.append(q)
			p.fill()
			//q.fill()

//			let pth = UIBezierPath(rect: r)
//			context.cgContext.setFillColor(UIColor.clear.cgColor)
//			context.cgContext.setBlendMode(.clear)
//			// "fill" the rect with clear
//			pth.fill()
		}
		return image
	}
	func translucentPaths(arrayOfPaths paths: [UIBezierPath], usingColor color: UIColor, andAlpha alpha: CGFloat) -> UIImage {
		let renderer = UIGraphicsImageRenderer(size: size)
		let image = renderer.image { (context) in
			// draw the full image
			draw(at: .zero)
			
			context.cgContext.setAlpha(alpha)
			color.setFill()

			let p = paths[0]
			for i in 1..<paths.count {
				p.append(paths[i])
			}
			p.fill()
		}
		return image
	}
}

class CircleMoveVC: UIViewController {
	
	let circle = UIView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		circle.backgroundColor = .systemBlue
		circle.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(circle)
		
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			circle.widthAnchor.constraint(equalToConstant: 80.0),
			circle.heightAnchor.constraint(equalTo: circle.widthAnchor),
			circle.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			circle.centerYAnchor.constraint(equalTo: g.centerYAnchor),
		])
	
		circle.layer.cornerRadius = 40.0
		
		let pg = UIPanGestureRecognizer(target: self, action: #selector(circleMoved(_:)))
		circle.addGestureRecognizer(pg)
	}
	
	@objc func circleMoved(_ gesture: UIPanGestureRecognizer) {
		switch gesture.state {
		case .changed:
			let translation = gesture.translation(in: view)
			
			//circle.layer.zPosition = 200
			let spread = view.frame.width
			let angle: CGFloat = 100
			
			let angleMoveX = angle * translation.x / spread
			let angleMoveY = angle * translation.y / spread
			
			let angleMoveXRadians = angleMoveX * CGFloat.pi/180
			let angleMoveYRadians = angleMoveY * CGFloat.pi/180
			
			var move = CATransform3DIdentity
			move = CATransform3DRotate(move, angleMoveXRadians, 0, 1, 0)
			move = CATransform3DRotate(move, -angleMoveYRadians, 1, 0, 0)
			move = CATransform3DTranslate(move, translation.x, translation.y, 0)
			
			circle.layer.transform = CATransform3DConcat(circle.layer.transform, move)
			
			
			gesture.setTranslation(.zero, in: view)
			
//		case .possible:
//			<#code#>
//		case .began:
//			<#code#>
//		case .ended:
//			<#code#>
//		case .cancelled:
//			<#code#>
//		case .failed:
//			<#code#>
		@unknown default:
			()
		}
		
	}
}

class zManyLayersViewController: UIViewController, UIScrollViewDelegate {
	
	let scrollView: UIScrollView = {
		let v = UIScrollView()
		v.contentInsetAdjustmentBehavior = .never
		return v
	}()
	let imgView: UIImageView = {
		let v = UIImageView()
		return v
	}()
	
	var theImage: UIImage!
	
	var pathsArray: [CGPath] = []

	var idx: Int = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		[scrollView, imgView].forEach { v in
			v.translatesAutoresizingMaskIntoConstraints = false
		}
		
		// add pathView to the scroll view
		scrollView.addSubview(imgView)
		
		// add scroll view to self.view
		view.addSubview(scrollView)
		
		let safeG = view.safeAreaLayoutGuide
		let contentG = scrollView.contentLayoutGuide
		
		NSLayoutConstraint.activate([
			
			// scroll view Top/Leading/Trailing/Bottom to safe area
			scrollView.topAnchor.constraint(equalTo: safeG.topAnchor, constant: 40.0),
			scrollView.leadingAnchor.constraint(equalTo: safeG.leadingAnchor, constant: 40.0),
			scrollView.trailingAnchor.constraint(equalTo: safeG.trailingAnchor, constant: -40.0),
			scrollView.bottomAnchor.constraint(equalTo: safeG.bottomAnchor, constant: -40.0),
			
			// pathView Top/Leading/Trailing/Bottom to scroll view's CONTENT GUIDE
			imgView.topAnchor.constraint(equalTo: contentG.topAnchor, constant: 0.0),
			imgView.leadingAnchor.constraint(equalTo: contentG.leadingAnchor, constant: 0.0),
			imgView.trailingAnchor.constraint(equalTo: contentG.trailingAnchor, constant: 0.0),
			imgView.bottomAnchor.constraint(equalTo: contentG.bottomAnchor, constant: 0.0),
			
			imgView.widthAnchor.constraint(equalToConstant: 1600.0),
			imgView.heightAnchor.constraint(equalToConstant: 1600.0),
			
		])
		
		scrollView.delegate = self
		scrollView.minimumZoomScale = 0.25
		scrollView.maximumZoomScale = 8.0
		
		// so we can see the scroll view frame
		scrollView.layer.borderWidth = 2
		scrollView.layer.borderColor = UIColor.red.cgColor
		
		theImage = UIColor.systemBlue.image(CGSize(width: 1600, height: 1600))
		imgView.image = theImage
		
		let colors: [UIColor] = [
			.red, .green, .blue,
			.cyan, .magenta, .yellow
		]
		
		
		// use a large font so we can see it easily
		let font = UIFont(name: "Times", size: 40)!
		
		let str: String = "ABCDEFGHI"
		var a: [UniChar] = Array(str.utf16)
		
		var glyphs = [CGGlyph](repeatElement(0, count: a.count))
		
		let gotGlyphs = CTFontGetGlyphsForCharacters(font, &a, &glyphs, a.count)
		
		if gotGlyphs {
			glyphs.forEach { g in
				if let cgpath = CTFontCreatePathForGlyph(font, g, nil) {
					var tr = CGAffineTransform(scaleX: 1.0, y: -1.0)
					if let p = cgpath.copy(using: &tr) {
						pathsArray.append(p)
					}
				}
			}
		}
		
		
		let num: Int = 1
		var cIDX: Int = 0
		var off: Int = 4
		pathsArray.forEach { pth in
			let clr = colors[cIDX % colors.count]
			for c in 0..<num {
				for r in 0..<num {
					let sl = CAShapeLayer()
					sl.path = pth
					sl.strokeColor = UIColor.systemYellow.cgColor
					sl.fillColor = clr.cgColor
					sl.frame.origin = CGPoint(x: c * 50 + off, y: r * 50 + off + 30)
					//pathView.layer.addSublayer(sl)
				}
			}
			off += 20
			cIDX += 1
		}
		//pathView.clipsToBounds = true
		
		//print(pathView.layer.sublayers?.count)
		
		updateImage()
		
		scrollView.delegate = self
		
		return()
		
	}
	func updateImage() {
		let fmt = UIGraphicsImageRendererFormat()
		fmt.scale = UIScreen.main.scale
		let rdr = UIGraphicsImageRenderer(size: theImage.size, format: fmt)
		let image = rdr.image { (context) in
			theImage.draw(at: .zero)
			context.cgContext.setFillColor(UIColor.red.cgColor)
			context.cgContext.setStrokeColor(UIColor.green.cgColor)
			UIBezierPath(roundedRect: CGRect(x: 80, y: 80, width: 200, height: 100), cornerRadius: 16).fill()
			UIBezierPath(roundedRect: CGRect(x: 80, y: 80, width: 200, height: 100), cornerRadius: 16).stroke()
		}
		theImage = image
		imgView.image = theImage
	}
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return imgView
	}
	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		imgView.contentScaleFactor = scrollView.zoomScale * UIScreen.main.scale
	}
	
}

class ManyLayersViewController: UIViewController, UIScrollViewDelegate {
	
	let scrollView: UIScrollView = {
		let v = UIScrollView()
		v.contentInsetAdjustmentBehavior = .never
		return v
	}()
	let pathView: UIView = {
		let v = UIView()
		return v
	}()
	
	let pvSize: CGFloat = 1200.0
	
	var pts: [CGPoint] = []
	var markers: [UIView] = []
	var order: [Int] = []
	var idx: Int = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		[scrollView, pathView].forEach { v in
			v.translatesAutoresizingMaskIntoConstraints = false
		}
		
		// add pathView to the scroll view
		scrollView.addSubview(pathView)
		
		// add scroll view to self.view
		view.addSubview(scrollView)
		
		let safeG = view.safeAreaLayoutGuide
		let contentG = scrollView.contentLayoutGuide
		
		NSLayoutConstraint.activate([
			
			// scroll view Top/Leading/Trailing/Bottom to safe area
			scrollView.topAnchor.constraint(equalTo: safeG.topAnchor, constant: 40.0),
			scrollView.leadingAnchor.constraint(equalTo: safeG.leadingAnchor, constant: 40.0),
			scrollView.trailingAnchor.constraint(equalTo: safeG.trailingAnchor, constant: -40.0),
			scrollView.bottomAnchor.constraint(equalTo: safeG.bottomAnchor, constant: -40.0),
			
			// pathView Top/Leading/Trailing/Bottom to scroll view's CONTENT GUIDE
			pathView.topAnchor.constraint(equalTo: contentG.topAnchor, constant: 0.0),
			pathView.leadingAnchor.constraint(equalTo: contentG.leadingAnchor, constant: 0.0),
			pathView.trailingAnchor.constraint(equalTo: contentG.trailingAnchor, constant: 0.0),
			pathView.bottomAnchor.constraint(equalTo: contentG.bottomAnchor, constant: 0.0),
			
			pathView.widthAnchor.constraint(equalToConstant: 1600.0),
			pathView.heightAnchor.constraint(equalToConstant: 1600.0),
			
		])
		
		scrollView.delegate = self
		scrollView.minimumZoomScale = 0.25
		scrollView.maximumZoomScale = 8.0
		
		// so we can see the scroll view frame
		scrollView.layer.borderWidth = 2
		scrollView.layer.borderColor = UIColor.red.cgColor

		let colors: [UIColor] = [
			.red, .green, .blue,
			.cyan, .magenta, .yellow
		]
		
		
		// use a large font so we can see it easily
		let font = UIFont(name: "Times", size: 40)!
		
		let str: String = "ABCDEFGHI"
		var a: [UniChar] = Array(str.utf16)

		var glyphs = [CGGlyph](repeatElement(0, count: a.count))
		
		let gotGlyphs = CTFontGetGlyphsForCharacters(font, &a, &glyphs, a.count)

		var pathsArray: [CGPath] = []
		if gotGlyphs {
			glyphs.forEach { g in
				if let cgpath = CTFontCreatePathForGlyph(font, g, nil) {
					var tr = CGAffineTransform(scaleX: 1.0, y: -1.0)
					if let p = cgpath.copy(using: &tr) {
						pathsArray.append(p)
					}
				}
			}
		}
		

		let num: Int = 30
		var cIDX: Int = 0
		var off: Int = 4
		pathsArray.forEach { pth in
			let clr = colors[cIDX % colors.count]
			for c in 0..<num {
				for r in 0..<num {
					let sl = CAShapeLayer()
					sl.path = pth
					sl.strokeColor = UIColor.systemYellow.cgColor
					sl.fillColor = clr.cgColor
					sl.frame.origin = CGPoint(x: c * 50 + off, y: r * 50 + off + 30)
					pathView.layer.addSublayer(sl)
				}
			}
			off += 20
			cIDX += 1
		}
		pathView.clipsToBounds = true
		
		print(pathView.layer.sublayers?.count)

		return()
		
	}
	
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return pathView
	}
	
}

extension UIColor {
	func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
		return UIGraphicsImageRenderer(size: size).image { rendererContext in
			self.setFill()
			rendererContext.fill(CGRect(origin: .zero, size: size))
		}
	}
}

class FollowPathViewController: UIViewController, UIScrollViewDelegate {

	let scrollView: UIScrollView = {
		let v = UIScrollView()
		v.contentInsetAdjustmentBehavior = .never
		return v
	}()
	let pathView: PathView = {
		let v = PathView()
		return v
	}()
	
	let carView: UIImageView = {
		let v = UIImageView()
		return v
	}()
	
	let pvSize: CGFloat = 1200.0

	var pts: [CGPoint] = []
	var markers: [UIView] = []
	var order: [Int] = []
	var idx: Int = 0
	
    override func viewDidLoad() {
        super.viewDidLoad()

		guard let pdfFile = Bundle.main.url(forResource: "us-states-map", withExtension: "pdf") else { return }

		guard let document = PDFDocument(url: pdfFile) else { return }
		
		let pdfView = PDFView()
		pdfView.document = document
		pdfView.isUserInteractionEnabled = false
		
		guard let pdfR = pdfView.documentView?.frame else { return }

		[scrollView, pathView, pdfView].forEach { v in
			v.translatesAutoresizingMaskIntoConstraints = false
		}
		
		// pathView creates its own "car" view, so
		//	insert pdfView below it
		pathView.insertSubview(pdfView, at: 0)
		
		let xs: CGFloat = pdfR.width / 5.0
		let ys: CGFloat = pdfR.height / 6.0
		var x: CGFloat = xs
		var y: CGFloat = ys
		var n: Int = 1
		for i in 1...5 {
			y = ys * CGFloat(i) - ys * 0.25
			x = xs * (i % 2 == 1 ? 0.5 : 0.25)
			for j in 1...5 {
				let v = UILabel()
				v.text = "\(n)"
				v.textAlignment = .center
				v.textColor = .yellow
				v.backgroundColor = .systemBlue
				v.font = .systemFont(ofSize: 14.0, weight: .light)
				v.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
				v.layer.cornerRadius = 20
				v.layer.masksToBounds = true
				pts.append(CGPoint(x: x, y: y + (j % 2 == 1 ? ys * 0.4 : 0)))
				markers.append(v)
				x += xs
				n += 1
			}
		}
		
		for (v, p) in zip(markers, pts) {
			pathView.addSubview(v)
			v.center = p
		}
		
		// let's create a shuffled index for the markers
		order = Array(0..<markers.count) //.shuffled()
		
		// add pathView to the scroll view
		scrollView.addSubview(pathView)
		
		// add scroll view to self.view
		view.addSubview(scrollView)
		
		let safeG = view.safeAreaLayoutGuide
		let contentG = scrollView.contentLayoutGuide
		
		NSLayoutConstraint.activate([
			
			// scroll view Top/Leading/Trailing/Bottom to safe area
			scrollView.topAnchor.constraint(equalTo: safeG.topAnchor, constant: 40.0),
			scrollView.leadingAnchor.constraint(equalTo: safeG.leadingAnchor, constant: 40.0),
			scrollView.trailingAnchor.constraint(equalTo: safeG.trailingAnchor, constant: -40.0),
			scrollView.bottomAnchor.constraint(equalTo: safeG.bottomAnchor, constant: -40.0),
			
			// pathView Top/Leading/Trailing/Bottom to scroll view's CONTENT GUIDE
			pathView.topAnchor.constraint(equalTo: contentG.topAnchor, constant: 0.0),
			pathView.leadingAnchor.constraint(equalTo: contentG.leadingAnchor, constant: 0.0),
			pathView.trailingAnchor.constraint(equalTo: contentG.trailingAnchor, constant: 0.0),
			pathView.bottomAnchor.constraint(equalTo: contentG.bottomAnchor, constant: 0.0),

			pdfView.topAnchor.constraint(equalTo: pathView.topAnchor, constant: 0.0),
			pdfView.leadingAnchor.constraint(equalTo: pathView.leadingAnchor, constant: 0.0),
			pdfView.trailingAnchor.constraint(equalTo: pathView.trailingAnchor, constant: 0.0),
			pdfView.bottomAnchor.constraint(equalTo: pathView.bottomAnchor, constant: 0.0),
			
			pathView.widthAnchor.constraint(equalToConstant: pdfR.width),
			pathView.heightAnchor.constraint(equalToConstant: pdfR.height),
			
		])
		
		scrollView.delegate = self
		scrollView.minimumZoomScale = 0.25
		scrollView.maximumZoomScale = 3.0
		
		// so we can see the scroll view frame
		scrollView.layer.borderWidth = 2
		scrollView.layer.borderColor = UIColor.red.cgColor
		
    }
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

		self.idx += 1

		let newPT = self.pts[self.order[self.idx % self.order.count]]
		
		self.pathView.addPoint(newPT)
		
		if true {
			
			var r = CGRect(x: newPT.x - 20.0, y: newPT.y - 20.0, width: 40.0, height: 40.0)
			r = r.applying(CGAffineTransform(scaleX: self.scrollView.zoomScale, y: self.scrollView.zoomScale))
			
			if true {
				// let's slow down the animation a little
				UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: {
					self.scrollView.scrollRectToVisible(r, animated: false)
				}, completion: nil)
			} else {
				self.scrollView.scrollRectToVisible(r, animated: false)
			}

		}
		
		return()
		
		if true {
			// convert the point to a rect using scroll view's zoomScale
			let sz: CGFloat = 40.0

			let x = newPT.x * self.scrollView.zoomScale
			let y = newPT.y * self.scrollView.zoomScale

			var r = CGRect(x: x, y: y, width: sz, height: sz)
			r = r.offsetBy(dx: -sz * 0.5, dy: -sz * 0.5)
			
			if !self.scrollView.bounds.contains(r) {
				// convert the point to a rect using scroll view's zoomScale
				let w: CGFloat = self.scrollView.frame.width
				let h: CGFloat = self.scrollView.frame.height
				r = CGRect(x: x, y: y, width: w, height: h)
				r = r.offsetBy(dx: -w * 0.5, dy: -h * 0.5)
			}
			
			UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: {
				self.scrollView.scrollRectToVisible(r, animated: false)
			}, completion: nil)
			
		} else {
			// convert the point to a rect using scroll view's zoomScale
			let w: CGFloat = self.scrollView.frame.width
			let h: CGFloat = self.scrollView.frame.height
			let x = newPT.x * self.scrollView.zoomScale
			let y = newPT.y * self.scrollView.zoomScale
			var r = CGRect(x: x, y: y, width: w, height: h)
			r = r.offsetBy(dx: -w * 0.5, dy: -h * 0.5)
			UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: {
				self.scrollView.scrollRectToVisible(r, animated: false)
			}, completion: nil)
		}

	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		let x = pts[0].x * self.scrollView.zoomScale
		let y = pts[0].y * self.scrollView.zoomScale
		
		let w: CGFloat = self.scrollView.frame.width
		let h: CGFloat = self.scrollView.frame.height
		var r = CGRect(x: x, y: y, width: w, height: h)
		r = r.offsetBy(dx: -w * 0.5, dy: -h * 0.5)

		scrollView.scrollRectToVisible(r, animated: false)
		pathView.addPoint(pts[0])
		
	}
	
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return pathView
	}
	
}

class gridPathView: UIView {

	let hReplicatorLayer = CAReplicatorLayer()
	let vReplicatorLayer = CAReplicatorLayer()
	let square = CAShapeLayer()
	
	let routeLayer = CAShapeLayer()
	var routePath = UIBezierPath()
	var points: [CGPoint] = []
	
	let imgView = UIImageView()

	let animDuration: TimeInterval = 0.5

	func addPoint(_ pt: CGPoint) {
		
		let fromPath = UIBezierPath()
		routePath = UIBezierPath()
		
		fromPath.move(to: points[0])
		routePath.move(to: points[0])
		
		for i in 1..<points.count {
			fromPath.addLine(to: points[i])
			routePath.addLine(to: points[i])
		}

		fromPath.addLine(to: points[points.count - 1])
		routePath.addLine(to: pt)

		points.append(pt)

		let anim = CABasicAnimation(keyPath: "path")
		
		anim.duration = animDuration
		anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
		anim.fromValue = fromPath.cgPath
		anim.toValue = routePath.cgPath
		anim.fillMode = .forwards
		anim.isRemovedOnCompletion = false
		anim.delegate = self
		
		self.routeLayer.add(anim, forKey: "path")

		UIView.animate(withDuration: animDuration, delay: 0.0, options: [.curveEaseInOut], animations: {
			self.imgView.center = pt
		}, completion: nil)

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
		layer.addSublayer(vReplicatorLayer)
		layer.addSublayer(routeLayer)

		square.strokeColor = UIColor.yellow.cgColor
		square.fillColor = UIColor.clear.cgColor
		square.lineWidth = 1

		hReplicatorLayer.addSublayer(square)
		vReplicatorLayer.addSublayer(hReplicatorLayer)
		
		routeLayer.strokeColor = UIColor.green.cgColor
		routeLayer.fillColor = UIColor.clear.cgColor
		routeLayer.lineWidth = 5
		
		if let img = UIImage(systemName: "car") {
			imgView.image = img
		}
		imgView.tintColor = .systemRed
		imgView.frame = CGRect(x: 40, y: 40, width: 40, height: 40)
		addSubview(imgView)
	}
	
	var curWidth: CGFloat = 0
	
	override func layoutSubviews() {
		super.layoutSubviews()
	
		self.bringSubviewToFront(imgView)
		
		if points.count == 0 {
			let pt = CGPoint(x: bounds.midX, y: bounds.midY)
			points.append(pt)
			imgView.center = pt
		}

		
//		routePath.move(to: points[0])
//		routePath.addLine(to: points[1])
//		routePath.addLine(to: points[1])

		routeLayer.path = routePath.cgPath

		if curWidth != bounds.width {
			// update grid when bounds changes
			curWidth = bounds.width
			let instanceCount = 10
			let sw: CGFloat = bounds.width / CGFloat(instanceCount)
			let sh: CGFloat = bounds.height / CGFloat(instanceCount)
			let pth = UIBezierPath(rect: CGRect(x: 0.0, y: 0.0, width: sw, height: sh))
			square.path = pth.cgPath
			hReplicatorLayer.instanceCount = instanceCount
			hReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(sw, 0, 0)
			vReplicatorLayer.instanceCount = instanceCount
			vReplicatorLayer.instanceTransform = CATransform3DMakeTranslation(0, sh, 0)
		}

	}

}
extension gridPathView: CAAnimationDelegate {
	func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
		self.routeLayer.path = self.routePath.cgPath
		routeLayer.removeAllAnimations()
	}
}

class tryFollowPathViewController: UIViewController, UIScrollViewDelegate {
	
	let scrollView: UIScrollView = {
		let v = UIScrollView()
		v.contentInsetAdjustmentBehavior = .never
		return v
	}()
	let pathView: PathView = {
		let v = PathView()
		return v
	}()
	
	let carView: CarImageView = {
		let v = CarImageView()
		return v
	}()
	
	var cvCenterX: NSLayoutConstraint!
	var cvCenterY: NSLayoutConstraint!

	let pvSize: CGFloat = 1200.0
	
	var pts: [CGPoint] = []
	var markers: [UIView] = []
	var order: [Int] = []
	var idx: Int = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		guard let pdfFile = Bundle.main.url(forResource: "us-states-map", withExtension: "pdf") else { return }
		
		guard let document = PDFDocument(url: pdfFile) else { return }
		
		let pdfView = PDFView()
		pdfView.document = document
		pdfView.isUserInteractionEnabled = false
		
		guard let pdfR = pdfView.documentView?.frame else { return }
		
		[scrollView, pathView, pdfView].forEach { v in
			v.translatesAutoresizingMaskIntoConstraints = false
		}
		
		// pathView creates its own "car" view, so
		//	insert pdfView below it
		pathView.insertSubview(pdfView, at: 0)
		
		let xs: CGFloat = pdfR.width / 5.0
		let ys: CGFloat = pdfR.height / 6.0
		var x: CGFloat = xs
		var y: CGFloat = ys
		var n: Int = 1
		for i in 1...5 {
			y = ys * CGFloat(i) - ys * 0.25
			x = xs * (i % 2 == 1 ? 0.5 : 0.25)
			for j in 1...5 {
				let v = UILabel()
				v.text = "\(n)"
				v.textAlignment = .center
				v.textColor = .yellow
				v.backgroundColor = .systemBlue
				v.font = .systemFont(ofSize: 14.0, weight: .light)
				v.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
				v.layer.cornerRadius = 20
				v.layer.masksToBounds = true
				pts.append(CGPoint(x: x, y: y + (j % 2 == 1 ? ys * 0.4 : 0)))
				markers.append(v)
				x += xs
				n += 1
			}
		}
		
		for (v, p) in zip(markers, pts) {
			pathView.addSubview(v)
			v.center = p
		}
		
		// let's create a shuffled index for the markers
		order = Array(0..<markers.count) //.shuffled()
		
		// add pathView to the scroll view
		scrollView.addSubview(pathView)
		
		// add scroll view to self.view
		view.addSubview(scrollView)
		
		
		if let img = UIImage(systemName: "car") {
			carView.image = img
		}
		carView.tintColor = .systemYellow
		carView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(carView)
		
		let safeG = view.safeAreaLayoutGuide
		let contentG = scrollView.contentLayoutGuide
		let frameG = scrollView.frameLayoutGuide

		cvCenterX = carView.leadingAnchor.constraint(equalTo: pathView.leadingAnchor, constant: 80.0)
		cvCenterY = carView.topAnchor.constraint(equalTo: pathView.topAnchor, constant: 180.0)
		cvCenterX.priority = .required
		cvCenterY.priority = .required
		let cvt = carView.topAnchor.constraint(greaterThanOrEqualTo: scrollView.topAnchor, constant: 8.0)
		let cvl = carView.leadingAnchor.constraint(greaterThanOrEqualTo: scrollView.leadingAnchor, constant: 8.0)
		let cvr = carView.trailingAnchor.constraint(lessThanOrEqualTo: scrollView.trailingAnchor, constant: -8.0)
		let cvb = carView.bottomAnchor.constraint(lessThanOrEqualTo: scrollView.bottomAnchor, constant: -8.0)

		[cvt, cvl, cvr, cvb].forEach { c in
			c.priority = .required
		}

		NSLayoutConstraint.activate([
			
			// scroll view Top/Leading/Trailing/Bottom to safe area
			scrollView.topAnchor.constraint(equalTo: safeG.topAnchor, constant: 40.0),
			scrollView.leadingAnchor.constraint(equalTo: safeG.leadingAnchor, constant: 40.0),
			scrollView.trailingAnchor.constraint(equalTo: safeG.trailingAnchor, constant: -40.0),
			scrollView.bottomAnchor.constraint(equalTo: safeG.bottomAnchor, constant: -40.0),
			
			// pathView Top/Leading/Trailing/Bottom to scroll view's CONTENT GUIDE
			pathView.topAnchor.constraint(equalTo: contentG.topAnchor, constant: 0.0),
			pathView.leadingAnchor.constraint(equalTo: contentG.leadingAnchor, constant: 0.0),
			pathView.trailingAnchor.constraint(equalTo: contentG.trailingAnchor, constant: 0.0),
			pathView.bottomAnchor.constraint(equalTo: contentG.bottomAnchor, constant: 0.0),
			
			pdfView.topAnchor.constraint(equalTo: pathView.topAnchor, constant: 0.0),
			pdfView.leadingAnchor.constraint(equalTo: pathView.leadingAnchor, constant: 0.0),
			pdfView.trailingAnchor.constraint(equalTo: pathView.trailingAnchor, constant: 0.0),
			pdfView.bottomAnchor.constraint(equalTo: pathView.bottomAnchor, constant: 0.0),
			
			pathView.widthAnchor.constraint(equalToConstant: pdfR.width),
			pathView.heightAnchor.constraint(equalToConstant: pdfR.height),
			
			carView.widthAnchor.constraint(equalToConstant: 40.0),
			carView.heightAnchor.constraint(equalTo: carView.widthAnchor),

//			carView.topAnchor.constraint(greaterThanOrEqualTo: frameG.topAnchor, constant: 8.0),
//			carView.leadingAnchor.constraint(greaterThanOrEqualTo: frameG.leadingAnchor, constant: 8.0),
//			carView.trailingAnchor.constraint(lessThanOrEqualTo: frameG.trailingAnchor, constant: -8.0),
//			carView.bottomAnchor.constraint(lessThanOrEqualTo: frameG.bottomAnchor, constant: -8.0),

			cvt, cvl, cvr, cvb,
			cvCenterX, cvCenterY,
			
		])
		
		scrollView.delegate = self
		scrollView.minimumZoomScale = 0.25
		scrollView.maximumZoomScale = 3.0
		
		// so we can see the scroll view frame
		scrollView.layer.borderWidth = 2
		scrollView.layer.borderColor = UIColor.red.cgColor
		
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		print(pathView.frame)
		cvCenterX.constant += 60.0
		UIView.animate(withDuration: 0.5, animations: {
			self.view.layoutIfNeeded()
		})
		return()
		
		self.idx += 1
		
		let newPT = self.pts[self.order[self.idx % self.order.count]]
		
		self.pathView.addPoint(newPT)
		
		if true {
			// convert the point to a rect using scroll view's zoomScale
			let sz: CGFloat = 40.0
			
			let x = newPT.x * self.scrollView.zoomScale
			let y = newPT.y * self.scrollView.zoomScale
			
			var r = CGRect(x: x, y: y, width: sz, height: sz)
			r = r.offsetBy(dx: -sz * 0.5, dy: -sz * 0.5)
			
			if !self.scrollView.bounds.contains(r) {
				// convert the point to a rect using scroll view's zoomScale
				let w: CGFloat = self.scrollView.frame.width
				let h: CGFloat = self.scrollView.frame.height
				r = CGRect(x: x, y: y, width: w, height: h)
				r = r.offsetBy(dx: -w * 0.5, dy: -h * 0.5)
			}
			
			UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: {
				self.scrollView.scrollRectToVisible(r, animated: false)
			}, completion: nil)
			
		} else {
			// convert the point to a rect using scroll view's zoomScale
			let w: CGFloat = self.scrollView.frame.width
			let h: CGFloat = self.scrollView.frame.height
			let x = newPT.x * self.scrollView.zoomScale
			let y = newPT.y * self.scrollView.zoomScale
			var r = CGRect(x: x, y: y, width: w, height: h)
			r = r.offsetBy(dx: -w * 0.5, dy: -h * 0.5)
			UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: {
				self.scrollView.scrollRectToVisible(r, animated: false)
			}, completion: nil)
		}
		
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		scrollView.contentOffset.x = cvCenterX.constant
		scrollView.contentOffset.y = cvCenterY.constant

		let x = pts[0].x * self.scrollView.zoomScale
		let y = pts[0].y * self.scrollView.zoomScale
		
		let w: CGFloat = self.scrollView.frame.width
		let h: CGFloat = self.scrollView.frame.height
		var r = CGRect(x: x, y: y, width: w, height: h)
		r = r.offsetBy(dx: -w * 0.5, dy: -h * 0.5)
		
		//scrollView.scrollRectToVisible(r, animated: false)
		//pathView.addPoint(pts[0])
		
	}
	
//	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//		return pathView
//	}
	
}

class CarImageView: UIImageView {
	
}

class PathView: UIView {
	
	let routeLayer = CAShapeLayer()
	var routePath = UIBezierPath()
	var points: [CGPoint] = []
	
	let imgView = UIImageView()
	
	let animDuration: TimeInterval = 0.5
	
	func addPoint(_ pt: CGPoint) {
		
		if points.count == 0 {
			points.append(pt)
			self.imgView.center = pt
			return
		}
		
		let fromPath = UIBezierPath()
		routePath = UIBezierPath()
		
		fromPath.move(to: points[0])
		routePath.move(to: points[0])
		
		for i in 1..<points.count {
			fromPath.addLine(to: points[i])
			routePath.addLine(to: points[i])
		}
		
		fromPath.addLine(to: points[points.count - 1])
		routePath.addLine(to: pt)
		
		points.append(pt)
		
		let anim = CABasicAnimation(keyPath: "path")
		
		anim.duration = animDuration
		anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
		anim.fromValue = fromPath.cgPath
		anim.toValue = routePath.cgPath
		anim.fillMode = .forwards
		anim.isRemovedOnCompletion = false
		anim.delegate = self
		
		self.routeLayer.add(anim, forKey: "path")
		
		UIView.animate(withDuration: animDuration, delay: 0.0, options: [.curveEaseInOut], animations: {
			self.imgView.center = pt
		}, completion: nil)
		
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
		
		routeLayer.strokeColor = UIColor.green.cgColor
		routeLayer.fillColor = UIColor.clear.cgColor
		routeLayer.lineWidth = 5
		layer.addSublayer(routeLayer)
		
		if let img = UIImage(systemName: "car") {
			imgView.image = img
		}
		imgView.tintColor = .systemRed
		imgView.frame = CGRect(x: 40, y: 40, width: 40, height: 40)
		addSubview(imgView)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()

		// make sure car is in front
		self.bringSubviewToFront(imgView)
		
//		if points.count == 0 {
//			let pt = CGPoint(x: bounds.midX, y: bounds.midY)
//			points.append(pt)
//			imgView.center = pt
//		}

	}
	
}

extension PathView: CAAnimationDelegate {
	func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
		self.routeLayer.path = self.routePath.cgPath
		routeLayer.removeAllAnimations()
	}
}


class CenterInScrollVC: UIViewController, UIScrollViewDelegate {
	
	let scrollView: UIScrollView = {
		let v = UIScrollView()
		return v
	}()
	
	// can be any type of view
	//	using a "Dashed Outline" so we can see its edges
	let mapView: DashView = {
		let v = DashView()
		v.backgroundColor = UIColor(white: 0.9, alpha: 0.5)
		v.color = .blue
		v.style = .border
		return v
	}()

	var mapMarkers: [UIView] = []
	var markerIndex: Int = 0
	
	// let's make the markers 40x40
	let markerSize: CGFloat = 40.0
	
	// percentage of one-half of marker that must be visible to NOT screll to center
	//	1.0 == entire marker must be visible
	//	0.5 == up to 1/4 of marker may be out of view
	//	<= 0.0 == only check that the Center of the marker is in view
	//	can be set to > 1.0 to require entire marker Plus some "padding"
	let pctVisible: CGFloat = 1.0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// a button to center the current marker (if needed)
		let btnA: UIButton = {
			let v = UIButton()
			v.backgroundColor = .systemRed
			v.setTitleColor(.white, for: .normal)
			v.setTitleColor(.lightGray, for: .highlighted)
			v.setTitle("Center Current if Needed", for: [])
			v.addTarget(self, action: #selector(btnATap(_:)), for: .touchUpInside)
			return v
		}()
		
		// a button to select the next marker, center if needed
		let btnB: UIButton = {
			let v = UIButton()
			v.backgroundColor = .systemRed
			v.setTitleColor(.white, for: .normal)
			v.setTitleColor(.lightGray, for: .highlighted)
			v.setTitle("Go To Marker - 2", for: [])
			v.addTarget(self, action: #selector(btnBTap(_:)), for: .touchUpInside)
			return v
		}()
		
		// add a view with a "+" marker to show the center of the scroll view
		let centerView: DashView = {
			let v = DashView()
			v.backgroundColor = .clear
			v.color = UIColor(red: 0.95, green: 0.2, blue: 1.0, alpha: 0.5)
			v.style = .centerMarker
			v.isUserInteractionEnabled = false
			return v
		}()
		
		[btnA, btnB, mapView, scrollView, centerView].forEach { v in
			v.translatesAutoresizingMaskIntoConstraints = false
		}
		
		[btnA, btnB, scrollView, centerView].forEach { v in
			view.addSubview(v)
		}

		scrollView.addSubview(mapView)
		
		let safeG = view.safeAreaLayoutGuide
		let contentG = scrollView.contentLayoutGuide
		let frameG = scrollView.frameLayoutGuide
		
		NSLayoutConstraint.activate([
			
			// buttons at the top
			btnA.topAnchor.constraint(equalTo: safeG.topAnchor, constant: 20.0),
			btnA.widthAnchor.constraint(equalTo: safeG.widthAnchor, multiplier: 0.7),
			btnA.centerXAnchor.constraint(equalTo: safeG.centerXAnchor),
			
			btnB.topAnchor.constraint(equalTo: btnA.bottomAnchor, constant: 20.0),
			btnB.widthAnchor.constraint(equalTo: btnA.widthAnchor),
			btnB.centerXAnchor.constraint(equalTo: safeG.centerXAnchor),
			
			// let's inset the scroll view to make it easier to distinguish
			scrollView.topAnchor.constraint(equalTo: btnB.bottomAnchor, constant: 40.0),
			scrollView.leadingAnchor.constraint(equalTo: safeG.leadingAnchor, constant: 40.0),
			scrollView.trailingAnchor.constraint(equalTo: safeG.trailingAnchor, constant: -40.0),
			scrollView.bottomAnchor.constraint(equalTo: safeG.bottomAnchor, constant: -40.0),
			
			// overlay "center lines" view
			centerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
			centerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
			centerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
			centerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

			// mapView Top/Leading/Trailing/Bottom to scroll view's CONTENT GUIDE
			mapView.topAnchor.constraint(equalTo: contentG.topAnchor, constant: 0.0),
			mapView.leadingAnchor.constraint(equalTo: contentG.leadingAnchor, constant: 0.0),
			mapView.trailingAnchor.constraint(equalTo: contentG.trailingAnchor, constant: 0.0),
			mapView.bottomAnchor.constraint(equalTo: contentG.bottomAnchor, constant: 0.0),
			
			// let's make the mapView twice as wide and tall as the scroll view
			mapView.widthAnchor.constraint(equalTo: frameG.widthAnchor, multiplier: 2.0),
			mapView.heightAnchor.constraint(equalTo: frameG.heightAnchor, multiplier: 2.0),
			
		])
		
		// some example locations for the Markers
		let pcts: [[CGFloat]] = [
			
			[0.50, 0.50],
			
			[0.25, 0.50],
			[0.50, 0.25],
			[0.75, 0.50],
			[0.50, 0.75],

			[0.10, 0.15],
			[0.90, 0.15],
			[0.90, 0.85],
			[0.10, 0.85],
			
		]
		for (i, p) in pcts.enumerated() {
			let v = UILabel()
			v.text = "\(i + 1)"
			v.textAlignment = .center
			v.textColor = .yellow
			v.backgroundColor = .systemBlue
			v.font = .systemFont(ofSize: 15.0, weight: .bold)
			v.translatesAutoresizingMaskIntoConstraints = false
			mapMarkers.append(v)
			mapView.addSubview(v)
			v.widthAnchor.constraint(equalToConstant: markerSize).isActive = true
			v.heightAnchor.constraint(equalTo: v.widthAnchor).isActive = true
			NSLayoutConstraint(item: v, attribute: .centerX, relatedBy: .equal, toItem: mapView, attribute: .trailing, multiplier: p[0], constant: 0.0).isActive = true
			NSLayoutConstraint(item: v, attribute: .centerY, relatedBy: .equal, toItem: mapView, attribute: .bottom, multiplier: p[1], constant: 0.0).isActive = true
		}
		
		scrollView.minimumZoomScale = 0.5
		scrollView.maximumZoomScale = 5.0
		scrollView.delegate = self
		
		let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.onLongPress(gesture:)))
		//self.hostingController.view.addGestureRecognizer(longPressGestureRecognizer)
		//scrollView.addGestureRecognizer(longPressGestureRecognizer)
		mapView.addGestureRecognizer(longPressGestureRecognizer)
	}
	
	@objc func onLongPress(gesture: UILongPressGestureRecognizer) {
		switch gesture.state {
		case .began:
			guard let view = gesture.view else { break }
			let location = gesture.location(in: view)
			let pinPointWidth = 32.0
			let pinPointHeight = 42.0
			let x = location.x - (pinPointWidth / 2)
			let y = location.y - pinPointHeight
			let finalLocation = CGPoint(x: x / scrollView.zoomScale, y: y)
//			let cfg = UIImage.SymbolConfiguration(pointSize: 20.0)
//			if let img = UIImage(systemName: "mappin.and.ellipse", withConfiguration: cfg) {
			if let img = UIImage(named: "mapMarker1") {
				let mv = UIImageView(image: img)
				mv.frame = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height * 2.0)
				mv.contentMode = .top
				mv.tintColor = .red
				mv.center = location
				//mv.frame.origin = CGPoint(x: location.x - img.size.width * 0.5, y: location.y - img.size.height * 0.5)
				mv.backgroundColor = .systemYellow.withAlphaComponent(0.5)
				mapView.addSubview(mv)
				let s = 1.0 / scrollView.zoomScale
				let t: CGAffineTransform = .identity
				mv.transform = t.scaledBy(x: s, y: s)
			}
			print(finalLocation, "v:", view.frame.size)
			//self.onLongPress(finalLocation)
		default:
			break
		}
	}

	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		let markers = mapView.subviews.filter({$0 is UIImageView})
		markers.forEach { v in
			let s = 1.0 / scrollView.zoomScale
			let t: CGAffineTransform = .identity
			v.transform = t.scaledBy(x: s, y: s)
			//v.frame.size = CGSize(width: 32.0 / scrollView.zoomScale, height: 42.0 / scrollView.zoomScale)
		}
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		// let's start with the scroll view zoomed out
		scrollView.zoomScale = 1.0 //scrollView.minimumZoomScale
		
		// highlight and center (if needed) the 1st marker
		markerIndex = 0
		let marker = mapMarkers[markerIndex % mapMarkers.count]
		highlightMarkerAndCenterIfNeeded(marker, animated: true)
	}

	@objc func btnATap(_ sender: Any?) {
		scrollView.zoomScale = scrollView.zoomScale == 1.0 ? 2.0 : 1.0
		// to easily test "center if not visible" without changing the "current marker"
		let marker = mapMarkers[markerIndex % mapMarkers.count]
		highlightMarkerAndCenterIfNeeded(marker, animated: true)
	}
	
	@objc func btnBTap(_ sender: Any?) {
		// increment index to the next marker
		markerIndex += 1
		let marker = mapMarkers[markerIndex % mapMarkers.count]
		// center if needed
		highlightMarkerAndCenterIfNeeded(marker, animated: true)
		// update button title
		if let b = sender as? UIButton, let m = mapMarkers[(markerIndex + 1) % mapMarkers.count] as? UILabel, let t = m.text {
			b.setTitle("Go To Marker - \(t)", for: [])
		}
	}
	
	func highlightMarkerAndCenterIfNeeded(_ marker: UIView, animated: Bool) {
		
		// "un-highlight" all markers
		mapMarkers.forEach { v in
			v.backgroundColor = .systemBlue
		}
		// "highlight" the new marker
		marker.backgroundColor = .systemGreen

		// get the marker frame, scaled by zoom scale
		var r = marker.frame.applying(CGAffineTransform(scaleX: self.scrollView.zoomScale, y: self.scrollView.zoomScale))
		
		// inset the rect if we allow less-than-full marker visible
		if pctVisible > 0.0 {
			let iw: CGFloat = (1.0 - pctVisible) * r.width * 0.5
			let ih: CGFloat = (1.0 - pctVisible) * r.height * 0.5
			r = r.insetBy(dx: iw, dy: ih)
		}
		
		var isInside: Bool = true
		
		if pctVisible <= 0.0 {
			// check center point only
			isInside = self.scrollView.bounds.contains(CGPoint(x: r.midX, y: r.midY))
		} else {
			// check the rect
			isInside = self.scrollView.bounds.contains(r)
		}
		
		// if the marker rect (or point) IS inside the scroll view
		//	we don't do anything
		
		// if it's NOT inside the scroll view
		//	center it
		
		if !isInside {
			// create a rect using scroll view's bounds centered on marker's center
			let w: CGFloat = self.scrollView.bounds.width
			let h: CGFloat = self.scrollView.bounds.height
			r = CGRect(x: r.midX, y: r.midY, width: w, height: h).offsetBy(dx: -w * 0.5, dy: -h * 0.5)

			if animated {
				// let's slow down the animation a little
				UIView.animate(withDuration: 0.75, delay: 0.0, options: [.curveEaseInOut], animations: {
					self.scrollView.scrollRectToVisible(r, animated: false)
				}, completion: nil)
			} else {
				self.scrollView.scrollRectToVisible(r, animated: false)
			}
		}
		
	}

	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return mapView
	}
	
}

class zCenterInScrollVC: UIViewController, UIScrollViewDelegate {
	
	let scrollView: UIScrollView = {
		let v = UIScrollView()
		return v
	}()
	
	// can be any type of view
	//	using a "Dashed Outline" so we can see its edges
	let mapView: DashView = {
		let v = DashView()
		v.backgroundColor = UIColor(white: 0.9, alpha: 0.5)
		v.color = .clear
		v.style = .border
		return v
	}()
	
	var mapMarkers: [UIView] = []
	var markerIndex: Int = 0
	
	// let's make the markers 40x40 (we'll round them to a circle)
	let markerSize: CGFloat = 30.0
	
	// percentage of one-half of marker that must be visible to NOT screll to center
	//	1.0 == entire marker must be visible
	//	0.5 == up to 1/4 of marker may be out of view
	//	<= 0.0 == only check that the Center of the marker is in view
	//	can be set to > 1.0 to require entire marker Plus some "padding"
	let pctVisible: CGFloat = 1.0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .systemBackground
		
		// a button to center the current marker (if needed)
		let btnA: UIButton = {
			let v = UIButton()
			v.backgroundColor = .systemRed
			v.setTitleColor(.white, for: .normal)
			v.setTitleColor(.lightGray, for: .highlighted)
			v.setTitle("Center Current if Needed", for: [])
			v.addTarget(self, action: #selector(btnATap(_:)), for: .touchUpInside)
			return v
		}()
		
		// a button to select the next marker, center if needed
		let btnB: UIButton = {
			let v = UIButton()
			v.backgroundColor = .systemRed
			v.setTitleColor(.white, for: .normal)
			v.setTitleColor(.lightGray, for: .highlighted)
			v.setTitle("Go To Marker - 2", for: [])
			v.addTarget(self, action: #selector(btnBTap(_:)), for: .touchUpInside)
			return v
		}()
		
		// add a view with a "+" marker to show the center of the scroll view
		let centerView: DashView = {
			let v = DashView()
			v.backgroundColor = .clear
			v.color = UIColor(red: 0.95, green: 0.2, blue: 1.0, alpha: 0.5)
			v.style = .centerMarker
			v.isUserInteractionEnabled = false
			return v
		}()
		
		[btnA, btnB, mapView, scrollView, centerView].forEach { v in
			v.translatesAutoresizingMaskIntoConstraints = false
		}
		
		[btnA, btnB, scrollView, centerView].forEach { v in
			view.addSubview(v)
		}
		
		scrollView.addSubview(mapView)
		
		let safeG = view.safeAreaLayoutGuide
		let contentG = scrollView.contentLayoutGuide
		let frameG = scrollView.frameLayoutGuide
		
		NSLayoutConstraint.activate([
			
			// buttons at the top
			btnA.topAnchor.constraint(equalTo: safeG.topAnchor, constant: 20.0),
			btnA.widthAnchor.constraint(equalTo: safeG.widthAnchor, multiplier: 0.7),
			btnA.centerXAnchor.constraint(equalTo: safeG.centerXAnchor),
			
			btnB.topAnchor.constraint(equalTo: btnA.bottomAnchor, constant: 20.0),
			btnB.widthAnchor.constraint(equalTo: btnA.widthAnchor),
			btnB.centerXAnchor.constraint(equalTo: safeG.centerXAnchor),
			
			// let's inset the scroll view to make it easier to distinguish
			scrollView.topAnchor.constraint(equalTo: btnB.bottomAnchor, constant: 40.0),
//			scrollView.leadingAnchor.constraint(equalTo: safeG.leadingAnchor, constant: 40.0),
//			scrollView.trailingAnchor.constraint(equalTo: safeG.trailingAnchor, constant: -40.0),
//			scrollView.bottomAnchor.constraint(equalTo: safeG.bottomAnchor, constant: -40.0),
			scrollView.widthAnchor.constraint(equalToConstant: 200.0),
			scrollView.heightAnchor.constraint(equalToConstant: 300.0),
			scrollView.centerXAnchor.constraint(equalTo: safeG.centerXAnchor),
			
			// overlay "center lines" view
			centerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
			centerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
			centerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
			centerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
			
			// mapView Top/Leading/Trailing/Bottom to scroll view's CONTENT GUIDE
			mapView.topAnchor.constraint(equalTo: contentG.topAnchor, constant: 0.0),
			mapView.leadingAnchor.constraint(equalTo: contentG.leadingAnchor, constant: 0.0),
			mapView.trailingAnchor.constraint(equalTo: contentG.trailingAnchor, constant: 0.0),
			mapView.bottomAnchor.constraint(equalTo: contentG.bottomAnchor, constant: 0.0),
			
			// let's make the mapView twice as wide and tall as the scroll view
			mapView.widthAnchor.constraint(equalTo: frameG.widthAnchor, multiplier: 2.0),
			mapView.heightAnchor.constraint(equalTo: frameG.heightAnchor, multiplier: 2.0),
			
		])

		let v = UILabel()
		v.text = "1"
		v.textAlignment = .center
		v.textColor = .yellow
		v.backgroundColor = .systemBlue
		v.font = .systemFont(ofSize: 15.0, weight: .bold)
//		v.layer.cornerRadius = markerSize * 0.5
//		v.layer.masksToBounds = true
		v.translatesAutoresizingMaskIntoConstraints = false
		mapMarkers.append(v)
		mapView.addSubview(v)
		v.widthAnchor.constraint(equalToConstant: markerSize).isActive = true
		v.heightAnchor.constraint(equalTo: v.widthAnchor).isActive = true
		v.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 400.0).isActive = true
		v.leadingAnchor.constraint(equalTo: mapView.leadingAnchor, constant: 240.0).isActive = true

		// some example locations for the Markers
//		let pcts: [[CGFloat]] = [
//
//			[0.50, 0.50],
//
//			[0.25, 0.50],
//			[0.50, 0.25],
//			[0.75, 0.50],
//			[0.50, 0.75],
//
//			[0.10, 0.15],
//			[0.90, 0.15],
//			[0.90, 0.85],
//			[0.10, 0.85],
//
//		]
//		for (i, p) in pcts.enumerated() {
//			let v = UILabel()
//			v.text = "\(i + 1)"
//			v.textAlignment = .center
//			v.textColor = .yellow
//			v.backgroundColor = .systemBlue
//			v.font = .systemFont(ofSize: 15.0, weight: .bold)
//			v.layer.cornerRadius = markerSize * 0.5
//			v.layer.masksToBounds = true
//			v.translatesAutoresizingMaskIntoConstraints = false
//			mapMarkers.append(v)
//			mapView.addSubview(v)
//			v.widthAnchor.constraint(equalToConstant: markerSize).isActive = true
//			v.heightAnchor.constraint(equalTo: v.widthAnchor).isActive = true
//			NSLayoutConstraint(item: v, attribute: .centerX, relatedBy: .equal, toItem: mapView, attribute: .trailing, multiplier: p[0], constant: 0.0).isActive = true
//			NSLayoutConstraint(item: v, attribute: .centerY, relatedBy: .equal, toItem: mapView, attribute: .bottom, multiplier: p[1], constant: 0.0).isActive = true
//		}
		
		scrollView.minimumZoomScale = 0.5
		scrollView.maximumZoomScale = 3.0
		scrollView.delegate = self
		
		scrollView.backgroundColor = .systemYellow
		
		scrollView.showsVerticalScrollIndicator = false
		scrollView.showsHorizontalScrollIndicator = false

		centerView.isHidden = true
		btnA.isHidden = true
		btnB.isHidden = true
	}
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		print(scrollView.contentSize)
		print(scrollView.bounds)
		markerIndex = 0
		let marker = mapMarkers[markerIndex % mapMarkers.count]
		showMarkerCenterIfNeeded(marker, animated: true)
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		// let's start with the scroll view zoomed out
		scrollView.zoomScale = 1.0 //scrollView.minimumZoomScale
		
		// highlight and center (if needed) the 1st marker
		markerIndex = 0
		let marker = mapMarkers[markerIndex % mapMarkers.count]
//		marker.backgroundColor = .systemGreen
		showMarkerCenterIfNeeded(marker, animated: true)
	}
	
	@objc func btnATap(_ sender: Any?) {
		// to easily test "center if not visible"
		let marker = mapMarkers[markerIndex % mapMarkers.count]
		showMarkerCenterIfNeeded(marker, animated: true)
	}
	
	@objc func btnBTap(_ sender: Any?) {
		// "un-highlight" all markers
		mapMarkers.forEach { v in
			v.backgroundColor = .systemBlue
		}
		// increment index to the next marker
		markerIndex += 1
		let marker = mapMarkers[markerIndex % mapMarkers.count]
		// "highlight" the marker
		marker.backgroundColor = .systemGreen
		// center if needed
		showMarkerCenterIfNeeded(marker, animated: true)
		// update button title
		if let b = sender as? UIButton, let m = mapMarkers[(markerIndex + 1) % mapMarkers.count] as? UILabel, let t = m.text {
			b.setTitle("Go To Marker - \(t)", for: [])
		}
	}
	
	func showMarkerCenterIfNeeded(_ marker: UIView, animated: Bool) {
		
		// get the marker frame, scaled by zoom scale
		var r = marker.frame.applying(CGAffineTransform(scaleX: self.scrollView.zoomScale, y: self.scrollView.zoomScale))
		
		// inset the rect if we allow less-than-full marker visible
		if pctVisible > 0.0 {
			let iw: CGFloat = (1.0 - pctVisible) * r.width * 0.5
			let ih: CGFloat = (1.0 - pctVisible) * r.height * 0.5
			r = r.insetBy(dx: iw, dy: ih)
		}
		
		var isInside: Bool = true
		
		if pctVisible <= 0.0 {
			// check center point only
			isInside = self.scrollView.bounds.contains(CGPoint(x: r.midX, y: r.midY))
		} else {
			// check the rect
			isInside = self.scrollView.bounds.contains(r)
		}
		
		// if the marker rect (or point) IS inside the scroll view
		//	we don't do anything
		
		// if it's NOT inside the scroll view
		//	center it
		
		if !isInside {
			// create a rect using scroll view's frame centered on marker's center
			let w: CGFloat = self.scrollView.frame.width
			let h: CGFloat = self.scrollView.frame.height
			r = CGRect(x: r.midX, y: r.midY, width: w, height: h).offsetBy(dx: -w * 0.5, dy: -h * 0.5)
			
			if animated {
				UIView.animate(withDuration: 0.5, delay: 0.0, options: [.curveEaseInOut], animations: {
					self.scrollView.scrollRectToVisible(r, animated: false)
				}, completion: nil)
			} else {
				self.scrollView.scrollRectToVisible(r, animated: false)
			}
		}
		
	}
	
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return mapView
	}
	
}


class DashView: UIView {
	// border or
	// vertical and horizontal center lines or
	// two lines forming a + in the center
	enum Style: Int {
		case border
		case centerLines
		case centerMarker
	}
	
	public var style: Style = .border {
		didSet {
			setNeedsLayout()
		}
	}

	// solid or dashed
	public var solid: Bool = false
	
	// line color
	public var color: UIColor = .yellow {
		didSet {
			dashLayer.strokeColor = color.cgColor
		}
	}
	
	private let dashLayer = CAShapeLayer()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	private func commonInit() {
		layer.addSublayer(dashLayer)
		dashLayer.strokeColor = color.cgColor
		dashLayer.fillColor = UIColor.clear.cgColor
		dashLayer.lineWidth = 2
		
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		var bez = UIBezierPath()
		switch style {
		case .border:
			bez = UIBezierPath(rect: bounds)
			dashLayer.lineDashPattern = [10, 10]

		case .centerLines:
			bez.move(to: CGPoint(x: bounds.midX, y: bounds.minY))
			bez.addLine(to: CGPoint(x: bounds.midX, y: bounds.maxY))
			bez.move(to: CGPoint(x: bounds.minX, y: bounds.midY))
			bez.addLine(to: CGPoint(x: bounds.maxX, y: bounds.midY))
			dashLayer.lineDashPattern = [10, 10]

		case .centerMarker:
			bez.move(to: CGPoint(x: bounds.midX, y: bounds.midY - 40.0))
			bez.addLine(to: CGPoint(x: bounds.midX, y: bounds.midY + 40.0))
			bez.move(to: CGPoint(x: bounds.midX - 40.0, y: bounds.midY))
			bez.addLine(to: CGPoint(x: bounds.midX + 40.0, y: bounds.midY))
			dashLayer.lineDashPattern = []
		}
		if solid {
			dashLayer.lineDashPattern = []
		}
		dashLayer.path = bez.cgPath
	}
}

class MyMapView: UIView {
	let cornerLayer = CAShapeLayer()

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {
		layer.addSublayer(cornerLayer)
		cornerLayer.strokeColor = UIColor.blue.cgColor
		cornerLayer.fillColor = UIColor.clear.cgColor
		cornerLayer.lineWidth = 2
		cornerLayer.lineDashPattern = [12, 12]

	}
	override func layoutSubviews() {
		super.layoutSubviews()
		
		cornerLayer.path = UIBezierPath(rect: bounds.insetBy(dx: 8, dy: 8)).cgPath
		return()
		
		// add "corner lines"
		let bez = UIBezierPath()
		var pt: CGPoint = .zero
		
		let pad: CGFloat = 8
		let len: CGFloat = 40

		// top-left
		pt.x = bounds.minX + pad
		pt.y = bounds.minY + pad + len
		bez.move(to: pt)
		pt.y -= len
		bez.addLine(to: pt)
		pt.x += len
		bez.addLine(to: pt)

		// top-right
		pt.x = bounds.maxX - (pad + len)
		bez.move(to: pt)
		pt.x += len
		bez.addLine(to: pt)
		pt.y += len
		bez.addLine(to: pt)
		
		// bottom-right
		pt.y = bounds.maxY - (pad + len)
		bez.move(to: pt)
		pt.y += len
		bez.addLine(to: pt)
		pt.x -= len
		bez.addLine(to: pt)
		
		// bottom-left
		pt.x = bounds.minX + (pad + len)
		bez.move(to: pt)
		pt.x -= len
		bez.addLine(to: pt)
		pt.y -= len
		bez.addLine(to: pt)
		
		cornerLayer.path = bez.cgPath
	}
}



class SFVC: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
//		guard let img = UIImage(named: "ex1") else { return }
//		
//		var d = img.jpegData(compressionQuality: 1.0)
//		print(d?.count)
//		d = img.jpegData(compressionQuality: 1)
//		print(d?.count)
//		d = img.jpegData(compressionQuality: 0.9)
//		print(d?.count)
//		d = img.jpegData(compressionQuality: 0.8)
//		print(d?.count)

	}
	
}

class NavTestVC: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.addCustomTransitioning()
	}
}

class SlideViewVC: UIViewController {

	let label = UILabel()
	let labelHolderView = UIView()
	
	var labelTop: NSLayoutConstraint!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.title = "Nav Bar"

		// configure the label
		label.textAlignment = .center
		label.text = "I'm going to slide up."
		label.backgroundColor = .systemYellow
		
		// add it to the holder view
		labelHolderView.addSubview(label)
		
		// prevents label from showing outside the bounds
		labelHolderView.clipsToBounds = true

		label.translatesAutoresizingMaskIntoConstraints = false
		labelHolderView.translatesAutoresizingMaskIntoConstraints = false

		// add holder view to self.view
		view.addSubview(labelHolderView)

		// constant height for the label
		let labelHeight: CGFloat = 160.0
		
		// setup label top constraint
		labelTop = label.topAnchor.constraint(equalTo: labelHolderView.topAnchor)
		
		let g = view.safeAreaLayoutGuide
		
		NSLayoutConstraint.activate([

			// activate label top constraint
			labelTop,
			
			// constrain label Leading/Trailing to holder
			//	we'll inset it by 20-points so we can see the holder view
			label.leadingAnchor.constraint(equalTo: labelHolderView.leadingAnchor, constant: 20.0),
			label.trailingAnchor.constraint(equalTo: labelHolderView.trailingAnchor, constant: -20.0),
			
			// constant height
			label.heightAnchor.constraint(equalToConstant: labelHeight),
			
			// label gets NO Bottom constraint
			
			// constrain holder to safe area
			labelHolderView.topAnchor.constraint(equalTo: g.topAnchor),
			labelHolderView.leadingAnchor.constraint(equalTo: g.leadingAnchor),
			labelHolderView.trailingAnchor.constraint(equalTo: g.trailingAnchor),

			// constant height (same as label height)
			labelHolderView.heightAnchor.constraint(equalTo: label.heightAnchor),
			
		])
		
		// let's add a button to animate the label
		//	and one to show/hide the holder view
		let btn1 = UIButton(type: .system)
		btn1.setTitle("Animate It", for: [])
		btn1.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(btn1)
		
		let btn2 = UIButton(type: .system)
		btn2.setTitle("Toggle Holder View Color", for: [])
		btn2.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(btn2)

		NSLayoutConstraint.activate([
			// put the first button below the holder view
			btn1.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			btn1.topAnchor.constraint(equalTo: labelHolderView.bottomAnchor, constant: 20.0),
			// second button below it
			btn2.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			btn2.topAnchor.constraint(equalTo: btn1.bottomAnchor, constant: 20.0),

		])
		

		// give the buttons an action
		btn1.addTarget(self, action: #selector(animLabel(_:)), for: .touchUpInside)
		btn2.addTarget(self, action: #selector(toggleHolderColor(_:)), for: .touchUpInside)

	}
	
	@objc func animLabel(_ sender: Any?) {
		// animate the label up if it's down, down if it's up
		labelTop.constant = labelTop.constant == 0 ? -label.frame.height : 0
		UIView.animate(withDuration: 0.5, animations: {
			self.view.layoutIfNeeded()
		})
	}
	
	@objc func toggleHolderColor(_ sender: Any?) {
		labelHolderView.backgroundColor = labelHolderView.backgroundColor == .red ? .clear : .red
	}
	
}
