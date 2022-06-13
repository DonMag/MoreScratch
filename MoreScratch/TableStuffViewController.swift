//
//  TableStuffViewController.swift
//  MoreScratch
//
//  Created by Don Mag on 4/17/22.
//

import UIKit

class TableStuffViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}

class PagingVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

	let pageControl = UIPageControl()
	
	var collectionView: UICollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		view.backgroundColor = .systemBlue
		
		let fl = UICollectionViewFlowLayout()
		fl.scrollDirection = .horizontal
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: fl)
		
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		pageControl.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(collectionView)
		view.addSubview(pageControl)
		
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			
			collectionView.topAnchor.constraint(equalTo: g.topAnchor, constant: 40.0),
			collectionView.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 40.0),
			collectionView.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -40.0),
			collectionView.heightAnchor.constraint(equalToConstant: 300.0),
			
			pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 4.0),
			pageControl.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
			pageControl.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
			
		])
		
		collectionView.dataSource = self
		collectionView.delegate = self
		
		collectionView.register(BasicColViewCell.self, forCellWithReuseIdentifier: "c")
		
		collectionView.isPagingEnabled = true
		pageControl.numberOfPages = 2
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		if let fl = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
			fl.minimumInteritemSpacing = 0
			fl.minimumLineSpacing = 0
			fl.itemSize = CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
			print(fl.itemSize)
		}
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 2
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let c = collectionView.dequeueReusableCell(withReuseIdentifier: "c", for: indexPath) as! BasicColViewCell
		c.label.text = "\(indexPath)"
		return c
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let fw = scrollView.frame.width
		let pct = scrollView.contentOffset.x / fw
		pageControl.currentPage = pct < 0.5 ? 0 : 1
	}
}


class BasicColViewCell: UICollectionViewCell {
	let label = UILabel()
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	private func commonInit() {
		label.backgroundColor = .yellow
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(label)
		let g = contentView.layoutMarginsGuide
		NSLayoutConstraint.activate([
			label.topAnchor.constraint(equalTo: g.topAnchor),
			label.leadingAnchor.constraint(equalTo: g.leadingAnchor),
			label.trailingAnchor.constraint(equalTo: g.trailingAnchor),
			label.bottomAnchor.constraint(equalTo: g.bottomAnchor),
		])
	}
}
class WithCollectionViewTableCell: UITableViewCell {
	var collectionView: UICollectionView!
}

class LabelCollectionViewCell: UICollectionViewCell {
	let label = UILabel()
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	private func commonInit() {
		label.textAlignment = .center
		label.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(label)
		let g = contentView.layoutMarginsGuide
		NSLayoutConstraint.activate([
			label.topAnchor.constraint(equalTo: g.topAnchor, constant: 4.0),
			label.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 8.0),
			label.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -8.0),
			label.bottomAnchor.constraint(equalTo: g.bottomAnchor, constant: -4.0),
		])
		
		// default (unselected) appearance
		contentView.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
		label.textColor = .black
		
		// let's round the corners so it looks nice
		contentView.layer.cornerRadius = 12
	}
	override var isSelected: Bool {
		didSet {
			contentView.backgroundColor = isSelected ? .systemBlue : UIColor(white: 0.95, alpha: 1.0)
			label.textColor = isSelected ? .white : .black
		}
	}
}

class TagsLayout: UICollectionViewFlowLayout {
	var rowMaxX: [CGFloat] = []
	
