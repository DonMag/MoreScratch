//
//  TableColTableViewController.swift
//  MoreScratch
//
//  Created by Don Mag on 4/18/22.
//

import UIKit
import CoreMIDI

class InvertedGradientLayer: CALayer {
	
	public var lineHeight: CGFloat = 0
	public var gradWidth: CGFloat = 0
	
	override func draw(in inContext: CGContext) {
		
		// fill all but the bottom "line height" with opaque color
		inContext.setFillColor(UIColor.gray.cgColor)
		var r = self.bounds
		r.size.height -= lineHeight
		inContext.fill(r)

		// can be any color, we're going from Opaque to Clear
		let colors = [UIColor.gray.cgColor, UIColor.gray.withAlphaComponent(0.0).cgColor]
		
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		
		let colorLocations: [CGFloat] = [0.0, 1.0]
		
		let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations)!
		
		// start the gradient "grad width" from right edge
		let startPoint = CGPoint(x: bounds.maxX - gradWidth, y: 0.5)
		// end the gradient at the right edge, but
		// probably want to leave the farthest-right 1 or 2 points
		//	completely transparent
		let endPoint = CGPoint(x: bounds.maxX - 2.0, y: 0.5)

		// gradient rect starts at the bottom of the opaque rect
		r.origin.y = r.size.height - 1
		// gradient rect height can extend below the bounds, becuase it will be clipped
		r.size.height = bounds.height
		inContext.addRect(r)
		inContext.clip()
		inContext.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: .drawsBeforeStartLocation)

	}
	
}

class CornerFadeLabel: UILabel {
	let ivgLayer = InvertedGradientLayer()
	override func layoutSubviews() {
		super.layoutSubviews()
		guard let f = self.font, let t = self.text else { return }
		// we only want to fade-out the last line if
		//	it would be clipped
		let constraintRect = CGSize(width: bounds.width, height: .greatestFiniteMagnitude)
		let boundingBox = t.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : f], context: nil)
		if boundingBox.height <= bounds.height {
			layer.mask = nil
			return
		}
		layer.mask = ivgLayer
		ivgLayer.lineHeight = f.lineHeight
		ivgLayer.gradWidth = 60.0
		ivgLayer.frame = bounds
		ivgLayer.setNeedsDisplay()
	}
}

class CornerGradLabel: UILabel {
	let ivgLayer = InvertedGradientLayer()
	override func layoutSubviews() {
		super.layoutSubviews()
		if ivgLayer.superlayer == nil {
			layer.addSublayer(ivgLayer)
		}
		guard let f = self.font else { return }
		ivgLayer.lineHeight = f.lineHeight
		ivgLayer.gradWidth = 60.0
		ivgLayer.frame = bounds
		ivgLayer.setNeedsDisplay()
	}
}

class DemoFadeVC: UIViewController {
	
	let wordWrapFadeLabel: CornerFadeLabel = {
		let v = CornerFadeLabel()
		v.numberOfLines = 1
		v.lineBreakMode = .byWordWrapping
		return v
	}()
	
	let charWrapFadeLabel: CornerFadeLabel = {
		let v = CornerFadeLabel()
		v.numberOfLines = 1
		v.lineBreakMode = .byCharWrapping
		return v
	}()
	
	let numLinesLabel: UILabel = {
		let v = UILabel()
		v.textAlignment = .center
		return v
	}()
	
	var numLines: Int = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .systemBackground
		
		let sampleText = "This is some example text that will wrap onto multiple lines and fade-out the bottom-right corner instead of truncating or clipping a last line."
		wordWrapFadeLabel.text = sampleText
		charWrapFadeLabel.text = sampleText

		let stack: UIStackView = {
			let v = UIStackView()
			v.axis = .vertical
			v.spacing = 8
			v.translatesAutoresizingMaskIntoConstraints = false
			return v
		}()
		
		let bStack: UIStackView = {
			let v = UIStackView()
			v.axis = .horizontal
			v.spacing = 8
			v.translatesAutoresizingMaskIntoConstraints = false
			return v
		}()

		let btnUP: UIButton = {
			let v = UIButton()
			let cfg = UIImage.SymbolConfiguration(pointSize: 28.0, weight: .bold, scale: .large)
			let img = UIImage(systemName: "chevron.up.circle.fill", withConfiguration: cfg)
			v.setImage(img, for: [])
			v.tintColor = .systemGreen
			v.widthAnchor.constraint(equalTo: v.heightAnchor).isActive = true
			v.addTarget(self, action: #selector(btnUpTapped), for: .touchUpInside)
			return v
		}()
		
		let btnDown: UIButton = {
			let v = UIButton()
			let cfg = UIImage.SymbolConfiguration(pointSize: 28.0, weight: .bold, scale: .large)
			let img = UIImage(systemName: "chevron.down.circle.fill", withConfiguration: cfg)
			v.setImage(img, for: [])
			v.tintColor = .systemGreen
			v.widthAnchor.constraint(equalTo: v.heightAnchor).isActive = true
			v.addTarget(self, action: #selector(btnDownTapped), for: .touchUpInside)
			return v
		}()

		bStack.addArrangedSubview(btnUP)
		bStack.addArrangedSubview(numLinesLabel)
		bStack.addArrangedSubview(btnDown)

		let v1 = UILabel()
		v1.text = "Word-wrapping"
		v1.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
		
		let v2 = UILabel()
		v2.text = "Character-wrapping"
		v2.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
		
		stack.addArrangedSubview(bStack)
		stack.addArrangedSubview(v1)
		stack.addArrangedSubview(wordWrapFadeLabel)
		stack.addArrangedSubview(v2)
		stack.addArrangedSubview(charWrapFadeLabel)

		stack.setCustomSpacing(20, after: bStack)
		stack.setCustomSpacing(20, after: wordWrapFadeLabel)

		view.addSubview(stack)

		// dashed border views so we can see the lable frames
		let wordBorderView = DashedView()
		let charBorderView = DashedView()
		wordBorderView.translatesAutoresizingMaskIntoConstraints = false
		charBorderView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(wordBorderView)
		view.addSubview(charBorderView)
		
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			
			stack.topAnchor.constraint(equalTo: g.topAnchor, constant: 40.0),
			stack.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 60.0),
			stack.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -60.0),
			
