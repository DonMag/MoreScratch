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
