//
//  MoreExpCellViewController.swift
//  MoreScratch
//
//  Created by Don Mag on 5/30/22.
//

import UIKit

struct MyTeam {
	var name: String = ""
	var logo: String = ""
	var country: String = ""
	var founded: String = ""
	var code: String = ""
	var national: Bool = false
	var isOpen: Bool = false
}

class TeamCell: UITableViewCell {
	let titleStack: UIStackView = {
		let v = UIStackView()
		return v
	}()
	let bodyStack: UIStackView = {
		let v = UIStackView()
		v.axis = .vertical
		v.spacing = 4
		return v
	}()
	let nameLabel: UILabel = {
		let v = UILabel()
		v.font = .systemFont(ofSize: 20.0, weight: .bold)
		return v
	}()
	let logoImageView: UIImageView = {
		let v = UIImageView()
		return v
	}()
	
	var closedConstraint: NSLayoutConstraint!
	var openConstraint: NSLayoutConstraint!
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {
		[titleStack, bodyStack].forEach { v in
			v.translatesAutoresizingMaskIntoConstraints = false
			contentView.addSubview(v)
		}
		let g = contentView.layoutMarginsGuide
		
		closedConstraint = titleStack.bottomAnchor.constraint(equalTo: g.bottomAnchor)
		openConstraint = bodyStack.bottomAnchor.constraint(equalTo: g.bottomAnchor)
		closedConstraint.priority = .required - 1
		openConstraint.priority = .required - 1

		titleStack.addArrangedSubview(nameLabel)
		titleStack.addArrangedSubview(logoImageView)
		
		NSLayoutConstraint.activate([
			
			titleStack.topAnchor.constraint(equalTo: g.topAnchor),
			titleStack.leadingAnchor.constraint(equalTo: g.leadingAnchor),
			titleStack.trailingAnchor.constraint(equalTo: g.trailingAnchor),
			
			bodyStack.topAnchor.constraint(equalTo: titleStack.bottomAnchor, constant: 8.0),
			bodyStack.leadingAnchor.constraint(equalTo: g.leadingAnchor),
			bodyStack.trailingAnchor.constraint(equalTo: g.trailingAnchor),
		
			logoImageView.widthAnchor.constraint(equalToConstant: 32.0),
			logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),
			
			closedConstraint, openConstraint,
		])

		for _ in 1...4 {
			let v = UILabel()
			bodyStack.addArrangedSubview(v)
		}
		
		contentView.clipsToBounds = true
	}
	
	func fillData(_ t: MyTeam) {
		nameLabel.text = t.name
		if let img = UIImage(systemName: t.logo) {
			logoImageView.image = img
		}
		if let v = bodyStack.arrangedSubviews[0] as? UILabel {
			v.text = "Country: \(t.country)"
		}
		if let v = bodyStack.arrangedSubviews[1] as? UILabel {
			v.text = "Founded: \(t.founded)"
		}
		if let v = bodyStack.arrangedSubviews[2] as? UILabel {
			v.text = "Code: \(t.code)"
		}
		if let v = bodyStack.arrangedSubviews[3] as? UILabel {
			v.text = "National: \(t.national)"
		}
		openConstraint.priority = t.isOpen ? .defaultHigh : .defaultLow
		closedConstraint.priority = t.isOpen ? .defaultLow : .defaultHigh
//		openConstraint.isActive = false
//		closedConstraint.isActive = false
//		openConstraint.isActive = t.isOpen
//		closedConstraint.isActive = !t.isOpen // !openConstraint.isActive
	}
	
}
class TeameTableViewController: UIViewController {

	var myData: [MyTeam] = []
	
	let tableView: UITableView = UITableView()
	
    override func viewDidLoad() {
        super.viewDidLoad()

		var t: MyTeam!

		for i in 0..<10 {
			t = MyTeam()
			t.name = "Team Name \(i)"
			t.logo = "\(i).square"
			t.country = "Country \(i)"
			t.founded = "\(1900 + i)"
			t.code = "Team Code \(i)"
			t.national = i % 2 == 1
			myData.append(t)
		}
		
		tableView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(tableView)
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([

			tableView.topAnchor.constraint(equalTo: g.topAnchor, constant: 80.0),
			tableView.leadingAnchor.constraint(equalTo: g.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: g.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: g.bottomAnchor),

		])
		
		tableView.register(TeamCell.self, forCellReuseIdentifier: "teamCell")
		tableView.delegate = self
		tableView.dataSource = self
    }
    
}

extension TeameTableViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return myData.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let c = tableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath) as! TeamCell
		c.fillData(myData[indexPath.row])
		c.selectionStyle = .none
		return c
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print(indexPath)
		myData[indexPath.row].isOpen.toggle()
		tableView.performBatchUpdates({
			tableView.reloadRows(at: [indexPath], with: .automatic)
		}, completion: nil)
	}
}


class BtnTitleViewController: UIViewController {
	
	@IBOutlet var imgView: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let bez = UIBezierPath()
		
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		// Create the initial layer from the view bounds.
		let maskLayer = CAShapeLayer()
		maskLayer.frame = imgView.bounds
		maskLayer.fillColor = UIColor.black.cgColor
		
//		// Create the path.
//		let path = UIBezierPath(rect: imgView.bounds)
//		maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
//
//		let pathA = UIBezierPath()
//		pathA.move(to: CGPoint(x: 100.0, y: 100.0))
//		pathA.addLine(to: CGPoint(x: 200.0, y: 200.0))
//
//		// Append the overlay image to the path so that it is subtracted.
//		path.append(pathA)
//		maskLayer.path = path.cgPath
//
//		maskLayer.lineWidth = 20.0
//		maskLayer.strokeColor = UIColor.white.cgColor

		let pathA = UIBezierPath()
		pathA.move(to: CGPoint(x: 100.0, y: 100.0))
		pathA.addLine(to: CGPoint(x: 200.0, y: 200.0))
		pathA.addLine(to: CGPoint(x: 100.0, y: 200.0))
		pathA.close()

		// Create the path.
		let path = UIBezierPath(rect: imgView.bounds)
		maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
		pathA.lineWidth = 20.0
		path.append(pathA)
		
		// Append the overlay image to the path so that it is subtracted.
//		path.append(UIBezierPath(rect: imgView.bounds.insetBy(dx: 40, dy: 40)))
		maskLayer.path = path.cgPath

		
		// Set the mask of the view.
		imgView.layer.mask = maskLayer
		
	}

}