			wordBorderView.topAnchor.constraint(equalTo: wordWrapFadeLabel.topAnchor, constant: 0.0),
			wordBorderView.leadingAnchor.constraint(equalTo: wordWrapFadeLabel.leadingAnchor, constant: 0.0),
			wordBorderView.trailingAnchor.constraint(equalTo: wordWrapFadeLabel.trailingAnchor, constant: 0.0),
			wordBorderView.bottomAnchor.constraint(equalTo: wordWrapFadeLabel.bottomAnchor, constant: 0.0),

			charBorderView.topAnchor.constraint(equalTo: charWrapFadeLabel.topAnchor, constant: 0.0),
			charBorderView.leadingAnchor.constraint(equalTo: charWrapFadeLabel.leadingAnchor, constant: 0.0),
			charBorderView.trailingAnchor.constraint(equalTo: charWrapFadeLabel.trailingAnchor, constant: 0.0),
			charBorderView.bottomAnchor.constraint(equalTo: charWrapFadeLabel.bottomAnchor, constant: 0.0),
			
		])
		
		// set initial number of lines
		btnUpTapped()
		
		let demoFadeLabel: CornerGradLabel = {
			let v = CornerGradLabel()
			v.numberOfLines = 1
			v.lineBreakMode = .byWordWrapping
			v.text = "Test"
			return v
		}()
		stack.addArrangedSubview(demoFadeLabel)
		demoFadeLabel.heightAnchor.constraint(equalToConstant: 61.0).isActive = true

	}
	@objc func btnUpTapped() {
		numLines += 1
		numLinesLabel.text = "Num Lines: \(numLines)"
		wordWrapFadeLabel.numberOfLines = numLines
		charWrapFadeLabel.numberOfLines = numLines
	}
	@objc func btnDownTapped() {
		if numLines == 1 { return }
		numLines -= 1
		numLinesLabel.text = "Num Lines: \(numLines)"
		wordWrapFadeLabel.numberOfLines = numLines
		charWrapFadeLabel.numberOfLines = numLines
	}
}

class MyFakeLabel: UIView {
	
	public var text: String = "" {
		didSet {
			setNeedsLayout()
		}
	}
	public var textColor: UIColor = .black {
		didSet {
			myTextLayer.foregroundColor = textColor.cgColor
		}
	}
	public var font: UIFont = .systemFont(ofSize: 17.0) {
		didSet {
			myTextLayer.font = font
			myTextLayer.fontSize = font.pointSize
			setNeedsLayout()
		}
	}
	
	private let myTextLayer = CATextLayer()

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	private func commonInit() {
		layer.addSublayer(myTextLayer)
		myTextLayer.contentsScale = UIScreen.main.scale
		myTextLayer.isWrapped = true
		myTextLayer.string = text
		myTextLayer.foregroundColor = textColor.cgColor
	}
	
	override func layoutSubviews() {
		myTextLayer.string = text
		myTextLayer.frame = bounds
	}
}

class TextViewLabel: UITextView {
	
	override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)
		commonInit()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	
	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		commonInit()
	}
	func commonInit() -> Void {
		isScrollEnabled = false
		isEditable = false
		isSelectable = false
		textContainerInset = UIEdgeInsets.zero
		textContainer.lineFragmentPadding = 0
	}
	
}

class TextViewLabelTestVC: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		let stack: UIStackView = {
			let v = UIStackView()
			v.axis = .vertical
			v.spacing = 8
			v.translatesAutoresizingMaskIntoConstraints = false
			return v
		}()

		let v1 = UILabel()
		let v2 = TextViewLabel()
		let v3 = UILabel()
		let v4 = TextViewLabel()

		[v1, v2, v3, v4].forEach { v in
			let lb = UILabel()
			lb.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
			if let v = v as? UILabel {
				lb.text = "UILabel"
				v.backgroundColor = .cyan
				v.font = .systemFont(ofSize: 16.0)
				v.numberOfLines = 0
			}
			if let v = v as? TextViewLabel {
				lb.text = "Text View Label"
				v.backgroundColor = .green
				v.font = .systemFont(ofSize: 16.0)
			}
			stack.addArrangedSubview(lb)
			stack.addArrangedSubview(v)
		}
		
		stack.setCustomSpacing(32.0, after: v2)
		
		view.addSubview(stack)
		
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
		
			stack.topAnchor.constraint(equalTo: g.topAnchor, constant: 40.0),
			stack.widthAnchor.constraint(equalToConstant: 255.0),
			stack.centerXAnchor.constraint(equalTo: g.centerXAnchor),

		])
		
		var vs: String = "Does this string result in an orphan?"

		v1.text = vs
		v2.text = vs
		
		vs = "This string should wrap onto four lines of text. Compare the word wrap to see if TextKit allows the orphan."

		v3.text = vs
		v4.text = vs
	}
}

class FadeVC: UIViewController {
	
	let wordWrapFadeLabel: CornerFadeLabel = {
		let v = CornerFadeLabel()
		v.numberOfLines = 1
		v.lineBreakMode = .byWordWrapping
		return v
	}()
	
	let charWrapFadeLabel: CornerFadeLabel = {
		let v = CornerFadeLabel()
		v.numberOfLines = 1
		v.lineBreakMode = .byCharWrapping
		return v
	}()
	
