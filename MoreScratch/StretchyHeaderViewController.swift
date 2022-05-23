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
	
	var exp: [Bool] = []
	
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
		
		if #available(iOS 15.0, *) {
			tableView.sectionHeaderTopPadding = 0
			tableView.sectionFooterHeight = 0
			tableView.sectionHeaderHeight = 12
		}

		exp = Array(repeating: true, count: Book.sections.count)
	}
	
//	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//		return "Section: \(section)"
//	}
	
	// MARK: - Table View Data Source / Delegate
	func numberOfSections(in tableView: UITableView) -> Int {
		return Book.sections.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if exp[section] {
			return Book.booksFor(section: section).count
		}
		return 1
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
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print(#function)
		if indexPath.row == 0 {
			exp[indexPath.section].toggle()
			tableView.reloadSections([indexPath.section], with: .automatic)
		}
	}
}

class MySimpleTableView: UIViewController, UITableViewDelegate, UITableViewDataSource {
	private var tableView: UITableView!
	private let reuseIdentifier = "myCell"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if let img = UIImage(named: "swiftRed") {
			let szImg2 = img.resized(toSize: CGSize(width: 28, height: 28), atScale: 2)
			let szImg3 = img.resized(toSize: CGSize(width: 28, height: 28), atScale: 3)
			let szImgD = img.resized(toSize: CGSize(width: 28, height: 28))
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
			let szImg = img.resized(toSize: CGSize(width: 28, height: 28), atScale: UIScreen.main.scale)
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
	func resized(toSize sz: CGSize, atScale: CGFloat? = nil) -> UIImage {
		let newScale = atScale ?? UIScreen.main.scale
		let format = UIGraphicsImageRendererFormat()
		format.scale = newScale
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

class ButtonFontVC: UIViewController {
	
	let b1 = UIButton()
	let b2 = UIButton()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		[b1, b2].forEach { b in
			//b.setTitle("Testing", for: [])
			b.setTitleColor(.white, for: .normal)
			b.setTitleColor(.lightGray, for: .highlighted)
			b.backgroundColor = .systemBlue
			b.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview(b)
		}
		
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			b1.topAnchor.constraint(equalTo: g.topAnchor, constant: 80.0),
			b2.topAnchor.constraint(equalTo: b1.bottomAnchor, constant: 20.0),
			b1.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			b2.centerXAnchor.constraint(equalTo: g.centerXAnchor),
		])
		
		var cfg = UIButton.Configuration.plain()
		cfg.title = "Testing"
		cfg.baseForegroundColor = .white
		b1.configuration = cfg
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		print(#function)
		let font: UIFont = .systemFont(ofSize: 72.0, weight: .light)
//		b1.titleLabel?.font = font
		var s = NSAttributedString(string: "Testing", attributes: [
			NSAttributedString.Key.font : font,
			NSAttributedString.Key.foregroundColor : UIColor.yellow,
		])
		b2.setAttributedTitle(s, for: .normal)
		s = NSAttributedString(string: "Testing", attributes: [
			NSAttributedString.Key.font : font,
			NSAttributedString.Key.foregroundColor : UIColor.cyan,
		])
		b2.setAttributedTitle(s, for: .highlighted)


		var ss: AttributedString!
		
		do {
			ss = try AttributedString(s, including: \.uiKit)
		} catch {
			
		}
		
		var cfg = b1.configuration
		if cfg == nil {
			print("nil")
			cfg = UIButton.Configuration.plain()
		}
		cfg?.attributedTitle = ss
		
		b1.configuration = cfg
	}
	
}

class MyBaseVC: UIViewController {
	
	let imgViewA = UIImageView()
	let imgViewB = UIImageView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		[imgViewA, imgViewB].forEach { v in
			// use AspectFill
			v.contentMode = .scaleAspectFill
			// background color so we can see the framing
			v.backgroundColor = .systemYellow
			v.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview(v)
		}
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			
			imgViewA.topAnchor.constraint(equalTo: g.topAnchor, constant: 40.0),
			imgViewA.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			imgViewA.widthAnchor.constraint(equalToConstant: 160.0),
			imgViewA.heightAnchor.constraint(equalTo: imgViewA.widthAnchor),
			
			imgViewB.topAnchor.constraint(equalTo: imgViewA.bottomAnchor, constant: 20.0),
			imgViewB.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			imgViewB.widthAnchor.constraint(equalToConstant: 160.0),
			imgViewB.heightAnchor.constraint(equalTo: imgViewB.widthAnchor),
			
		])
		
	}
	
}

