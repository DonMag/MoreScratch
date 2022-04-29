//
//  StretchyHeaderViewController.swift
//  MoreScratch
//
//  Created by Don Mag on 4/12/22.
//

import UIKit

class StretchyHeaderViewController: UIViewController {
	
	let scrollView: UIScrollView = {
		let v = UIScrollView()
		v.contentInsetAdjustmentBehavior = .never
		return v
	}()
	let stretchyView: UIView = {
		let v = UIView()
		return v
	}()
	let contentView: UIView = {
		let v = UIView()
		v.backgroundColor = .systemYellow
		return v
	}()
	
	let stretchyViewHeight: CGFloat = 350.0
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// set to a greter-than-zero value if you want spacing between the "pages"
		let opts = [UIPageViewController.OptionsKey.interPageSpacing: 0.0]
		// instantiate the Page View controller
		let pgVC = SamplePageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: opts)
		// add it as a child controller
		self.addChild(pgVC)
		// safe unwrap
		guard let pgv = pgVC.view else { return }
		pgv.translatesAutoresizingMaskIntoConstraints = false
		// add the page controller view to stretchyView
		stretchyView.addSubview(pgv)
		pgVC.didMove(toParent: self)
		
		NSLayoutConstraint.activate([
			// constrain page view controller's view on all 4 sides
			pgv.topAnchor.constraint(equalTo: stretchyView.topAnchor),
			pgv.bottomAnchor.constraint(equalTo: stretchyView.bottomAnchor),
			pgv.centerXAnchor.constraint(equalTo: stretchyView.centerXAnchor),
			pgv.widthAnchor.constraint(equalTo: stretchyView.widthAnchor),
		])
		
		[scrollView, stretchyView, contentView].forEach { v in
			v.translatesAutoresizingMaskIntoConstraints = false
		}
		
		// add contentView and stretchyView to the scroll view
		[stretchyView, contentView].forEach { v in
			scrollView.addSubview(v)
		}
		
		// add scroll view to self.view
		view.addSubview(scrollView)
		
		let safeG = view.safeAreaLayoutGuide
		let contentG = scrollView.contentLayoutGuide
		let frameG = scrollView.frameLayoutGuide
		
		// keep stretchyView's Top "pinned" to the Top of the scroll view FRAME
		//	so its Height will "stretch" when scroll view is pulled down
		let stretchyTop = stretchyView.topAnchor.constraint(equalTo: frameG.topAnchor, constant: 0.0)
		// priority needs to be less-than-required so we can "push it up" out of view
		stretchyTop.priority = .defaultHigh
		
		NSLayoutConstraint.activate([
			
			// scroll view Top to view Top
			scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0),

			// scroll view Leading/Trailing/Bottom to safe area
			scrollView.leadingAnchor.constraint(equalTo: safeG.leadingAnchor, constant: 0.0),
			scrollView.trailingAnchor.constraint(equalTo: safeG.trailingAnchor, constant: 0.0),
			scrollView.bottomAnchor.constraint(equalTo: safeG.bottomAnchor, constant: 0.0),
			
			// constrain stretchy view Top to scroll view's FRAME
			stretchyTop,
			
			// stretchyView to Leading/Trailing of scroll view FRAME
			stretchyView.leadingAnchor.constraint(equalTo: frameG.leadingAnchor, constant: 0.0),
			stretchyView.trailingAnchor.constraint(equalTo: frameG.trailingAnchor, constant: 0.0),
			
			// stretchyView Height - greater-than-or-equal-to
			//	so it can "stretch" vertically
			stretchyView.heightAnchor.constraint(greaterThanOrEqualToConstant: stretchyViewHeight),
			
			// content view Leading/Trailing/Bottom to scroll view's CONTENT GUIDE
			contentView.leadingAnchor.constraint(equalTo: contentG.leadingAnchor, constant: 0.0),
			contentView.trailingAnchor.constraint(equalTo: contentG.trailingAnchor, constant: 0.0),
			contentView.bottomAnchor.constraint(equalTo: contentG.bottomAnchor, constant: 0.0),

			// content view Width to scroll view's FRAME
			contentView.widthAnchor.constraint(equalTo: frameG.widthAnchor, constant: 0.0),

			// content view Top to scroll view's CONTENT GUIDE
			//	plus Height of stretchyView
			contentView.topAnchor.constraint(equalTo: contentG.topAnchor, constant: stretchyViewHeight),

			// content view Top to stretchyView Bottom
			contentView.topAnchor.constraint(equalTo: stretchyView.bottomAnchor, constant: 0.0),
	
		])
		
		// add some content to the content view so we have something to scroll
		addSomeContent()
				
	}
	
	func addSomeContent() {
		let stack = UIStackView()
		stack.axis = .vertical
		stack.spacing = 32
		stack.backgroundColor = .gray
		stack.translatesAutoresizingMaskIntoConstraints = false
		for i in 1...20 {
			let v = UILabel()
			v.text = "Label \(i)"
			v.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
			v.heightAnchor.constraint(equalToConstant: 48.0).isActive = true
			stack.addArrangedSubview(v)
		}
		contentView.addSubview(stack)
		NSLayoutConstraint.activate([
			stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16.0),
			stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
			stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
			stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16.0),
		])
	}
	
}