	let cellSpacing: CGFloat = 20
	override init(){
		super.init()
	}
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
	}
	func commonInit() {
		scrollDirection = .horizontal
	}
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		guard let attributes = super.layoutAttributesForElements(in: rect) else {
			return nil
		}
		
		guard let attributesToReturn =  attributes.map( { $0.copy() }) as? [UICollectionViewLayoutAttributes] else {
			return nil
		}
		var leftMargin = sectionInset.left
		var maxX: CGFloat = -1.0
		var curY: CGFloat = -1.0
		attributesToReturn.forEach { layoutAttribute in
			if layoutAttribute.frame.origin.y > curY {
				
			}
			if layoutAttribute.frame.origin.x >= maxX {
				leftMargin = sectionInset.left
			}
			
			layoutAttribute.frame.origin.x = leftMargin
			
			leftMargin += layoutAttribute.frame.width + cellSpacing
			maxX = max(layoutAttribute.frame.maxX , maxX)
		}
		
		return attributesToReturn
	}
}

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
	
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		let attributes = super.layoutAttributesForElements(in: rect)
		
		var leftMargin = sectionInset.left
		var maxY: CGFloat = -1.0
		attributes?.forEach { layoutAttribute in
			if layoutAttribute.frame.origin.y >= maxY {
				leftMargin = sectionInset.left
			}
			
			layoutAttribute.frame.origin.x = leftMargin
			
			leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
			maxY = max(layoutAttribute.frame.maxY , maxY)
		}
		
		return attributes
	}
}

class SelColViewVC: UIViewController {
	
	var collectionView: UICollectionView!
	
	let myData: [String] = [
		"All Venues - First Cell",
		"Venue One",
		"Two",
		"Venue Three",
		"Venue Four",
		"Venue Five",
		"Venue Six",
		"Venue Seven",
		"Venue Eight",
		"Nine",
		"Ten",
		"Eleven",
		"Twelve",
		"Thirteen",
	]
	
	// use this to track the currently selected item / cell
	var currentSelection: IndexPath!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
//		let fl = UICollectionViewFlowLayout()
//		fl.scrollDirection = .horizontal
//		fl.estimatedItemSize = CGSize(width: 120, height: 50)
//		fl.minimumLineSpacing = 4
//		fl.minimumInteritemSpacing = 4

		let fl = TagsLayout()
		//let fl = LeftAlignedCollectionViewFlowLayout()
		//fl.scrollDirection = .horizontal
		fl.estimatedItemSize = CGSize(width: 120, height: 50)
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: fl)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(collectionView)
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: g.topAnchor, constant: 20.0),
			collectionView.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
			collectionView.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -20.0),
			collectionView.heightAnchor.constraint(equalToConstant: 180.0),
		])
		
		collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
		collectionView.register(LabelCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
		collectionView.dataSource = self
		collectionView.delegate = self
		
		// we want to "pre-select" the first item / cell
		let idx = IndexPath(item: 0, section: 0)
		collectionView.selectItem(at: idx, animated: false, scrollPosition: .left)

		// update currentSelection var
		currentSelection = idx
	}
	
}
extension SelColViewVC: UICollectionViewDataSource, UICollectionViewDelegate {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return myData.count
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let c = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LabelCollectionViewCell
		c.label.text = myData[indexPath.item]
		return c
	}
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if currentSelection == indexPath {
			// user tapped already selected cell, so
			//	just return
			print("Tapped Already Selected item:", indexPath.item)
			return
		}

		// update currentSelection var
		currentSelection = indexPath
		
		print("New Selected item:", indexPath.item)
		// run code for new selection
	}
	
}

class ToggleSelColViewVC: UIViewController {
	
	var collectionView: UICollectionView!
	
	var myData: [String] = [
		"Favorites",
		"Recents",
		"Recently Added",
		"Something Else",
		"Five",
		"Six",
		"Seven",
		"Eight",
	]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let fl = UICollectionViewFlowLayout()
		fl.scrollDirection = .vertical
		fl.estimatedItemSize = CGSize(width: 120, height: 50)
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: fl)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(collectionView)
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: g.topAnchor, constant: 20.0),
			collectionView.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
			collectionView.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -20.0),
			collectionView.heightAnchor.constraint(equalToConstant: 280.0),
		])
		
		collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 8.0, bottom: 0.0, right: 8.0)
		collectionView.register(LabelCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
		collectionView.dataSource = self
		collectionView.delegate = self
		
	}
	
}
extension ToggleSelColViewVC: UICollectionViewDataSource, UICollectionViewDelegate {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 50
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let c = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LabelCollectionViewCell
		c.label.text = "Item: \(indexPath.item)"
		return c
	}
	
	func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
		
		// is a row already selected?
		if let selectedItems = collectionView.indexPathsForSelectedItems {
			if selectedItems.contains(indexPath) {
				collectionView.deselectItem(at: indexPath, animated: true)
				return false
			}
		}
		return true
		
