//
//  ViewController.swift
//  MoreScratch
//
//  Created by Don Mag on 3/16/22.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}


}

// simple cell class, based on your code
class PeerCell: UITableViewCell {
	
	let nameLabel = UILabel()
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.font = .systemFont(ofSize: 12, weight: UIFont.Weight(rawValue: 400))
		contentView.addSubview(nameLabel)
		let g = contentView.layoutMarginsGuide
		NSLayoutConstraint.activate([
			nameLabel.topAnchor.constraint(equalTo: g.topAnchor),
			nameLabel.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 180.0),
			nameLabel.trailingAnchor.constraint(equalTo: g.trailingAnchor),
			nameLabel.heightAnchor.constraint(equalToConstant: 30.0),
		])
	}
	
}

class PeerSupportVC: UIViewController {
	
	@IBOutlet var peerSupportTableView: UITableView!
	var supportArray: [String] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// register our custom cell
		self.peerSupportTableView.register(PeerCell.self, forCellReuseIdentifier: "Cell")
		self.peerSupportTableView.delegate = self;
		self.peerSupportTableView.dataSource = self;
		self.peerSupportTableView.rowHeight = 200.0
		getPeerSupport();
	}
	
	func getPeerSupport(){
		self.supportArray = ["One","Two","Three"]
	}
	
}

extension PeerSupportVC: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
		let item = self.supportArray[indexPath.row]
		
		return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
			let phoneAction = UIAction(title: "Phone Call", image: UIImage(systemName: "person.fill")) { (action) in
				print("Wants to Phone Call");
			}
			
			let textAction = UIAction(title: "Text Messsage", image: UIImage(systemName: "person.badge.plus")) { (action) in
				print("Wants to Text Message");
			}
			
			return UIMenu(title: "Contact Options", children: [phoneAction, textAction])
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let r = tableView.rectForRow(at: indexPath)

		let ac = UIAlertController(title: "Contact Options", message: nil, preferredStyle: .actionSheet)
		ac.addAction(UIAlertAction(title: "Phone Call", style: .default, handler: { _ in
			print("Wants to Phone Call");
		}))
		ac.addAction(UIAlertAction(title: "Text Message", style: .default, handler: {(_: UIAlertAction!) in
			print("Wants to Text Message");
		}))

		ac.modalPresentationStyle = .popover
		
//		if let popOverPresentationController : UIPopoverPresentationController = ac.popoverPresentationController {
//
//			let cellRect = tableView.rectForRow(at: indexPath)
//
//			popOverPresentationController.sourceView                = tableView
//			popOverPresentationController.sourceRect                = cellRect
//			popOverPresentationController.permittedArrowDirections  = .any
//
//		}
		
		if let ppc = ac.popoverPresentationController, let cell = tableView.cellForRow(at: indexPath) {
			ppc.sourceView = cell
			ppc.sourceRect = CGRect(x: cell.bounds.width - 58, y: cell.bounds.height/2 - 11, width: 22, height: 22)
			ac.modalPresentationStyle = .popover
		}
		present(ac, animated: true, completion: nil)
		
//		let c = tableView.cellForRow(at: indexPath)
//		let pop = ac.popoverPresentationController
//		//if let pop = popVC {
//			pop?.sourceView = c
//			pop?.sourceRect = r
//			present(ac, animated: true, completion: nil)
//		//}
	}
}

extension PeerSupportVC: UITableViewDataSource{
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		print("Count of Support Array:",self.supportArray.count);
		return self.supportArray.count;
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PeerCell
		
		let result = self.supportArray[indexPath.row]
		print(result)
		cell.nameLabel.text = result
		
		return cell;
	}
	
}

class PercentLayoutMethodsVC: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()

		let safeG = view.safeAreaLayoutGuide
		
		// create a "container" view
		let cView = UIView()
		cView.translatesAutoresizingMaskIntoConstraints = false
		cView.layer.borderWidth = 1
		cView.layer.borderColor = UIColor.red.cgColor
		
		view.addSubview(cView)
		
		// constraints for the container view
		NSLayoutConstraint.activate([
			cView.topAnchor.constraint(equalTo: safeG.topAnchor, constant: 20.0),
			cView.heightAnchor.constraint(equalToConstant: 40.0),
			cView.widthAnchor.constraint(equalToConstant: 200.0),
			cView.centerXAnchor.constraint(equalTo: safeG.centerXAnchor),
		])
		
		// create a "cyan" view
		let cyanView = UIView()
		cyanView.translatesAutoresizingMaskIntoConstraints = false
		cyanView.backgroundColor = .cyan

		// add it to the container
		cView.addSubview(cyanView)

		// constrain the cyan view Top / Bottom / Trailing to the container
		NSLayoutConstraint.activate([
			cyanView.topAnchor.constraint(equalTo: cView.topAnchor),
			cyanView.bottomAnchor.constraint(equalTo: cView.bottomAnchor),
			cyanView.trailingAnchor.constraint(equalTo: cView.trailingAnchor),
		])
		
		// we want the cyan view's leading-edge to be 15% from the
		//	leading-edge of the container
		// but, we can't do that with a leadingAnchor
		//	so, let's add a UILayoutGuide
		
		// create the guide
		let leftGuide = UILayoutGuide()
		
		// add it to the container view
		cView.addLayoutGuide(leftGuide)
		
		// now, we'll constrain the guide
		NSLayoutConstraint.activate([

			//	Top / Bottom / Leading to the container
			leftGuide.topAnchor.constraint(equalTo: cView.topAnchor),
			leftGuide.bottomAnchor.constraint(equalTo: cView.bottomAnchor),
			leftGuide.leadingAnchor.constraint(equalTo: cView.leadingAnchor),

			//	Width as 15% of the container Width
			leftGuide.widthAnchor.constraint(equalTo: cView.widthAnchor, multiplier: 15.0 / 100.0),
			
			// and cyan view Leading to the guide's Trailing
			cyanView.leadingAnchor.constraint(equalTo: leftGuide.trailingAnchor),
			
		])
	}
	
}

class xPercentLayoutMethodsVC: UIViewController {
	
	let viewsView: UsingViewsPPV = UsingViewsPPV()
	let guidesView: UsingGuidesPPV = UsingGuidesPPV()
	
	var lPCT: CGFloat = 5.0 / 100.0
	var rPCT: CGFloat = 10.0 / 100.0
	
	var widthC: NSLayoutConstraint!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		let views: [PercentPaddedView] = [
			viewsView,
			guidesView,
		]
		
		views.forEach { v in
			v.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview(v)
			v.leftPCT = lPCT
			v.rightPCT = rPCT
		}

		// let's put a "control" view at the top
		//	to show the full width
		let cView: UIView = UIView()
		cView.backgroundColor = .systemRed
		cView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(cView)
		
		let g = view.safeAreaLayoutGuide
		
		// the width constraint that we'll update later
		widthC = cView.widthAnchor.constraint(equalToConstant: 100.0)
		
		NSLayoutConstraint.activate([
			
			cView.topAnchor.constraint(equalTo: g.topAnchor, constant: 20.0),
			cView.heightAnchor.constraint(equalToConstant: 20.0),
			cView.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			widthC,
			
		])
		
		var prevView: UIView = cView
		
		views.forEach { v in
			NSLayoutConstraint.activate([
				v.topAnchor.constraint(equalTo: prevView.bottomAnchor, constant: 20.0),
				v.heightAnchor.constraint(equalToConstant: 50.0),
				v.centerXAnchor.constraint(equalTo: g.centerXAnchor),
				v.widthAnchor.constraint(equalTo: cView.widthAnchor),
			])
			prevView = v
		}
		
	}
	
}

class PercentPaddedView: UIView {
	
	var leftPCT: CGFloat = 0 {
		didSet {
			updatePadding()
		}
	}
	var rightPCT: CGFloat = 0 {
		didSet {
			updatePadding()
		}
	}

	var leftWidthC: NSLayoutConstraint!
	var rightWidthC: NSLayoutConstraint!
	
	let contentView: UIView = UIView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {
		contentView.backgroundColor = .cyan
		contentView.translatesAutoresizingMaskIntoConstraints = false
		addSubview(contentView)
		NSLayoutConstraint.activate([
			contentView.topAnchor.constraint(equalTo: topAnchor),
			contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
		])
		layer.borderColor = UIColor.red.cgColor
		layer.borderWidth = 1
	}
	func updatePadding() {
		
	}
	
}

class UsingViewsPPV: PercentPaddedView {
	
	let leftView: UIView = UIView()
	let rightView: UIView = UIView()
	