class xRevealImageView: UIImageView {
	
	private var maskPath = UIBezierPath()
	private var maskLayer: CAShapeLayer = CAShapeLayer()
	private var whiteLayer: CALayer = CALayer()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() -> Void {
		layer.addSublayer(whiteLayer)
		whiteLayer.backgroundColor = UIColor.red.cgColor
		
		// default is false for UIImageView
		isUserInteractionEnabled = true
		// we only want to stroke the path, not fill it
		maskLayer.fillColor = UIColor.clear.cgColor
		// any color will work, as the mask uses the alpha value
		maskLayer.strokeColor = UIColor.white.cgColor
		// adjust drawing-line-width as desired
		maskLayer.lineWidth = 48
		maskLayer.lineCap = .round
		maskLayer.lineJoin = .round
		
		// set the mask layer
		whiteLayer.mask = maskLayer
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		whiteLayer.frame = bounds
		maskLayer.frame = bounds
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		let currentPoint = touch.location(in: self)
		maskPath.move(to: currentPoint)
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		let currentPoint = touch.location(in: self)
		// add line to on maskPath
		maskPath.addLine(to: currentPoint)
		// update the mask layer path
		maskLayer.path = maskPath.cgPath
	}
	
}

class RevealImageView: UIImageView {
	
	private var maskPath = UIBezierPath()
	private var maskLayer: CAShapeLayer = CAShapeLayer()
	private var blackLayer: CALayer = CALayer()
	private var imageLayer: CALayer = CALayer()

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() -> Void {
		layer.addSublayer(imageLayer)
		//whiteLayer.backgroundColor = UIColor.red.cgColor
		
		imageLayer.contents = UIImage(named: "sampleImage")?.cgImage
		
		// default is false for UIImageView
		isUserInteractionEnabled = true
		// we only want to stroke the path, not fill it
		maskLayer.fillColor = UIColor.clear.cgColor
		// any color will work, as the mask uses the alpha value
		maskLayer.strokeColor = UIColor.red.cgColor
		// adjust drawing-line-width as desired
		maskLayer.lineWidth = 32
		maskLayer.lineCap = .round
		maskLayer.lineJoin = .round
		
		maskLayer.fillRule = CAShapeLayerFillRule.evenOdd

		//blackLayer.backgroundColor = UIColor.red.cgColor
		// set the mask layer
		//imageLayer.mask = maskLayer
		layer.addSublayer(maskLayer)
		
//		blackLayer.mask = maskLayer
//		maskPath = UIBezierPath()

	}
	override func layoutSubviews() {
		super.layoutSubviews()
		imageLayer.frame = bounds
		blackLayer.frame = bounds
		maskLayer.frame = bounds
		let path = UIBezierPath(rect: bounds)
		maskLayer.path = path.cgPath
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		let currentPoint = touch.location(in: self)
		maskPath = UIBezierPath()
		maskPath.move(to: currentPoint)
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		let currentPoint = touch.location(in: self)
		// add line to on maskPath
		maskPath.addLine(to: currentPoint)

		//maskPath.append(UIBezierPath(rect: bounds))
		
//		let path = UIBezierPath(rect: bounds)
//		path.append(maskPath)
		
		// update the mask layer path
		maskLayer.path = maskPath.cgPath
	}
	
}


class RevealViewController: UIViewController {
	
	let myRevealView = RevealImageView(frame: .zero)
//	let myRevealView = UIImageView()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		guard let img = UIImage(named: "sampleImage") else {
			fatalError("Could not load image!!!!")
		}
		//myRevealView.image = img
		myRevealView.backgroundColor = .clear
		
		// a view to show the frame for the Reveal Image view
		//  so we know where we can "draw"
		let frameView = UIView()
		frameView.layer.borderWidth = 1
		frameView.layer.borderColor = UIColor.gray.cgColor
		
		frameView.translatesAutoresizingMaskIntoConstraints = false
		myRevealView.translatesAutoresizingMaskIntoConstraints = false
		
		view.addSubview(frameView)
		view.addSubview(myRevealView)
		
		// respect safe area
		let g = view.safeAreaLayoutGuide
		
		NSLayoutConstraint.activate([
			
			// 300 x 300 (1:1 ratio)
			myRevealView.widthAnchor.constraint(equalToConstant: 300.0),
			myRevealView.heightAnchor.constraint(equalTo: myRevealView.widthAnchor),
			// centered in view
			myRevealView.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			myRevealView.centerYAnchor.constraint(equalTo: g.centerYAnchor),
			
			// constrain the frame view 2-pts larger
			frameView.widthAnchor.constraint(equalTo: myRevealView.widthAnchor, constant: 2.0),
			frameView.heightAnchor.constraint(equalTo: frameView.widthAnchor),
			// center it
			frameView.centerXAnchor.constraint(equalTo: myRevealView.centerXAnchor),
			frameView.centerYAnchor.constraint(equalTo: myRevealView.centerYAnchor),
			
		])
		
	}
}

class MyShapeLayer: CALayer {
	
	var myPath: CGPath?
	
	override func draw(in inContext: CGContext) {
		
		// fill entire layer with solid color
		inContext.setFillColor(UIColor.gray.cgColor)
		inContext.fill(self.bounds);
		
		// we want to "clear" the stroke
		inContext.setStrokeColor(UIColor.clear.cgColor);
		// any color will work, as the mask uses the alpha value
		inContext.setFillColor(UIColor.white.cgColor)
		// adjust drawing-line-width as desired
		inContext.setLineWidth(24.0)

		inContext.setLineCap(.round)
		inContext.setLineJoin(.round)
		if let pth = self.myPath {
			inContext.addPath(pth)
		}
		inContext.setBlendMode(.sourceIn)
		inContext.drawPath(using: .fillStroke)

	}
	
}

class ScratchOffImageView: UIView {

	public var image: UIImage? {
		didSet {
			self.scratchOffImageLayer.contents = image?.cgImage
		}
	}

	// adjust drawing-line-width as desired
	//	or set from
	public var lineWidth: CGFloat = 24.0 {
		didSet {
			maskLayer.lineWidth = lineWidth
		}
	}

	private class MyCustomLayer: CALayer {
		
		var myPath: CGPath?
		var lineWidth: CGFloat = 24.0