	let normalLabel: UILabel = {
		let v = UILabel()
		v.numberOfLines = 1
		return v
	}()
	
	let numLinesLabel: UILabel = {
		let v = UILabel()
		v.textAlignment = .center
		return v
	}()
	
	var numLines: Int = 0
	
	
	@IBOutlet var vv1: UILabel!
	@IBOutlet var vv2: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	
//		vv1.lineBreakStrategy = .pushOut
//		vv2.lineBreakStrategy = .standard
		guard let fnt = vv1.font else { return }
		var vs = "A label can contain an arbitrary amount and another couple of words"
		//vs = "amount and another couple of words"

		vv1.text = vs
		vv2.text = vs
		vv2.lineBreakStrategy = .pushOut
		
//		let style = NSMutableParagraphStyle()
//		style.lineBreakStrategy = .pushOut
//
//		let ns1 = NSAttributedString(string: vs, attributes: [.paragraphStyle : style])
//		vv1.attributedText = ns1
//
//		style.lineBreakStrategy = .standard
//		let ns2 = NSAttributedString(string: vs, attributes: [.paragraphStyle : style])
//
//		vv2.attributedText = ns2

		view.backgroundColor = .systemBackground
		
		return()
		
		let sampleText = "This is some example text that will wrap onto multiple lines and fade-out the bottom-right corner instead of truncating or clipping a last line."
		wordWrapFadeLabel.text = sampleText
		charWrapFadeLabel.text = sampleText
		normalLabel.text = sampleText
		
		let stack: UIStackView = {
			let v = UIStackView()
			v.axis = .vertical
			v.spacing = 8
			v.translatesAutoresizingMaskIntoConstraints = false
			return v
		}()
		
		let bStack: UIStackView = {
			let v = UIStackView()
			v.axis = .horizontal
			v.spacing = 8
			v.translatesAutoresizingMaskIntoConstraints = false
			return v
		}()
		
		let btnUP: UIButton = {
			let v = UIButton()
			let cfg = UIImage.SymbolConfiguration(pointSize: 28.0, weight: .bold, scale: .large)
			let img = UIImage(systemName: "chevron.up.circle.fill", withConfiguration: cfg)
			v.setImage(img, for: [])
			v.tintColor = .systemGreen
			v.widthAnchor.constraint(equalTo: v.heightAnchor).isActive = true
			v.addTarget(self, action: #selector(btnUpTapped), for: .touchUpInside)
			return v
		}()
		
		let btnDown: UIButton = {
			let v = UIButton()
			let cfg = UIImage.SymbolConfiguration(pointSize: 28.0, weight: .bold, scale: .large)
			let img = UIImage(systemName: "chevron.down.circle.fill", withConfiguration: cfg)
			v.setImage(img, for: [])
			v.tintColor = .systemGreen
			v.widthAnchor.constraint(equalTo: v.heightAnchor).isActive = true
			v.addTarget(self, action: #selector(btnDownTapped), for: .touchUpInside)
			return v
		}()
		
		bStack.addArrangedSubview(btnUP)
		bStack.addArrangedSubview(numLinesLabel)
		bStack.addArrangedSubview(btnDown)
		
		let v1 = UILabel()
		v1.text = "Word-wrapping"
		v1.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
		
		let v2 = UILabel()
		v2.text = "Character-wrapping"
		v2.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
		
		let v3 = UILabel()
		v3.text = "Normal Label (Truncate Tail)"
		v3.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
		
		stack.addArrangedSubview(bStack)
		stack.addArrangedSubview(v1)
		stack.addArrangedSubview(wordWrapFadeLabel)
		stack.addArrangedSubview(v2)
		stack.addArrangedSubview(charWrapFadeLabel)
		stack.addArrangedSubview(v3)
		stack.addArrangedSubview(normalLabel)

		stack.setCustomSpacing(20, after: bStack)
		stack.setCustomSpacing(20, after: wordWrapFadeLabel)
		stack.setCustomSpacing(20, after: charWrapFadeLabel)

		view.addSubview(stack)
		
		// dashed border views so we can see the lable frames
		let wordBorderView = DashedView()
		let charBorderView = DashedView()
		let normalBorderView = DashedView()
		wordBorderView.translatesAutoresizingMaskIntoConstraints = false
		charBorderView.translatesAutoresizingMaskIntoConstraints = false
		normalBorderView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(wordBorderView)
		view.addSubview(charBorderView)
		view.addSubview(normalBorderView)

		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			
			stack.topAnchor.constraint(equalTo: g.topAnchor, constant: 40.0),
			stack.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 60.0),
			stack.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -60.0),
			
			wordBorderView.topAnchor.constraint(equalTo: wordWrapFadeLabel.topAnchor, constant: 0.0),
			wordBorderView.leadingAnchor.constraint(equalTo: wordWrapFadeLabel.leadingAnchor, constant: 0.0),
			wordBorderView.trailingAnchor.constraint(equalTo: wordWrapFadeLabel.trailingAnchor, constant: 0.0),
			wordBorderView.bottomAnchor.constraint(equalTo: wordWrapFadeLabel.bottomAnchor, constant: 0.0),
			
			charBorderView.topAnchor.constraint(equalTo: charWrapFadeLabel.topAnchor, constant: 0.0),
			charBorderView.leadingAnchor.constraint(equalTo: charWrapFadeLabel.leadingAnchor, constant: 0.0),
			charBorderView.trailingAnchor.constraint(equalTo: charWrapFadeLabel.trailingAnchor, constant: 0.0),
			charBorderView.bottomAnchor.constraint(equalTo: charWrapFadeLabel.bottomAnchor, constant: 0.0),
			
