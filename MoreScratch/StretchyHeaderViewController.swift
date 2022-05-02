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


enum AuthorType {
	case single, multiple
}

struct Book: Hashable {
	var title = ""
	var author = ""
	var pages = 0
	var year = 0
	var genre = ""
	var authType = AuthorType.single
	
	static var sections: [String] {
		return ["Fiction", "Non-Fiction"]
	}
	
	static var books: [String: [Book]] {
		return [
			"Fiction": [
				Book(title: "Peace Talks", author:"Jim Butcher", pages: 340, year: 2020),
				Book(title: "Battle Ground", author:"Jim Butcher", pages: 300, year: 2020),
				Book(title: "Neuromancer", author:"William Gibson", pages: 271, year: 1984),
				Book(title: "Snow Crash", author:"Neal Stephenson", pages: 480, year: 1992)
			],
			"Non-Fiction": [
				Book(title: "UIKit Apprentice", author:"Fahim Farook & Matthijs Hollemans", pages: 1128, year: 2020, authType: AuthorType.multiple),
				Book(title: "Swift Apprentice", author:"The Ray Wenderlich Tutorial Team", pages: 500, year: 2020, authType: AuthorType.multiple)
			]
		]
	}
	
	static func booksFor(section: Int) -> [Book] {
		let sec = Book.sections[section]
		if let arr = Book.books[sec] {
			return arr
		}
		return []
	}
}

class SimpleTableView: UIViewController, UITableViewDelegate, UITableViewDataSource {
	private var tableView: UITableView!
	private let reuseIdentifier = "BookCell"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// View title
		title = "Books - Table"
		// Add table view
		tableView = UITableView(frame: view.bounds, style: .insetGrouped)
		tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		view.addSubview(tableView)
		tableView.delegate = self
		tableView.dataSource = self
		// Register cell
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
	}
	
	// MARK: - Table View Data Source / Delegate
	func numberOfSections(in tableView: UITableView) -> Int {
		return Book.sections.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Book.booksFor(section: section).count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath)
		var content = cell.defaultContentConfiguration()
		let section = Book.sections[indexPath.section]
		if let arr = Book.books[section] {
			let book = arr[indexPath.row]
			//content.image = book.authType == .single ? UIImage(systemName: "person.fill") : UIImage(systemName: "person.2.fill")
			if let img = UIImage(named: "myTestIMG") {
				content.image = img
			}
			content.text = book.title
			content.secondaryText = book.author
		}
		cell.contentConfiguration = content
		return cell
	}
}

class MySimpleTableView: UIViewController, UITableViewDelegate, UITableViewDataSource {
	private var tableView: UITableView!
	private let reuseIdentifier = "myCell"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let img = UIImage(named: "swiftRed") {
			let szImg2 = img.resized(to: CGSize(width: 28, height: 28), withScale: 2)
			let szImg3 = img.resized(to: CGSize(width: 28, height: 28), withScale: 3)
			print()
		}
		
		
		// Add table view
		tableView = UITableView(frame: view.bounds, style: .plain)
		tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		view.addSubview(tableView)
		tableView.delegate = self
		tableView.dataSource = self
		// Register cell
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
	}
	
	// MARK: - Table View Data Source / Delegate
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 4
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath)
		var content = cell.defaultContentConfiguration()
		content.text = "Cell \(indexPath)"
		if indexPath.row % 2 == 1 {
			content.secondaryText = "Secondary"
		}
//		content.image = UIImage(systemName: "person")

		//content.image = UIImage(named: "myTestIMG")
		//content.image = UIImage(named: "80x80")
		//content.image = UIImage(named: "swiftRed")
		let v = UIListContentConfiguration.ImageProperties.standardDimension
		content.imageProperties.reservedLayoutSize = CGSize(width: v, height: v)
		
		if let img = UIImage(named: "swiftRed") {
			let szImg = img.resized(to: CGSize(width: 28, height: 28), withScale: UIScreen.main.scale)
			content.image = szImg
		}

		//		if let img = UIImage(named: "myTestIMG") {
//			content.image = img
//		}
		cell.contentConfiguration = content
		return cell
	}
}