//		if let idx = tableView.indexPathForSelectedRow {
//			if idx == indexPath {
//				// tapped row is already selected, so
//				//  deselect it
//				tableView.deselectRow(at: indexPath, animated: false)
//				//  update our data
//				pincodes[indexPath.row].isSelected = false
//				//  tell table view NOT to select the row
//				return nil
//			} else {
//				// some other row is selected, so
//				//  update our data
//				//  table view will automatically deselect that row
//				pincodes[idx.row].isSelected = false
//			}
//		}
//		// tapped row should now be selected, so
//		//  update our data
//		pincodes[indexPath.row].isSelected = true
//		//  tell table view TO select the row
//		return indexPath

	}
	
//	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//		// is an item already selected?
//		if let selectedItems = collectionView.indexPathsForSelectedItems {
//			if selectedItems.contains(indexPath) {
//				// tapped item is already selected, so
//				//  deselect it
//				collectionView.deselectItem(at: indexPath, animated: true)
//				//  update our data
//				//pincodes[indexPath.row].isSelected = false
//				//  tell table view NOT to select the row
//				return
//			} else {
//				// some other row is selected, so
//				//  update our data
//				//  table view will automatically deselect that row
//				//pincodes[idx.row].isSelected = false
//			}
//		}
//		// tapped row should now be selected, so
//		//  update our data
//		//pincodes[indexPath.row].isSelected = true
//		//  tell table view TO select the row
//		//return indexPath
//
//
////		if collectionView == collectionView {
////			print("Selected item:", indexPath.item)
////			//			presenter?.didChooseAlbum(with: indexPath.item) {
////			//				self.picturesCollectionView.reloadData()
////			//			}
////		}
//	}
}

class CarView: UIView {
	
}
class CarCell: UITableViewCell {

	let carView = CarView()
	let carImageView = UIImageView()
	let carImage = UIImageView()
	let stringStack = UIStackView()
	let editButton = UIButton()
	
	let carImageWidthAndHeight: CGFloat = 40.0
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {
		[carView, carImageView, carImage, stringStack, editButton].forEach { v in
			v.translatesAutoresizingMaskIntoConstraints = false
		}
		[carImageView, carImage, stringStack, editButton].forEach { v in
			carView.addSubview(v)
		}
		contentView.addSubview(carView)
		
		let c  = carView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		c.priority = .required - 1
		
		NSLayoutConstraint.activate([
			
			// don't use this one
			//carView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
			
			// activate the less-than-required bottom constraint
			c,
			
			// the rest of your constraints....
			carView.heightAnchor.constraint(equalToConstant: 120),
			carView.topAnchor.constraint(equalTo: contentView.topAnchor),
			carView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			carView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

			// and so on....
			
			carImageView.leadingAnchor.constraint(equalTo: carView.leadingAnchor, constant: 15),
			carImageView.centerYAnchor.constraint(equalTo: carView.centerYAnchor),
			carImageView.heightAnchor.constraint(equalToConstant: carImageWidthAndHeight),
			carImageView.widthAnchor.constraint(equalToConstant: carImageWidthAndHeight),
			
			carImage.widthAnchor.constraint(equalTo: carImageView.widthAnchor),
			carImage.heightAnchor.constraint(equalTo: carImageView.heightAnchor),
			carImage.centerYAnchor.constraint(equalTo: carImageView.centerYAnchor),
			carImage.centerXAnchor.constraint(equalTo: carImageView.centerXAnchor),
			
			stringStack.leadingAnchor.constraint(equalTo: carImageView.trailingAnchor, constant: 20),
			stringStack.centerYAnchor.constraint(equalTo: carView.centerYAnchor),
			
			editButton.trailingAnchor.constraint(equalTo: carView.trailingAnchor, constant: -15),
			editButton.centerYAnchor.constraint(equalTo: carView.centerYAnchor),
		])
		
		carView.backgroundColor = .yellow
		carImageView.backgroundColor = .cyan
		carImage.backgroundColor = .systemBlue
		stringStack.backgroundColor = .blue
		editButton.backgroundColor = .red
	}
}
class CarVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	let carsTableView = UITableView()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.addSubview(carsTableView)
		carsTableView.translatesAutoresizingMaskIntoConstraints = false
		carsTableView.backgroundColor = .darkGray
		carsTableView.dataSource = self
		carsTableView.isScrollEnabled = false
		carsTableView.allowsSelection = true
		carsTableView.delegate = self
		
		carsTableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
		carsTableView.separatorColor = .lightGray
		carsTableView.separatorInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
		
		carsTableView.register(CarCell.self, forCellReuseIdentifier: "CarCell")
		
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			carsTableView.topAnchor.constraint(equalTo: g.topAnchor, constant: 40.0),
			carsTableView.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 40.0),
			carsTableView.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -40.0),
			carsTableView.bottomAnchor.constraint(equalTo: g.bottomAnchor, constant: -40.0),
		])

	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let c = tableView.dequeueReusableCell(withIdentifier: "CarCell", for: indexPath) as! CarCell
		return c
	}
	
}