			normalBorderView.topAnchor.constraint(equalTo: normalLabel.topAnchor, constant: 0.0),
			normalBorderView.leadingAnchor.constraint(equalTo: normalLabel.leadingAnchor, constant: 0.0),
			normalBorderView.trailingAnchor.constraint(equalTo: normalLabel.trailingAnchor, constant: 0.0),
			normalBorderView.bottomAnchor.constraint(equalTo: normalLabel.bottomAnchor, constant: 0.0),
			
		])
		
		// set initial number of lines to 1
		btnUpTapped()
		
	}
	@objc func btnUpTapped() {
		numLines += 1
		numLinesLabel.text = "Num Lines: \(numLines)"
		wordWrapFadeLabel.numberOfLines = numLines
		charWrapFadeLabel.numberOfLines = numLines
		normalLabel.numberOfLines = numLines
	}
	@objc func btnDownTapped() {
		if numLines == 1 { return }
		numLines -= 1
		numLinesLabel.text = "Num Lines: \(numLines)"
		wordWrapFadeLabel.numberOfLines = numLines
		charWrapFadeLabel.numberOfLines = numLines
		normalLabel.numberOfLines = numLines
	}
}

class DashedView: UIView {
	// line color
	public var color: UIColor = .red {
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
		dashLayer.lineWidth = 1
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		var bez = UIBezierPath()
		bez = UIBezierPath(rect: bounds)
		dashLayer.lineDashPattern = [4, 4]
		dashLayer.path = bez.cgPath
	}
}


// original coll in table
/*
struct SomeDataStruct {
	var color: UIColor = .white
	var num: Int = 0
	var offsetX: CGFloat = 0
}
class TableColTableViewController: UITableViewController {

	var myData: [SomeDataStruct] = []
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let colors: [UIColor] = [
			.systemRed, .systemGreen, .systemBlue, .cyan, .magenta, .yellow,
			.red, .green, .blue, .orange, .brown, .purple,
		]
		let nums: [Int] = [
			12, 15, 8, 21, 17, 14,
			16, 10, 5, 13, 20, 19,
		]
		for (c, n) in zip(colors, nums) {
			let d = SomeDataStruct(color: c, num: n)
			myData.append(d)
		}
		
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return myData.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "someTableCell", for: indexPath) as! SomeTableCell
		cell.rowTitleLabel.text = "Row \(indexPath.row)"
		cell.thisData = myData[indexPath.row]
		
		cell.didSelectClosure = { [weak self] c in
			guard let self = self,
				  let idx = tableView.indexPath(for: c)
			else { return }
			tableView.selectRow(at: idx, animated: true, scrollPosition: .none)
			self.myTableView(tableView, didSelectRowAt: idx)
		}
		
		cell.didScrollClosure = { [weak self] c, x in
			guard let self = self,
				  let idx = tableView.indexPath(for: c)
			else { return }
			self.myData[idx.row].offsetX = x
		}
		
        return cell
    }
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print("tableView didSelectRowAt:", indexPath)
		myTableView(tableView, didSelectRowAt: indexPath)
	}
	func myTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print("My didSelectRowAt:", indexPath)
	}
}
class SomeTableCell: UITableViewCell {
	
	public var didSelectClosure: ((UITableViewCell) ->())?
	public var didScrollClosure: ((UITableViewCell, CGFloat) ->())?

	@IBOutlet var rowTitleLabel: UILabel!
	@IBOutlet var collectionView: UICollectionView!
	var thisData: SomeDataStruct = SomeDataStruct() {
		didSet {
			collectionView.reloadData()
			collectionView.contentOffset.x = thisData.offsetX
		}
	}
}
extension SomeTableCell: UICollectionViewDataSource, UICollectionViewDelegate {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return thisData.num
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "someCollectionCell", for: indexPath) as! SomeCollectionCell
		cell.label.text = "Cell \(indexPath.item)"
		cell.contentView.backgroundColor = thisData.color
		return cell
	}
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("collectionView didSelecteItemAt:", indexPath)
		print("Calling closure...")
		didSelectClosure?(self)
	}
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		didScrollClosure?(self, scrollView.contentOffset.x)
	}
}
class SomeCollectionCell: UICollectionViewCell {
	@IBOutlet var label: UILabel!
}
*/

