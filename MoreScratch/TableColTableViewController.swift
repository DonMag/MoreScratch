//
//  TableColTableViewController.swift
//  MoreScratch
//
//  Created by Don Mag on 4/18/22.
//

import UIKit

struct SomeDataStruct {
	var color: UIColor = .white
	var num: Int = 0
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
        return cell
    }
}

class SomeTableCell: UITableViewCell {
	@IBOutlet var rowTitleLabel: UILabel!
	@IBOutlet var collectionView: UICollectionView!
	var thisData: SomeDataStruct = SomeDataStruct() {
		didSet {
			collectionView.reloadData()
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
}
class SomeCollectionCell: UICollectionViewCell {
	@IBOutlet var label: UILabel!
}