	override func commonInit() {
		super.commonInit()
		
		[leftView, rightView].forEach { v in
			v.translatesAutoresizingMaskIntoConstraints = false
			addSubview(v)
			v.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
			v.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
		}
		
		leftWidthC = leftView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: leftPCT)
		rightWidthC = rightView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: rightPCT)

		NSLayoutConstraint.activate([
			
			leftView.leadingAnchor.constraint(equalTo: leadingAnchor),
			rightView.trailingAnchor.constraint(equalTo: trailingAnchor),

			contentView.leadingAnchor.constraint(equalTo: leftView.trailingAnchor),
			contentView.trailingAnchor.constraint(equalTo: rightView.leadingAnchor),

			// activate the width constraints
			leftWidthC,
			rightWidthC,
			
		])

		leftView.backgroundColor = .systemYellow
		rightView.backgroundColor = .systemBlue
	}
	override func updatePadding() {
		leftWidthC.isActive = false
		rightWidthC.isActive = false
		
		// updated multipliers
		leftWidthC = leftView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: leftPCT)
		rightWidthC = rightView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: rightPCT)
		
		leftWidthC.isActive = true
		rightWidthC.isActive = true
	}
}

class UsingGuidesPPV: PercentPaddedView {
	
	let leftGuide: UILayoutGuide = UILayoutGuide()
	let rightGuide: UILayoutGuide = UILayoutGuide()
	
	override func commonInit() {
		super.commonInit()
		
		[leftGuide, rightGuide].forEach { v in
			addLayoutGuide(v)
			v.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
			v.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
		}
		
		leftWidthC = leftGuide.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: leftPCT)
		rightWidthC = rightGuide.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: rightPCT)
		
		NSLayoutConstraint.activate([
			
			leftGuide.leadingAnchor.constraint(equalTo: leadingAnchor),
			rightGuide.trailingAnchor.constraint(equalTo: trailingAnchor),
			
			contentView.leadingAnchor.constraint(equalTo: leftGuide.trailingAnchor),
			contentView.trailingAnchor.constraint(equalTo: rightGuide.leadingAnchor),
			
			// activate the width constraints
			leftWidthC,
			rightWidthC,
			
		])
	}
	override func updatePadding() {
		leftWidthC.isActive = false
		rightWidthC.isActive = false
		
		// updated multipliers
		leftWidthC = leftGuide.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: leftPCT)
		rightWidthC = rightGuide.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: rightPCT)
		
		leftWidthC.isActive = true
		rightWidthC.isActive = true
	}
}

class RelScrollView: UIScrollView {
	
	public var speed: CGFloat = 1.0
	
	private var startTouchY: CGFloat = 0
	private var startY: CGFloat = 0
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	private func commonInit() {
		// scrolling must be disabled
		isScrollEnabled = false
	}
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		if !isScrollEnabled, let t = touches.first, let sv = superview {
			startTouchY = t.location(in: sv).y
			startY = contentOffset.y
		}
	}
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		if !isScrollEnabled, let t = touches.first, let sv = superview {
			let diff = t.location(in: sv).y - startTouchY
			contentOffset.y = startY - diff * speed
			//print(diff, contentOffset.y)
		}
	}
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		if !isScrollEnabled, let t = touches.first, let sv = superview {
			let diff1 = t.location(in: sv).y - startTouchY
			let diff2 = startY - contentOffset.y
			print(diff1, diff2)
		}
	}
}
class xSlowScrollVC: UIViewController, UIScrollViewDelegate {
	
	let scrollView = RelScrollView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// add a bunch of labels so we have something to scroll
		let stack = UIStackView()
		stack.axis = .vertical
		stack.spacing = 40
		
		for i in 1...20 {
			let v = UILabel()
			v.text = "Label \(i)"
			v.textAlignment = .center
			v.backgroundColor = .cyan
			stack.addArrangedSubview(v)
			let b = UIButton()
			b.setTitle("Button \(i)", for: [])
			b.backgroundColor = .systemBlue
			b.addTarget(self, action: #selector(btnTap(_:)), for: .touchUpInside)
			stack.addArrangedSubview(b)
		}
		
		stack.translatesAutoresizingMaskIntoConstraints = false
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		
		scrollView.addSubview(stack)
		view.addSubview(scrollView)

		// so we can see the scroll view frame
		scrollView.backgroundColor = .yellow
		
		let g = view.safeAreaLayoutGuide
		let cg = scrollView.contentLayoutGuide
		let fg = scrollView.frameLayoutGuide
		
		NSLayoutConstraint.activate([
			
			scrollView.topAnchor.constraint(equalTo: g.topAnchor, constant: 20.0),
			scrollView.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
			scrollView.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -20.0),
			scrollView.bottomAnchor.constraint(equalTo: g.bottomAnchor, constant: -20.0),

			stack.topAnchor.constraint(equalTo: cg.topAnchor, constant: 8.0),
			stack.leadingAnchor.constraint(equalTo: cg.leadingAnchor, constant: 8.0),
			stack.trailingAnchor.constraint(equalTo: cg.trailingAnchor, constant: -8.0),
			stack.bottomAnchor.constraint(equalTo: cg.bottomAnchor, constant: -8.0),
			
			stack.widthAnchor.constraint(equalTo: fg.widthAnchor, constant: -16.0),

		])
		
		scrollView.speed = 0.5
		
		//scrollView.delegate = self
		
	}

	@objc func btnTap(_ sender: UIButton) {
		print("Tap:", sender.currentTitle)
	}
	
}

class ySlowScrollVC: UIViewController, UIScrollViewDelegate {
	
	let scrollView = UIScrollView()
	let scrollViewOverlay = UIScrollView()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		// add a bunch of labels so we have something to scroll
		let stack = UIStackView()
		stack.axis = .vertical
		stack.spacing = 40
		
		for i in 1...40 {
			let v = UILabel()
			v.text = "Label \(i)"
			v.textAlignment = .center
			v.backgroundColor = .cyan
			stack.addArrangedSubview(v)
		}
		
		stack.translatesAutoresizingMaskIntoConstraints = false
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollViewOverlay.translatesAutoresizingMaskIntoConstraints = false

		scrollView.addSubview(stack)
		view.addSubview(scrollView)
		view.addSubview(scrollViewOverlay)

		// so we can see the scroll view frame
		scrollView.backgroundColor = .yellow
		
		let g = view.safeAreaLayoutGuide
		let cg = scrollView.contentLayoutGuide
		let fg = scrollView.frameLayoutGuide
		
		NSLayoutConstraint.activate([
			
			scrollView.topAnchor.constraint(equalTo: g.topAnchor, constant: 20.0),
			scrollView.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
			scrollView.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -20.0),
			scrollView.bottomAnchor.constraint(equalTo: g.bottomAnchor, constant: -20.0),
			
			stack.topAnchor.constraint(equalTo: cg.topAnchor, constant: 8.0),
			stack.leadingAnchor.constraint(equalTo: cg.leadingAnchor, constant: 8.0),
			stack.trailingAnchor.constraint(equalTo: cg.trailingAnchor, constant: -8.0),
			stack.bottomAnchor.constraint(equalTo: cg.bottomAnchor, constant: -8.0),
			
			stack.widthAnchor.constraint(equalTo: fg.widthAnchor, constant: -16.0),

			scrollViewOverlay.topAnchor.constraint(equalTo: scrollView.topAnchor),
			scrollViewOverlay.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
			scrollViewOverlay.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
			scrollViewOverlay.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

		])
		
		//scrollView.speed = 0.5
		
		scrollViewOverlay.delegate = self
		
	}
	
	var cHeight: CGFloat = 0
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if scrollView.contentSize.height == 0 {
			scrollView.setNeedsLayout()
			scrollView.layoutIfNeeded()
		}
		if cHeight != scrollView.contentSize.height {
			cHeight = scrollView.contentSize.height
			scrollViewOverlay.contentSize = CGSize(width: 0.0, height: cHeight / factor)
			//scrollViewOverlay.contentSize.height += scrollViewOverlay.frame.height
			//scrollViewOverlay.contentInset.bottom = scrollViewOverlay.frame.height
			print(cHeight)
		}
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let pct = scrollViewOverlay.contentOffset.y / (scrollViewOverlay.contentSize.height - scrollViewOverlay.frame.height)
		self.scrollView.contentOffset.y = (self.scrollView.contentSize.height - scrollView.frame.height) * pct
	}
	
	var factor: CGFloat = 0.75
	var startY: CGFloat = 0
	
}

class SlowScrollVC: UIViewController, UIScrollViewDelegate {
	
	// scrollSpeed --- example values
	//	1.0 == normal
	//	1.5 == fast
	//	0.5 == slow
	var scrollSpeed: CGFloat = 0.5
	
	var startingOffsetY: CGFloat = 0
	var bManualOffset: Bool = false

	let scrollView = UIScrollView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// add a bunch of labels and buttons so we have something to scroll
		let stack = UIStackView()
		stack.axis = .vertical
		stack.spacing = 40
		