// original code coll in table
/*
struct SomeDataStruct {
	var color: UIColor = .white
	var strings: [String] = []
}
class TableColTableViewController: UITableViewController {
	
	var myData: [SomeDataStruct] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let sample: [String] = [
			"Label - A label can contain an arbitrary amount of text, but UILabel may shrink, wrap, or truncate the text, depending on the size of the bounding rectangle and properties you set. You can control the font, text color, alignment, highlighting, and shadowing of the text in the label.",
			"Button - You can set the title, image, and other appearance properties of a button. In addition, you can specify a different appearance for each button state.",
			"Segmented Control - The segments can represent single or multiple selection, or a list of commands. Each segment can display text or an image, but not both.",
			"Text Field - Displays a rounded rectangle that can contain editable text. When a user taps a text field, a keyboard appears; when a user taps Return in the keyboard, the keyboard disappears and the text field can handle the input in an application-specific way. UITextField supports overlay views to display additional information, such as a bookmarks icon. UITextField also provides a clear text control a user taps to erase the contents of the text field.",
			"Slider - UISlider displays a horizontal bar, called a track, that represents a range of values. The current value is shown by the position of an indicator, or thumb. A user selects a value by sliding the thumb along the track. You can customize the appearance of both the track and the thumb.",
			"Switch - Displays an element that shows the user the boolean state of a given value. By tapping the control, the state can be toggled.",
			"Activity Indicator View - Used to indicate processing for a task with unknown completion percentage.",
			"Progress View - Shows that a lengthy task is underway, and indicates the percentage of the task that has been completed.",
			"Page Control - UIPageControl indicates the number of open pages in an application by displaying a dot for each open page. The dot that corresponds to the currently viewed page is highlighted. UIPageControl supports navigation by sending the delegate an event when a user taps to the right or to the left of the currently highlighted dot.",
			"Stepper - Often combined with a label or text field to show the value being incremented.",
			"Horizontal Stack View - An UIStackView creates and manages the constraints necessary to create horizontal or vertical stacks of views. It will dynamically add and remove its constraints to react to views being removed or added to its stack. With customization it can also react and influence the layout around it.",
			"Vertical Stack View - An UIStackView creates and manages the constraints necessary to create horizontal or vertical stacks of views. It will dynamically add and remove its constraints to react to views being removed or added to its stack. With customization it can also react and influence the layout around it.",
			"Table View - Coordinates with a data source and delegate to display a scrollable list of rows. Each row in a table view is a UITableViewCell object. The rows can be grouped into sections, and the sections can optionally have headers and footers. The user can edit a table by inserting, deleting, and reordering table cells.",
			"Table View Cell - Defines the attributes and behavior of cells in a table view. You can set a table cell's selected-state appearance, support editing functionality, display accessory views (such as a switch control), and specify background appearance and content indentation.",
			"Image View - Shows an image, or series of images as an animation.",
			"Collection View - Coordinates with a data source and delegate to display a scrollable collection of cells. Each cell in a collection view is a UICollectionViewCell object. Collection views support flow layout as well a custom layouts, and cells can be grouped into sections, and the sections and cells can optionally have supplementary views.",
			"Collection View Cell - A single view representing one cell in a collection view. Populate it with subviews, like labels and image views, to provide appearance.",
			"Collection View Reusable View - Defines the attributes and behavior of reusable views in a collection view, such as a section header or footer.",
			"Text View - When a user taps a text view, a keyboard appears; when a user taps Return in the keyboard, the keyboard disappears and the text view can handle the input in an application-specific way. You can specify attributes, such as font, color, and alignment, that apply to all text in a text view.",
			"Scroll View - UIScrollView provides a mechanism to display content that is larger than the size of the application’s window and enables users to scroll within that content by making swiping gestures.",
			"Date Picker - Provides an object that uses multiple rotating wheels to allow users to select dates and times. Examples of a date picker are the Timer and Alarm (Set Alarm) panes of the Clock application. You may also use a UIDatePicker as a countdown timer.",
			"Picker View - Provides a potentially multidimensional user-interface element consisting of rows and components. A component is a wheel, which has a series of items (rows) at indexed locations on the wheel. Each row on a component has content, which is either a string or a view object such as a label or an image.",
		]
		let colors: [UIColor] = [
			.systemRed, .systemGreen, .systemBlue, .cyan, .magenta, .yellow,
			.red, .green, .blue, .orange, .brown, .purple,
		]
		for (idx, s) in sample.enumerated() {
			let c = colors[idx % colors.count]
			let a1: [String] = s.components(separatedBy: " - ")
			let a: [String] = [a1[0] + ":"] + a1[1].components(separatedBy: " ")
			let d = SomeDataStruct(color: c, strings: a)
			myData.append(d)
		}

		tableView.register(SomeTableCell.self, forCellReuseIdentifier: "c")
		tableView.dataSource = self
		tableView.delegate = self
	}
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return myData.count
	}
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "c", for: indexPath) as! SomeTableCell
		cell.rowTitleLabel.text = "Row \(indexPath.row)"
		cell.thisData = myData[indexPath.row]
		
		cell.didSelectClosure = { [weak self] c in
			guard let self = self,
				  let idx = tableView.indexPath(for: c)
			else { return }
			tableView.selectRow(at: idx, animated: true, scrollPosition: .none)
			self.myTableView(tableView, didSelectRowAt: idx)
		}
		
		return cell
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print("tableView didSelectRowAt:", indexPath)
		myTableView(tableView, didSelectRowAt: indexPath)
	}
	func myTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print("My didSelectRowAt:", indexPath)
	}
}
class SomeTableCell: UITableViewCell {
	
	public var didSelectClosure: ((UITableViewCell) ->())?
	
	var rowTitleLabel: UILabel!
	var collectionView: UICollectionView!
	
	var thisData: SomeDataStruct = SomeDataStruct() {
		didSet {
			collectionView.reloadData()
		}
	}
	override func prepareForReuse() {
		collectionView.contentOffset.x = 0
	}
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
		fl.estimatedItemSize = CGSize(width: 120, height: 50)
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: fl)
		collectionView.backgroundColor = .systemYellow
		collectionView.register(SomeCollectionCell.self, forCellWithReuseIdentifier: "c")
		collectionView.dataSource = self
		collectionView.delegate = self
		rowTitleLabel = UILabel()
		rowTitleLabel.translatesAutoresizingMaskIntoConstraints = false
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(rowTitleLabel)
		contentView.addSubview(collectionView)
		let g = contentView.layoutMarginsGuide
		NSLayoutConstraint.activate([
			rowTitleLabel.topAnchor.constraint(equalTo: g.topAnchor),
			rowTitleLabel.leadingAnchor.constraint(equalTo: g.leadingAnchor),
			rowTitleLabel.trailingAnchor.constraint(equalTo: g.trailingAnchor),
			
			collectionView.topAnchor.constraint(equalTo: rowTitleLabel.bottomAnchor, constant: 8.0),
			collectionView.leadingAnchor.constraint(equalTo: g.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: g.trailingAnchor),
			collectionView.bottomAnchor.constraint(equalTo: g.bottomAnchor),
			
			collectionView.heightAnchor.constraint(equalToConstant: 70.0),
		])
	}
}
extension SomeTableCell: UICollectionViewDataSource, UICollectionViewDelegate {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return thisData.strings.count
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "c", for: indexPath) as! SomeCollectionCell
		cell.label.text = thisData.strings[indexPath.item]
		cell.contentView.backgroundColor = thisData.color
		return cell
	}
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("collectionView didSelecteItemAt:", indexPath)
		print("Calling closure...")
		didSelectClosure?(self)
	}
}
class SomeCollectionCell: UICollectionViewCell {
	
	var label: UILabel!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {
		label = UILabel()
		label.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
		label.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(label)
		contentView.layoutMargins = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
		let g = contentView.layoutMarginsGuide
		NSLayoutConstraint.activate([
			label.topAnchor.constraint(equalTo: g.topAnchor),
			label.leadingAnchor.constraint(equalTo: g.leadingAnchor),
			label.trailingAnchor.constraint(equalTo: g.trailingAnchor),
			label.bottomAnchor.constraint(equalTo: g.bottomAnchor),
		])
	}
}
*/