class PeopleCell: UIView {
	
	
	static let identifier = "PeopleCell"
	
	private lazy var mainStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .vertical
		stackView.distribution = .fill
		stackView.alignment = .leading
		return stackView
	}()
	
	private lazy var stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.axis = .horizontal
		stackView.distribution = .fill
		stackView.alignment = .center
		return stackView
	}()
	private lazy var lastnameTitleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		label.textAlignment = .center
		return label
	}()
	
	private lazy var firstnameTitleLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.numberOfLines = 0
		label.textAlignment = .center
		return label
	}()
	
	private lazy var peopleImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFit
		imageView.backgroundColor = .blue
		return imageView
	}()
	
//	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//		super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//		setUpUI()
//	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setUpUI()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setUpUI()
	}
	
	func configureCell(firstName: String, lastName: String) {
		firstnameTitleLabel.text = "Firstname :\(firstName)"
		lastnameTitleLabel.text = "Lastname : \(lastName)"
		if let img = UIImage(named: "sample3") {
			peopleImageView.image = img
		}
	}
	
	
//	func configureImageCell(row: Int, viewModel: ViewModel) {
//
//		peopleImageView.image = nil
//
//		viewModel
//			.downloadImage(row: row) { [weak self] data in
//				let image = UIImage(data: data)
//				self?.peopleImageView.image = image
//			}
//	}
	
	private func setUpUI() {
		
		mainStackView.axis = .horizontal
		
		stackView.axis = .vertical
		
		firstnameTitleLabel.backgroundColor = .cyan
		lastnameTitleLabel.backgroundColor = .yellow
		
		mainStackView.layer.borderColor = UIColor.red.cgColor
		mainStackView.layer.borderWidth = 1
		
		stackView.backgroundColor = .green
		
		stackView.addArrangedSubview(lastnameTitleLabel)
		stackView.addArrangedSubview(firstnameTitleLabel)
		
		mainStackView.addArrangedSubview(peopleImageView)
		mainStackView.addArrangedSubview(stackView)
		
//		contentView.addSubview(mainStackView)
//
//		// constraints
//		let safeArea = contentView.safeAreaLayoutGuide

		addSubview(mainStackView)
		
		// constraints
		//let safeArea = self.safeAreaLayoutGuide
		let safeArea = self.layoutMarginsGuide

		mainStackView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
		mainStackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
		mainStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10).isActive = true
		mainStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10).isActive = true
		
		peopleImageView.heightAnchor.constraint(equalToConstant: 140).isActive = true
		peopleImageView.widthAnchor.constraint(equalToConstant: 140).isActive = true
		
		// don't do this
		//stackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor).isActive = true
		//stackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor).isActive = true
		
		configureCell(firstName: "Bob", lastName: "Tester")
	}
}

@IBDesignable
class RoundedView: UIView {
	@IBInspectable
	public var cRad: CGFloat {
		set (radius) {
			self.layer.cornerRadius = radius
			self.layer.masksToBounds = radius > 0
			setNeedsLayout()
		}
		get {
			return self.layer.cornerRadius
		}
	}
}