		for i in 1...20 {
			let v = UILabel()
			v.text = "Label \(i)"
			v.textAlignment = .center
			v.backgroundColor = .cyan
			stack.addArrangedSubview(v)
			let b = UIButton()
			b.setTitle("Button \(i)", for: [])
			b.setTitleColor(.white, for: .normal)
			b.setTitleColor(.lightGray, for: .highlighted)
			b.backgroundColor = .systemBlue
			b.addTarget(self, action: #selector(btnTap(_:)), for: .touchUpInside)
			stack.addArrangedSubview(b)
		}
		
		stack.translatesAutoresizingMaskIntoConstraints = false
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		
		scrollView.addSubview(stack)
		view.addSubview(scrollView)
		
		// so we can see the scroll view frame
		scrollView.backgroundColor = .yellow
		
		let g = view.safeAreaLayoutGuide
		let cg = scrollView.contentLayoutGuide
		let fg = scrollView.frameLayoutGuide
		
		NSLayoutConstraint.activate([
			
			scrollView.topAnchor.constraint(equalTo: g.topAnchor, constant: 20.0),
			scrollView.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
			scrollView.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -20.0),
			scrollView.bottomAnchor.constraint(equalTo: g.bottomAnchor, constant: -20.0),
			
			stack.topAnchor.constraint(equalTo: cg.topAnchor, constant: 8.0),
			stack.leadingAnchor.constraint(equalTo: cg.leadingAnchor, constant: 8.0),
			stack.trailingAnchor.constraint(equalTo: cg.trailingAnchor, constant: -8.0),
			stack.bottomAnchor.constraint(equalTo: cg.bottomAnchor, constant: -8.0),
			
			stack.widthAnchor.constraint(equalTo: fg.widthAnchor, constant: -16.0),
			
		])
		
		scrollView.delegate = self

		// you may also want to adjust .decelerationRate
		//	try various values to see the result
		//scrollView.decelerationRate = UIScrollView.DecelerationRate(rawValue: 0.99)

	}
	
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		startingOffsetY = scrollView.contentOffset.y
	}
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if !bManualOffset {
			// get the difference between previous offset.y and new offset.y
			let diff = scrollView.contentOffset.y - startingOffsetY
			// adjust by scroll-speed factor
			let newY = startingOffsetY + diff * scrollSpeed
			// prevent recursion
			bManualOffset = true
			// set adjusted offset.y
			scrollView.contentOffset.y = newY
			// update start Y
			startingOffsetY = newY
		}
		bManualOffset = false
	}
	
	@objc func btnTap(_ sender: UIButton) {
		// just to confirm we tapped a button
		print("Tap:", sender.currentTitle)
	}

}

class xMarkerVC: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .systemBlue
		
		guard let img = UIImage(named: "img80x80")
		else {
			fatalError("Could not load sample image!!!")
		}

		let markerView1 = getMarker(lbl: "Testing", img: img)
		
		let markerView2 = getMarkerAutoSized(lbl: "Testing", img: img)

		markerView1.translatesAutoresizingMaskIntoConstraints = false
		markerView2.translatesAutoresizingMaskIntoConstraints = false

		view.addSubview(markerView1)
		view.addSubview(markerView2)

		// respect safe area
		let safeG = view.safeAreaLayoutGuide
		
		NSLayoutConstraint.activate([
			
			// we have to set both Position and Size constraints
			//	for markerView1
			markerView1.topAnchor.constraint(equalTo: safeG.topAnchor, constant: 20.0),
			markerView1.widthAnchor.constraint(equalToConstant: 240.0),
			markerView1.heightAnchor.constraint(equalToConstant: 100.0),
			markerView1.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			
			// markerView2 uses its subviews to set its own size
			//	so we only need position constraints
			markerView2.topAnchor.constraint(equalTo: markerView1.bottomAnchor, constant: 20.0),
			markerView2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			
		])

		// so we can see the view frames
		markerView1.backgroundColor = .systemRed
		markerView2.backgroundColor = .systemRed

	}
	
	func getMarker (lbl:String, img:UIImage) -> UIView {
		
		let myView = UIView()
		myView.backgroundColor = UIColor.clear
		
		let imageView = UIImageView(image: img)

		let label = UILabel()
		label.text = lbl
		label.textAlignment = .center
		label.adjustsFontSizeToFitWidth = true
		label.textColor = UIColor.black
		label.backgroundColor = UIColor.white
		label.layer.borderColor = UIColor.lightGray.cgColor
		label.layer.borderWidth = 0.5
		label.layer.cornerRadius = 5
		label.layer.masksToBounds = true

		imageView.translatesAutoresizingMaskIntoConstraints = false
		label.translatesAutoresizingMaskIntoConstraints = false
		
		myView.addSubview(imageView)
		myView.addSubview(label)

		NSLayoutConstraint.activate([

			// image view Width and Height
			imageView.widthAnchor.constraint(equalToConstant: 20.0),
			imageView.heightAnchor.constraint(equalToConstant: 40.0),

			// labe Width and Height
			label.widthAnchor.constraint(equalToConstant: 120.0),
			label.heightAnchor.constraint(equalToConstant: 30.0),
			
			// image view aligned to Top
			imageView.topAnchor.constraint(equalTo: myView.topAnchor),
			// centered Horizontally
			imageView.centerXAnchor.constraint(equalTo: myView.centerXAnchor),
			
			// label 5-pts below image view
			label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5.0),
			// centered Horizontally
			label.centerXAnchor.constraint(equalTo: myView.centerXAnchor),
			
		])
		
		return myView
	}
	
	func getMarkerAutoSized (lbl:String, img:UIImage) -> UIView {
		
		let myView = UIView()
		myView.backgroundColor = UIColor.clear
		
		let imageView = UIImageView(image: img)
		
		let label = UILabel()
		label.text = lbl
		label.textAlignment = .center
		label.adjustsFontSizeToFitWidth = true
		label.textColor = UIColor.black
		label.backgroundColor = UIColor.white
		label.layer.borderColor = UIColor.lightGray.cgColor
		label.layer.borderWidth = 0.5
		label.layer.cornerRadius = 5
		label.layer.masksToBounds = true
		
		imageView.translatesAutoresizingMaskIntoConstraints = false
		label.translatesAutoresizingMaskIntoConstraints = false
		
		myView.addSubview(imageView)
		myView.addSubview(label)
		
		NSLayoutConstraint.activate([
			
			// image view Width and Height
			imageView.widthAnchor.constraint(equalToConstant: 20.0),
			imageView.heightAnchor.constraint(equalToConstant: 40.0),
			
			// labe Width and Height
			label.widthAnchor.constraint(equalToConstant: 120.0),
			label.heightAnchor.constraint(equalToConstant: 30.0),
			
			// image view aligned to Top
			imageView.topAnchor.constraint(equalTo: myView.topAnchor),
			// centered Horizontally
			imageView.centerXAnchor.constraint(equalTo: myView.centerXAnchor),
			
			// label 5-pts below image view
			label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 5.0),
			// centered Horizontally
			label.centerXAnchor.constraint(equalTo: myView.centerXAnchor),
			
			// to auto-size myView
			label.leadingAnchor.constraint(equalTo: myView.leadingAnchor),
			label.trailingAnchor.constraint(equalTo: myView.trailingAnchor),
			label.bottomAnchor.constraint(equalTo: myView.bottomAnchor),
			
		])
		
		return myView
	}
	
}

class MarkerVC: UIViewController {
	
	let textView = UITextView()
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// so we can see it
		textView.backgroundColor = .cyan

		// disable scrolling
		textView.isScrollEnabled = false

		// set the font
		let font: UIFont = .systemFont(ofSize: 20.0, weight: .light)
		textView.font = font
		
		// we want the height to be at least one-line high
		//	even if it has no text yet
		let minHeight: CGFloat = font.lineHeight
		
		textView.translatesAutoresizingMaskIntoConstraints = false

		view.addSubview(textView)
		
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			// Leading / Trailing -- will likely be based on other UI elements
			textView.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 60.0),
			textView.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -60.0),
			// Bottom constraint, so it will "grow up"
			textView.bottomAnchor.constraint(equalTo: g.topAnchor, constant: 300.0),
			// at least minHeight tall
			textView.heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight),
		])
		
	}
}

class iMarkerVC: UIViewController {
	
	let testLabel: InputLabel = InputLabel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let instructionLabel = UILabel()
		instructionLabel.textAlignment = .center
		instructionLabel.text = "Tap yellow label to edit..."
		
		let centeringFrameView = UIView()
		
		// label properties
		let fnt: UIFont = .systemFont(ofSize: 32.0)
		testLabel.isUserInteractionEnabled = true
		testLabel.font = fnt
		testLabel.adjustsFontSizeToFitWidth = true
		testLabel.minimumScaleFactor = 0.25
		testLabel.numberOfLines = 2
		testLabel.setContentHuggingPriority(.required, for: .vertical)
		let minLabelHeight = ceil(fnt.lineHeight)
		
		// so we can see the frames
		centeringFrameView.backgroundColor = .red
		testLabel.backgroundColor = .yellow
		
		[centeringFrameView, instructionLabel, testLabel].forEach {
			$0.translatesAutoresizingMaskIntoConstraints = false
		}
		