extension UIImage {
	func xclearRect(_ r: CGRect) -> UIImage {
		let renderer = UIGraphicsImageRenderer(size: size)
		let image = renderer.image { (context) in
			// draw the full image
			draw(at: .zero)
			let pth = UIBezierPath(rect: r)
			context.cgContext.setFillColor(UIColor.clear.cgColor)
			context.cgContext.setBlendMode(.clear)
			// "fill" the rect with clear
			pth.fill()
		}
		return image
	}
	func resized(to sz: CGSize, withScale: CGFloat) -> UIImage {
		
		let format = UIGraphicsImageRendererFormat()
		format.scale = withScale
		
		let renderer = UIGraphicsImageRenderer(size: sz, format: format)

		let image = renderer.image { (context) in
			draw(in: CGRect(origin: .zero, size: sz))
		}
		return image
	}
}

extension UIView {
	func xscale(by scale: CGFloat) {
		self.contentScaleFactor = scale
		for subview in self.subviews {
			subview.scale(by: scale)
		}
	}
	
	func xgetImage(scale: CGFloat? = nil) -> UIImage {
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

class SuperViewA: UIView {
	
}
class SubViewA: SuperViewA {
	
	var sv: SuperViewA!
	
	override func layoutSubviews() {
		super.layoutSubviews()
		if let v = sv {
			v.frame = bounds.insetBy(dx: 20, dy: 20)
		}
	}
	override init(frame: CGRect) {
		super.init(frame: frame)

		if let v = Bundle.main.loadNibNamed(String(describing: SuperViewA.self), owner: nil)?.first as? SuperViewA {
			v.frame = CGRect(x: 20, y: 20, width: 120, height: 80)
			addSubview(v)
			sv = v
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
class LoadNibVC: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()

		let v = SubViewA()
		
		//if let v = Bundle.main.loadNibNamed(String(describing: SuperViewA.self), owner: nibName)?.first as? SuperViewA {
			v.frame = CGRect(x: 100, y: 200, width: 200, height: 100)
			v.backgroundColor = .green
			view.addSubview(v)
		//}
		
	}
}

class SlidingHeaderView: UIView {
	
	// simple view with two labels
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {
		
		backgroundColor = .systemBlue
		
		let v1 = UILabel()
		v1.translatesAutoresizingMaskIntoConstraints = false
		v1.text = "Label 1"
		v1.backgroundColor = .yellow
		addSubview(v1)

		let v2 = UILabel()
		v2.translatesAutoresizingMaskIntoConstraints = false
		v2.text = "Label 2"
		v2.backgroundColor = .yellow
		addSubview(v2)

		NSLayoutConstraint.activate([
			
			v1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.0),
			v1.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.0),
			v2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12.0),
			v2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.0),
			
			v1.topAnchor.constraint(equalTo: topAnchor, constant: 8.0),
			v2.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0),
			
			v2.topAnchor.constraint(equalTo: v1.bottomAnchor, constant: 4.0),
			
			v2.heightAnchor.constraint(equalTo: v1.heightAnchor),
			
		])
		
	}
	
}

class SlidingHeaderViewController: UIViewController {
	
	let scrollView: UIScrollView = {
		let v = UIScrollView()
		v.contentInsetAdjustmentBehavior = .never
		return v
	}()
	let slidingHeaderView: SlidingHeaderView = {
		let v = SlidingHeaderView()
		return v
	}()
	let contentView: UIView = {
		let v = UIView()
		v.backgroundColor = .systemYellow
		return v
	}()

	// Top constraint for the slidingHeaderView
	var slidingViewTopC: NSLayoutConstraint!

	// to track the scroll activity
	var curScrollY: CGFloat = 0

	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .systemBackground
		
		[scrollView, slidingHeaderView, contentView].forEach { v in
			v.translatesAutoresizingMaskIntoConstraints = false
		}
		
		// add contentView and slidingHeaderView to the scroll view
		[contentView, slidingHeaderView].forEach { v in
			scrollView.addSubview(v)
		}
		
		// add scroll view to self.view
		view.addSubview(scrollView)
		
		let safeG = view.safeAreaLayoutGuide
		let contentG = scrollView.contentLayoutGuide
		let frameG = scrollView.frameLayoutGuide
		
		// we're going to change slidingHeaderView's Top constraint relative to the Top of the scroll view FRAME
		slidingViewTopC = slidingHeaderView.topAnchor.constraint(equalTo: frameG.topAnchor, constant: 0.0)
		