		override func draw(in ctx: CGContext) {

			// fill entire layer with solid color
			ctx.setFillColor(UIColor.gray.cgColor)
			ctx.fill(self.bounds);

			// we want to "clear" the stroke
			ctx.setStrokeColor(UIColor.clear.cgColor);
			// any color will work, as the mask uses the alpha value
			ctx.setFillColor(UIColor.white.cgColor)
			ctx.setLineWidth(self.lineWidth)
			ctx.setLineCap(.round)
			ctx.setLineJoin(.round)
			if let pth = self.myPath {
				ctx.addPath(pth)
			}
			ctx.setBlendMode(.sourceIn)
			ctx.drawPath(using: .fillStroke)

		}
		
	}

	private let maskPath: UIBezierPath = UIBezierPath()
	private let maskLayer: MyCustomLayer = MyCustomLayer()
	private let scratchOffImageLayer: CALayer = CALayer()

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {

		// Important, otherwise you will get a black rectangle
		maskLayer.isOpaque = false
		
		// add the image layer
		layer.addSublayer(scratchOffImageLayer)
		// assign the layer mask
		scratchOffImageLayer.mask = maskLayer
		
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()

		// set frames for mask and image layers
		maskLayer.frame = bounds
		scratchOffImageLayer.frame = bounds

		// triggers drawInContext
		maskLayer.setNeedsDisplay()
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		let currentPoint = touch.location(in: self)
		maskPath.move(to: currentPoint)
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		let currentPoint = touch.location(in: self)
		// add line to our maskPath
		maskPath.addLine(to: currentPoint)
		// update the mask layer path
		maskLayer.myPath = maskPath.cgPath
		// triggers drawInContext
		maskLayer.setNeedsDisplay()
	}
	
}

class ScratchOffViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .systemBackground
		
		guard let img = UIImage(named: "test.jpg") else {
			fatalError("Could not load image!!!!")
		}

		let scratchOffView = ScratchOffImageView()
		
		// set the "scratch-off" image
		scratchOffView.image = img
		
		// default line width is 24.0
		//	we can set it to a different width here
		//scratchOffView.lineWidth = 12

		// let's add a light-gray label with red text
		//	we'll overlay the scratch-off-view on top of the label
		//	so we can see the text "through" the image
		let backgroundLabel = UILabel()
		backgroundLabel.font = .italicSystemFont(ofSize: 36)
		backgroundLabel.text = "This is some text in a label so we can see that the path is clear -- so it appears as if the image is being \"scratched off\""
		backgroundLabel.numberOfLines = 0
		backgroundLabel.textColor = .red
		backgroundLabel.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
		
		[backgroundLabel, scratchOffView].forEach { v in
			v.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview(v)
		}
		
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			backgroundLabel.widthAnchor.constraint(equalTo: g.widthAnchor, multiplier: 0.7),
			backgroundLabel.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			backgroundLabel.centerYAnchor.constraint(equalTo: g.centerYAnchor),
			
			scratchOffView.widthAnchor.constraint(equalTo: g.widthAnchor, multiplier: 0.8),
			scratchOffView.heightAnchor.constraint(equalTo: scratchOffView.widthAnchor, multiplier: 2.0 / 3.0),
			scratchOffView.centerXAnchor.constraint(equalTo: backgroundLabel.centerXAnchor),
			scratchOffView.centerYAnchor.constraint(equalTo: backgroundLabel.centerYAnchor),
		])
		
	}

}

class ToastVC: UIViewController {
	
	let tv = MyToastView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBlue
		tv.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(tv)
		let g = view.safeAreaLayoutGuide
		
		NSLayoutConstraint.activate([
			tv.topAnchor.constraint(equalTo: g.topAnchor, constant: 12.0),
			tv.widthAnchor.constraint(equalToConstant: 200.0),
			tv.heightAnchor.constraint(equalToConstant: 40.0),
			tv.centerXAnchor.constraint(equalTo: g.centerXAnchor),
		])
		
	}
	
	var b: Bool = false
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		b.toggle()
		if b {
			self.tv.startAnimation(toastMessage: "New Message")
		} else {
			self.tv.stopAnimation()
		}
	}
	
}

class MyToastView: UIView {
	
	let label: UILabel = {
		let label = UILabel()
		label.textColor = .white
		label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
		return label
	}()
	
	// clear view with a white single-point border
	//	on its layer
	let whiteBorderView: UIView = {
		let v = UIView()
		v.layer.borderWidth = 1
		v.layer.borderColor = UIColor.white.cgColor
		v.layer.cornerRadius = 4
		return v
	}()

	// clear view that will get a sublayer
	//	that we'll use to animate the strokeEnd
	let animBorderView: UIView = {
		let v = UIView()
		return v
	}()
	
	let animBorderLayer: CAShapeLayer = {
		let shapeLayer = CAShapeLayer()
		shapeLayer.fillColor = UIColor.clear.cgColor
		// start with a clear border so we don't see it
		//	before the strokeEnd animation starts
		shapeLayer.strokeColor = UIColor.clear.cgColor
		shapeLayer.lineCap = .round
		shapeLayer.lineWidth = 2
		return shapeLayer
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		customInit()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		customInit()
	}
	
	private func customInit() {
		backgroundColor = .black
		
		// add the subviews
		[whiteBorderView, animBorderView, label].forEach { v in
			v.translatesAutoresizingMaskIntoConstraints = false
			addSubview(v)
		}
		
		let constraints = [

			// label with a bit of "padding"
			label.topAnchor.constraint(equalTo: self.topAnchor, constant: 2),
			label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3),	// should be a negative constant
			label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
			label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4),	// should be a negative constant
			
			// constrain white border view to all 4 sides
			whiteBorderView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
			whiteBorderView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
			whiteBorderView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
			whiteBorderView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
			