class OnePageVC: UIViewController {
	
	var image: UIImage = UIImage() {
		didSet {
			imgView.image = image
		}
	}
	let imgView: UIImageView = {
		let v = UIImageView()
		v.backgroundColor = .systemBlue
		v.contentMode = .scaleAspectFill
		v.clipsToBounds = true
		v.translatesAutoresizingMaskIntoConstraints = false
		return v
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .systemBackground
		
		view.addSubview(imgView)
		NSLayoutConstraint.activate([
			// constrain image view to all 4 sides
			imgView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0),
			imgView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
			imgView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
			imgView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0),
		])
	}
}

class SamplePageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
	
	var controllers: [UIViewController] = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let imgNames: [String] = [
			"ex1", "ex2", "ex3",
		]
		for i in 0..<imgNames.count {
			let aViewController = OnePageVC()
			if let img = UIImage(named: imgNames[i]) {
				aViewController.image = img
			}
			self.controllers.append(aViewController)
		}

		self.dataSource = self
		self.delegate = self
		
		self.setViewControllers([controllers[0]], direction: .forward, animated: false)
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		if let index = controllers.firstIndex(of: viewController), index > 0 {
			return controllers[index - 1]
		}
		return nil
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		if let index = controllers.firstIndex(of: viewController), index < controllers.count - 1 {
			return controllers[index + 1]
		}
		return nil
	}

}

class SubPageVC: UIViewController {
	
	let bkgLayer = CALayer()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// set to a greter-than-zero value if you want spacing between the "pages"
		let opts = [UIPageViewController.OptionsKey.interPageSpacing: 0.0]
		// instantiate the Page View controller
		let pgVC = NumberPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: opts)
		// add it as a child controller
		self.addChild(pgVC)
		// safe unwrap
		guard let pgv = pgVC.view else { return }
		pgv.translatesAutoresizingMaskIntoConstraints = false
		// add the page controller view to stretchyView
		view.addSubview(pgv)
		pgVC.didMove(toParent: self)
		
		let g = view.safeAreaLayoutGuide
		
		NSLayoutConstraint.activate([
			// constrain page view controller's view on all 4 sides
			pgv.topAnchor.constraint(equalTo: g.topAnchor, constant: 40.0),
			pgv.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
			pgv.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -20.0),
			pgv.bottomAnchor.constraint(equalTo: g.bottomAnchor, constant: -40.0),
		])
		
		view.backgroundColor = .systemYellow
		
//		if let img = UIImage(named: "navBKG") {
//			bkgLayer.contents = img.cgImage
//		}
//		view.layer.addSublayer(bkgLayer)

	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		bkgLayer.frame = view.bounds
	}
	
	
}

class NumberPageVC: UIViewController {
	
	var myNum: Int = 0 {
		didSet {
			myLabel.text = "\(myNum)"
		}
	}
	let myLabel: UILabel = {
		let v = UILabel()
		v.font = .systemFont(ofSize: 120, weight: .light)
		v.textAlignment = .center
		v.layer.borderWidth = 2
		v.layer.borderColor = UIColor.red.cgColor
		v.translatesAutoresizingMaskIntoConstraints = false
		return v
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .clear
		
		view.addSubview(myLabel)
		
		let g = view.safeAreaLayoutGuide
		
		NSLayoutConstraint.activate([
			// constrain image view to all 4 sides
			myLabel.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			myLabel.centerYAnchor.constraint(equalTo: g.centerYAnchor),
			myLabel.widthAnchor.constraint(equalTo: g.widthAnchor, multiplier: 0.6),
			myLabel.heightAnchor.constraint(equalTo: g.heightAnchor, multiplier: 0.4),
		])
	}
}

class NumberPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
	
	var controllers: [UIViewController] = []
	let bkgLayer = CALayer()
	
	var theSV: UIScrollView!
	var cX: CGFloat = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//view.backgroundColor = .yellow
		
		for i in 1...6 {
			let aViewController = NumberPageVC()
			aViewController.myNum = i
			self.controllers.append(aViewController)
		}
		
		self.dataSource = self
		self.delegate = self
		
		self.setViewControllers([controllers[0]], direction: .forward, animated: false)
		
		if let img = UIImage(named: "bk1") {
			bkgLayer.contents = img.cgImage
		}
		view.layer.insertSublayer(bkgLayer, at: 0)
		
		if let scrollView = self.view.subviews.first(where: { $0 is UIScrollView }) as? UIScrollView {
			theSV = scrollView
			theSV.delegate = self
		}
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		bkgLayer.frame = view.bounds
	}

	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		if let index = controllers.firstIndex(of: viewController), index > 0 {
			return controllers[index - 1]
		}
		return nil
	}
	
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		if let index = controllers.firstIndex(of: viewController), index < controllers.count - 1 {
			return controllers[index + 1]
		}
		return nil
	}

	var nextPage: Int = 0
	func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
		if let fvc = pendingViewControllers.first as? NumberPageVC {
			print(fvc.myNum, theSV.contentOffset)
			cX = theSV.contentOffset.x
			nextPage = fvc.myNum
		} else {
			print("not a npVC?")
		}
	}
	
	public func presentationCount(for pageViewController: UIPageViewController) -> Int {
		return controllers.count
	}
	
	
	public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
		guard let firstViewController = viewControllers?.first,
			  let firstViewControllerIndex = controllers.firstIndex(of: firstViewController) else {
				  return 0
			  }
		
		return firstViewControllerIndex
	}

}

extension NumberPageViewController: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let x: CGFloat = scrollView.contentOffset.x
		let pct = (x - cX) / scrollView.frame.width
		
		print(pct)
	}
}

class RoundView: UIView {
	override func layoutSubviews() {
		super.layoutSubviews()
		// this assumes constraints keep
		//	self at a 1:1 ratio (square)
		layer.cornerRadius = bounds.height * 0.5
	}
}

class RoundDemoVC: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let colors: [UIColor] = [
			.systemRed, .systemGreen, .systemBlue
		]
		let widths: [CGFloat] = [
			200, 140, 140
		]
		let xPos: [CGFloat] = [
			20, 120, 180
		]
		let g = view.safeAreaLayoutGuide
		for i in 0..<colors.count {
			let v = RoundView()
			v.backgroundColor = colors[i]
			view.addSubview(v)
			v.translatesAutoresizingMaskIntoConstraints = false
			v.widthAnchor.constraint(equalToConstant: widths[i]).isActive = true
			// make it square
			v.heightAnchor.constraint(equalTo: v.widthAnchor).isActive = true
			v.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: xPos[i]).isActive = true
			v.centerYAnchor.constraint(equalTo: g.centerYAnchor).isActive = true
		}
		
	}
	
}

class OffersTableViewCell: UITableViewCell {
	
	@IBOutlet weak var offerTitle: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
}

class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
	@IBOutlet weak var tableView: UITableView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.tableView.dataSource = self
		self.tableView.delegate = self
		
		self.registerTableViewCells()
	}
	
	func tableView(_ tableView: UITableView,
				   numberOfRowsInSection section: Int) -> Int {
		return 10
	}
	
	func tableView(_ tableView: UITableView,
				   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: "OffersTableViewCell") as? OffersTableViewCell {
			return cell
		}
		
		return UITableViewCell()
	}
	
	private func registerTableViewCells() {
		let textFieldCell = UINib(nibName: "OffersTableViewCell",
								  bundle: nil)
		self.tableView.register(textFieldCell,
								forCellReuseIdentifier: "OffersTableViewCell")
	}
}

class CustomUIViewClass: UIView {
	
	@objc dynamic var subviewColor: UIColor? {
		get { return self.backgroundColor }
		set { self.backgroundColor = newValue }
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setup()
	}
	
	
	@objc dynamic func setup(){
		self.backgroundColor = .yellow
		self.frame.size.height = 250
		self.layer.borderWidth = 5
		self.backgroundColor = subviewColor
		
	}