//@IBDesignable
//extension UIView {
//	@IBInspectable
//	public var cRad: CGFloat {
//		set (radius) {
//			self.layer.cornerRadius = radius
//			self.layer.masksToBounds = radius > 0
//		}
//		get {
//			return self.layer.cornerRadius
//		}
//	}
//}
//

class CardView: UIView {
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() {
		layer.cornerRadius = 16
		layer.masksToBounds = true
		layer.borderWidth = 1
		layer.borderColor = UIColor.black.cgColor
	}
}
class AnimCardVC: UIViewController {
	
	let deckStackView: UIStackView = UIStackView()
	let cardPositionView: UIView = UIView()
	let deckPileView: CardView = CardView()
	
	let cardSize: CGSize = CGSize(width: 80, height: 120)
	
	// card colors to cycle through
	let colors: [UIColor] = [
		.systemRed, .systemGreen, .systemBlue,
		.systemCyan, .systemOrange,
	]
	var colorIDX: Int = 0
	
	// card position constraints to animate
	var animXAnchor: NSLayoutConstraint!
	var animYAnchor: NSLayoutConstraint!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .systemBackground
		
		deckStackView.translatesAutoresizingMaskIntoConstraints = false
		deckPileView.translatesAutoresizingMaskIntoConstraints = false
		cardPositionView.translatesAutoresizingMaskIntoConstraints = false
		
		deckStackView.addArrangedSubview(deckPileView)
		view.addSubview(deckStackView)
		view.addSubview(cardPositionView)
		
		// always respect safe area
		let g = view.safeAreaLayoutGuide
		
		NSLayoutConstraint.activate([
			
			deckStackView.topAnchor.constraint(equalTo: g.topAnchor, constant: 40.0),
			deckStackView.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
			// we'll let the stack view subviews determine its size

			deckPileView.widthAnchor.constraint(equalToConstant: cardSize.width),
			deckPileView.heightAnchor.constraint(equalToConstant: cardSize.height),

			cardPositionView.topAnchor.constraint(equalTo: deckStackView.bottomAnchor, constant: 100.0),
			cardPositionView.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			cardPositionView.widthAnchor.constraint(equalToConstant: cardSize.width + 2.0),
			cardPositionView.heightAnchor.constraint(equalToConstant: cardSize.height + 2.0),
			
		])
		
		// outline the card holder view
		cardPositionView.backgroundColor = .systemYellow
		cardPositionView.layer.borderColor = UIColor.blue.cgColor
		cardPositionView.layer.borderWidth = 2
		
		// make the "deck card" gray to represent the deck
		deckPileView.backgroundColor = .lightGray
	}
	
	func animCard() {
		
		let card = CardView()
		card.backgroundColor = colors[colorIDX % colors.count]
		colorIDX += 1
		
		card.translatesAutoresizingMaskIntoConstraints = false
		
		card.widthAnchor.constraint(equalToConstant: cardSize.width).isActive = true
		card.heightAnchor.constraint(equalToConstant: cardSize.height).isActive = true
		
		view.addSubview(card)

		// center the new card on the deckCard
		animXAnchor = card.centerXAnchor.constraint(equalTo: deckPileView.centerXAnchor)
		animYAnchor = card.centerYAnchor.constraint(equalTo: deckPileView.centerYAnchor)
		
		// activate those constraints
		animXAnchor.isActive = true
		animYAnchor.isActive = true
		
		// run the animation *after* the card has been placed at its starting position
		DispatchQueue.main.async {
			// de-activate the current constraints
			self.animXAnchor.isActive = false
			self.animYAnchor.isActive = false
			// center the new card on the cardPositionView
			self.animXAnchor = card.centerXAnchor.constraint(equalTo: self.cardPositionView.centerXAnchor)
			self.animYAnchor = card.centerYAnchor.constraint(equalTo: self.cardPositionView.centerYAnchor)
			// re-activate those constraints
			self.animXAnchor.isActive = true
			self.animYAnchor.isActive = true
			// 1/2 second animation
			UIView.animate(withDuration: 0.5, animations: {
				self.view.layoutIfNeeded()
			})
		}

	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		animCard()
	}
	
}