		view.addSubview(instructionLabel)
		view.addSubview(centeringFrameView)
		centeringFrameView.addSubview(testLabel)
		
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			
			// instruction label centered at top
			instructionLabel.topAnchor.constraint(equalTo: g.topAnchor, constant: 20.0),
			instructionLabel.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			
			// centeringFrameView 20-pts from instructionLabel bottom
			centeringFrameView.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 20.0),
			// Leading / Trailing with 20-pts "padding"
			centeringFrameView.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
			centeringFrameView.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -20.0),
			
			// test label centered vertically in centeringFrameView
			testLabel.centerYAnchor.constraint(equalTo: centeringFrameView.centerYAnchor, constant: 0.0),
			// Leading / Trailing with 20-pts "padding"
			testLabel.leadingAnchor.constraint(equalTo: centeringFrameView.leadingAnchor, constant: 20.0),
			testLabel.trailingAnchor.constraint(equalTo: centeringFrameView.trailingAnchor, constant: -20.0),
			
			// height will be zero if label has no text,
			//  so give it a min height of one line
			testLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: minLabelHeight),
			
			// centeringFrameView height = 3 * minLabelHeight
			centeringFrameView.heightAnchor.constraint(equalToConstant: minLabelHeight * 3.0)
		])
		
		// to handle user input
		testLabel.editCallBack = { [weak self] str in
			guard let self = self else { return }
			self.testLabel.text = str
		}
		testLabel.doneCallBack = { [weak self] in
			guard let self = self else { return }
			// do something when user taps done / enter
		}
		
		let t = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
		testLabel.addGestureRecognizer(t)
		
	}
	
	@objc func labelTapped(_ g: UITapGestureRecognizer) -> Void {
		testLabel.becomeFirstResponder()
		testLabel.inputContainerView.theTextView.text = testLabel.text
		testLabel.inputContainerView.theTextView.becomeFirstResponder()
	}
	
}

class InputLabel: UILabel {
	
	var editCallBack: ((String) -> ())?
	var doneCallBack: (() -> ())?
	
	override var canBecomeFirstResponder: Bool {
		return true
	}
	override var canResignFirstResponder: Bool {
		return true
	}
	override var inputAccessoryView: UIView? {
		get { return inputContainerView }
	}
	
	lazy var inputContainerView: CustomInputAccessoryView = {
		let v = CustomInputAccessoryView()
		v.editCallBack = { [weak self] str in
			guard let self = self else { return }
			self.editCallBack?(str)
		}
		v.doneCallBack = { [weak self] in
			guard let self = self else { return }
			self.resignFirstResponder()
		}
		return v
	}()
	
}

class CustomInputAccessoryView: UIView, UITextViewDelegate {
	
	var editCallBack: ((String) -> ())?
	var doneCallBack: (() -> ())?
	
	let theTextView: UITextView = {
		let tv = UITextView()
		tv.isScrollEnabled = false
		tv.font = .systemFont(ofSize: 16)
		tv.autocorrectionType = .no
		tv.returnKeyType = .done
		return tv
	}()
	
	let imgView: UIImageView = {
		let v = UIImageView()
		v.contentMode = .scaleAspectFit
		v.clipsToBounds = true
		return v
	}()
	
	let sendButton: UIButton = {
		let v = UIButton()
		return v
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .lightGray
		autoresizingMask = [.flexibleHeight, .flexibleWidth]
		
		if let img = UIImage(named: "testImage") {
			imgView.image = img
		} else {
			imgView.backgroundColor = .systemBlue
		}
		
		let largeConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular, scale: .large)
		let buttonImg = UIImage(systemName: "paperplane.fill", withConfiguration: largeConfig)
		sendButton.setImage(buttonImg, for: .normal)
		
		[theTextView, imgView, sendButton].forEach { v in
			addSubview(v)
			v.translatesAutoresizingMaskIntoConstraints = false
		}
		
		// if we want to see the image view and button frames
		//[imgView, sendButton].forEach { v in
		//  v.backgroundColor = .systemYellow
		//}
		
		NSLayoutConstraint.activate([
			
			// constrain image view 40x40 with 8-pts leading
			imgView.widthAnchor.constraint(equalToConstant: 40.0),
			imgView.heightAnchor.constraint(equalTo: imgView.widthAnchor),
			imgView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8.0),
			
			// constrain image view 40x40 with 8-pts trailing
			sendButton.widthAnchor.constraint(equalToConstant: 40.0),
			sendButton.heightAnchor.constraint(equalTo: sendButton.widthAnchor),
			sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8.0),
			
			// constrain text view with 10-pts from
			//  image view trailing
			//  send button leading
			theTextView.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 10),
			theTextView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -10),
			
			// constrain image view and button
			//  centered vertically
			//  at least 8-pts top and bottom
			imgView.centerYAnchor.constraint(equalTo: centerYAnchor),
			sendButton.centerYAnchor.constraint(equalTo: centerYAnchor),
			imgView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 8.0),
			sendButton.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 8.0),
			imgView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -8.0),
			sendButton.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -8.0),
			
			// constrain text view 8-pts top/bottom
			theTextView.topAnchor.constraint(equalTo: topAnchor, constant: 8.0),
			theTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0),
			
		])
		
		theTextView.delegate = self
	}
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		if (text == "\n") {
			textView.resignFirstResponder()
			doneCallBack?()
		}
		return true
	}
	func textViewDidChange(_ textView: UITextView) {
		editCallBack?(textView.text ?? "")
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	override var intrinsicContentSize: CGSize {
		return .zero
	}
	
}

enum MyCellType: Int {
	case header
	case detail
}
struct MyStruct {
	var type: MyCellType = .header
	var headerString: String = ""
	var detailString: String = ""
	var detailValue: String = ""
}
class TestViewController: UIViewController {
	var myData: [MyStruct] = []
	
	var collectionView: UICollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .systemBlue
		
		// some sample data
		let headers: [String] = [
			"SOFTWARE", "BATTERY", "DEVICE", "HARDWARE", "MLB", "USAGE",
		]
		let counts: [Int] = [
			4, 2, 7, 5, 1, 8,
		]
		var val: Int = 1
		for (i, s) in headers.enumerated() {
			let t: MyStruct = MyStruct(type: .header, headerString: s, detailString: "", detailValue: "")
			myData.append(t)
			for j in 1...counts[i % counts.count] {
				let t: MyStruct = MyStruct(type: .detail, headerString: "", detailString: "Detail \(i),\(j)", detailValue: "Val: \(val)")
				myData.append(t)
				val += 1
			}
		}
	
		let fl = UICollectionViewFlowLayout()
		fl.scrollDirection = .horizontal
		fl.minimumLineSpacing = 12
		fl.minimumInteritemSpacing = 0
		fl.itemSize = CGSize(width: 200, height: 30)
		
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: fl)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(collectionView)
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: g.topAnchor, constant: 20.0),
			collectionView.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
			collectionView.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -20.0),
			collectionView.heightAnchor.constraint(equalToConstant: 300.0),
		])
		
		collectionView.register(MyHeaderCell.self, forCellWithReuseIdentifier: "headerCell")
		collectionView.register(MyDetailCell.self, forCellWithReuseIdentifier: "detailCell")
		
		collectionView.dataSource = self
		collectionView.delegate = self
	}
	
}

extension TestViewController: UICollectionViewDataSource, UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let t = myData[indexPath.item]
		if t.type == .header {
			let c = collectionView.dequeueReusableCell(withReuseIdentifier: "headerCell", for: indexPath) as! MyHeaderCell
			c.label.text = t.headerString
			return c
		}
		let c = collectionView.dequeueReusableCell(withReuseIdentifier: "detailCell", for: indexPath) as! MyDetailCell
		c.detailLabel.text = t.detailString
		c.valueLabel.text = t.detailValue
		// we don't want to show the "separator line" if the next
		//	item is a "header"
		if indexPath.item < myData.count - 1 {
			c.hideSepLine(myData[indexPath.item + 1].type == .header)
		}
		return c
	}
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return myData.count
	}
}

class MyHeaderCell: UICollectionViewCell {
	
	let label = UILabel()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .systemFont(ofSize: 10, weight: .bold)
		contentView.addSubview(label)
		contentView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
		let g = contentView.layoutMarginsGuide
		NSLayoutConstraint.activate([
			label.topAnchor.constraint(equalTo: g.topAnchor, constant: 0.0),
			label.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 0.0),
			label.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: 0.0),
			label.bottomAnchor.constraint(equalTo: g.bottomAnchor, constant: 0.0),
		])
	}
}

class MyDetailCell: UICollectionViewCell {
	
	let detailLabel = UILabel()
	let valueLabel = UILabel()
	let sepLineView = UIView()

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {
		
		detailLabel.font = .systemFont(ofSize: 12.0, weight: .light)
		valueLabel.font = .systemFont(ofSize: 12.0, weight: .light)
		valueLabel.textColor = .gray

		sepLineView.backgroundColor = .lightGray
		
		[detailLabel, valueLabel, sepLineView].forEach { v in
			v.translatesAutoresizingMaskIntoConstraints = false
			contentView.addSubview(v)
		}

		let g = contentView.layoutMarginsGuide
		NSLayoutConstraint.activate([

			detailLabel.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 16.0),
			detailLabel.centerYAnchor.constraint(equalTo: g.centerYAnchor),

			valueLabel.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: 0.0),
			valueLabel.centerYAnchor.constraint(equalTo: g.centerYAnchor),

			sepLineView.leadingAnchor.constraint(equalTo: detailLabel.leadingAnchor),
			sepLineView.trailingAnchor.constraint(equalTo: valueLabel.trailingAnchor),
			sepLineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			sepLineView.heightAnchor.constraint(equalToConstant: 1.0),

		])
		
	}
	
	func hideSepLine(_ b: Bool) {
		sepLineView.isHidden = b
	}
}

