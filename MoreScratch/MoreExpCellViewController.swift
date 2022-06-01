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