class Example5VC: MyBaseVC {
	override func viewDidLoad() {
		super.viewDidLoad()
		
//		let nm = "person.crop.circle.fill"
		let nm = "mic.circle.fill"

		// create UIImage from SF Symbol at "160-pts" size
		let cfg = UIImage.SymbolConfiguration(pointSize: 160.0)
		guard let imgA = UIImage(systemName: nm, withConfiguration: cfg)?.withTintColor(.red, renderingMode: .alwaysOriginal) else {
			fatalError("Could not load SF Symbol: \(nm)!")
		}
		
		// get a cgRef from imgA
		guard let cgRef = imgA.cgImage else {
			fatalError("Could not get cgImage!")
		}
		// create imgB from the cgRef
		let imgB = UIImage(cgImage: cgRef, scale: imgA.scale, orientation: imgA.imageOrientation)
			.withTintColor(.red, renderingMode: .alwaysOriginal)
		
		print("imgA:", imgA.size, "imgB:", imgB.size)
		
		imgViewA.image = imgA
		imgViewB.image = imgB
	}
}

class TextCell: UIView {
	
	let label = UILabel()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		configure()
	}
	required init?(coder: NSCoder) {
		fatalError("not implemnted")
	}
	
}

extension TextCell {
	func configure() {
		label.translatesAutoresizingMaskIntoConstraints = false
		label.adjustsFontForContentSizeCategory = true
		addSubview(label)
		label.font = UIFont.preferredFont(forTextStyle: .caption1)
		let inset = CGFloat(10)
		let g = self.layoutMarginsGuide
		NSLayoutConstraint.activate([
			label.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: inset),
			label.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -inset),
			label.topAnchor.constraint(equalTo: g.topAnchor, constant: inset),
			label.bottomAnchor.constraint(equalTo: g.bottomAnchor, constant: -inset)
		])
	}
}

class StackColumnsVC: UIViewController {
	
	let numItems: Int = 7
	
}

class CircleView: UIView {
	
	var color: UIColor = .yellow
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .clear
	}
	
	required init(coder aDecoder : NSCoder) {
		fatalError("init(coder : ) has not been implemented")
	}
	
	override func draw(_ rect: CGRect) {
		if let context = UIGraphicsGetCurrentContext(){
			context.setLineWidth(2)
			color.setStroke()
			context.addEllipse(in: bounds.insetBy(dx: 2, dy: 2))
			context.strokePath()
		}
	}
		
}

class CircleViewController: UIViewController {

	// array of Circle Views to track
	var circleViews: [CircleView] = []
	
	// this will be set if touchesBegan is inside an existing circle
	var selectedCircleView: CircleView!
	
	let colors: [UIColor] = [
		.yellow, .green, .red, .cyan, .orange
	]
	
	let circleSize: CGSize = CGSize(width: 100.0, height: 100.0)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = UIColor.lightGray
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let touch = touches.first {
			let loc = touch.location(in: view)
			selectedCircleView = nil
			
			if let draggedCircle = circleViews.filter({ UIBezierPath(ovalIn: $0.frame).contains(loc) }).first {
				selectedCircleView = draggedCircle
			}
			
		}
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		if let touch = touches.first {
			if selectedCircleView == nil {
				// we did not have a touched circle, so create a new one
				let newCV: CircleView = CircleView(frame: CGRect(origin: .zero, size: circleSize))
				newCV.center = touch.location(in: view)
				// cycle through our colors array so we can tell the circles from each other
				newCV.color = colors[circleViews.count % colors.count]
				// add it to the view
				view.addSubview(newCV)
				// add it to the tracking array
				circleViews.append(newCV)
			}
		}
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else {
			return
		}
		// if we have a selected circle view
		if let curCV = selectedCircleView {
			// move it
			curCV.center = touch.location(in: view)
		}
	}
	
}

class ServiceAnnotationView: UIView {
	@IBOutlet var stackView: UIStackView!
	
	let imgNames: [String] = [
		"pay",
		"charging",
		"fuel",
		"parking",
		"charging",
	]
	
	var numItems: Int = 1 {
		didSet {
			for i in 0..<numItems {
				let imgView = UIImageView()
				imgView.backgroundColor = .yellow
				if let img = UIImage(systemName: "\(i).circle.fill") {
					imgView.image = img
				}
				stackView.addArrangedSubview(imgView)
				imgView.heightAnchor.constraint(equalToConstant: 24.0).isActive = true
				imgView.widthAnchor.constraint(equalTo: imgView.heightAnchor).isActive = true
			}
		}
	}
}