class MyLabel: UILabel {
	let redLayer = CALayer()
	let blueLayer = CALayer()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {
		layer.addSublayer(redLayer)
		layer.addSublayer(blueLayer)
		redLayer.borderWidth = 1
		blueLayer.borderWidth = 1
		redLayer.borderColor = UIColor.blue.cgColor
		blueLayer.borderColor = UIColor.red.cgColor
	}

	override func layoutSubviews() {
		var r = frame
		redLayer.frame = r
		redLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
		blueLayer.frame = bounds
	}
}


class VerticalLabelView: UIView {
	
	public var numberOfLines: Int = 1 {
		didSet {
			label.numberOfLines = numberOfLines
		}
	}
	public var text: String = "" {
		didSet {
			label.text = text
		}
	}
	
	// vertical and horizontal "padding"
	//	defaults to 16-ps (8-pts on each side)
	public var vPad: CGFloat = 16.0 {
		didSet {
			h.constant = vPad
		}
	}
	public var hPad: CGFloat = 16.0 {
		didSet {
			w.constant = hPad
		}
	}
	
	// because the label is rotated, we need to swap the axis
	override func setContentHuggingPriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
		label.setContentHuggingPriority(priority, for: axis == .horizontal ? .vertical : .horizontal)
	}
	
	// this is just for development
	//	show/hide border of label
	public var showBorder: Bool = false {
		didSet {
			label.layer.borderWidth = showBorder ? 1 : 0
			label.layer.borderColor = showBorder ? UIColor.red.cgColor : UIColor.clear.cgColor
		}
	}
	
	public let label = UILabel()
	
	private var w: NSLayoutConstraint!
	private var h: NSLayoutConstraint!
	private var mh: NSLayoutConstraint!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {
		addSubview(label)
		label.backgroundColor = .clear
		
		label.translatesAutoresizingMaskIntoConstraints = false
		
		// rotate 90-degrees
		let angle = .pi * 0.5
		label.transform = CGAffineTransform(rotationAngle: angle)
		
		// so we can change the "padding" dynamically
		w = self.widthAnchor.constraint(equalTo: label.heightAnchor, constant: hPad)
		h = self.heightAnchor.constraint(equalTo: label.widthAnchor, constant: vPad)
		
		NSLayoutConstraint.activate([
			
			label.centerXAnchor.constraint(equalTo: self.centerXAnchor),
			label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			w, h,
			
		])
		
	}
	
}

class BaseVC: UIViewController {
	
	let greenView: UIView = {
		let v = UIView()
		v.backgroundColor = .green
		return v
	}()
	let normalLabel: UILabel = {
		let v = UILabel()
		v.numberOfLines = 0
		return v
	}()
	
	let lYellow: VerticalLabelView = {
		let v = VerticalLabelView()
		v.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.5, alpha: 1.0)
		v.numberOfLines = 0
		return v
	}()
	
	let lRed: VerticalLabelView = {
		let v = VerticalLabelView()
		v.backgroundColor = UIColor(red: 1.0, green: 0.5, blue: 0.5, alpha: 1.0)
		v.numberOfLines = 0
		return v
	}()
	
	let lBlue: VerticalLabelView = {
		let v = VerticalLabelView()
		v.backgroundColor = UIColor(red: 0.3, green: 0.8, blue: 1.0, alpha: 1.0)
		v.numberOfLines = 1
		return v
	}()
	
	let container: UIView = {
		let v = UIView()
		v.backgroundColor = .systemYellow
		return v
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let strs: [String] = [
			"Multiline Vertical Text",
			"Vertical Text",
			"Overflow Vertical Text",
		]
		
		// default UILabel
		normalLabel.text = "Regular UILabel wrapping text"
		// add the normal label to the green view
		greenView.addSubview(normalLabel)
		
		// set text of vertical labels
		for (s, v) in zip(strs, [lYellow, lRed, lBlue]) {
			v.text = s
		}
		
		[container, greenView, normalLabel, lYellow, lRed, lBlue].forEach { v in
			v.translatesAutoresizingMaskIntoConstraints = false
		}
		
		// add greenView to the container
		container.addSubview(greenView)
		
		// add container to self's view
		view.addSubview(container)
		
		let g = view.safeAreaLayoutGuide
		
		NSLayoutConstraint.activate([
			
			// constrain container Top and CenterX
			container.topAnchor.constraint(equalTo: g.topAnchor, constant: 40.0),
			container.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			
			// comment next line to allow container subviews to set the height
			container.heightAnchor.constraint(equalToConstant: 260.0),
			
			// comment next line to allow container subviews to set the width
			container.widthAnchor.constraint(equalToConstant: 160.0),
			
			// green view at Top, stretched full width
			greenView.topAnchor.constraint(equalTo: container.topAnchor, constant: 0.0),
			greenView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0.0),
			greenView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0.0),

			// constrain normal label in green view
			//	with 8-pts "padding" on all 4 sides
			normalLabel.topAnchor.constraint(equalTo: greenView.topAnchor, constant: 8.0),
			normalLabel.leadingAnchor.constraint(equalTo: greenView.leadingAnchor, constant: 8.0),
			normalLabel.trailingAnchor.constraint(equalTo: greenView.trailingAnchor, constant: -8.0),
			normalLabel.bottomAnchor.constraint(equalTo: greenView.bottomAnchor, constant: -8.0),
			
		])
	}
	
}

class SubviewsExampleVC: BaseVC {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// add vertical labels to the container
		[lYellow, lRed, lBlue].forEach { v in
			container.addSubview(v)
		}

		NSLayoutConstraint.activate([
			
			// yellow label constrained to Bottom of green view
			lYellow.topAnchor.constraint(equalTo: greenView.bottomAnchor, constant: 0.0),
			// Leading to container Leading
			lYellow.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0.0),
			
			// red label constrained to Bottom of green view
			lRed.topAnchor.constraint(equalTo: greenView.bottomAnchor, constant: 0.0),
			// Leading to yellow label Trailing
			lRed.leadingAnchor.constraint(equalTo: lYellow.trailingAnchor, constant: 0.0),
			
			// blue label constrained to Bottom of green view
			lBlue.topAnchor.constraint(equalTo: greenView.bottomAnchor, constant: 0.0),
			// Leading to red label Trailing
			lBlue.leadingAnchor.constraint(equalTo: lRed.trailingAnchor, constant: 0.0),
			
			// if we want the labels to fill the container width
			//	blue label Trailing constrained to container Trailing
			lBlue.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0.0),
			
			// using constraints to set the vertical label heights
			lYellow.heightAnchor.constraint(equalToConstant: 132.0),
			lRed.heightAnchor.constraint(equalTo: lYellow.heightAnchor),
			lBlue.heightAnchor.constraint(equalTo: lYellow.heightAnchor),
			
		])
		
		// as always, we need to control which view(s)
		//	hug their content

		// so, for example, if we want the Yellow label to "stretch" horizontally
		lRed.setContentHuggingPriority(.required, for: .horizontal)
		lBlue.setContentHuggingPriority(.required, for: .horizontal)
		
		// or, for example, if we want the Red label to "stretch" horizontally
		//lYellow.setContentHuggingPriority(.required, for: .horizontal)
		//lBlue.setContentHuggingPriority(.required, for: .horizontal)

	}

}

class StackviewExampleVC: BaseVC {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// horizontal stack view
		let stackView = UIStackView()
		
		// add vertical labels to the stack view
		[lYellow, lRed, lBlue].forEach { v in
			stackView.addArrangedSubview(v)
		}
		
		stackView.translatesAutoresizingMaskIntoConstraints = false
		
		// add stack view to container
		container.addSubview(stackView)
		
		NSLayoutConstraint.activate([
			
			// constrain stack view Top to green view Bottom
			stackView.topAnchor.constraint(equalTo: greenView.bottomAnchor, constant: 0.0),

			// Leading / Trailing to container Leading / Trailing
			stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 0.0),
			stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0.0),
			
			// stack view height
			stackView.heightAnchor.constraint(equalToConstant: 132.0),
			
		])

		// as always, we need to control which view(s)
		//	hug their content
		// so, for example, if we want the Yellow label to "stretch" horizontally
		lRed.setContentHuggingPriority(.required, for: .horizontal)
		lBlue.setContentHuggingPriority(.required, for: .horizontal)
		
		// or, for example, if we want the Red label to "stretch" horizontally
		//lYellow.setContentHuggingPriority(.required, for: .horizontal)
		//lBlue.setContentHuggingPriority(.required, for: .horizontal)
		
	}
	
}

