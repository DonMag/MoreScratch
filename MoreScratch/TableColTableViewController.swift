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
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("collectionView didSelecteItemAt:", indexPath)
		print("Calling closure...")
		didSelectClosure?(self)
	}
}
class SomeCollectionCell: UICollectionViewCell {
	@IBOutlet var label: UILabel!
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