import MapKit

extension UIView {
	class func fromNib<T: UIView>() -> T {
		return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
	}
}
extension UIView {
	
	// Using a function since `var image` might conflict with an existing variable
	// (like on `UIImageView`)
	func asImage() -> UIImage {
		let renderer = UIGraphicsImageRenderer(bounds: bounds)
		return renderer.image { rendererContext in
			layer.render(in: rendererContext.cgContext)
		}
	}
}
class SizeXIBViewController: UIViewController, MKMapViewDelegate {
	
	@IBOutlet var mapView: MKMapView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
		let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
		let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
		let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
		let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
	
		mapView.delegate = self
		
		mapView.addAnnotations([london, oslo, paris, rome, washington])
		
		// Set initial location in Honolulu
		let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
		
		mapView.centerToLocation(initialLocation)
		
		// Show artwork on map
		let artwork = Artwork(
			title: "King David Kalakaua",
			locationName: "Waikiki Gateway Park",
			discipline: "Sculpture",
			coordinate: CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661))
		mapView.addAnnotation(artwork)
		
	}

	var itemCount: Int = 1
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
//		let serviceAnnotationView: ServiceAnnotationView = ServiceAnnotationView.fromNib()
//
//		serviceAnnotationView.numItems = itemCount
//
//		serviceAnnotationView.translatesAutoresizingMaskIntoConstraints = false
//
//		serviceAnnotationView.setNeedsLayout()
//		serviceAnnotationView.layoutIfNeeded()
//
//		let img = serviceAnnotationView.asImage()
//
//		print(itemCount, img.size)
		
//		let view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//		view.image = serviceAnnotationView.asImage()
		
		itemCount += 1
		
	}
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		// 1
//		guard annotation is Capital else { return nil }
//		let identifier = "Capital"

		guard annotation is Artwork else { return nil }
		let identifier = "Artwork"

		// 3
		var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
		
		let serviceAnnotationView: ServiceAnnotationView = ServiceAnnotationView.fromNib()
		
		serviceAnnotationView.numItems = 3
		
		serviceAnnotationView.translatesAutoresizingMaskIntoConstraints = false
		
		serviceAnnotationView.setNeedsLayout()
		serviceAnnotationView.layoutIfNeeded()
		
		let img = serviceAnnotationView.asImage()

		
//		if annotationView == nil {
//			//4
//			annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//			annotationView?.canShowCallout = true
//
//			// 5
//			let btn = UIButton(type: .detailDisclosure)
//			annotationView?.rightCalloutAccessoryView = btn
//		} else {
//			// 6
//			annotationView?.annotation = annotation
//		}

		if annotationView == nil {
			annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
		} else {
			annotationView?.annotation = annotation
		}

		annotationView?.image = img
		
		
		return annotationView
	}
	
}

class Capital: NSObject, MKAnnotation {
	var title: String?
	var coordinate: CLLocationCoordinate2D
	var info: String
	
	init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
		self.title = title
		self.coordinate = coordinate
		self.info = info
	}
}

private extension MKMapView {
	func centerToLocation(
		_ location: CLLocation,
		regionRadius: CLLocationDistance = 1000
	) {
		let coordinateRegion = MKCoordinateRegion(
			center: location.coordinate,
			latitudinalMeters: regionRadius,
			longitudinalMeters: regionRadius)
		setRegion(coordinateRegion, animated: true)
	}
}

import MapKit

class Artwork: NSObject, MKAnnotation {
	let title: String?
	let locationName: String?
	let discipline: String?
	let coordinate: CLLocationCoordinate2D
	
	init(
		title: String?,
		locationName: String?,
		discipline: String?,
		coordinate: CLLocationCoordinate2D
	) {
		self.title = title
		self.locationName = locationName
		self.discipline = discipline
		self.coordinate = coordinate
		
		super.init()
	}
	
	var subtitle: String? {
		return locationName
	}
}

class SimpleViewController: UIViewController {
	
	let testLabel = UILabel()
	
	// custom DotsView
	let testDotsView = DotsView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .systemBackground
		
		testLabel.font = .systemFont(ofSize: 24.0)
		
		testLabel.text = "Retrieving boxes"
		
		// so we can see the label frame
		testLabel.backgroundColor = .cyan
		
		testLabel.translatesAutoresizingMaskIntoConstraints = false
		testDotsView.translatesAutoresizingMaskIntoConstraints = false
		
		view.addSubview(testLabel)
		view.addSubview(testDotsView)
		
		// always respect safe area
		let g = view.safeAreaLayoutGuide
		
