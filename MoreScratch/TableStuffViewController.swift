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