struct DonMagSampleDataStruct {
	var color: UIColor = .white
	var strings: [String] = []
}
class DonMagSampleTableViewController: UITableViewController {
	
	var myData: [DonMagSampleDataStruct] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
//		let allFontNames = UIFont.familyNames
//			.flatMap { UIFont.fontNames(forFamilyName: $0) }

		let sample: [String] = [
			"Label - A label can contain an arbitrary amount of text, but UILabel may shrink, wrap, or truncate the text, depending on the size of the bounding rectangle and properties you set. You can control the font, text color, alignment, highlighting, and shadowing of the text in the label.",
			"Button - You can set the title, image, and other appearance properties of a button. In addition, you can specify a different appearance for each button state.",
//			"Segmented Control - The segments can represent single or multiple selection, or a list of commands. Each segment can display text or an image, but not both.",
//			"Text Field - Displays a rounded rectangle that can contain editable text. When a user taps a text field, a keyboard appears; when a user taps Return in the keyboard, the keyboard disappears and the text field can handle the input in an application-specific way. UITextField supports overlay views to display additional information, such as a bookmarks icon. UITextField also provides a clear text control a user taps to erase the contents of the text field.",
//			"Slider - UISlider displays a horizontal bar, called a track, that represents a range of values. The current value is shown by the position of an indicator, or thumb. A user selects a value by sliding the thumb along the track. You can customize the appearance of both the track and the thumb.",
//			"Switch - Displays an element that shows the user the boolean state of a given value. By tapping the control, the state can be toggled.",
//			"Activity Indicator View - Used to indicate processing for a task with unknown completion percentage.",
//			"Progress View - Shows that a lengthy task is underway, and indicates the percentage of the task that has been completed.",
//			"Page Control - UIPageControl indicates the number of open pages in an application by displaying a dot for each open page. The dot that corresponds to the currently viewed page is highlighted. UIPageControl supports navigation by sending the delegate an event when a user taps to the right or to the left of the currently highlighted dot.",
//			"Stepper - Often combined with a label or text field to show the value being incremented.",
//			"Horizontal Stack View - An UIStackView creates and manages the constraints necessary to create horizontal or vertical stacks of views. It will dynamically add and remove its constraints to react to views being removed or added to its stack. With customization it can also react and influence the layout around it.",
//			"Vertical Stack View - An UIStackView creates and manages the constraints necessary to create horizontal or vertical stacks of views. It will dynamically add and remove its constraints to react to views being removed or added to its stack. With customization it can also react and influence the layout around it.",
//			"Table View - Coordinates with a data source and delegate to display a scrollable list of rows. Each row in a table view is a UITableViewCell object. The rows can be grouped into sections, and the sections can optionally have headers and footers. The user can edit a table by inserting, deleting, and reordering table cells.",
//			"Table View Cell - Defines the attributes and behavior of cells in a table view. You can set a table cell's selected-state appearance, support editing functionality, display accessory views (such as a switch control), and specify background appearance and content indentation.",
//			"Image View - Shows an image, or series of images as an animation.",
//			"Collection View - Coordinates with a data source and delegate to display a scrollable collection of cells. Each cell in a collection view is a UICollectionViewCell object. Collection views support flow layout as well a custom layouts, and cells can be grouped into sections, and the sections and cells can optionally have supplementary views.",
//			"Collection View Cell - A single view representing one cell in a collection view. Populate it with subviews, like labels and image views, to provide appearance.",
//			"Collection View Reusable View - Defines the attributes and behavior of reusable views in a collection view, such as a section header or footer.",
//			"Text View - When a user taps a text view, a keyboard appears; when a user taps Return in the keyboard, the keyboard disappears and the text view can handle the input in an application-specific way. You can specify attributes, such as font, color, and alignment, that apply to all text in a text view.",
//			"Scroll View - UIScrollView provides a mechanism to display content that is larger than the size of the application’s window and enables users to scroll within that content by making swiping gestures.",
//			"Date Picker - Provides an object that uses multiple rotating wheels to allow users to select dates and times. Examples of a date picker are the Timer and Alarm (Set Alarm) panes of the Clock application. You may also use a UIDatePicker as a countdown timer.",
//			"Picker View - Provides a potentially multidimensional user-interface element consisting of rows and components. A component is a wheel, which has a series of items (rows) at indexed locations on the wheel. Each row on a component has content, which is either a string or a view object such as a label or an image.",
		]
		let colors: [UIColor] = [
			.systemRed, .systemGreen, .systemBlue, .cyan, .magenta, .yellow,
			.red, .green, .blue, .orange, .brown, .purple,
		]
		for (idx, s) in sample.enumerated() {
			let c = colors[idx % colors.count]
			let a1: [String] = s.components(separatedBy: " - ")
			let a: [String] = [a1[0] + ":"] + a1[1].components(separatedBy: " ")
			let d = DonMagSampleDataStruct(color: c, strings: a)
			myData.append(d)
		}
		