		NSLayoutConstraint.activate([
			
			// let's constrain the label
			//  40-pts from Leading
			//  40-pts from Bottom
			testLabel.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 40.0),
			testLabel.bottomAnchor.constraint(equalTo: g.bottomAnchor, constant: -40.0),
			
			// constrain dots view to
			//  Top of label
			//  Trailing of label
			testDotsView.topAnchor.constraint(equalTo: testLabel.topAnchor),
			testDotsView.leadingAnchor.constraint(equalTo: testLabel.trailingAnchor, constant: 0.0),
			// dots image view Width and Height can be 0 (we can draw the layer outside the bounds)
			testDotsView.heightAnchor.constraint(equalToConstant: 0.0),
			testDotsView.widthAnchor.constraint(equalToConstant: 0.0),
			
		])
		
		// get the label font's baseline y-value
		testDotsView.baseline = testLabel.font.ascender
		
		// use defaults or set values here
		//testDotsView.dotXOffset = 4.0
		//testDotsView.dotSize = 4.0
		//testDotsView.dotSpacing = 8.0
		
		testDotsView.beginAnimating()

		// we want to
		//	Stop the Dots animation when the app goes into the Background, and
		//	Start the Dots animation when the app Enters the Foreground
		NotificationCenter.default.addObserver(self, selector: #selector(myEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(myEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
	}
	
	@objc func myEnterBackground() {
		testDotsView.stopAnimating()
	}
	@objc func myEnterForeground() {
		testDotsView.beginAnimating()
	}
	
}

class DotsView: UIView {
	
	// baseline = to put the bottom of the dots at the baseline of the text in the label
	// dotXOffset = gap between end of label and first dot
	// dotSize = dot width and height
	// dotSpacing = gap between dots

	public var baseline: CGFloat = 0
	public var dotXOffset: CGFloat = 4.0
	public var dotSize: CGFloat = 4.0
	public var dotSpacing: CGFloat = 8.0

	private let lay = CAReplicatorLayer()
	private let bar = CALayer()

	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {
		lay.addSublayer(bar)
		layer.addSublayer(lay)
	}
	public func beginAnimating() {
		bar.frame = CGRect(x: dotXOffset, y: baseline - dotSize, width: dotSize, height: dotSize)
		// we want round dots
		bar.cornerRadius = bar.frame.width / 2.0
		bar.backgroundColor = UIColor.black.cgColor
		//How many instances / objs we want to see
		lay.instanceCount = 3
		//1st arg is the spacing between the instances
		lay.instanceTransform = CATransform3DMakeTranslation(dotSpacing, 0, 0)
		let anim = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
		anim.fromValue = 1.0
		anim.toValue = 0.2
		anim.duration = 1
		anim.repeatCount = .infinity
		bar.add(anim, forKey: nil)
		// so the dots animate in sequence
		lay.instanceDelay = anim.duration / Double(lay.instanceCount)
	}
	public func stopAnimating() {
		layer.removeAllAnimations()
	}
}

class GapLineVC: UIViewController {
	
	let gapLineView = GapLineView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .systemBackground
		
		gapLineView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(gapLineView)
		
		gapLineView.backgroundColor = .black
		
		// respect safe area
		let g = view.safeAreaLayoutGuide
		
		NSLayoutConstraint.activate([
			
			gapLineView.topAnchor.constraint(equalTo: g.topAnchor, constant: 20.0),
			gapLineView.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
			gapLineView.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -20.0),
			
			gapLineView.heightAnchor.constraint(equalToConstant: 60.0),

		])
		
	}
}

class sGapLineView: UIView {
	
	let seg1 = UIView()
	let seg2 = UIView()
	let seg3 = UIView()
	let seg4 = UIView()
	
	let hold1 = UILabel()
	let hold2 = UILabel()
	