class LineView: UIView {
	
	public var maxVal: CGFloat = 0
	
	private var yVals: [CGFloat] = []
	
	private let shapeLayer = CAShapeLayer()
	
	private var curPath: UIBezierPath!
	
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
		shapeLayer.lineWidth = 2
		shapeLayer.strokeColor = UIColor.red.cgColor
		shapeLayer.fillColor = UIColor.clear.cgColor
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		if yVals.count > 1, maxVal > 0 {
			let pcts = transformVals(yVals, zeroAtBottom: true)
			curPath = makePath(pcts)
			shapeLayer.path = curPath.cgPath
		}
	}
	
	public func addVals(_ y: [CGFloat]) {
		yVals.append(contentsOf: y)
		if yVals.count < 3 {
			setNeedsLayout()
			layoutIfNeeded()
		} else {
			animateLine()
		}
	}
	
	private func makePath(_ a: [CGFloat]) -> UIBezierPath {
		var pt: CGPoint = .zero
		let pth = UIBezierPath()
		let w: CGFloat = bounds.width / CGFloat(a.count - 1)
		pt.x = 0
		pt.y = bounds.height * a[0]
		pth.move(to: pt)
		for i in 1..<a.count {
			pt.x += w
			pt.y = bounds.height * a[i]
			pth.addLine(to: pt)
		}
		return pth
	}
	private func transformVals(_ a: [CGFloat], zeroAtBottom: Bool) -> [CGFloat] {
		var newVals = a.compactMap({ $0 / maxVal})
		if zeroAtBottom {
			newVals = newVals.compactMap({ 1.0 - $0 })
		}
		return newVals
	}
	private func animateLine() {
		
		let pcts = transformVals(yVals, zeroAtBottom: true)
		curPath = makePath(pcts)
		
		let anim = CABasicAnimation(keyPath: "path")
		
		anim.duration = 0.3
		anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

		anim.toValue = curPath.cgPath
		anim.fillMode = .forwards
		anim.isRemovedOnCompletion = false
		anim.delegate = self
		
		self.shapeLayer.add(anim, forKey: "path")
	}
}
extension LineView: CAAnimationDelegate {
	func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
		self.shapeLayer.path = self.curPath.cgPath
		shapeLayer.removeAllAnimations()
	}
}

class LineViewTestVC: UIViewController {
	
	let lineView = LineView()
	
	let sampleValues: [CGFloat] = [
		90, 60, 87, 12, 55, 24, 97, 67, 92, 33,
		//77, 22, 44, 11, 41, 27, 99, 59, 91, 50,
	]
	var idx: Int = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemYellow
		
		lineView.translatesAutoresizingMaskIntoConstraints = false
		lineView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
		view.addSubview(lineView)
		
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			lineView.topAnchor.constraint(equalTo: g.topAnchor, constant: 20.0),
			lineView.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
			lineView.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -20.0),
			lineView.heightAnchor.constraint(equalToConstant: 240.0),
		])
		
		lineView.maxVal = 100.0
		
		lineView.addVals([0, 0])
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		lineView.addVals([sampleValues[idx % sampleValues.count]])
		idx += 1
	}
}

class xStackAnimVC: UIViewController {
	
	let stackView: UIStackView = {
		let v = UIStackView()
		v.axis = .vertical
		v.spacing = 8
		return v
	}()
	
	let topLabel: UILabel = {
		let v = UILabel()
		v.backgroundColor = .cyan
		v.numberOfLines = 0
		v.font = .systemFont(ofSize: 24.0, weight: .light)
		return v
	}()
	
	let botLabel: UILabel = {
		let v = UILabel()
		v.backgroundColor = .green
		v.numberOfLines = 0
		v.font = .systemFont(ofSize: 24.0, weight: .light)
		return v
	}()
	
	let soloLabel: UILabel = {
		let v = UILabel()
		v.backgroundColor = .cyan
		v.numberOfLines = 0
		v.font = .systemFont(ofSize: 24.0, weight: .light)
		return v
	}()

	var cHeight: NSLayoutConstraint!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		stackView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(stackView)
		
		soloLabel.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(soloLabel)
	
		stackView.addArrangedSubview(topLabel)
		stackView.addArrangedSubview(botLabel)
		
		// view arrangement gets quirky when all
		//	arrangedSubviews are hidden
		//	so we'll add an empty view
		stackView.addArrangedSubview(UIView())
		
		let g = view.safeAreaLayoutGuide

		cHeight = soloLabel.heightAnchor.constraint(equalToConstant: 0)
		
		NSLayoutConstraint.activate([
			
			soloLabel.topAnchor.constraint(equalTo: g.topAnchor, constant: 20.0),
			soloLabel.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
			soloLabel.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -20.0),
			
			stackView.topAnchor.constraint(equalTo: g.topAnchor, constant: 200.0),
			stackView.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
			stackView.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -20.0),

		])

		[soloLabel, topLabel, botLabel].forEach { v in
			
			v.text = "It seems that even without a stack view, if I animate the height constraint, you get this \"squeeze\" effect."
			
			// try it with this line un-commented
			v.contentMode = .top
		}

	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

		UIView.animate(withDuration: 1.5) {

			// change height constraint on solo label
			self.cHeight.isActive.toggle()

			// toggle hidden and alpha on stack view labels
			self.topLabel.alpha = self.topLabel.isHidden ? 1.0 : 0.0
			self.botLabel.alpha = self.botLabel.isHidden ? 1.0 : 0.0

			self.topLabel.isHidden.toggle()
			self.botLabel.isHidden.toggle()

			
		}
	}
}

// labels outside stack view
// with ContentMode toggle
class outcmStackAnimVC: UIViewController {
	
	let stackView: UIStackView = {
		let v = UIStackView()
		v.axis = .vertical
		v.spacing = 8
		return v
	}()
	
	let topLabel: UILabel = {
		let v = UILabel()
		v.numberOfLines = 0
		return v
	}()
	
	let botLabel: UILabel = {
		let v = UILabel()
		v.numberOfLines = 0
		return v
	}()
	
	let headerLabel = UILabel()
	let threeLabel = UILabel()
	let footerLabel = UILabel()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		// label setup
		let colors: [UIColor] = [
			.systemYellow,
			.cyan,
			UIColor(red: 1.0, green: 0.85, blue: 0.9, alpha: 1.0),
			UIColor(red: 0.7, green: 0.5, blue: 0.4, alpha: 1.0),
			UIColor(white: 0.9, alpha: 1.0),
		]
		for (c, v) in zip(colors, [headerLabel, topLabel, botLabel, threeLabel, footerLabel]) {
			v.backgroundColor = c
			v.font = .systemFont(ofSize: 24.0, weight: .light)
		}
		
		headerLabel.text = "Header"
		threeLabel.text = "Three"
		footerLabel.text = "Footer"
		
		topLabel.text = "It seems that even without a stack view, if I animate the height constraint, you get this \"squeeze\" effect."
		botLabel.text = "I still want to hide the labels, but want an animation where the alpha changes but the labels don't \"slide\"."
		
		// add labels to stack view
		stackView.addArrangedSubview(topLabel)
		stackView.addArrangedSubview(botLabel)
		
		// view arrangement gets quirky when all
		//	arrangedSubviews are hidden
		//	so we'll add an empty view
		stackView.addArrangedSubview(UIView())
		
		// let's add a label and a Switch to toggle the labels .contentMode
		let promptView = UIView()
		let hStack = UIStackView()
		hStack.spacing = 8
		let prompt = UILabel()
		prompt.text = "Content Mode Top:"
		prompt.textAlignment = .right
		let sw = UISwitch()
		sw.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
		hStack.addArrangedSubview(prompt)
		hStack.addArrangedSubview(sw)
		hStack.translatesAutoresizingMaskIntoConstraints = false
		promptView.addSubview(hStack)
		
		// add an Animate button
		let btn = UIButton(type: .system)
		btn.setTitle("Animate", for: [])
		btn.titleLabel?.font = .systemFont(ofSize: 24.0, weight: .regular)
		btn.addTarget(self, action: #selector(btnTap(_:)), for: .touchUpInside)

		let g = view.safeAreaLayoutGuide

		// add elements to view and give them all the same Leading and Trailing constraints
		[promptView, headerLabel, stackView, threeLabel, footerLabel, btn].forEach { v in

			v.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview(v)

			NSLayoutConstraint.activate([
				v.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
				v.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -20.0),
			])
		}

		NSLayoutConstraint.activate([

			promptView.topAnchor.constraint(equalTo: g.topAnchor, constant: 20.0),
			headerLabel.topAnchor.constraint(equalTo: promptView.bottomAnchor, constant: 0.0),
			stackView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 0.0),
			threeLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 0.0),
			footerLabel.topAnchor.constraint(equalTo: threeLabel.bottomAnchor, constant: 0.0),