		tableView.register(DonMagSampleTableCell.self, forCellReuseIdentifier: "c")
		tableView.dataSource = self
		tableView.delegate = self
		
		let v = HideLastSepView()
		v.backgroundColor = .white
		tableView.tableFooterView = v
		v.frame.size.height = 0
	}
	var defaultSeparatorInsets: UIEdgeInsets = .zero
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
//		print("tv:", tableView.separatorInset)
//		defaultSeparatorInsets = tableView.separatorInset
//		if let c = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) {
//			if defaultSeparatorInsets.left != c.separatorInset.left {
//				defaultSeparatorInsets = c.separatorInset
//			}
//			print("d:", c.separatorInset)
//		}
	}
	override func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return myData.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "c", for: indexPath) as! DonMagSampleTableCell
		cell.rowTitleLabel.text = "Row \(indexPath.row)"
		cell.thisData = myData[indexPath.row]
		
//		print(cell.separatorInset)
//		cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//		if indexPath.row == myData.count - 1 {
//			cell.separatorInset = UIEdgeInsets(top: 0, left: .greatestFiniteMagnitude, bottom: 0, right: -1.0)
//		}
		
		cell.didSelectClosure = { [weak self] c in
			guard let self = self,
				  let idx = tableView.indexPath(for: c)
			else { return }
			tableView.selectRow(at: idx, animated: true, scrollPosition: .none)
			self.myTableView(tableView, didSelectRowAt: idx)
		}
		
		return cell
	}
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		myTableView(tableView, didSelectRowAt: indexPath)
	}
	func myTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let c = tableView.cellForRow(at: indexPath) {
			print("i:", c.separatorInset)
		}
		print("My tableView didSelectRowAt:", indexPath)
	}
}
class HideLastSepView: UIView {
	let lay = CALayer()
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {
		layer.addSublayer(lay)
		lay.backgroundColor = UIColor.white.cgColor
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		var r = bounds
		r.origin.y -= 2.0
		r.size.height = 4.0
		lay.frame = r
	}
}
class DonMagSampleTableCell: UITableViewCell {
	
	public var didSelectClosure: ((UITableViewCell) ->())?
	
	var rowTitleLabel: UILabel!
	var collectionView: UICollectionView!
	
	var thisData: DonMagSampleDataStruct = DonMagSampleDataStruct() {
		didSet {
			collectionView.reloadData()
		}
	}
	override func prepareForReuse() {
		collectionView.contentOffset.x = 0
	}
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
		fl.estimatedItemSize = CGSize(width: 120, height: 50)
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: fl)
		collectionView.backgroundColor = .systemYellow
		collectionView.register(DonMagSampleCollectionCell.self, forCellWithReuseIdentifier: "c")
		collectionView.dataSource = self
		collectionView.delegate = self
		rowTitleLabel = UILabel()
		rowTitleLabel.translatesAutoresizingMaskIntoConstraints = false
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(rowTitleLabel)
		contentView.addSubview(collectionView)
		let g = contentView.layoutMarginsGuide
		NSLayoutConstraint.activate([
			rowTitleLabel.topAnchor.constraint(equalTo: g.topAnchor),
			rowTitleLabel.leadingAnchor.constraint(equalTo: g.leadingAnchor),
			rowTitleLabel.trailingAnchor.constraint(equalTo: g.trailingAnchor),
			
			collectionView.topAnchor.constraint(equalTo: rowTitleLabel.bottomAnchor, constant: 8.0),
			collectionView.leadingAnchor.constraint(equalTo: g.leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: g.trailingAnchor),
			collectionView.bottomAnchor.constraint(equalTo: g.bottomAnchor),
			
			collectionView.heightAnchor.constraint(equalToConstant: 70.0),
		])
	}
}
extension DonMagSampleTableCell {
	open override func layoutSubviews() {
		super.layoutSubviews()
		return()
		print(#function)
		if separatorInset.left < 10000 {
			var si = separatorInset
			si.left = contentView.layoutMargins.left
			separatorInset = si
			print("l:", separatorInset, contentView.layoutMargins)
		}
	}
}
extension DonMagSampleTableCell: UICollectionViewDataSource, UICollectionViewDelegate {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return thisData.strings.count
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "c", for: indexPath) as! DonMagSampleCollectionCell
		cell.label.text = thisData.strings[indexPath.item]
		cell.contentView.backgroundColor = thisData.color
		return cell
	}
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("collectionView didSelecteItemAt:", indexPath)
		print("Calling closure...")
		didSelectClosure?(self)
	}
}
class DonMagSampleCollectionCell: UICollectionViewCell {
	
	var label: UILabel!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {
		label = UILabel()
		label.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
		label.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(label)
		contentView.layoutMargins = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
		let g = contentView.layoutMarginsGuide
		NSLayoutConstraint.activate([
			label.topAnchor.constraint(equalTo: g.topAnchor),
			label.leadingAnchor.constraint(equalTo: g.leadingAnchor),
			label.trailingAnchor.constraint(equalTo: g.trailingAnchor),
			label.bottomAnchor.constraint(equalTo: g.bottomAnchor),
		])
	}
}


class TmpVC: UIViewController {
	
	var soundView: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	
		soundView = UIView(frame: CGRect(x: 100, y: 150, width: 100, height: 100))
		soundView.backgroundColor = .red
		view.addSubview(soundView)
	}
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		animatedHideSoundView(toRight: false)
	}

	private func animatedHideSoundView(toRight: Bool) {
		print(#function)
		let screenWidth: CGFloat = 400
		let translationX = toRight ? 0.0 : -screenWidth
		UIView.animate(withDuration: 0.5) {
			self.soundView.transform = CGAffineTransform(translationX: translationX, y: 0.0)
		} completion: { isFinished in
			if isFinished {
				self.soundView.removeFromSuperview()
				//self.songPlayer.pause()
			}
		}
	}
}