			// constrain anim border view to all 4 sides
			animBorderView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
			animBorderView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
			animBorderView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
			animBorderView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
			
		]
		NSLayoutConstraint.activate(constraints)
		
		self.layer.cornerRadius = 4

		// add the anim border layer to the anim border view
		animBorderView.layer.addSublayer(animBorderLayer)
		
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		// we want to update the animated border layer frame here
		animBorderLayer.frame = animBorderView.bounds
	}
	
	func startAnimation(toastMessage: String) {

		self.label.text = toastMessage

//		// set the border path
//		self.animBorderLayer.path = UIBezierPath(roundedRect: self.animBorderView.bounds, cornerRadius: 4).cgPath
//		// set the strokeColor here
//		self.animBorderLayer.strokeColor = UIColor.green.cgColor
		
//		let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
//		strokeAnimation.beginTime = 0
//		strokeAnimation.fromValue = 0
//		strokeAnimation.toValue = 1
//		strokeAnimation.duration = 1.5
//		strokeAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
//
//		let strokeAnimationA = CABasicAnimation(keyPath: "strokeStart")
//		strokeAnimationA.beginTime = 0.25
//		strokeAnimationA.fromValue = 0
//		strokeAnimationA.toValue = 1
//		strokeAnimationA.duration = 1.0
//		strokeAnimationA.timingFunction = CAMediaTimingFunction(name: .easeIn)
		
		//self.animBorderLayer.add(strokeAnimation, forKey: "a")
		//self.animBorderLayer.add(strokeAnimationA, forKey: "b")

		
		// set the border path
		self.animBorderLayer.path = UIBezierPath(roundedRect: self.animBorderView.bounds, cornerRadius: self.animBorderView.bounds.height * 0.5).cgPath
		// set the strokeColor here
		self.animBorderLayer.strokeColor = UIColor.red.cgColor

		let duration: CFTimeInterval = 2.5
		
		// 2)
		let end = CABasicAnimation(keyPath: "strokeEnd")
		end.fromValue = 0
		//end.toValue = 1.0175
		end.toValue = 1.0
		end.beginTime = 0
		end.duration = duration * 0.75
		//begin.timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.88, 0.09, 1.0)
		//end.timingFunction = CAMediaTimingFunction(controlPoints: 0.5, 0.2, 0.2, 1.0)
		end.timingFunction = .easeOutSine
		//end.timingFunction = CAMediaTimingFunction(controlPoints: 0.23, 1, 0.32, 1)
		end.fillMode = .forwards
		
		// 3)
		let begin = CABasicAnimation(keyPath: "strokeStart")
		begin.fromValue = 0
		//begin.toValue = 1.0175
		begin.toValue = 1.0
		begin.beginTime = duration * 0.15
		begin.duration = duration * 0.85
//		begin.timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.88, 0.09, 1.0)
//		begin.timingFunction = CAMediaTimingFunction(controlPoints: 0.2, 0.88, 0.51, 0.99)
		//begin.timingFunction = CAMediaTimingFunction(controlPoints: 0.5, 0.2, 0.2, 1.0)
		begin.timingFunction = end.timingFunction
		begin.timingFunction = .easeInSine
		//begin.timingFunction = CAMediaTimingFunction(controlPoints: 0.455, 0.15, 0.855, 0.06)
		begin.fillMode = .forwards
		
		// 4)
		let group = CAAnimationGroup()
		group.animations = [end, begin]
		group.duration = duration
		
		group.repeatCount = .infinity
		
		// 5)
//		strokeEnd = 1
//		strokeStart = 1
		
		// 6)
		self.animBorderLayer.add(group, forKey: "move")

	}
	func stopAnimation() {
		self.animBorderLayer.removeAllAnimations()
	}
}

extension CAMediaTimingFunction {
	
	// default
	static let defaultTiming = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
	static let linear = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
	static let easeIn = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
	static let easeOut = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
	static let easeInEaseOut = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
	
	// custom
	static let easeInSine = CAMediaTimingFunction(controlPoints: 0.47, 0, 0.745, 0.715)
	static let easeInQuad = CAMediaTimingFunction(controlPoints: 0.55, 0.085, 0.68, 0.53)
	static let easeInCubic = CAMediaTimingFunction(controlPoints: 0.55, 0.055, 0.675, 0.19)
	static let easeInQuart = CAMediaTimingFunction(controlPoints: 0.895, 0.03, 0.685, 0.22)
	static let easeInQuint = CAMediaTimingFunction(controlPoints: 0.755, 0.05, 0.855, 0.06)
	static let easeInExpo = CAMediaTimingFunction(controlPoints: 0.95, 0.05, 0.795, 0.035)
	static let easeInCirc = CAMediaTimingFunction(controlPoints: 0.6, 0.04, 0.98, 0.335)
	static let easeInBack = CAMediaTimingFunction(controlPoints: 0.6, -0.28, 0.735, 0.045)
	static let easeOutSine = CAMediaTimingFunction(controlPoints: 0.39, 0.575, 0.565, 1)
	static let easeInOutSine = CAMediaTimingFunction(controlPoints: 0.445, 0.05, 0.55, 0.95)
	static let easeOutQuad = CAMediaTimingFunction(controlPoints: 0.25, 0.46, 0.45, 0.94)
	static let easeInOutQuad = CAMediaTimingFunction(controlPoints: 0.455, 0.03, 0.515, 0.955)
	static let easeOutCubic = CAMediaTimingFunction(controlPoints: 0.215, 0.61, 0.355, 1)
	static let easeInOutCubic = CAMediaTimingFunction(controlPoints: 0.645, 0.045, 0.355, 1)
	static let easeOutQuart = CAMediaTimingFunction(controlPoints: 0.165, 0.84, 0.44, 1)
	static let easeInOutQuart = CAMediaTimingFunction(controlPoints: 0.77, 0, 0.175, 1)
	static let easeOutQuint = CAMediaTimingFunction(controlPoints: 0.23, 1, 0.32, 1)
	static let easeInOutQuint = CAMediaTimingFunction(controlPoints: 0.86, 0, 0.07, 1)
	static let easeOutExpo = CAMediaTimingFunction(controlPoints: 0.19, 1, 0.22, 1)
	static let easeInOutExpo = CAMediaTimingFunction(controlPoints: 1, 0, 0, 1)
	static let easeOutCirc = CAMediaTimingFunction(controlPoints: 0.075, 0.82, 0.165, 1)
	static let easeInOutCirc = CAMediaTimingFunction(controlPoints: 0.785, 0.135, 0.15, 0.86)
	static let easeOutBack = CAMediaTimingFunction(controlPoints: 0.175, 0.885, 0.32, 1.275)
	static let easeInOutBack = CAMediaTimingFunction(controlPoints: 0.68, -0.55, 0.265, 1.55)
}

class zToastView: UIView {
	
	lazy var label: UILabel = {
		let label = UILabel()
		label.textColor = .white
		label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
		return label
	}()
	
