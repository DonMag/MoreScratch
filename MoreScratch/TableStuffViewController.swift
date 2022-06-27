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

class TagCell: UICollectionViewCell {
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
}

class TagsLayout: UICollectionViewFlowLayout {
	
	var cachedFrames: [[CGRect]] = []
	
	var numRows: Int = 3
	
	let cellSpacing: CGFloat = 20

	override init(){
		super.init()
		commonInit()
	}
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
		commonInit()
	}
	func commonInit() {
		scrollDirection = .horizontal
	}
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//		guard let attributes = super.layoutAttributesForElements(in: rect) else {
//			return nil
//		}

		// we want to force the collection view to ask for the attributes for ALL the cells
		//	instead of the cells in the rect
		var r: CGRect = rect
		// we could probably get and use the max-width from the cachedFrames array...
		//	but let's just set it to a very large value for now
		r.size.width = 50000
		guard let attributes = super.layoutAttributesForElements(in: r) else {
			return nil
		}

		guard let attributesToReturn =  attributes.map( { $0.copy() }) as? [UICollectionViewLayoutAttributes] else {
			return nil
		}

		attributesToReturn.forEach { layoutAttribute in

			let thisRow: Int = layoutAttribute.indexPath.item % numRows
			let thisCol: Int = layoutAttribute.indexPath.item / numRows

			layoutAttribute.frame.origin.x = cachedFrames[thisRow][thisCol].origin.x
		}
		
		return attributesToReturn
	}
}

class OrigTagsLayout: UICollectionViewFlowLayout {
	
	let cellSpacing: CGFloat = 20
	override init(){
		super.init()
		scrollDirection = .horizontal
	}
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
		self.scrollDirection = .horizontal
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
		attributesToReturn.forEach { layoutAttribute in
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

class HorizontalTagColViewVC: UIViewController {
	
	var collectionView: UICollectionView!
	
	var myData: [String] = []
	
	// number of cells that will fit vertically in the collection view
	let numRows: Int = 3
	
	override func viewDidLoad() {
		super.viewDidLoad()

		// let's generate some rows of "tags"
		//	we're using 3 rows for this example
		for i in 0...28 {
			switch i % numRows {
			case 0:
				// top row will have long tag strings
				myData.append("A long tag name \(i)")
			case 1:
				// 2nd row will have short tag strings
				myData.append("Tag \(i)")
			default:
				// 3nd row will have numeric strings
				myData.append("\(i)")
			}
		}
		
		// now we'll pre-calculate the tag-cell widths
		let szCell = TagCell()
		let fitSize = CGSize(width: 1000, height: 50)
		var calcedFrames: [[CGRect]] = Array(repeating: [], count: numRows)
		for i in 0..<myData.count {
			szCell.label.text = myData[i]
			let sz = szCell.systemLayoutSizeFitting(fitSize, withHorizontalFittingPriority: .defaultLow, verticalFittingPriority: .required)
			let r = CGRect(origin: .zero, size: sz)
			calcedFrames[i % numRows].append(r)
		}
		// loop through each "row" setting the origin.x to the
		//	previous cell's origin.x + width + 20
		for row in 0..<numRows {
			for col in 1..<calcedFrames[row].count {
				var thisRect = calcedFrames[row][col]
				let prevRect = calcedFrames[row][col - 1]
				thisRect.origin.x += prevRect.maxX + 20.0
				calcedFrames[row][col] = thisRect
			}
		}

		let fl = TagsLayout()
		// for horizontal flow, this is becomes the minimum-inter-line spacing
		fl.minimumInteritemSpacing = 20
		// we need this so the last cell does not get clipped
		fl.minimumLineSpacing = 20
		// a reasonalbe estimated size
		fl.estimatedItemSize = CGSize(width: 120, height: 50)
		
		// set the number of rows in our custom layout
		fl.numRows = numRows
		// set our calculated frames in our custom layout
		fl.cachedFrames = calcedFrames
		
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: fl)
		
		// so we can see the collection view frame
		collectionView.backgroundColor = .cyan
		
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(collectionView)
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: g.topAnchor, constant: 20.0),
			collectionView.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
			collectionView.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -20.0),
			collectionView.heightAnchor.constraint(equalToConstant: 180.0),
		])
		
		collectionView.register(TagCell.self, forCellWithReuseIdentifier: "cell")
		collectionView.dataSource = self
		collectionView.delegate = self
		
	}
	
}
extension HorizontalTagColViewVC: UICollectionViewDataSource, UICollectionViewDelegate {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return myData.count
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let c = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TagCell
		c.label.text = myData[indexPath.item]
		return c
	}
}