		NSLayoutConstraint.activate([
			
			// scroll view Top to view Top
			scrollView.topAnchor.constraint(equalTo: safeG.topAnchor, constant: 0.0),
			
			// scroll view Leading/Trailing/Bottom to safe area
			scrollView.leadingAnchor.constraint(equalTo: safeG.leadingAnchor, constant: 0.0),
			scrollView.trailingAnchor.constraint(equalTo: safeG.trailingAnchor, constant: 0.0),
			scrollView.bottomAnchor.constraint(equalTo: safeG.bottomAnchor, constant: 0.0),
			
			// constrain slidingHeaderView Top to scroll view's FRAME
			slidingViewTopC,
			
			// slidingHeaderView to Leading/Trailing of scroll view FRAME
			slidingHeaderView.leadingAnchor.constraint(equalTo: frameG.leadingAnchor, constant: 0.0),
			slidingHeaderView.trailingAnchor.constraint(equalTo: frameG.trailingAnchor, constant: 0.0),
			
			// no Height or Bottom constraint for slidingHeaderView
			
			// content view Top/Leading/Trailing/Bottom to scroll view's CONTENT GUIDE
			contentView.topAnchor.constraint(equalTo: contentG.topAnchor, constant: 0.0),
			contentView.leadingAnchor.constraint(equalTo: contentG.leadingAnchor, constant: 0.0),
			contentView.trailingAnchor.constraint(equalTo: contentG.trailingAnchor, constant: 0.0),
			contentView.bottomAnchor.constraint(equalTo: contentG.bottomAnchor, constant: 0.0),
			
			// content view Width to scroll view's FRAME
			contentView.widthAnchor.constraint(equalTo: frameG.widthAnchor, constant: 0.0),
			
		])
		
		// add some content to the content view so we have something to scroll
		addSomeContent()
		
		// because we're going to track the scroll offset
		scrollView.delegate = self
		
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		if slidingHeaderView.frame.height == 0 {
			// get the size of the slidingHeaderView
			let sz = slidingHeaderView.systemLayoutSizeFitting(CGSize(width: scrollView.frame.width, height: .greatestFiniteMagnitude), withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
			// use its Height for the scroll view's Top contentInset
			scrollView.contentInset = UIEdgeInsets(top: sz.height, left: 0, bottom: 0, right: 0)
		}
	}
	
	func addSomeContent() {
		// create a vertical stack view with a bunch of labels
		//	and add it to our content view so we have something to scroll
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

extension SlidingHeaderViewController: UIScrollViewDelegate {
	
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		curScrollY = scrollView.contentOffset.y
	}
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let diffY = scrollView.contentOffset.y - curScrollY
		var newY: CGFloat = slidingViewTopC.constant - diffY
		if diffY < 0 {
			// we're scrolling DOWN
			newY = min(newY, 0.0)
		} else {
			// we're scrolling UP
			if scrollView.contentOffset.y <= -slidingHeaderView.frame.height {
				newY = 0.0
			} else {
				newY = max(-slidingHeaderView.frame.height, newY)
			}
		}
		// update slidingHeaderView Top constraint constant
		slidingViewTopC.constant = newY
		curScrollY = scrollView.contentOffset.y
	}
	
}

class zSlidingHeaderViewController: UIViewController {
	
	let scrollView: UIScrollView = {
		let v = UIScrollView()
		v.contentInsetAdjustmentBehavior = .never
		return v
	}()
	let slidingHeaderView: SlidingHeaderView = {
		let v = SlidingHeaderView()
		return v
	}()
	let contentView: UIView = {
		let v = UIView()
		v.backgroundColor = .systemYellow
		return v
	}()
	
	// Top constraint for the slidingHeaderView
	var slidingViewTopC: NSLayoutConstraint!
	
	// to track the scroll activity
	var curScrollY: CGFloat = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .systemBackground
		
		[scrollView, slidingHeaderView, contentView].forEach { v in
			v.translatesAutoresizingMaskIntoConstraints = false
		}
		
		// add contentView and slidingHeaderView to the scroll view
		[contentView, slidingHeaderView].forEach { v in
			scrollView.addSubview(v)
		}
		
		// add scroll view to self.view
		view.addSubview(scrollView)
		
		let safeG = view.safeAreaLayoutGuide
		let contentG = scrollView.contentLayoutGuide
		let frameG = scrollView.frameLayoutGuide
		