class PushToDVC: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemRed
	}
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let vc = DelayedVC()
		self.navigationController?.pushViewController(vc, animated: true)
	}
}
class MyScrollView: UIScrollView, UIScrollViewDelegate {
	
//	func scrollViewDidScroll(_ scrollView: UIScrollView) {
//		NSLog("MSV", scrollView.contentOffset.y)
//		//print("MSV", scrollView.contentOffset.y)
//	}

	var st1: TimeInterval = 0
	var st2: TimeInterval = 0
	var st3: TimeInterval = 0

	var stVC: TimeInterval = 0

	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		st1 = CACurrentMediaTime()
		st2 = CACurrentMediaTime()
		NSLog("MSV End Drag")
	}
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		st2 = CACurrentMediaTime()
		NSLog("MSV End Decel - %0.4f", st2 - st1)
	}

	deinit {
		st3 = CACurrentMediaTime()
		NSLog("MSV Deinit - %0.4f", stVC - st3)
		//print("MSV Deinit")
	}
	
}
class DelayedVC: UIViewController, UIScrollViewDelegate {
	
	deinit {
		sv.stVC = CACurrentMediaTime()
		NSLog("VC Deinit")
		//print("Deinit")
	}

	var sv: MyScrollView!

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .systemBlue
		
		sv = MyScrollView()
		sv.backgroundColor = .yellow
		let v1 = UILabel()
		v1.text = "Top"
		let v2 = UILabel()
		v2.text = "Bottom"

		[sv, v1, v2].forEach { v in
			v.translatesAutoresizingMaskIntoConstraints = false
		}
		[v1, v2].forEach { v in
			sv.addSubview(v)
		}
		view.addSubview(sv)
		
		let g = view.safeAreaLayoutGuide
		let cg = sv.contentLayoutGuide
		NSLayoutConstraint.activate([
			
			sv.topAnchor.constraint(equalTo: g.topAnchor, constant: 120.0),
			sv.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
			sv.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -20.0),
			sv.bottomAnchor.constraint(equalTo: g.bottomAnchor, constant: -20.0),
			
			v1.topAnchor.constraint(equalTo: cg.topAnchor, constant: 8.0),
			v1.leadingAnchor.constraint(equalTo: cg.leadingAnchor, constant: 16.0),
			v1.trailingAnchor.constraint(equalTo: cg.trailingAnchor, constant: -16.0),

			v2.topAnchor.constraint(equalTo: v1.bottomAnchor, constant: 10000.0),
			v2.leadingAnchor.constraint(equalTo: cg.leadingAnchor, constant: 16.0),
			v2.trailingAnchor.constraint(equalTo: cg.trailingAnchor, constant: -16.0),
			v2.bottomAnchor.constraint(equalTo: cg.bottomAnchor, constant: -8.0),

		])
		
		//sv.delegate = sv
	}
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		print("tb")
		sv.stVC = CACurrentMediaTime()
		sv.removeFromSuperview()
		sv = nil
	}
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		print("vc", scrollView.contentOffset.y)
	}
}

class FiveViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let firstView = UIView()
		firstView.backgroundColor = .red
		let secondView = UIView()
		secondView.backgroundColor = .cyan
		let thirdView = UIView()
		thirdView.backgroundColor = .yellow
		let fourthView = UIView()
		fourthView.backgroundColor = .green
		let fifthView = UIView()
		fifthView.backgroundColor = .orange

		[firstView, secondView, thirdView, fourthView, fifthView].forEach { v in
			v.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview(v)
		}

		// we want the first view to TRY to be 88-points tall
		let firstHeight: NSLayoutConstraint = firstView.heightAnchor.constraint(equalToConstant: 88.0)
		// but with less-than-required priority so it can shrink
		firstHeight.priority = .required - 1
		
		
		NSLayoutConstraint.activate([
			
			firstView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			firstView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
			firstView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),

			// don't do this
			//firstView.heightAnchor.constraint(equalToConstant: 88),

			firstHeight,
			
			// we don't want the view heights to be Greater-Than 88-points
			firstView.heightAnchor.constraint(lessThanOrEqualToConstant: 88.0),

			secondView.topAnchor.constraint(equalTo: firstView.bottomAnchor),
			secondView.leftAnchor.constraint(equalTo: firstView.leftAnchor),
			secondView.rightAnchor.constraint(equalTo: firstView.rightAnchor),
			secondView.heightAnchor.constraint(equalTo: firstView.heightAnchor),
			
			thirdView.topAnchor.constraint(equalTo: secondView.bottomAnchor),
			thirdView.leftAnchor.constraint(equalTo: firstView.leftAnchor),
			thirdView.rightAnchor.constraint(equalTo: firstView.rightAnchor),
			thirdView.heightAnchor.constraint(equalTo: firstView.heightAnchor),
			
			fourthView.topAnchor.constraint(equalTo: thirdView.bottomAnchor),
			fourthView.leftAnchor.constraint(equalTo: firstView.leftAnchor),
			fourthView.rightAnchor.constraint(equalTo: firstView.rightAnchor),
			fourthView.heightAnchor.constraint(equalTo: firstView.heightAnchor),
			
			fifthView.topAnchor.constraint(equalTo: fourthView.bottomAnchor),
			fifthView.leftAnchor.constraint(equalTo: firstView.leftAnchor),
			fifthView.rightAnchor.constraint(equalTo: firstView.rightAnchor),
			fifthView.heightAnchor.constraint(equalTo: firstView.heightAnchor),
			
			// we want the fifth view Bottom to never extend below the safe area Bottom
			fifthView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
			
		])
	}
}