	lazy var subLayer: CAShapeLayer = {
		let shapeLayer = CAShapeLayer()
		shapeLayer.fillColor = nil
		shapeLayer.strokeColor = UIColor.green.cgColor
		shapeLayer.lineCap = .round
		shapeLayer.lineWidth = 2 //2
		return shapeLayer
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		customInit()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		customInit()
	}
	
	private func customInit() {
		backgroundColor = .black
		self.addSubview(label)
		label.translatesAutoresizingMaskIntoConstraints = false
		let constraints = [
			label.topAnchor.constraint(equalTo: self.topAnchor, constant: 2),
			label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3),
			label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
			label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4)
		]
		NSLayoutConstraint.activate(constraints)
		
		layer.borderWidth = 1
		layer.borderColor = UIColor.white.cgColor
		layer.cornerRadius = 4
		//layer.masksToBounds = true
	}
	
	func startAnimation(toastMessage: String) {
		self.label.text = toastMessage
		self.label.layoutIfNeeded()
		DispatchQueue.main.async {
			let subLayer = self.subLayer
			self.layer.insertSublayer(subLayer, at: 0)
			subLayer.frame = self.bounds // self.layer.frame
			subLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 4).cgPath
			//subLayer.masksToBounds = true
			
			let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
			strokeAnimation.beginTime = 0
			strokeAnimation.fromValue = 0
			strokeAnimation.toValue = 1
			strokeAnimation.duration = 1.5
			strokeAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
			
			subLayer.add(strokeAnimation, forKey: "")
		}
	}
}


class xToastView: UIView {
	
	lazy var label: UILabel = {
		let label = UILabel()
		label.textColor = .white
		label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
		return label
	}()
	
	lazy var subLayer: CAShapeLayer = {
		let shapeLayer = CAShapeLayer()
		shapeLayer.fillColor = nil
		shapeLayer.strokeColor = UIColor.green.cgColor
		shapeLayer.lineCap = .round
		shapeLayer.lineWidth = 4 //2
		return shapeLayer
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		customInit()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		customInit()
	}
	
	private func customInit() {
		backgroundColor = .black
		self.addSubview(label)
		label.translatesAutoresizingMaskIntoConstraints = false
		let constraints = [
			label.topAnchor.constraint(equalTo: self.topAnchor, constant: 2),
			label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 3),
			label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
			label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 4)
		]
		NSLayoutConstraint.activate(constraints)
		
		layer.borderWidth = 1
		layer.borderColor = UIColor.white.cgColor
		layer.cornerRadius = 4
		//layer.masksToBounds = true
	}
	
	func startAnimation(toastMessage: String) {
		label.text = toastMessage
		
		//self.layer.insertSublayer(subLayer, at: 0)
		self.layer.addSublayer(subLayer)
		subLayer.frame = bounds // layer.frame
		subLayer.path = UIBezierPath(roundedRect: self.bounds.insetBy(dx: 0, dy: 0), cornerRadius: 4).cgPath
		//subLayer.masksToBounds = true
		
		let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
		strokeAnimation.beginTime = 0
		strokeAnimation.fromValue = 0
		strokeAnimation.toValue = 1
		strokeAnimation.duration = 1.5
		strokeAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
		
		subLayer.add(strokeAnimation, forKey: "")
		//animate coming up with message
	}
}

class ToastView: UIView {
	
	lazy var label: UILabel = {
		let label = UILabel()
		label.textColor = .white
		label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
		return label
	}()
	
	lazy var subLayer: CAShapeLayer = {
		let shapeLayer = CAShapeLayer()
		shapeLayer.fillColor = nil
		shapeLayer.strokeColor = UIColor.green.cgColor
		shapeLayer.lineCap = .round
		shapeLayer.lineWidth = 2
		return shapeLayer
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		customInit()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		customInit()
	}
	
	private func customInit() {
		backgroundColor = .black
		self.addSubview(label)
		label.translatesAutoresizingMaskIntoConstraints = false
		let constraints = [
			label.topAnchor.constraint(equalTo: self.topAnchor, constant: 2),
			label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 3),
			label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
			label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 4)
		]
		NSLayoutConstraint.activate(constraints)
		
		layer.borderWidth = 1
		layer.borderColor = UIColor.white.cgColor
		layer.cornerRadius = 4
		//layer.masksToBounds = true
		layer.masksToBounds = false
	}
	
	func startAnimation(toastMessage: String) {
		
		self.label.text = toastMessage
		self.layer.insertSublayer(subLayer, at: 0)
		//subLayer.frame = layer.frame
		subLayer.frame = self.bounds // layer.frame
		subLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 4).cgPath
		//subLayer.masksToBounds = true
		subLayer.masksToBounds = false
		
		let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
		strokeAnimation.beginTime = 0
		strokeAnimation.fromValue = 0
		strokeAnimation.toValue = 1
		strokeAnimation.duration = 1.5
		strokeAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
		
		subLayer.add(strokeAnimation, forKey: "")
		//animate coming up with message
	}
}

class MainViewController: UIViewController {
	
	let titleBarView = UIView(frame: .zero)
	let container = UIViewController()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
		layout()
	}
	
	func setup() {
		
		titleBarView.backgroundColor = .red
		view.addSubview(titleBarView)

		// change this
		//addViewController(container)
		
		// to this
		addViewController(container, constrainToSuperview: false)

		showViewControllerA()
	}
	
	func layout() {
		titleBarView.translatesAutoresizingMaskIntoConstraints = false
		container.view.translatesAutoresizingMaskIntoConstraints = false
		container.view.backgroundColor = .green
		
		NSLayoutConstraint.activate([
			titleBarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			titleBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			titleBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			titleBarView.heightAnchor.constraint(equalToConstant: 24),
			
			container.view.topAnchor.constraint(equalTo: titleBarView.bottomAnchor, constant: 0),
			container.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			container.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			container.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
		])
	}
	
	func showViewControllerA() {
		let viewControllerA = ViewControllerA()
		viewControllerA.delegate = self
		
		container.children.first?.remove()
		container.addViewController(viewControllerA)
	}
	
	func showViewControllerB() {
		let viewControllerB = ViewControllerB()
		
		container.children.first?.remove()
		container.addViewController(viewControllerB)
	}
}

extension MainViewController: ViewControllerADelegate {
	func nextViewController() {
		showViewControllerB()
	}
}

protocol ViewControllerADelegate: AnyObject {
	func nextViewController()
}

class ViewControllerA: UIViewController {
	