	@objc dynamic func setBorderGradientColortoView1(firstColor: Int, secondColor: Int)  {
		
		let c1 = UIColor(red: CGFloat((firstColor >> 16) & 0xff) / 255.0, green: CGFloat((firstColor >> 8) & 0xff) / 255.0, blue: CGFloat(firstColor & 0xff) / 255.0, alpha: 1.0)
		let c2 = UIColor(red: CGFloat((secondColor >> 16) & 0xff) / 255.0, green: CGFloat((secondColor >> 8) & 0xff) / 255.0, blue: CGFloat(secondColor & 0xff) / 255.0, alpha: 1.0)

		let colorTop = c1.cgColor
		let colorBottom = c2.cgColor
		
		let gradientLayer = CAGradientLayer()
		gradientLayer.colors = [colorTop, colorBottom]
		gradientLayer.locations = [0.0, 1.0]
		gradientLayer.frame = self.bounds
		gradientLayer.cornerRadius = self.layer.cornerRadius
		self.layer.sublayers?.filter{ $0 is CAGradientLayer }.forEach{ $0.removeFromSuperlayer() }
		
		self.layer.insertSublayer(gradientLayer, at:0)
		
	}

//	@objc dynamic func setBorderGradientColortoView1(firstColor : String , secondColor : String)  {
//		let colorTop =  UIColor(hexString : firstColor )!.cgColor
//		let colorBottom = UIColor(hexString : secondColor)!.cgColor
//		let gradientLayer = CAGradientLayer()
//		gradientLayer.colors = [colorTop, colorBottom]
//		gradientLayer.locations = [0.0, 1.0]
//		gradientLayer.frame = self.bounds
//		gradientLayer.cornerRadius = self.layer.cornerRadius
//		self.layer.sublayers?.filter{ $0 is CAGradientLayer }.forEach{ $0.removeFromSuperlayer() }
//
//		self.layer.insertSublayer(gradientLayer, at:0)
//	}
}

class ASubPageVC: UIViewController {
	
	@IBOutlet var button: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		guard let c1 = UIColor(hexString: "#FF2222", alpha: 1.0),
			  let c2 = UIColor(hexString: "#7A1111", alpha: 1.0)
		else {
			view.backgroundColor = .green
			return
		}

		CustomUIViewClass.appearance().setBorderGradientColortoView1(firstColor: 0xff2222, secondColor: 0x7a1111)
		
		button.setImage(UIImage(systemName: "arrow.up.and.down.square"), for: .normal)
		button.setImage(UIImage(systemName: "arrow.up.bin"), for: .selected)
		button.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 50.0)
		
	}
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

		print(button.currentImage) // Optional(<UIImage:0x6000025a4090...
		print(button.imageView?.image) // Optional(<UIImage:0x6000025a4090...
		

	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		print(button.currentImage) // Optional(<UIImage:0x6000025a4090...
		print(button.imageView?.image) // Optional(<UIImage:0x6000025a4090...
		
		button.isSelected = true
//		if let v = button.imageView {
//			v.image = nil
//		}
//		if let img = UIImage(systemName: "arrow.up.bin") {
//			button.imageView?.image = img
//		}
		
	}
	
//	func IntFromHex(_ s: String) -> Int {
//
//		var hex = s
//
//		// Check for hash and remove the hash
//		if hex.hasPrefix("#") {
//			hex = String(hex[hex.index(after: hex.startIndex)...])
//		}
//
//		guard let hexVal = Int64(hex, radix: 16) else {
//			return 0
//		}
//
//		let r =
//		self.init(red:   CGFloat( (hex6 & 0xFF0000) >> 16 ) / 255.0,
//				  green: CGFloat( (hex6 & 0x00FF00) >> 8 ) / 255.0,
//				  blue:  CGFloat( (hex6 & 0x0000FF) >> 0 ) / 255.0, alpha: CGFloat(alpha))
//
//		switch hex.count {
//		case 3:
//			self.init(hex3: hexVal, alpha: alpha ?? 1.0)
//		case 4:
//			self.init(hex4: hexVal, alpha: alpha)
//		case 6:
//			self.init(hex6: hexVal, alpha: alpha ?? 1.0)
//		case 8:
//			self.init(hex8: hexVal, alpha: alpha)
//		default:
//			// Note:
//			// The swift 1.1 compiler is currently unable to destroy partially initialized classes in all cases,
//			// so it disallows formation of a situation where it would have to.  We consider this a bug to be fixed
//			// in future releases, not a feature. -- Apple Forum
//			self.init()
//			return nil
//		}
//
//	}
}