			// center the hStack in the promptView
			hStack.centerXAnchor.constraint(equalTo: promptView.centerXAnchor),
			hStack.centerYAnchor.constraint(equalTo: promptView.centerYAnchor),
			promptView.heightAnchor.constraint(equalTo: hStack.heightAnchor, constant: 16.0),
			
			// put button near bottom
			btn.bottomAnchor.constraint(equalTo: g.bottomAnchor, constant: -40.0),

		])
		
	}
	
	@objc func switchChanged(_ sender: UISwitch) {
		[topLabel, botLabel].forEach { v in
			v.contentMode = sender.isOn ? .top : .left
		}
	}
	@objc func btnTap(_ sender: UIButton) {
		
		UIView.animate(withDuration: 1.0) {
			
			// toggle hidden and alpha on stack view labels
			self.topLabel.alpha = self.topLabel.isHidden ? 1.0 : 0.0
			self.botLabel.alpha = self.botLabel.isHidden ? 1.0 : 0.0
			
			self.topLabel.isHidden.toggle()
			self.botLabel.isHidden.toggle()
			
			
		}

	}
}

class TopAlignedLabelView: UIView {
	
	let label = UILabel()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {
		self.addSubview(label)
		label.numberOfLines = 0
		label.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			label.topAnchor.constraint(equalTo: topAnchor, constant: 0.0),
			label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.0),
			label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0.0),
		])
		// we need bottom anchor to have
		//	less-than-required Priority
		let c = label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0.0)
		c.priority = .required - 1
		c.isActive = true
		
		// don't allow label to be compressed
		label.setContentCompressionResistancePriority(.required, for: .vertical)
		
		// we need to clip the label
		self.clipsToBounds = true
	}
}

// labels outside stack view
// with custom view
class outcvStackAnimVC: UIViewController {
	
	let stackView: UIStackView = {
		let v = UIStackView()
		v.axis = .vertical
		v.spacing = 8
		return v
	}()
	
	let topLabel: TopAlignedLabelView = {
		let v = TopAlignedLabelView()
		return v
	}()
	
	let botLabel: TopAlignedLabelView = {
		let v = TopAlignedLabelView()
		return v
	}()
	
	let headerLabel = UILabel()
	let threeLabel = UILabel()
	let footerLabel = UILabel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// label setup
		let colors: [UIColor] = [
			.systemYellow,
			.cyan,
			UIColor(red: 1.0, green: 0.85, blue: 0.9, alpha: 1.0),
			UIColor(red: 0.7, green: 0.5, blue: 0.4, alpha: 1.0),
			UIColor(white: 0.9, alpha: 1.0),
		]
		for (c, v) in zip(colors, [headerLabel, topLabel, botLabel, threeLabel, footerLabel]) {
			v.backgroundColor = c
			if let vv = v as? UILabel {
				vv.font = .systemFont(ofSize: 24.0, weight: .light)
			}
			if let vv = v as? TopAlignedLabelView {
				vv.label.font = .systemFont(ofSize: 24.0, weight: .light)
			}
		}
		
		headerLabel.text = "Header"
		threeLabel.text = "Three"
		footerLabel.text = "Footer"
		
		topLabel.label.text = "It seems that even without a stack view, if I animate the height constraint, you get this \"squeeze\" effect."
		botLabel.label.text = "I still want to hide the labels, but want an animation where the alpha changes but the labels don't \"slide\"."
		
		// add labels to stack view
		stackView.addArrangedSubview(topLabel)
		stackView.addArrangedSubview(botLabel)
		
		// view arrangement gets quirky when all
		//	arrangedSubviews are hidden
		//	so we'll add an empty view
		stackView.addArrangedSubview(UIView())
		
		// add an Animate button
		let btn = UIButton(type: .system)
		btn.setTitle("Animate", for: [])
		btn.titleLabel?.font = .systemFont(ofSize: 24.0, weight: .regular)
		btn.addTarget(self, action: #selector(btnTap(_:)), for: .touchUpInside)
		
		let g = view.safeAreaLayoutGuide
		
		// add elements to view and give them all the same Leading and Trailing constraints
		[headerLabel, stackView, threeLabel, footerLabel, btn].forEach { v in
			
			v.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview(v)
			
			NSLayoutConstraint.activate([
				v.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
				v.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -20.0),
			])
		}
		
		NSLayoutConstraint.activate([
			
			headerLabel.topAnchor.constraint(equalTo: g.topAnchor, constant: 20.0),
			stackView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 0.0),
			threeLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 0.0),
			footerLabel.topAnchor.constraint(equalTo: threeLabel.bottomAnchor, constant: 0.0),
			
			// put button near bottom
			btn.bottomAnchor.constraint(equalTo: g.bottomAnchor, constant: -40.0),
			
		])
		
	}
	
	@objc func btnTap(_ sender: UIButton) {
		
		UIView.animate(withDuration: 1.0) {
			
			// toggle hidden and alpha on stack view labels
			self.topLabel.alpha = self.topLabel.isHidden ? 1.0 : 0.0
			self.botLabel.alpha = self.botLabel.isHidden ? 1.0 : 0.0
			
			self.topLabel.isHidden.toggle()
			self.botLabel.isHidden.toggle()
			
			
		}
		
	}
}

// labels inside stack view
// with ContentMode toggle
class liStackAnimVC: UIViewController {
	
	let stackView: UIStackView = {
		let v = UIStackView()
		v.axis = .vertical
		v.spacing = 0
		return v
	}()
	
	let topLabel: UILabel = {
		let v = UILabel()
		v.numberOfLines = 0
		return v
	}()
	
	let botLabel: UILabel = {
		let v = UILabel()
		v.numberOfLines = 0
		return v
	}()
	
	let headerLabel = UILabel()
	let threeLabel = UILabel()
	let footerLabel = UILabel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// label setup
		let colors: [UIColor] = [
			.systemYellow,
			.cyan,
			UIColor(red: 1.0, green: 0.85, blue: 0.9, alpha: 1.0),
			UIColor(red: 0.7, green: 0.5, blue: 0.4, alpha: 1.0),
			UIColor(white: 0.9, alpha: 1.0),
		]
		for (c, v) in zip(colors, [headerLabel, topLabel, botLabel, threeLabel, footerLabel]) {
			v.backgroundColor = c
			v.font = .systemFont(ofSize: 24.0, weight: .light)
			stackView.addArrangedSubview(v)
		}
		
		headerLabel.text = "Header"
		threeLabel.text = "Three"
		footerLabel.text = "Footer"
		
		topLabel.text = "It seems that even without a stack view, if I animate the height constraint, you get this \"squeeze\" effect."
		botLabel.text = "I still want to hide the labels, but want an animation where the alpha changes but the labels don't \"slide\"."
		
		// we want 8-pts "padding" under the "collapsible" labels
		stackView.setCustomSpacing(8.0, after: topLabel)
		stackView.setCustomSpacing(8.0, after: botLabel)

		// let's add a label and a Switch to toggle the labels .contentMode
		let promptView = UIView()
		let hStack = UIStackView()
		hStack.spacing = 8
		let prompt = UILabel()
		prompt.text = "Content Mode Top:"
		prompt.textAlignment = .right
		let sw = UISwitch()
		sw.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
		hStack.addArrangedSubview(prompt)
		hStack.addArrangedSubview(sw)
		hStack.translatesAutoresizingMaskIntoConstraints = false
		promptView.addSubview(hStack)
		
		// add an Animate button
		let btn = UIButton(type: .system)
		btn.setTitle("Animate", for: [])
		btn.titleLabel?.font = .systemFont(ofSize: 24.0, weight: .regular)
		btn.addTarget(self, action: #selector(btnTap(_:)), for: .touchUpInside)
		
		let g = view.safeAreaLayoutGuide
		
		// add elements to view and give them all the same Leading and Trailing constraints
		[promptView, stackView, btn].forEach { v in
			
			v.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview(v)
			
			NSLayoutConstraint.activate([
				v.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
				v.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -20.0),
			])
		}
		
		NSLayoutConstraint.activate([
			
			promptView.topAnchor.constraint(equalTo: g.topAnchor, constant: 20.0),
			stackView.topAnchor.constraint(equalTo: promptView.bottomAnchor, constant: 0.0),
			
			// center the hStack in the promptView
			hStack.centerXAnchor.constraint(equalTo: promptView.centerXAnchor),
			hStack.centerYAnchor.constraint(equalTo: promptView.centerYAnchor),
			promptView.heightAnchor.constraint(equalTo: hStack.heightAnchor, constant: 16.0),
			
			// put button near bottom
			btn.bottomAnchor.constraint(equalTo: g.bottomAnchor, constant: -40.0),
			
		])
		
	}
	
	@objc func switchChanged(_ sender: UISwitch) {
		[topLabel, botLabel].forEach { v in
			v.contentMode = sender.isOn ? .top : .left
		}
	}
	@objc func btnTap(_ sender: UIButton) {
		
		UIView.animate(withDuration: 1.0) {
			
			// toggle hidden and alpha on stack view labels
			self.topLabel.alpha = self.topLabel.isHidden ? 1.0 : 0.0
			self.botLabel.alpha = self.botLabel.isHidden ? 1.0 : 0.0
			
			self.topLabel.isHidden.toggle()
			self.botLabel.isHidden.toggle()
			
			
		}
		
	}
}


