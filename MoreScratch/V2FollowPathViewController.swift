//
//  FollowPathViewController.swift
//  MoreScratch
//
//  Created by Don Mag on 4/13/22.
//

import UIKit

import PDFKit
import SwiftUI


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
		
		guard let img = UIImage(systemName: "circle") else { return }
		print()
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
		scrollView.maximumZoomScale = 3.0
		scrollView.delegate = self
		
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		// let's start with the scroll view zoomed out
		scrollView.zoomScale = scrollView.minimumZoomScale
		
		// highlight and center (if needed) the 1st marker
		markerIndex = 0
		let marker = mapMarkers[markerIndex % mapMarkers.count]
		highlightMarkerAndCenterIfNeeded(marker, animated: true)
	}

	@objc func btnATap(_ sender: Any?) {
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