	let nextButton = UIButton()
	
	weak var delegate: ViewControllerADelegate?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
		layout()
		view.backgroundColor = .blue
	}
	
	func setup() {
		nextButton.setTitle("next", for: .normal)
		nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .primaryActionTriggered)
		view.addSubview(nextButton)
	}
	
	func layout() {
		nextButton.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
	}
	
	@objc func nextButtonPressed() {
		delegate?.nextViewController()
	}
}

class ViewControllerB: UIViewController {
	
	let imageView = UIImageView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
		layout()
		view.backgroundColor = .orange
	}
	
	func setup() {
		view.addSubview(imageView)
		blankImage()
	}
	
	func layout() {
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFill
		imageView.layer.magnificationFilter = CALayerContentsFilter.nearest;
		
		NSLayoutConstraint.activate([
			// change this
			//imageView.centerYAnchor.constraint(equalTo: super.view.centerYAnchor),
			//imageView.centerXAnchor.constraint(equalTo: super.view.centerXAnchor),
			//imageView.heightAnchor.constraint(equalTo: super.view.heightAnchor, multiplier: 0.6),

			// to this
			imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
		])
		
		view.layoutSubviews()
		
	}
	
	func blankImage() {
		let ciImage = CIImage(cgImage: createBlankCGImage(width: 32, height: 64)!)
		imageView.image = cIImageToUIImage(ciimage: ciImage, context: CIContext())
	}
}

func createBlankCGImage(width: Int, height: Int) -> CGImage? {
	
	let bounds = CGRect(x: 0, y:0, width: width, height: height)
	let intWidth = Int(ceil(bounds.width))
	let intHeight = Int(ceil(bounds.height))
	let bitmapContext = CGContext(data: nil,
								  width: intWidth, height: intHeight,
								  bitsPerComponent: 8,
								  bytesPerRow: 0,
								  space: CGColorSpace(name: CGColorSpace.sRGB)!,
								  bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)
	
	if let cgContext = bitmapContext {
		cgContext.saveGState()
		let r = CGFloat.random(in: 0...1)
		let g = CGFloat.random(in: 0...1)
		let b = CGFloat.random(in: 0...1)
		
		cgContext.setFillColor(red: r, green: g, blue: b, alpha: 1)
		cgContext.fill(bounds)
		cgContext.restoreGState()
		
		return cgContext.makeImage()
	}
	
	return nil
}

func cIImageToUIImage(ciimage: CIImage, context: CIContext) -> UIImage? {
	if let cgimg = context.createCGImage(ciimage, from: ciimage.extent) {
		return UIImage(cgImage: cgimg)
	}
	return nil
}


extension UIViewController {
	
	func addViewController(_ child: UIViewController, constrainToSuperview: Bool = true) {
		addChild(child)
		view.addSubview(child.view)
		
		if constrainToSuperview {
			child.view.translatesAutoresizingMaskIntoConstraints = false
			NSLayoutConstraint.activate([
				child.view.topAnchor.constraint(equalTo: view.topAnchor),
				child.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
				child.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
				child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			])
		}
		
		child.didMove(toParent: self)
	}
	
	func remove() {
		guard parent != nil else { return }
		willMove(toParent: nil)
		view.removeFromSuperview()
		removeFromParent()
	}
}

class AlertVC: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemGreen
	}
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let msg = "testing"
		showAlert(message: msg)
	}

func showAlert(message: String) {
	let alert = UIAlertController(title: "You lost!", message: message, preferredStyle: .alert)
	alert.addAction(UIAlertAction(title: "Retry", style: .default) { action in
		print("Alert Action...")
		//self.performSegue(withIdentifier: "goToHomePage", sender: nil)
	})
	self.present(alert, animated: true, completion: nil)
}

}

class OrthViewController: UIViewController, UICollectionViewDelegate {
	
	var collectionView: UICollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout(hasOrthogonalScroll: false))
		collectionView.delegate = self
		collectionView.frame = view.bounds.insetBy(dx: 40, dy: 40)
		collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
		view.addSubview(collectionView)
		collectionView.backgroundColor = .cyan

		setupDataSource()
	}
	
	private func collectionLayout(hasOrthogonalScroll: Bool) -> UICollectionViewLayout {

		let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
		//let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.75), heightDimension: .fractionalHeight(1.0))
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.2))

//		var group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
//
//		if hasOrthogonalScroll {
//			group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
//		}
		
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
		
		let section = NSCollectionLayoutSection(group: group)
		
		section.orthogonalScrollingBehavior = hasOrthogonalScroll ? .groupPagingCentered : .none

		section.visibleItemsInvalidationHandler = { visibleItems, scrollOffset, environment in
			print("X", visibleItems.count)
			print("Z", environment.container)
			
			visibleItems.forEach { i in
				guard let cell = self.collectionView.cellForItem(at: i.indexPath) else { return }
				print(i.indexPath, cell.frame)
				cell.setNeedsLayout()
				cell.layoutIfNeeded()
			}
		}
		
		return UICollectionViewCompositionalLayout(section: section)
	}
	
	enum Section {
		case main
	}
	
	private var dataSource: UICollectionViewDiffableDataSource<Section, Int>!
	
	private func setupDataSource() {
		let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Int> { (cell, indexPath, identifier) in
			var configuration = cell.defaultContentConfiguration()
			configuration.text = identifier.description
			
			cell.contentConfiguration = configuration
			
			var backgroundConfiguration = cell.backgroundConfiguration
			backgroundConfiguration?.backgroundColor = .secondarySystemBackground
			backgroundConfiguration?.cornerRadius = 8
			backgroundConfiguration?.backgroundInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
			
			cell.backgroundConfiguration = backgroundConfiguration
		}
		
		dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) { collectionView, indexPath, identifier in
			collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
		}
		
		var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
		snapshot.appendSections([.main])
		snapshot.appendItems(Array(1...100))
		dataSource.apply(snapshot, animatingDifferences: false)
	}
	
	var hasOrthogonalScroll = false
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		collectionView.deselectItem(at: indexPath, animated: true)
		
		hasOrthogonalScroll.toggle()
		
		let layout = collectionLayout(hasOrthogonalScroll: hasOrthogonalScroll)

		let x = 3
		
		if x == 1 {
			collectionView.setCollectionViewLayout(layout, animated: true, completion: { b in
			})
		}

		if x == 3 {

			
			if !self.hasOrthogonalScroll {
				let w = collectionView.frame.width
				collectionView.frame.size.width = view.bounds.width + 2000
				collectionView.collectionViewLayout.invalidateLayout()
				collectionView.layoutIfNeeded()
				DispatchQueue.main.async {
					self.collectionView.setCollectionViewLayout(layout, animated: true, completion: { b in
						self.collectionView.frame.size.width = w
					})
				}
			} else {
				collectionView.setCollectionViewLayout(layout, animated: true, completion: { b in
				})
			}

		}
		
		if x == 2 {
//			collectionView.setCollectionViewLayout(layout, animated: true, completion: { b in
//				if !self.hasOrthogonalScroll {
//					UIView.animate(withDuration: 0.3, animations: {
//						collectionView.scrollToItem(at: IndexPath(item: 14, section: 0), at: .top, animated: false)
//					}, completion: { _ in
//						collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
//					})
//				}
//			})
//			collectionView.frame.size.height -= 1
			if !self.hasOrthogonalScroll {
				collectionView.reloadData()
			}
			collectionView.setCollectionViewLayout(layout, animated: true)
//			collectionView.frame.size.height += 1
//			UIView.animate(withDuration: 0.3, animations: {
//				self.view.layoutIfNeeded()
//			}, completion: { _ in
//
//			})
		}
		
	}
}