class SelColViewVC: UIViewController {
	
	var collectionView: UICollectionView!
	
	var myData: [String] = []
	
	// use this to track the currently selected item / cell
	var currentSelection: IndexPath!
	
	override func viewDidLoad() {
		super.viewDidLoad()

		let formatter = NumberFormatter()
		formatter.numberStyle = .spellOut

		var numNames: [String] = []

		for i in 0...13 {
			if let nm = formatter.string(from: i as NSNumber) {
				numNames.append("Option \(nm)")
				switch i % 3 {
				case 0:
					myData.append("Option " + nm)
				case 1:
					myData.append(nm)
				default:
					myData.append("\(i)")
				}
			}
		}

		myData = []
		
		for i in 0...28 {
			switch i % 3 {
			case 0:
				myData.append("A long tag name \(i)")
			case 1:
				myData.append("Tag \(i)")
			default:
				myData.append("\(i)")
			}
		}
		
		let szCell = TagCell()
		let fitSize = CGSize(width: 1000, height: 50)
		var xs: [[CGRect]] = [[],[],[]]
		for i in 0..<myData.count {
			szCell.label.text = myData[i]
			let sz = szCell.systemLayoutSizeFitting(fitSize, withHorizontalFittingPriority: .defaultLow, verticalFittingPriority: .required)
			let r = CGRect(origin: .zero, size: sz)
			xs[i % 3].append(r)
		}
		for row in 0..<3 {
			for col in 1..<xs[row].count {
				var thisRect = xs[row][col]
				let prevRect = xs[row][col - 1]
				thisRect.origin.x += prevRect.maxX + 20.0
				xs[row][col] = thisRect
			}
		}
		
		myData = []

		for i in 0...16 {
			myData.append("\(i)")
		}
		
//		var row = 1
//		var col = 0
//		for i in 0..<30 {
//			row = i % 3
//			if row == 0 {
//				col += 1
//			}
//			switch row {
//			case 0:
//				myData.append(numNames[col - 1])
//			case 1:
//				myData.append("Row \(row) - \(col)")
//			default:
//				myData.append("\(row)-\(col)")
//			}
//		}
		
		let flh = UICollectionViewFlowLayout()
		flh.scrollDirection = .horizontal
		flh.estimatedItemSize = CGSize(width: 120, height: 50)
//		fl.minimumLineSpacing = 4
//		fl.minimumInteritemSpacing = 4

		let fl = OrigTagsLayout()
		//let fl = LeftAlignedCollectionViewFlowLayout()
		//fl.scrollDirection = .horizontal
		fl.minimumLineSpacing = 20
		fl.minimumInteritemSpacing = 8
		fl.estimatedItemSize = CGSize(width: 120, height: 50)
//		fl.cachedFrames = xs
		
		collectionView = UICollectionView(frame: .zero, collectionViewLayout: fl)
		//collectionView = UICollectionView(frame: .zero, collectionViewLayout: flh)
		collectionView.backgroundColor = .cyan

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
		collectionView.register(TagCell.self, forCellWithReuseIdentifier: "cell")
		collectionView.dataSource = self
		collectionView.delegate = self
		
		// we want to "pre-select" the first item / cell
//		let idx = IndexPath(item: 0, section: 0)
//		collectionView.selectItem(at: idx, animated: false, scrollPosition: .left)
//
//		// update currentSelection var
//		currentSelection = idx
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
		let c = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TagCell
		c.label.text = myData[indexPath.item]
		return c
	}
//	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//		if currentSelection == indexPath {
//			// user tapped already selected cell, so
//			//	just return
//			print("Tapped Already Selected item:", indexPath.item)
//			return
//		}
//
//		// update currentSelection var
//		currentSelection = indexPath
//
//		print("New Selected item:", indexPath.item)
//		// run code for new selection
//	}
	
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

/*
class ModeOfPaymentTableViewCell: UITableViewCell{
	
	class var identifier: String { return String.className(self) }
	
	let addressDescriptionTextView:UILabel = {
		let textView = UILabel()
		textView.translatesAutoresizingMaskIntoConstraints = false
		textView.textAlignment = .natural
		textView.textColor = .gray
		textView.font = K.FONT.FONT17
		textView.isUserInteractionEnabled = false
		textView.numberOfLines = 0
		return textView
	}()
	
	let otherLabel:UILabel = {
		let lbl = UILabel()
		lbl.translatesAutoresizingMaskIntoConstraints = false
		lbl.textColor = UIColor.black
		lbl.textAlignment = .natural
		lbl.font = K.FONT.FONT17
		return lbl
	}()
	
	let indicatorImage:UIImageView = {
		let imageview = UIImageView()
		imageview.translatesAutoresizingMaskIntoConstraints =  false
		imageview.image = #imageLiteral(resourceName: "Back")
		return imageview
	}()
	
	let cardImage : UIImageView = {
		let imageview = UIImageView()
		imageview.translatesAutoresizingMaskIntoConstraints =  false
		imageview.contentMode = UIView.ContentMode.scaleAspectFit
		return imageview
	}()
	
	var primaryData = [String](){
		didSet{
			setUpDescriptionTextView()
		}
	}
	
	let shimmer = UIView() // ShimmerCellWithOutImage()
	
	var showShimmer = Bool(){
		didSet{
			shimmer.isHidden = !showShimmer
		}
	}
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		shimmer.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(shimmer)
		self.addSubview(addressDescriptionTextView)
		self.addSubview(otherLabel)
		self.addSubview(cardImage)
		self.addSubview(indicatorImage)
		
		self.borderColor = UIColor.groupTableViewBackground
		self.borderWidth = 1
		
		self.backgroundColor = .white
		
		self.selectionStyle = .none
		
		setUpUI()
		
		if Language.type == "en" || Language.type == "en-SA"{
			otherLabel.textAlignment = .right
			indicatorImage.image = #imageLiteral(resourceName: "Next")
		}
		else if Language.type == "ar" || Language.type == "ar-SA" {
			otherLabel.textAlignment = .left
			indicatorImage.image = #imageLiteral(resourceName: "Back")
		}
		else{
			otherLabel.textAlignment = .right
			indicatorImage.image = #imageLiteral(resourceName: "Next")
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("failed to load the frame")
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	override public func layoutSubviews() {
		super.layoutSubviews()
		shimmer.shimmerView.addShimmerAnimation()
	}
	
	
	func setUpDescriptionTextView(){
		
		let leftSideValue = primaryData[0].components(separatedBy: ",")
		
		let attributedText = NSMutableAttributedString()
		
		attributedText.append(NSAttributedString(
			string: "\n" + leftSideValue[0],
			attributes: [
				NSAttributedString.Key.foregroundColor : UIColor.red,
				NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12, weight: .light)
			]
		))

		attributedText.append(NSAttributedString(
			string: "\n" + "\(leftSideValue[1])" + "\n",
			attributes: [
				NSAttributedString.Key.foregroundColor : UIColor.black,
				NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17, weight: .regular)
			]
		))

//		attributedText.append(NSAttributedString(
//			string: "\n" + leftSideValue[0], attributes:
//				[NSAttributedString.Key.foregroundColor :
//
//
//					UIColor(hex:K.COLOR.GRAYTEXTCOLOR),NSAttributedString.Key.font:K.FONT.BOLDFONT12!]))
		
//		attributedText.append(NSAttributedString(
//			string: "\n" + "\(leftSideValue[1])" + "\n", attributes: [NSAttributedString.Key.foregroundColor : UIColor.black,NSAttributedString.Key.font:K.FONT.FONT17!]))
		
		addressDescriptionTextView.attributedText =  attributedText
		if primaryData[1] != " 0.0 " && primaryData[1] != ""{
			//            otherLabel.set(image: UIImage.directionIndicator()!, with: primaryData[1])
			let data = primaryData[1];
			if data == "VISA" || data == "MADA" || data == "MASTER"{
				if data == "VISA" {
					cardImage.image = #imageLiteral(resourceName: "visa")
				}else if data == "MADA"{
					cardImage.image = #imageLiteral(resourceName: "mada")
				}else if data == "MASTER"{
					cardImage.image = #imageLiteral(resourceName: "mascard")
				}else{
					cardImage.image = #imageLiteral(resourceName: "CARDS")
				}
				otherLabel.isHidden = true
				cardImage.isHidden = false
			}else{
				otherLabel.text = data
				otherLabel.isHidden = false
				cardImage.isHidden = true
				
			}
			
			otherLabel.tintColor = .systemBlue // UIColor(hex:K.COLOR.BLUE)
		}else{
			
			
		}
		
		
	}
	
	
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
	
	
	func setUpUI() {
		
		[shimmer.topAnchor.constraint(equalTo: topAnchor,constant: 2),
		 shimmer.leadingAnchor.constraint(equalTo:leadingAnchor, constant: 0),
		 shimmer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
		 shimmer.bottomAnchor.constraint(equalTo: bottomAnchor,constant:-2)].forEach{$0.isActive =  true}
		
		[addressDescriptionTextView.topAnchor.constraint(equalTo: topAnchor,constant: 0),
		 addressDescriptionTextView.leadingAnchor.constraint(equalTo:leadingAnchor, constant: 10),
		 addressDescriptionTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -UIScreen.main.bounds.width/2),
		 addressDescriptionTextView.bottomAnchor.constraint(equalTo: bottomAnchor,constant:0)].forEach{$0.isActive =  true}
		
		
		[otherLabel.topAnchor.constraint(equalTo: topAnchor,constant: 0),
		 otherLabel.leadingAnchor.constraint(equalTo: addressDescriptionTextView.trailingAnchor, constant: 2),
		 otherLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
		 otherLabel.bottomAnchor.constraint(equalTo: bottomAnchor,constant:0)].forEach{$0.isActive =  true}
		
		[cardImage.topAnchor.constraint(equalTo: topAnchor,constant: 0),
		 //         cardImage.leadingAnchor.constraint(equalTo: addressDescriptionTextView.trailingAnchor, constant: 2),
		 cardImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -25),
		 cardImage.bottomAnchor.constraint(equalTo: bottomAnchor,constant:0)].forEach{$0.isActive =  true}
		
		
		[indicatorImage.centerYAnchor.constraint(equalTo: centerYAnchor),
		 indicatorImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
		 indicatorImage.heightAnchor.constraint(equalToConstant: 15),
		 indicatorImage.widthAnchor.constraint(equalToConstant: 10)].forEach{$0.isActive =  true}
		
	}
	
}
*/

class ScaledLabelVC: UIViewController {
	
	let v1 = UILabel()
	let v2 = UILabel()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		[v1, v2].forEach { v in
			v.text = "This is a string."
			v.font = .systemFont(ofSize: 32.0, weight: .regular)
			v.backgroundColor = .yellow
			v.translatesAutoresizingMaskIntoConstraints = false
			view.addSubview(v)
		}
		
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			
			v1.topAnchor.constraint(equalTo: g.topAnchor, constant: 20.0),
			v1.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
			v1.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -20.0),
			
			v2.topAnchor.constraint(equalTo: v1.bottomAnchor, constant: 8.0),
			v2.leadingAnchor.constraint(equalTo: g.leadingAnchor, constant: 20.0),
			v2.trailingAnchor.constraint(equalTo: g.trailingAnchor, constant: -20.0),

		])
		
		v2.transform = CGAffineTransform(scaleX: 1.0, y: 0.5)

	}
	
}
