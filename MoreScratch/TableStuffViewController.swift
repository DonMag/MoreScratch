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

class BasicColViewCell: UICollectionViewCell {
	let label = UILabel()
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	private func commonInit() {
		label.backgroundColor = .yellow
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