	let centerImageView = UIImageView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {
		
		// horizontal spacing ("gaps")
		let gapWidth: CGFloat = 12.0
		
		// make sure we can load the center image
		guard let img = UIImage(systemName: "clock") else {
			fatalError("Could not create Clock image!")
		}
		
		// let's use a horizontal stack view
		let hStack = UIStackView()
		hStack.translatesAutoresizingMaskIntoConstraints = false
		
		// we want the elements vertically centered
		hStack.alignment = .center

		// gap between elements
		hStack.spacing = gapWidth

		addSubview(hStack)
		
		// add elements to the stack view
		[seg1, hold1, seg2, centerImageView, seg3, hold2, seg4].forEach { v in
			hStack.addArrangedSubview(v)
		}
		
		// line segments
		[seg1, seg2, seg3, seg4].forEach { v in
			v.backgroundColor = .lightGray
			v.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
		}
		
		// hold labels
		[hold1, hold2].forEach { v in
			v.font = .systemFont(ofSize: 15.0, weight: .regular)
			v.textColor = .white
			v.text = "HOLD"
			v.textAlignment = .center
		}
		
		// center image
		centerImageView.image = img
		
		NSLayoutConstraint.activate([
			
			// constrain the stack view to Top and Bottom
			hStack.topAnchor.constraint(equalTo: topAnchor, constant: 0.0),
			hStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0.0),
			
			// Leading and Trailing same as "gaps"
			hStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: gapWidth),
			hStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -gapWidth),

			// now we'll add sizing constraints
			
			// center image view 24x24 pts
			centerImageView.widthAnchor.constraint(equalToConstant: 24.0),
			centerImageView.heightAnchor.constraint(equalTo: centerImageView.widthAnchor),
			
			// seg2 and seg3 are equal widths
			seg2.widthAnchor.constraint(equalTo: seg3.widthAnchor),
			
			// seg1 and seg4 are equal widths
			seg1.widthAnchor.constraint(equalTo: seg4.widthAnchor),
			
			// longer segment widths are 3x shorter segment widths
			seg1.widthAnchor.constraint(equalTo: seg2.widthAnchor, multiplier: 3.0),
			
		])
		
	}
	
}

class GapLineView: UIView {
	
	let seg1 = UIView()
	let seg2 = UIView()
	let seg3 = UIView()
	let seg4 = UIView()

	let hold1 = UILabel()
	let hold2 = UILabel()
	
	let centerImageView = UIImageView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {
		
		// horizontal spacing ("gaps")
		let gapWidth: CGFloat = 12.0
		
		// make sure we can load the center image
		guard let img = UIImage(systemName: "clock") else {
			fatalError("Could not create Clock image!")
		}
		
		// all elements need this
		[seg1, seg2, seg3, seg4, hold1, hold2, centerImageView].forEach { v in
			v.translatesAutoresizingMaskIntoConstraints = false
			addSubview(v)
		}
		
		// line segments
		[seg1, seg2, seg3, seg4].forEach { v in
			v.backgroundColor = .lightGray
			v.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
			v.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		}
		
		// hold labels
		[hold1, hold2].forEach { v in
			v.font = .systemFont(ofSize: 15.0, weight: .regular)
			v.textColor = .white
			v.text = "HOLD"
			v.textAlignment = .center
			v.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		}
		
		// center image
		centerImageView.image = img
		centerImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

		// now we'll constrain the elements horizontally
		NSLayoutConstraint.activate([
			
			// first line segment gapWidth from Leading
			seg1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: gapWidth),
			
			// first HOLD label gapWidth from end of line segment
			hold1.leadingAnchor.constraint(equalTo: seg1.trailingAnchor, constant: gapWidth),
			
			// second line segment gapWidth from first HOLD label
			seg2.leadingAnchor.constraint(equalTo: hold1.trailingAnchor, constant: gapWidth),
			
			// center image view gapWidth from end of line segment
			centerImageView.leadingAnchor.constraint(equalTo: seg2.trailingAnchor, constant: gapWidth),
			
			// center image view 24x24 pts
			centerImageView.widthAnchor.constraint(equalToConstant: 24.0),
			centerImageView.heightAnchor.constraint(equalTo: centerImageView.widthAnchor),
			
			// third line segment gapWidth from center image view
			seg3.leadingAnchor.constraint(equalTo: centerImageView.trailingAnchor, constant: gapWidth),

			// second HOLD label gapWidth from end of line segment
			hold2.leadingAnchor.constraint(equalTo: seg3.trailingAnchor, constant: gapWidth),
			
			// fourth line segment gapWidth from second HOLD label
			seg4.leadingAnchor.constraint(equalTo: hold2.trailingAnchor, constant: gapWidth),
			
			// fourth line segment also gapWidth from Trailing
			seg4.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -gapWidth),

			// seg2 and seg3 are equal widths
			seg2.widthAnchor.constraint(equalTo: seg3.widthAnchor),
			
			// seg1 and seg4 are equal widths
			seg1.widthAnchor.constraint(equalTo: seg4.widthAnchor),
			
			// longer segment widths are 3x shorter segment widths
			seg1.widthAnchor.constraint(equalTo: seg2.widthAnchor, multiplier: 3.0),

		])
		
	}
	
}