		// we're going to change slidingHeaderView's Top constraint relative to the Top of the scroll view FRAME
		slidingViewTopC = slidingHeaderView.topAnchor.constraint(equalTo: frameG.topAnchor, constant: 0.0)
		
		NSLayoutConstraint.activate([
			
			// scroll view Top to view Top
			scrollView.topAnchor.constraint(equalTo: safeG.topAnchor, constant: 0.0),
			
			// scroll view Leading/Trailing/Bottom to safe area
			scrollView.leadingAnchor.constraint(equalTo: safeG.leadingAnchor, constant: 0.0),
			scrollView.trailingAnchor.constraint(equalTo: safeG.trailingAnchor, constant: 0.0),
			scrollView.bottomAnchor.constraint(equalTo: safeG.bottomAnchor, constant: 0.0),
			
			// constrain slidingHeaderView Top to scroll view's FRAME
			slidingViewTopC,
			
			// slidingHeaderView to Leading/Trailing of scroll view FRAME
			slidingHeaderView.leadingAnchor.constraint(equalTo: frameG.leadingAnchor, constant: 0.0),
			slidingHeaderView.trailingAnchor.constraint(equalTo: frameG.trailingAnchor, constant: 0.0),
			
			// no Height or Bottom constraint for slidingHeaderView
			
			// content view Top/Leading/Trailing/Bottom to scroll view's CONTENT GUIDE
			contentView.topAnchor.constraint(equalTo: contentG.topAnchor, constant: 0.0),
			contentView.leadingAnchor.constraint(equalTo: contentG.leadingAnchor, constant: 0.0),
			contentView.trailingAnchor.constraint(equalTo: contentG.trailingAnchor, constant: 0.0),
			contentView.bottomAnchor.constraint(equalTo: contentG.bottomAnchor, constant: 0.0),
			
			// content view Width to scroll view's FRAME
			contentView.widthAnchor.constraint(equalTo: frameG.widthAnchor, constant: 0.0),
			
		])
		
		// add some content to the content view so we have something to scroll
		addSomeContent()
		
		// because we're going to track the scroll offset
		scrollView.delegate = self
		
		// activate the scroll view's "drag down to refresh" feature
		scrollView.refreshControl = UIRefreshControl()
		scrollView.refreshControl?.addTarget(self, action: #selector(fetch), for: .valueChanged)
		
	}
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		if slidingHeaderView.frame.height == 0 {
			// get the size of the slidingHeaderView
			let sz = slidingHeaderView.systemLayoutSizeFitting(CGSize(width: scrollView.frame.width, height: .greatestFiniteMagnitude), withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
			// use its Height for the scroll view's Top contentInset
			scrollView.contentInset = UIEdgeInsets(top: sz.height, left: 0, bottom: 0, right: 0)
		}
	}
	
	// we'll use this to simulate fetching data to refresh the scroll view
	var cIDX: Int = 0
	@objc func fetch() {
		// let's simulate a 1-second task to get new content
		DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
			// change the background color of all the labels in our content virew
			let colors: [UIColor] = [
				.cyan, .magenta, .yellow
			]
			let c = colors[self.cIDX % colors.count]
			if let sv = self.contentView.subviews.first as? UIStackView {
				sv.subviews.forEach { v in
					v.backgroundColor = c
				}
			}
			self.cIDX += 1
			self.scrollView.refreshControl?.endRefreshing()
		}
	}
	
	func addSomeContent() {
		// create a vertical stack view with a bunch of labels
		//	and add it to our content view so we have something to scroll
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

extension zSlidingHeaderViewController: UIScrollViewDelegate {
	
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		curScrollY = scrollView.contentOffset.y
	}
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let diffY = scrollView.contentOffset.y - curScrollY
		var newY: CGFloat = slidingViewTopC.constant - diffY
		if diffY < 0 {
			// we're scrolling DOWN
			newY = min(newY, 0.0)
		} else {
			// we're scrolling UP
			if scrollView.contentOffset.y <= -slidingHeaderView.frame.height {
				newY = 0.0
			} else {
				newY = max(-slidingHeaderView.frame.height, newY)
			}
		}
		// update slidingHeaderView Top constraint constant
		slidingViewTopC.constant = newY
		curScrollY = scrollView.contentOffset.y
	}
	
}