// labels inside stack view
// with custom view
class StackAnimVC: UIViewController {
	
	let stackView: UIStackView = {
		let v = UIStackView()
		v.axis = .vertical
		v.spacing = 0
		return v
	}()
	
	let topLabel: TopAlignedLabelView = {
		let v = TopAlignedLabelView()
		return v
	}()
	
	let botLabel: TopAlignedLabelView = {
		let v = TopAlignedLabelView()
		return v
	}()
	
	let headerLabel = UILabel()
	let threeLabel = UILabel()
	let footerLabel = UILabel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
				
		// label setup
		let colors: [UIColor] = [
			.systemYellow,
			.cyan,
			UIColor(red: 1.0, green: 0.85, blue: 0.9, alpha: 1.0),
			UIColor(red: 0.7, green: 0.5, blue: 0.4, alpha: 1.0),
			UIColor(white: 0.9, alpha: 1.0),
		]
		for (c, v) in zip(colors, [headerLabel, topLabel, botLabel, threeLabel, footerLabel]) {
			v.backgroundColor = c
			if let vv = v as? UILabel {
				vv.font = .systemFont(ofSize: 24.0, weight: .light)
			}
			if let vv = v as? TopAlignedLabelView {
				vv.label.font = .systemFont(ofSize: 24.0, weight: .light)
			}
			stackView.addArrangedSubview(v)
		}
		
		headerLabel.text = "Header"
		threeLabel.text = "Three"
		footerLabel.text = "Footer"
		
		topLabel.label.text = "It seems that even without a stack view, if I animate the height constraint, you get this \"squeeze\" effect."
		botLabel.label.text = "I still want to hide the labels, but want an animation where the alpha changes but the labels don't \"slide\"."
		
		// we want 8-pts "padding" under the "collapsible" labels
		stackView.setCustomSpacing(8.0, after: topLabel)
		stackView.setCustomSpacing(8.0, after: botLabel)
		
		// add an Animate button
		let btn = UIButton(type: .system)
		btn.setTitle("Animate", for: [])
		btn.titleLabel?.font = .systemFont(ofSize: 24.0, weight: .regular)
		btn.addTarget(self, action: #selector(btnTap(_:)), for: .touchUpInside)
		
		let g = view.safeAreaLayoutGuide
		
		// add elements to view and give them all the same Leading and Trailing constraints
		[stackView, btn].forEach { v in
			
			v.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview(v)
			
			NSLayoutConstraint.activate([
				v.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
				v.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -20.0),
			])
		}
		
		NSLayoutConstraint.activate([
			
			stackView.topAnchor.constraint(equalTo: g.topAnchor, constant: 20.0),
			
			// put button near bottom
			btn.bottomAnchor.constraint(equalTo: g.bottomAnchor, constant: -40.0),
			
		])
		
	}
	
	@objc func btnTap(_ sender: UIButton) {

		UIView.animate(withDuration: 1.0) {
			
			// toggle hidden and alpha on stack view labels
			self.topLabel.alpha = self.topLabel.isHidden ? 1.0 : 0.0
			self.botLabel.alpha = self.botLabel.isHidden ? 1.0 : 0.0
			
			self.topLabel.isHidden.toggle()
			self.botLabel.isHidden.toggle()
			
			
		}
		
	}
}

class RPViewController: UIViewController {
	
}

class ExampleVC: UIViewController {
	
	let yellowView: UIView = {
		let v = UIView()
		v.backgroundColor = .systemYellow
		return v
	}()
	let greenView: UIView = {
		let v = UIView()
		v.backgroundColor = .green
		return v
	}()
	let redView: UIView = {
		let v = UIView()
		v.backgroundColor = .systemRed
		return v
	}()
	
	let scrollView: UIScrollView = {
		let v = UIScrollView()
		v.backgroundColor = .systemBlue
		return v
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// create a vertical stack view
		let stack = UIStackView()
		stack.axis = .vertical
		stack.spacing = 16
		
		// let's add some labels to the stack view
		//  so we have something to scroll
		(1...30).forEach { n in
			let v = UILabel()
			v.backgroundColor = .yellow
			v.text = "Label \(n)"
			v.textAlignment = .center
			stack.addArrangedSubview(v)
		}
		
		// add the stack view to the red view
		redView.addSubview(stack)
		
		// add these views to scroll view in this order
		[yellowView, redView, greenView].forEach { v in
			scrollView.addSubview(v)
		}
		
		// add scroll view to view
		view.addSubview(scrollView)
		
		// they will all use auto-layout
		[stack, yellowView, redView, greenView, scrollView].forEach { v in
			v.translatesAutoresizingMaskIntoConstraints = false
		}
		
		// always respect safe area
		let safeG = view.safeAreaLayoutGuide
		
		let contentG = scrollView.contentLayoutGuide
		let frameG = scrollView.frameLayoutGuide
		
		NSLayoutConstraint.activate([
			
			// constrain scroll view to safe area
			scrollView.topAnchor.constraint(equalTo: safeG.topAnchor),
			scrollView.leadingAnchor.constraint(equalTo: safeG.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: safeG.trailingAnchor),
			scrollView.bottomAnchor.constraint(equalTo: safeG.bottomAnchor),
			
			// we need yellow view to
			//  fill width of scroll view FRAME
			//  height: 100-pts
			//  "stick" to top of scroll view FRAME
			yellowView.leadingAnchor.constraint(equalTo: frameG.leadingAnchor),
			yellowView.trailingAnchor.constraint(equalTo: frameG.trailingAnchor),
			yellowView.heightAnchor.constraint(equalToConstant: 100.0),
			yellowView.topAnchor.constraint(equalTo: frameG.topAnchor),
			
			// we need green view to
			//  fill width of scroll view FRAME
			//  height: 100-pts
			//  start at bottom of yellow view
			//  "stick" to top of scroll view FRAME when scrolled up
			greenView.leadingAnchor.constraint(equalTo: frameG.leadingAnchor),
			// we'll use a constant of -40 here to leave a "gap" on the right, so it's
			//  easy to see what's happening...
			greenView.trailingAnchor.constraint(equalTo: frameG.trailingAnchor, constant: -40),
			greenView.heightAnchor.constraint(equalToConstant: 100.0),
			greenView.topAnchor.constraint(greaterThanOrEqualTo: frameG.topAnchor),
			
			// we need red view to
			//  fill width of scroll view FRAME
			//  dynamic height (determined by its contents - the stack view)
			//  start at bottom of green view
			//  "push / pull" green view when scrolled
			//  go under green view when green view is at top
			// red view will be controlling the scrollable area
			redView.leadingAnchor.constraint(equalTo: contentG.leadingAnchor),
			redView.trailingAnchor.constraint(equalTo: contentG.trailingAnchor),
			redView.bottomAnchor.constraint(equalTo: contentG.bottomAnchor),
			redView.widthAnchor.constraint(equalTo: frameG.widthAnchor),
			
			// let's inset the stack view 16-pts on all 4 sides
			stack.topAnchor.constraint(equalTo: redView.topAnchor, constant: 16.0),
			stack.leadingAnchor.constraint(equalTo: redView.leadingAnchor, constant: 16.0),
			stack.trailingAnchor.constraint(equalTo: redView.trailingAnchor, constant: -16.0),
			stack.bottomAnchor.constraint(equalTo: redView.bottomAnchor, constant: -16.0),
			
		])
		
		var c: NSLayoutConstraint!
		
		// these constraints need Priority adjustments
		
		// keep green view above red view, until green view is at top
		c = redView.topAnchor.constraint(equalTo: greenView.bottomAnchor)
		c.priority = .defaultHigh
		c.isActive = true
		
		// since yellow and green view Heights are constant 100-pts each
		c = redView.topAnchor.constraint(equalTo: contentG.topAnchor, constant: 200.0)
		c.isActive = true
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		scrollView.delegate = self
	}
}

extension ExampleVC: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		// set yellowView alpha to the percentage that it is covered
		yellowView.alpha = (100.0 - min(100.0, scrollView.contentOffset.y)) / 100.0
	}
}

class StoryBoardExampleVC: UIViewController, UIScrollViewDelegate {
	
	
	
}



//		// list of button titles
//		let btnList: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"]
//
//		// create vertical stack view
//		print("New vStack")
//
//		// array index var
//		var idx: Int = 0
//
//		while idx < btnList.count {
//			// create horizontal stack view and
//			// add it to vertical stack view
//			print("New hStack - add to vertical stack view")
//			for _ in 1...3 {
//				if idx < btnList.count {
//					let nextTitle = btnList[idx]
//					// create a new button with title
//					// add it to the horizontal stack view
//					print("add button \(nextTitle) to hStack")
//					// increment the array index
//					idx += 1
//				}
//			}
//		}
//
//		print("done")
//
//
//		print()