class ImageTextCell: UICollectionViewCell {

	public var callback: ((UICollectionViewCell, Int) -> ())?
	
	private var thisObject: MyObjectStruct!
	
	private let imageView = UIImageView()
	private var hotSpotViews: [UIView] = []

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	private func commonInit() {

		// be default, image view's are not enabled for user interaction
		imageView.isUserInteractionEnabled = true
		
		// add the image view to the content view
		imageView.translatesAutoresizingMaskIntoConstraints = false

		contentView.addSubview(imageView)
		
		let g = contentView.layoutMarginsGuide
		NSLayoutConstraint.activate([
			imageView.topAnchor.constraint(equalTo: g.topAnchor),
			imageView.leadingAnchor.constraint(equalTo: g.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: g.trailingAnchor),
			imageView.bottomAnchor.constraint(equalTo: g.bottomAnchor),
		])
		
		imageView.backgroundColor = .yellow
		contentView.backgroundColor = .systemYellow

	}
	
	public func configureCell(_ obj: MyObjectStruct) {
		thisObject = obj
		
		while hotSpotViews.count < thisObject.hotSpots.count {
			let v = UIView()
			
			let lpg = UILongPressGestureRecognizer(target: self, action: #selector(gotLongPress(_:)))
			v.addGestureRecognizer(lpg)
			
			hotSpotViews.append(v)
		}
		if let img = UIImage(systemName: thisObject.imageName) {
			imageView.image = img
		}
		imageView.subviews.forEach {
			$0.removeFromSuperview()
		}
		for i in 0..<thisObject.hotSpots.count {
			let v = hotSpotViews[i]
			imageView.addSubview(v)
			let hs = obj.hotSpots[i]
			v.backgroundColor = hs.color ?? .black.withAlphaComponent(0.2)
		}
	}
	
	public func updateCell(_ obj: MyObjectStruct) {
		thisObject = obj
		for i in 0..<thisObject.hotSpots.count {
			let v = hotSpotViews[i]
			let hs = obj.hotSpots[i]
			v.backgroundColor = hs.color ?? .black.withAlphaComponent(0.2)
		}
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()

		// make sure image view layout has been completed
		if imageView.frame.width == 0.0 {
			imageView.layoutIfNeeded()
		}
		for i in 0..<thisObject.hotSpots.count {
			let r = thisObject.hotSpots[i].rect
			let scaledown = imageView.frame.width / 2000.0
			let v = hotSpotViews[i]
			v.frame = CGRect(x: r.minX * scaledown, y: r.minY * scaledown, width: r.width * scaledown, height: r.height * scaledown)
		}
	}
	
	@objc func gotLongPress(_ recognizer: UILongPressGestureRecognizer) {
		if recognizer.state == .began {
			guard let v = recognizer.view,
				  let idx = hotSpotViews.firstIndex(of: v)
			else { return }
			print("hit", idx)
			callback?(self, idx)
		}
	}
	
}

struct HotSpot {
	var rect: CGRect = .zero
	var color: UIColor?
}
struct MyObjectStruct {
	var imageName: String = ""
	var hotSpots: [HotSpot] = []
}

class LongPressTestVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
	
	var collectionView: UICollectionView!
	
	var myData: [MyObjectStruct] = []
	
	let coords: [[CGFloat]] = [
		[1315, 522, 1547, 634],		// your coords
		[468, 485, 1316, 668],		// your coords
		[100, 100, 600, 600],		// upper-left
		[1400, 100, 1900, 600],		// upper-right
		[750, 750, 1250, 1250],		// center
		[100, 1400, 600, 1900],		// lower-left
		[1400, 1400, 1900, 1900],	// lower-right
	]
	let regions: [[Int]] = [
		[0, 1],
		[2],
		[2, 3],
		[3, 4],
		[2, 3, 5],
		[2, 3, 4, 5, 6],
		[3, 4, 6],
		[2, 4, 5, 6],
	]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		var obj: MyObjectStruct!
		var aSpot: HotSpot!
		var spots: [HotSpot]!
		
		for (i, r) in regions.enumerated() {
			print(i, r)

			obj = MyObjectStruct()
			obj.imageName = "\(i).square"
			spots = []

			r.forEach { n in
				let c = coords[n]
				let x = c[0]
				let y = c[1]
				let w = c[2] - x
				let h = c[3] - y
				aSpot = HotSpot(rect: CGRect(x: x, y: y, width: w, height: h))
				spots.append(aSpot)
			}
			
			obj.hotSpots = spots
			myData.append(obj)
		}
		
		let fl = UICollectionViewFlowLayout()
		fl.scrollDirection = .vertical
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: fl)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(collectionView)
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: g.topAnchor, constant: 20.0),
			collectionView.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
			collectionView.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -20.0),
			collectionView.bottomAnchor.constraint(equalTo: g.bottomAnchor, constant: -20.0),
		])
		
		collectionView.register(ImageTextCell.self, forCellWithReuseIdentifier: "c")
		collectionView.dataSource = self
		collectionView.delegate = self
	}
	
	var cvw: CGFloat = 0
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if cvw != collectionView.frame.width {
			cvw = collectionView.frame.width
			if let fl = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
				fl.itemSize = CGSize(width: cvw, height: cvw)
			}
		}
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return myData.count
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let c = collectionView.dequeueReusableCell(withReuseIdentifier: "c", for: indexPath) as! ImageTextCell
		
		c.configureCell(myData[indexPath.item])
		
		c.callback = { [weak self] cell, idx in
			guard let self = self,
				  let pth = collectionView.indexPath(for: cell)
			else {
				return
			}
			let ac = UIAlertController(title: "Select Color", message: nil, preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "Red", style: .default, handler: { _ in
				self.updateData(pth, hsIdx: idx, color: .red)
			}))
			ac.addAction(UIAlertAction(title: "Green", style: .default, handler: {(_: UIAlertAction!) in
				self.updateData(pth, hsIdx: idx, color: .green)
			}))
			ac.addAction(UIAlertAction(title: "Blue", style: .default, handler: {(_: UIAlertAction!) in
				self.updateData(pth, hsIdx: idx, color: .blue)
			}))
			ac.addAction(UIAlertAction(title: "Clear", style: .default, handler: {(_: UIAlertAction!) in
				self.updateData(pth, hsIdx: idx, color: .clear)
			}))
			ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {(_: UIAlertAction!) in
				print("Cancel");
			}))
			self.present(ac, animated: true, completion: nil)
		}
		return c
	}
	
	func updateData(_ pth: IndexPath, hsIdx: Int, color: UIColor) {
		myData[pth.item].hotSpots[hsIdx].color = color
		guard let c = collectionView.cellForItem(at: pth) as? ImageTextCell else { return }
		c.updateCell(myData[pth.item])
	}
	
}

class FirstCollectionViewCell: UICollectionViewCell {
	let buttonOne = UIButton()
}
class SecondCollectionViewCell: UICollectionViewCell {
	let buttonTwo = UIButton()
}
class TwoCollectionsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
	
	@IBOutlet var firstCV: UICollectionView!
	@IBOutlet var secondCV: UICollectionView!

	let firstData: [String] = [
		"Btn 1", "Btn 2", "Btn 3", "Btn 4", "Btn 5",
	]
	let secondData: [String] = [
		"Second 1", "Second 2", "Second 3", "Second 4"
	]

	override func viewDidLoad() {
		super.viewDidLoad()
		
		firstCV.dataSource = self
		firstCV.delegate = self
		
		secondCV.dataSource = self
		secondCV.delegate = self
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

		// if it's the First Collection View
		if collectionView == firstCV {
			return firstData.count
		}

		// it's not the First Collection View, so it's the Second one
		return secondData.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		// if it's the First Collection View
		if collectionView == firstCV {
			let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "firstCell", for: indexPath) as! FirstCollectionViewCell
			cell.buttonOne.setTitle(firstData[indexPath.item], for: [])
			return cell
		}
		
		// it's not the First Collection View, so it's the Second one
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "secondCell", for: indexPath) as! SecondCollectionViewCell
		cell.buttonTwo.setTitle(secondData[indexPath.item], for: [])
		return cell

	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

		// if it's the First Collection View
		if collectionView == firstCV {
			// do what you want because a cell in the First Collection View was selected
		}
		
		// it's not the First Collection View, so it's the Second one
		// do what you want because a cell in the Second Collection View was selected
		
	}
	
}

class DiceViewController: UIViewController {
	
	@IBOutlet weak var diceImageView1: UIImageView!
	@IBOutlet weak var diceImageView2: UIImageView!

	let diceNames: [String] = [
		"DiceOne", "DiceTwo", "DiceThree", "DiceFour", "DiceFive", "DiceSix"
	]
	
	var leftDiceNumber = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		diceImageView1.image = UIImage(named: diceNames[leftDiceNumber % 6])
	}
	
	@IBAction func rollButtonPressed(_ sender: UIButton) {
		print("button pressed")

		// increment the index
		leftDiceNumber += 1
		if let nm = diceNames.randomElement() {
			print("nm:", nm)
		}
		//print(diceNames[leftDiceNumber % 6])
		
		// udpate the image view
		diceImageView1.image = UIImage(named: diceNames[leftDiceNumber % 6])

	}
	
}

class zDiceViewController: UIViewController {
	
	@IBOutlet weak var diceImageView1: UIImageView!
	@IBOutlet weak var diceImageView2: UIImageView!
	
	let diceNames: [String] = [
		"DiceOne", "DiceTwo", "DiceThree", "DiceFour", "DiceFive", "DiceSix"
	]
	
	var leftDiceNumber = 1
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// start with both dice at One
		diceImageView1.image = UIImage(named: diceNames[0])
		diceImageView2.image = UIImage(named: diceNames[0])

		let n = "1.square"
		diceImageView1.image = UIImage(systemName: n)
		diceImageView2.image = UIImage(systemName: n)
	}
	
	@IBAction func rollButtonPressed(_ sender: UIButton) {
		print("button pressed")

		let ln = Int.random(in: 1...6)
		let rn = Int.random(in: 1...6)

		diceImageView1.image = UIImage(systemName: "\(ln).square")
		diceImageView2.image = UIImage(systemName: "\(rn).square")

	}
	
}

class yDiceViewController: UIViewController {
	
	@IBOutlet weak var diceImageView1: UIImageView!
	@IBOutlet weak var diceImageView2: UIImageView!
	
	let diceNames: [String] = [
		"DiceOne", "DiceTwo", "DiceThree", "DiceFour", "DiceFive", "DiceSix"
	]
	
	var leftDiceNumber = 1
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// start with both dice at One
		diceImageView1.image = UIImage(named: diceNames[0])
		diceImageView2.image = UIImage(named: diceNames[0])

	}
	
	@IBAction func rollButtonPressed(_ sender: UIButton) {
		print("button pressed")
		
		// arrays are Zero-based, so get a random Int
		//	from 0 to 5
		let l = Int.random(in: 0...5)
		let r = Int.random(in: 0...5)
		diceImageView1.image = UIImage(named: diceNames[l])
		diceImageView2.image = UIImage(named: diceNames[r])

		if true {
			// more "modern swift"
			if let nm = diceNames.randomElement() {
				diceImageView1.image = UIImage(named: nm)
			}
			if let nm = diceNames.randomElement() {
				diceImageView2.image = UIImage(named: nm)
			}
		}
	}
	
}
