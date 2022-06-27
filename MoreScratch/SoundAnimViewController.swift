//
//  SoundAnimViewController.swift
//  MoreScratch
//
//  Created by Don Mag on 6/17/22.
//

import UIKit

class cvA: UIView {}
class cvB: UIView {}
class ASVVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
	
	let scrollView = UIScrollView()
	let titleLabel = UILabel()
	let containerView = UIView()
	let contentView = UIView()

	let questionImageView = UIImageView()
	let questionTitleLabel = UILabel()
	let questionNumberLabel = UILabel()
	let marksLabel = UILabel()
	let quizOptionsTableView = UITableView()
	
	let instructionStackView = UIStackView()

	let clockImageView = UIImageView()
	let timerLabel = UILabel()


	override func viewDidLoad() {
		super.viewDidLoad()
		
		[scrollView, containerView, contentView, titleLabel, instructionStackView,
		 questionImageView, questionTitleLabel, questionNumberLabel,
		 marksLabel, quizOptionsTableView].forEach { v in
			v.translatesAutoresizingMaskIntoConstraints = false
		}

		//self.scrollView.showsVerticalScrollIndicator = false

		self.view.addSubview(self.scrollView)
		self.scrollView.addSubview(self.containerView)

		self.containerView.addSubview(self.titleLabel)
		self.containerView.addSubview(self.instructionStackView)
		self.containerView.addSubview(self.contentView)
		
		self.contentView.addSubview(self.questionImageView)
		self.contentView.addSubview(self.questionTitleLabel)
		self.contentView.addSubview(self.quizOptionsTableView)
		
		self.questionTitleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

		let verticalStackView = UIStackView(frame: .zero)
		verticalStackView.axis = .vertical
		verticalStackView.addArrangedSubview(self.questionNumberLabel)
		verticalStackView.addArrangedSubview(self.marksLabel)
		self.questionNumberLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
		
		let emptyView = UIView(frame: .zero)
		emptyView.widthAnchor.constraint(equalToConstant: 40).isActive = true
		
		let horizantalStackView = UIStackView(frame: .zero)
		horizantalStackView.axis = .horizontal
		horizantalStackView.addArrangedSubview(emptyView)
		horizantalStackView.addArrangedSubview(self.clockImageView)
		horizantalStackView.addArrangedSubview(self.timerLabel)
		horizantalStackView.spacing = 8

		self.instructionStackView.addArrangedSubview(verticalStackView)
		self.instructionStackView.addArrangedSubview(horizantalStackView)

		let safeGuide = view.safeAreaLayoutGuide
		let layoutGuide = scrollView.contentLayoutGuide
		
		NSLayoutConstraint.activate([

		// all 4 sides of scrollView to view
		self.scrollView.topAnchor.constraint(equalTo: safeGuide.topAnchor),
		self.scrollView.leftAnchor.constraint(equalTo: safeGuide.leftAnchor),
		self.scrollView.rightAnchor.constraint(equalTo: safeGuide.rightAnchor),
		self.scrollView.bottomAnchor.constraint(equalTo: safeGuide.bottomAnchor),
		
		// all 4 sides of containerView to scrollView's Content Layout Guide
		self.containerView.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
		self.containerView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
		self.containerView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
		self.containerView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
		
		// containerView Width to scrollView's Frame Layout Guide
		self.containerView.widthAnchor.constraint(equalTo: self.scrollView.frameLayoutGuide.widthAnchor),
		
		// NO height constraint for containerView
		
		// titleLabel to top of containerView + 16-points "padding"
		self.titleLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 16),
		// titleLabel to leading/trailing of containerView
		self.titleLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
		self.titleLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
		
		// instructionStackView top to titleLabel bottom with 24-points "padding"
		self.instructionStackView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 24),
		// instructionStackView to leading/trailing of containerView with 50-points "padding"
		self.instructionStackView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 50),
		self.instructionStackView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -50),
		
		// clockImageView width and height
		self.clockImageView.widthAnchor.constraint(equalToConstant: 46),
		self.clockImageView.heightAnchor.constraint(equalToConstant: 46),
		
		// contentView top to instructionStackView bottom + 16-points "padding"
		self.contentView.topAnchor.constraint(equalTo: self.instructionStackView.bottomAnchor, constant: 16),
		// contentView to leading/trailing of containerView with 50-points "padding"
		self.contentView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 50),
		self.contentView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -50),
		// contentView bottom to containerView bottom with 16-points "padding"
		self.contentView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -16),
		
		// questionImageView top/leading/trailing to contentView with 8-points "padding"
		self.questionImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
		self.questionImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
		self.questionImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
		// questionImageView height constant
		self.questionImageView.heightAnchor.constraint(equalToConstant: 170),
		
		// questionTitleLabel top to questionImageView bottom + 8-points "padding"
		self.questionTitleLabel.topAnchor.constraint(equalTo: self.self.questionImageView.bottomAnchor, constant: 8),
		// questionTitleLabel leading/trailing to contentView with 8-points "padding"
		self.questionTitleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
		self.questionTitleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
		
		// quizOptionsTableView top to questionTitleLabel + 8-points "padding
		self.quizOptionsTableView.topAnchor.constraint(equalTo: self.questionTitleLabel.bottomAnchor, constant: 8),
		// quizOptionsTableView leading/trailing to contentView with 8-points "padding"
		self.quizOptionsTableView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8),
		self.quizOptionsTableView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8),
		// quizOptionsTableView height constant
		self.quizOptionsTableView.heightAnchor.constraint(equalToConstant: 320),

		// quizOptionsTableView bottom to contentView bottom with 8-points "padding
		self.quizOptionsTableView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8),
		])
		
		// UI element properties
		titleLabel.numberOfLines = 0
		titleLabel.textAlignment = .center
		titleLabel.text = "This is the text for the Title Label which should be able to wrap onto multiple lines."
		
		questionTitleLabel.numberOfLines = 0
		questionTitleLabel.text = "This is the text for the Question Title Label which should be able to wrap onto multiple lines just like the Title Label."
		
		questionNumberLabel.text = "1"
		marksLabel.text = "Marks?"
		
		if let img = UIImage(systemName: "clock.fill") {
			clockImageView.image = img
		}
		if let img = UIImage(systemName: "photo.tv") {
			questionImageView.image = img
		}
		
		quizOptionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "c")
		quizOptionsTableView.dataSource = self
		quizOptionsTableView.delegate = self
		
		// let's give our UI elements some constrasting colors so we can see their frames
		view.backgroundColor = .lightGray
		scrollView.backgroundColor = .red
		containerView.backgroundColor = .systemGreen
		contentView.backgroundColor = .systemBlue
		titleLabel.backgroundColor = .yellow
		questionTitleLabel.backgroundColor = .cyan
		marksLabel.backgroundColor = .green
		clockImageView.backgroundColor = .systemYellow
		questionImageView.backgroundColor = .systemYellow
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 20
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let c = tableView.dequeueReusableCell(withIdentifier: "c", for: indexPath)
		c.textLabel?.text = "\(indexPath)"
		return c
	}

}

class AnotherScrollViewVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let scrollView = UIScrollView()
		let contentView = UIView()
		let topLabel = UILabel()
		let containerView = UIView()
		let imageView = UIImageView()
		let midLabel = UILabel()
		let tableView = UITableView()
		
		[scrollView, contentView, topLabel, containerView, imageView, midLabel, tableView].forEach { v in
			v.translatesAutoresizingMaskIntoConstraints = false
		}
		
		view.addSubview(scrollView)
		
		scrollView.addSubview(contentView)
		
		contentView.addSubview(topLabel)
		contentView.addSubview(containerView)
		
		containerView.addSubview(imageView)
		containerView.addSubview(midLabel)
		containerView.addSubview(tableView)
		
		// respect the safe area
		let safeG = view.safeAreaLayoutGuide
		
		let contentG = scrollView.contentLayoutGuide
		let frameG = scrollView.frameLayoutGuide
		
		NSLayoutConstraint.activate([
			
			// scrollView to all 4 sides of safe area
			scrollView.topAnchor.constraint(equalTo: safeG.topAnchor),
			scrollView.leadingAnchor.constraint(equalTo: safeG.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: safeG.trailingAnchor),
			scrollView.bottomAnchor.constraint(equalTo: safeG.bottomAnchor),

			// contentView to top/leading/trailing/bottom of scroll view's Content Layout Guide
			contentView.topAnchor.constraint(equalTo: contentG.topAnchor),
			contentView.leadingAnchor.constraint(equalTo: contentG.leadingAnchor),
			contentView.trailingAnchor.constraint(equalTo: contentG.trailingAnchor),
			contentView.bottomAnchor.constraint(equalTo: contentG.bottomAnchor),
			
			// contentView width to scroll view's Frame Layout Guide
			contentView.widthAnchor.constraint(equalTo: frameG.widthAnchor),
			
			// NO height constraint for contentView

			// topLabel to top of contentView + 12-points "padding"
			topLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12.0),
			// topLabel to leading/trailing of contentView
			topLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			topLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

			// NO height constraint for topLabel
			
			// containerView top to topLabel bottom + 12-points "padding"
			containerView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 12.0),
			// containerView Leading/Trailing to contentView
			containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			// containerView bottom to contentView bottom - 12-points "padding"
			containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12.0),
			
			// imageView to containerView top/leading/trailing with 12-points "padding"
			imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12.0),
			imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12.0),
			imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12.0),
			// imageView height constant
			imageView.heightAnchor.constraint(equalToConstant: 240.0),
			
			// midLabel top to imageView bottom + 12-points "padding"
			midLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 12.0),
			// midLabel leading/trailing to containerView with 12-points "padding"
			midLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12.0),
			midLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12.0),

			// NO height constraint for midLabel
			
			// tableView top to midLabel bottom + 12-points "padding"
			tableView.topAnchor.constraint(equalTo: midLabel.bottomAnchor, constant: 12.0),
			// tableView leading/trailing/bottom to containerView with 12-points "padding"
			tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12.0),
			tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12.0),
			tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12.0),

			// tableView height constant
			tableView.heightAnchor.constraint(equalToConstant: 400.0),

		])
		
		// UI element properties
		topLabel.numberOfLines = 0
		topLabel.textAlignment = .center
		topLabel.text = "This is the text for the Top Label which should be able to wrap onto multiple lines."

		midLabel.numberOfLines = 0
		midLabel.textAlignment = .center
		midLabel.text = "This is the text for the Middle Label which should be able to wrap onto multiple lines just like the Top Label."
		
		if let img = UIImage(systemName: "photo.tv") {
			imageView.image = img
		}
		
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "c")
		tableView.dataSource = self
		tableView.delegate = self
		
		// let's give our UI elements some constrasting colors so we can see their frames
		view.backgroundColor = .lightGray
		scrollView.backgroundColor = .blue
		contentView.backgroundColor = .systemBlue
		topLabel.backgroundColor = .yellow
		containerView.backgroundColor = .systemYellow
		imageView.backgroundColor = .cyan
		midLabel.backgroundColor = .green
		
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 20
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let c = tableView.dequeueReusableCell(withIdentifier: "c", for: indexPath)
		c.textLabel?.text = "\(indexPath)"
		return c
	}
}

class SoundAnimViewController: UIViewController, UISearchResultsUpdating {

	let loadingView = UIView()
	
    override func viewDidLoad() {
        super.viewDidLoad()

		loadingView.backgroundColor = .blue
		loadingView.frame = CGRect(x: 80, y: 200, width: 160, height: 80)
		view.addSubview(loadingView)
		
		let search = UISearchController(searchResultsController: nil)
		search.searchResultsUpdater = self
		//search.obscuresBackgroundDuringPresentation = false
		search.searchBar.placeholder = "Search Twitter"
		search.automaticallyShowsCancelButton = false
		//search.searchBar.showsBookmarkButton = true
		navigationItem.searchController = search
		let b = UIBarButtonItem(barButtonSystemItem: .trash, target: nil, action: nil)
		navigationItem.rightBarButtonItem = b
    }

	func updateSearchResults(for searchController: UISearchController) {
		guard let text = searchController.searchBar.text else { return }
		print(text)
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		UIView.animate(withDuration: 2.0, delay: 0.0, options: [.repeat, .autoreverse], animations: {
			self.loadingView.alpha = 0
		}, completion: nil)
//		UIView.animate(withDuration: 2.0, delay: 0, options: [.repeat, .autoreverse])
//			self.loadingView.alpha = 0
//
//		}
	}

}

final class SoundView: UIView {
	
	private var numberOfBars: Int = 4
	private var barWidth: CGFloat = 6.0
	private var barHeight: CGFloat = 30.0
	private var barSpace: CGFloat = 3.0
	private var barStopHeight: CGFloat = 2.0
	private let timerSpeed = 0.20
	private let barColor: UIColor = .white
	
	private var timer = Timer()
	
	private var barArray: [UIView] = []
	
	private lazy var barView = UIView(frame: CGRect(x: 23.0, y: 25.0, width: CGFloat(numberOfBars) * barWidth + barSpace * CGFloat((numberOfBars - 1)), height: barHeight))
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		layer.cornerRadius = frame.height / 2
		backgroundColor = .link
		setupSoundView()
		addSubview(barView)
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	private func setupSoundView() {
		for index in 0..<numberOfBars {
			let barInset = barWidth + barSpace
			let bar = UIView(frame: CGRect(x: barInset * CGFloat(index), y: 0.0, width: barWidth, height: barStopHeight))
			bar.layer.cornerRadius = barWidth / 2
			bar.backgroundColor = barColor
			barView.addSubview(bar)
			barArray.append(bar)
		}
		barView.transform = CGAffineTransform(rotationAngle: .pi)
	}
	
	func startSoundBarsAnimation() {
		timer = Timer.scheduledTimer(timeInterval: timerSpeed, target: self, selector: #selector(soundBarAnimation), userInfo: nil, repeats: true)
		RunLoop.main.add(timer, forMode: .common)
	}
	
	func stopSoundBarsAnimation() {
		timer.invalidate()
	}
	
	@objc func soundBarAnimation() {
		UIView.animate(withDuration: 0.35, animations: {
			for bar in self.barArray {
				bar.frame.size.height = CGFloat.random(in: 1.0...self.barHeight)
			}
		})
	}
}

import MediaPlayer
class ZeroViewController: UIViewController {
	var testZero: String = ""
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .red
		print("test Zero:", testZero)
	}
}
class OneViewController: UIViewController {
	var testOne: String = ""
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .blue
		print("test One:", testOne)
	}
}
final class UniversalTypesViewController: UIViewController {
	
	// MARK: Properties
	
	private lazy var soundView = SoundView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
	private let panGestureRecognizer = UIPanGestureRecognizer()
	private var initialOffset: CGPoint = .zero
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let s: String = "What is Lorem Ipsum?\n" +
		"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum." +
		"\n\n" +
		"Why do we use it?\n" +
		"It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like)." +
		"\n\n" +
		"Where does it come from?\n" +
		"Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of \"de Finibus Bonorum et Malorum\" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, \"Lorem ipsum dolor sit amet..\", comes from a line in section 1.10.32." +
		"\n\n" +
		"The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from \"de Finibus Bonorum et Malorum\" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham." +
		"\n\n" +
		"Where can I get some?\n" +
		"There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.\"" +
		"test."
		
		print(s.count)
		
		view.backgroundColor = .systemYellow
		panGestureRecognizer.addTarget(self, action: #selector(soundViewPanned(recognizer:)))
		soundView.addGestureRecognizer(panGestureRecognizer)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		animatedShowSoundView()
	}
	
	private func animatedShowSoundView() {
		// reset soundView's transform
		soundView.transform = .identity
		// add it to the view
		view.addSubview(soundView)
		// position soundView near bottom, but past the right side of view
		soundView.frame.origin = CGPoint(x: view.frame.width, y: view.frame.height - soundView.frame.height * 2.0)
		soundView.startSoundBarsAnimation()

		// animate soundView into view
		UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut) {
			self.soundView.transform = CGAffineTransform(translationX: -self.soundView.frame.width * 2.0, y: 0.0)
		}
	}
	
	private func animatedHideSoundView(toRight: Bool) {
		let translationX = toRight ? view.frame.width : -(view.frame.width + soundView.frame.width)
		UIView.animate(withDuration: 0.5) {
			self.soundView.transform = CGAffineTransform(translationX: translationX, y: 0.0)
		} completion: { isFinished in
			if isFinished {
				self.soundView.removeFromSuperview()
				//self.songPlayer.pause()
			}
		}
	}
	
	var idx: Int = 0
	func openController(index: Int) {
		var vc: UIViewController!
		switch index {
		case 0:
			let viewController = ZeroViewController()
			viewController.testZero = "Hello"
			vc = viewController
		case 1:
			let viewController = OneViewController()
			viewController.testOne = "Goodbye"
			vc = viewController
			// And it keeps going on till case 11
		default:
			return
		}
		self.present(vc, animated: true)
	}
	
	var bvc: Bool = true
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		openController(index: idx % 2)
		idx += 1
		return()
		
		// if soundView is not in the view hierarchy,
		//	animate it into view - animatedShowSoundView() func adds it as a subview
		if soundView.superview == nil {
			animatedShowSoundView()
		} else {
			// unwrap the touch
			guard let touch = touches.first else { return }
			// get touch location
			let loc = touch.location(in: self.view)
			// if touch is inside the soundView frame,
			//	return, so pan gesture can move soundView
			if soundView.frame.contains(loc) { return }
			// if touch is on the left-half of the screen,
			//	animate soundView to the left and remove after animation
			if loc.x < view.frame.midX {
				animatedHideSoundView(toRight: false)
			} else {
				// touch is on the right-half of the screen,
				//	so just remove soundView
				animatedHideSoundView(toRight: true)
			}
		}
	}
	// MARK: Objc methods
	
	@objc private func soundViewPanned(recognizer: UIPanGestureRecognizer) {
		let touchPoint = recognizer.location(in: view)
		switch recognizer.state {
		case .began:
			initialOffset = CGPoint(x: touchPoint.x - soundView.center.x, y: touchPoint.y - soundView.center.y)
		case .changed:
			soundView.center = CGPoint(x: touchPoint.x - initialOffset.x, y: touchPoint.y - initialOffset.y)
		case .ended, .cancelled:
			()
		default: break
		}
	}
	
}


/*
final class UniversalTypesViewController: UIViewController {
	
	// MARK: Properties

	let sideSpacing: CGFloat = 40
	let mediumSpacing: CGFloat = 40
	let screenWidth: CGFloat = 320
	let newIphoneSpacing: CGFloat = 0
	let screenHeight: CGFloat = 480
	
	private lazy var soundViewSide = 80.0
	private lazy var soundViewYCoordinate = view.safeAreaLayoutGuide.layoutFrame.maxY - soundViewSide - sideSpacing
	private lazy var soundView = SoundView(frame: CGRect(x: view.frame.maxX + soundViewSide, y: soundViewYCoordinate - newIphoneSpacing, width: soundViewSide, height: soundViewSide))
	private lazy var notHiddenSoundViewRect = CGRect(x: mediumSpacing, y: 0.0, width: screenWidth - mediumSpacing * 2, height: screenHeight)
	private let panGestureRecognizer = UIPanGestureRecognizer()
	private var initialOffset: CGPoint = .zero
	
	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .yellow // UIColor(named: "backgroundColor")
		panGestureRecognizer.addTarget(self, action: #selector(soundViewPanned(recognizer:)))
		soundView.addGestureRecognizer(panGestureRecognizer)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		animatedShowSoundView()
	}
	override var preferredStatusBarStyle: UIStatusBarStyle {
		return .darkContent
	}
	
	private func animatedShowSoundView() {
		view.addSubview(soundView)
		soundView.startSoundBarsAnimation()
		
		UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut) {
			self.soundView.transform = CGAffineTransform(translationX: -self.soundViewSide * 2 - self.sideSpacing, y: 0.0)
		}
	}
	
	private func animatedHideSoundView(toRight: Bool) {
		let translationX = toRight ? 0.0 : -screenWidth
		UIView.animate(withDuration: 0.5) {
			self.soundView.transform = CGAffineTransform(translationX: translationX, y: 0.0)
		} completion: { isFinished in
			if isFinished {
				//                self.soundView.removeFromSuperview()
				//self.songPlayer.pause()
			}
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
			self.soundView.removeFromSuperview()
		}
	}
	
	/// Distance traveled after decelerating to zero velocity at a constant rate.
	private func project(initialVelocity: CGFloat, decelerationRate: CGFloat) -> CGFloat {
		return (initialVelocity / 1000) * decelerationRate / (1 - decelerationRate)
	}
	
	private func nearestCorner(to point: CGPoint) -> CGPoint {
		var minDistance = CGFloat.greatestFiniteMagnitude
		var nearestPosition = CGPoint.zero
		let halfSoundViewWidth = soundViewSide / 2
		
		let soundViewPositions = [
			CGPoint(x: sideSpacing + halfSoundViewWidth + soundViewSide * 2 + sideSpacing, y: view.frame.minY + sideSpacing + halfSoundViewWidth - newIphoneSpacing),
			CGPoint(x: sideSpacing + halfSoundViewWidth + soundViewSide * 2 + sideSpacing, y: soundViewYCoordinate + halfSoundViewWidth - newIphoneSpacing),
			CGPoint(x: view.frame.maxX - soundViewSide - sideSpacing + halfSoundViewWidth + soundViewSide * 2 + sideSpacing, y: soundViewYCoordinate + halfSoundViewWidth - newIphoneSpacing),
			CGPoint(x: view.frame.maxX - soundViewSide - sideSpacing + halfSoundViewWidth + soundViewSide * 2 + sideSpacing, y: view.frame.minY + sideSpacing + halfSoundViewWidth - newIphoneSpacing)]
		
		for position in soundViewPositions {
			let distance: CGFloat = 200 //point.distance(to: position)
			if distance < minDistance {
				nearestPosition = position
				minDistance = distance
			}
		}
		return nearestPosition
	}
	
	/// Calculates the relative velocity needed for the initial velocity of the animation.
	private func relativeVelocity(forVelocity velocity: CGFloat, from currentValue: CGFloat, to targetValue: CGFloat) -> CGFloat {
		guard currentValue - targetValue != 0 else { return 0 }
		return velocity / (targetValue - currentValue)
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		print(#function)
		guard let touch = touches.first else { return }
		let loc = touch.location(in: self.view)
		if loc.x < 20 && loc.y < 100 {
			animatedHideSoundView(toRight: false)
		}
	}
	// MARK: Objc methods
	
	@objc private func soundViewPanned(recognizer: UIPanGestureRecognizer) {
		let touchPoint = recognizer.location(in: view)
		switch recognizer.state {
		case .began:
			initialOffset = CGPoint(x: touchPoint.x - soundView.center.x, y: touchPoint.y - soundView.center.y)
		case .changed:
			soundView.center = CGPoint(x: touchPoint.x - initialOffset.x, y: touchPoint.y - initialOffset.y)
//			if notHiddenSoundViewRect.minX > soundView.frame.minX {
//				animatedHideSoundView(toRight: false)
//			} else if notHiddenSoundViewRect.maxX < soundView.frame.maxX {
//				animatedHideSoundView(toRight: true)
//			}
		case .ended, .cancelled:
			let decelerationRate = UIScrollView.DecelerationRate.normal.rawValue
			let velocity = recognizer.velocity(in: view)
			let projectedPosition = CGPoint(
				x: soundView.center.x + project(initialVelocity: velocity.x, decelerationRate: decelerationRate),
				y: soundView.center.y + project(initialVelocity: velocity.y, decelerationRate: decelerationRate)
			)
			let nearestCornerPosition = nearestCorner(to: projectedPosition)
			let relativeInitialVelocity = CGVector(
				dx: relativeVelocity(forVelocity: velocity.x, from: soundView.center.x, to: nearestCornerPosition.x),
				dy: relativeVelocity(forVelocity: velocity.y, from: soundView.center.y, to: nearestCornerPosition.y)
			)
			let timingParameters = UISpringTimingParameters(dampingRatio: 0.8, initialVelocity: relativeInitialVelocity)
			let animator = UIViewPropertyAnimator(duration: 0.5, timingParameters: timingParameters)
			animator.addAnimations {
				self.soundView.center = nearestCornerPosition
			}
			animator.startAnimation()
		default: break
		}
	}
	
	@objc func backButtonAction(_ sender: UIButton) {
		navigationController?.popViewController(animated: true)
	}
}
*/
/*
extension UniversalTypesViewController: UITableViewDataSource, UITableViewDelegate {
	
	// MARK: UITableViewDataSource, UITableViewDelegate
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		var numberOfSections = 0
		switch universalTypeIdentifier {
		case .dishIdentifier:
			numberOfSections = DishManager.dishesTypes.count
		case .traditionIdentifier:
			numberOfSections = TraditionManager.traditionsTypes.count
		case .placeIdentifier:
			break
		case .languageIdentifier:
			break
		case .musicIdentifier:
			numberOfSections = artist.songs.count
		case .none:
			break
		}
		return numberOfSections
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let universalTypeTableViewCell = universalTypesTableView.dequeueReusableCell(withIdentifier: "UniversalTypeTableViewCell", for: indexPath) as! UniversalTypeTableViewCell
		
		switch universalTypeIdentifier {
		case .dishIdentifier:
			universalTypeTableViewCell.setupDishTypeCell(dishType: DishManager.dishesTypes[indexPath.section])
		case .traditionIdentifier:
			universalTypeTableViewCell.setupTraditionTypeCell(traditionType: TraditionManager.traditionsTypes[indexPath.section])
		case .placeIdentifier:
			break
		case .languageIdentifier:
			break
		case .musicIdentifier:
			universalTypeTableViewCell.setupSongCell(song: artist.songs[indexPath.section])
		case .none:
			break
		}
		
		return universalTypeTableViewCell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if universalTypeIdentifier == .dishIdentifier {
			showUnivarsalItemsViewController(controllerTitle: DishManager.dishesTypes[indexPath.section].title, universalTypeIdentifier: .dishIdentifier)
		} else if universalTypeIdentifier == .traditionIdentifier {
			showUnivarsalItemsViewController(controllerTitle: TraditionManager.traditionsTypes[indexPath.section].title, universalTypeIdentifier: .traditionIdentifier)
		} else if universalTypeIdentifier == .musicIdentifier {
			setupPlayer(songName: artist.songs[indexPath.section].title)
			songPlayer.play()
		}
	}
	
	private func showUnivarsalItemsViewController(controllerTitle: String, universalTypeIdentifier: UniversalTypeIdentifier) {
		let univarsalItemsViewController = UnivarsalItemsViewController()
		univarsalItemsViewController.modalPresentationStyle = .fullScreen
		univarsalItemsViewController.controllerTitle = controllerTitle
		univarsalItemsViewController.universalTypeIdentifier = universalTypeIdentifier
		navigationController?.pushViewController(univarsalItemsViewController, animated: true)
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let headerView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: headerViewLabel.frame.height + smallSpacing))
		headerView.addSubview(headerViewLabel)
		return headerView
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return section == 0 && universalTypeIdentifier != .musicIdentifier ? headerViewLabel.frame.height + smallSpacing : 0.0
	}
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return UIView()
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return smallSpacing
	}
}

extension UniversalTypesViewController: AVAudioPlayerDelegate {
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		if soundView.frame.minX == sideSpacing {
			animatedHideSoundView(toRight: false)
		} else if soundView.frame.maxX == screenWidth - sideSpacing {
			animatedHideSoundView(toRight: true)
		}
		soundView.stopSoundBarsAnimation()
	}
}
*/

class StackAlignVC: UIViewController {
	
	@IBOutlet var stackView: UIStackView!
	
	@IBOutlet var holderView: UIView!
	
	@IBOutlet var btnLeadingC: NSLayoutConstraint!
	@IBOutlet var btnCenterC: NSLayoutConstraint!
	@IBOutlet var btnTrailingC: NSLayoutConstraint!
	
	@IBAction func segChanged(_ sender: UISegmentedControl) {
		[btnLeadingC, btnCenterC, btnTrailingC].forEach { c in
			c?.priority = .defaultLow
		}
		switch sender.selectedSegmentIndex {
		case 0:
			stackView.alignment = .leading
			btnLeadingC.priority = .required
		case 1:
			stackView.alignment = .center
			btnCenterC.priority = .required
		case 2:
			stackView.alignment = .trailing
			btnTrailingC.priority = .required
		default:
			()
		}
//		stackView.setNeedsLayout()
//		stackView.layoutIfNeeded()
	}
}

class ImgExtTestVC: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let stack: UIStackView = {
			let v = UIStackView()
			v.axis = .vertical
			v.spacing = 8
			v.translatesAutoresizingMaskIntoConstraints = false
			return v
		}()
		
		let v1 = UIImageView()
		let v2 = UIImageView()
		let v3 = UIImageView()
		let v4 = UIImageView()
		
		[v1, v2, v3, v4].forEach { v in
			v.heightAnchor.constraint(equalTo: v.widthAnchor).isActive = true
			stack.addArrangedSubview(v)
		}
		
		view.addSubview(stack)
		
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			
			stack.topAnchor.constraint(equalTo: g.topAnchor, constant: 40.0),
			stack.widthAnchor.constraint(equalToConstant: 255.0),
			stack.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			
		])

		// swiftRed
		// myTestIMG
		if let img = UIImage(named: "myTestIMG") {
			v1.image = img
			let img2 = img.stroked(with: .green, thickness: 6, quality: 10)
			v2.image = img2
		}

	}
}

public extension UIImage {
	
	/**
	 Returns the flat colorized version of the image, or self when something was wrong
	 
	 - Parameters:
	 - color: The colors to user. By defaut, uses the ``UIColor.white`
	 
	 - Returns: the flat colorized version of the image, or the self if something was wrong
	 */
	func colorized(with color: UIColor = .white) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(size, false, scale)
		
		defer {
			UIGraphicsEndImageContext()
		}
		
		guard let context = UIGraphicsGetCurrentContext(), let cgImage = cgImage else { return self }
		
		
		let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
		
		color.setFill()
		context.translateBy(x: 0, y: size.height)
		context.scaleBy(x: 1.0, y: -1.0)
		context.clip(to: rect, mask: cgImage)
		context.fill(rect)
		
		guard let colored = UIGraphicsGetImageFromCurrentImageContext() else { return self }
		
		return colored
	}
	
	/**
	 Returns the stroked version of the fransparent image with the given stroke color and the thickness.
	 
	 - Parameters:
	 - color: The colors to user. By defaut, uses the ``UIColor.white`
	 - thickness: the thickness of the border. Default to `2`
	 - quality: The number of degrees (out of 360): the smaller the best, but the slower. Defaults to `10`.
	 
	 - Returns: the stroked version of the image, or self if something was wrong
	 */
	
	func stroked(with color: UIColor = .red, thickness: CGFloat = 2, quality: CGFloat = 10) -> UIImage {
		
		guard let cgImage = cgImage else { return self }
		
		// Colorize the stroke image to reflect border color
		let strokeImage = colorized(with: color)
		
		guard let strokeCGImage = strokeImage.cgImage else { return self }
		
		/// Rendering quality of the stroke
		let step = quality == 0 ? 10 : abs(quality)
		
		let oldRect = CGRect(x: thickness, y: thickness, width: size.width, height: size.height).integral
		let newSize = CGSize(width: size.width + 2 * thickness, height: size.height + 2 * thickness)
		let translationVector = CGPoint(x: thickness, y: 0)
		
		
		UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
		
		guard let context = UIGraphicsGetCurrentContext() else { return self }
		
		defer {
			UIGraphicsEndImageContext()
		}
		context.translateBy(x: 0, y: newSize.height)
		context.scaleBy(x: 1.0, y: -1.0)
		context.interpolationQuality = .high
		
		for angle: CGFloat in stride(from: 0, to: 360, by: step) {
			let vector = translationVector.rotated(around: .zero, byDegrees: angle)
			let transform = CGAffineTransform(translationX: vector.x, y: vector.y)
			
			context.concatenate(transform)
			
			context.draw(strokeCGImage, in: oldRect)
			
			let resetTransform = CGAffineTransform(translationX: -vector.x, y: -vector.y)
			context.concatenate(resetTransform)
		}
		
		context.draw(cgImage, in: oldRect)
		
		guard let stroked = UIGraphicsGetImageFromCurrentImageContext() else { return self }
		
		return stroked
	}
}

extension CGPoint {
	/*
	- Parameters:
	- origin: The center of he rotation;
	- byDegrees: Amount of degrees to rotate around the Z axis.
	
	- Returns: The rotated point.
	*/
	func rotated(around origin: CGPoint, byDegrees: CGFloat) -> CGPoint {
		let dx = x - origin.x
		let dy = y - origin.y
		let radius = sqrt(dx * dx + dy * dy)
		let azimuth = atan2(dy, dx) // in radians
		let newAzimuth = azimuth + byDegrees * .pi / 180.0 // to radians
		let x = origin.x + radius * cos(newAzimuth)
		let y = origin.y + radius * sin(newAzimuth)
		return CGPoint(x: x, y: y)
	}
}


class MyButtonCell: UICollectionViewCell{
	@IBOutlet weak var buttonOne: UIButton!
	
	var callback: ((UICollectionViewCell) -> ())?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}
	func commonInit() -> Void {
		contentView.layer.borderWidth = 1
		contentView.layer.borderColor = UIColor.black.cgColor
	}
	
	@IBAction func buttonTapped(_ sender: UIButton) {
		callback?(self)
	}
}

class StevenViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
	
	let buttonTitles: [String] = [
		"One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"
	]
	@IBOutlet var label: UILabel!
	
	@IBOutlet var collectionView: UICollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// before setting
		print(label.appliedContentSizeCategoryLimitsDescription)
		
		label.minimumContentSizeCategory = .small
		label.maximumContentSizeCategory = .accessibilityMedium
		
		// after setting
		print(label.appliedContentSizeCategoryLimitsDescription)
		
		collectionView.delegate = self
		collectionView.dataSource = self
	}
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return buttonTitles.count
	}
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCellID", for: indexPath) as! MyButtonCell
		
		// set the button title (and any other properties)
		cell.buttonOne.setTitle(buttonTitles[indexPath.item], for: [])
		
		// set the cell's callback closure
		cell.callback = { [weak self] theCell in
			guard let self = self,
				  let indexPath = collectionView.indexPath(for: theCell)
			else { return }
			print("Button was tapped at \(indexPath)")
			// do what you want when the button is tapped
		}
		
		return cell
	}
}


class AddPlayerStruct {
	
	var addPlayerViewStruct : PlayerView?
	var addPlayerViewsArrStruct : [PlayerView] = []
	var Label = UILabel()
	
	var playerNumber: Int = 0
}

class AddPlayerViewController: UIViewController {
	
	//MARK: AddPlayerView Variables
	
	// we can declare this as a standard UIView
	var draggedPlayerView: UIView?
	
	let playerViewWidth : CGFloat = 40
	
	@IBOutlet var playingFieldImageView: UIImageView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		playingFieldImageView.isUserInteractionEnabled = true
	}

	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let draggedAddPlayer = draggedPlayerView, let point = touches.first?.location(in: playingFieldImageView) else {
			return
		}
		draggedAddPlayer.center = point
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		// Do nothing if a PlayerView is being dragged
		// or if we do not have a coordinate
		guard draggedPlayerView == nil, let point = touches.first?.location(in: playingFieldImageView) else {
			return
		}
		
		// Do not create new PlayerView if touch is in an existing circle
		// Keep the reference of the (potentially) dragged circle
		//	filter only subviews which are PlayerView class (in case we've added another subview type)
		if let draggedAddPlayer = playingFieldImageView.subviews.filter({ $0 is PlayerView }).filter({ UIBezierPath(ovalIn: $0.frame).contains(point) }).first {
			self.draggedPlayerView = draggedAddPlayer
			return
		}
		
		// Create new PlayerView
		let rect = CGRect(x: point.x - 20, y: point.y - 20, width: playerViewWidth, height: playerViewWidth)
		let newPlayerView = PlayerView(frame: rect)
		
		// give the new player the lowest available number
		//	for example, if we've created numbers:
		//		"1" "2" "3" "4" "5"
		//	we want to assign "6" to the new guy
		//	but... if the user has changed the 3rd player to "12"
		//	we'll have players:
		//		"1" "2" "12" "4" "5"
		//	so we want to assign "3" to the new guy
		let nums = playingFieldImageView.subviews.compactMap{$0 as? PlayerView}.compactMap { $0.playerNumber }
		var newNum: Int = 1
		for i in 1..<nums.count + 2 {
			if !nums.contains(i) {
				newNum = i
				break
			}
		}

		newPlayerView.playerNumber = newNum
		
		// set the double-tap closure
		newPlayerView.gotDoubleTap  = { [weak self] pv in
			guard let self = self else { return }
			self.changePlayerNumber(pv)
		}
		
		playingFieldImageView.addSubview(newPlayerView)
		
		// The newly created view can be immediately dragged
		draggedPlayerView = newPlayerView
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
		draggedPlayerView = nil
	}

	// called when a PlayerView is double-tapped
	func changePlayerNumber(_ playerView: PlayerView) {

		// show data on alertview textfield
		let alert = UIAlertController(title: "Player Number", message: "Enter new player Number", preferredStyle: .alert)

		alert.addTextField { textData in
			textData.text = "\(playerView.playerNumber)"
		}
		
		// get changed data from textfield and update the playerNumber for the PlayerView
		alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
			guard let tf = alert.textFields?.first,
			   let newNumString = tf.text,
			   let newNumInt = Int(newNumString),
				  newNumInt != playerView.playerNumber
			else {
				// user entered something that was not a number, or
				//	tapped OK without changing the number
				return
			}
			// don't allow a duplicate player number
			let nums = self.playingFieldImageView.subviews.compactMap{$0 as? PlayerView}.compactMap { $0.playerNumber }
			if nums.contains(newNumInt) {
				let dupAlert = UIAlertController(title: "Duplicate PLayer Number", message: "Somebody else already has number: \(newNumInt)", preferredStyle: .alert)
				dupAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
					self.changePlayerNumber(playerView)
				}))
				self.present(dupAlert, animated: true)
			} else {
				playerView.playerNumber = newNumInt
			}
		}))
		
		self.present(alert, animated: false)

	}

}

class PlayerView : UIImageView {

	// closure to tell the controller this view was double-tapped
	public var gotDoubleTap: ((PlayerView) -> ())?
	
	public var playerNumber: Int = 0 {
		didSet {
			playerLabel.text = "\(playerNumber)"
		}
	}
	
	private let shapeLayer = CAShapeLayer()
	
	private let playerLabel: UILabel = {
		let v = UILabel()
		v.font = UIFont(name: "Helvetica" , size: 10)
		v.textColor = .white
		v.textAlignment = NSTextAlignment.center
		v.text = "0"
		v.translatesAutoresizingMaskIntoConstraints = false
		return v
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	private func setup() {
		self.isUserInteractionEnabled = true
		self.backgroundColor = .white
		self.tintColor = .systemBlue
		
		if let img = UIImage(named: "player") {
			self.image = img
		} else {
			if let img = UIImage(systemName: "person.fill") {
				self.image = img
			} else {
				self.backgroundColor = .green
			}
		}
		
		// if using as a mask, can be any opaque color
		shapeLayer.fillColor = UIColor.black.cgColor
		
		// assuming you want a "round" view
		//self.layer.addSublayer(shapeLayer)
		self.layer.mask = shapeLayer
		
		// add and constrain the label as a subview
		addSubview(playerLabel)
		NSLayoutConstraint.activate([
			playerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
			playerLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
			playerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5.0),
		])
		
		// add a double-tap gesture recognizer
		let g = UITapGestureRecognizer(target: self, action: #selector(doubleTapHandler(_:)))
		g.numberOfTapsRequired = 2
		addGestureRecognizer(g)
	}
	override func layoutSubviews() {
		// update the mask path here (we have accurate bounds)
		shapeLayer.path = UIBezierPath(ovalIn: bounds).cgPath
	}
	@objc func doubleTapHandler(_ g: UITapGestureRecognizer) {
		// tell the controller we were double-tapped
		gotDoubleTap?(self)
	}
}

class PointsView: UIView {
	var pts: [CGPoint] = []
	let shapeLayer = CAShapeLayer()
	override init(frame: CGRect) {
		super.init(frame: frame)
		commonInit()
	}
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit()
	}
	private func commonInit() {
		shapeLayer.lineWidth = 1
		shapeLayer.strokeColor = UIColor.red.cgColor
		shapeLayer.fillColor = UIColor.clear.cgColor
		layer.addSublayer(shapeLayer)
	}
	override func layoutSubviews() {
		if pts.isEmpty { return }
		let bez = UIBezierPath()
		bez.move(to: pts[0])
		for i in 1..<pts.count {
			bez.addLine(to: pts[i])
		}
		shapeLayer.path = bez.cgPath
	}
}
class EllipsePointVC: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		var pts: [CGPoint] = []
		for i in -180...0 {
			if i % 10 == 0 {
				let pt = pointOnEllipse2(CGPoint(x: 100.0, y: 200.0), radX: 100.0, radY: 200.0, angle: CGFloat(i))
				pts.append(pt)
			}
		}
		print(pts)
		let pv = PointsView()
		pv.translatesAutoresizingMaskIntoConstraints = false
		view.addSubview(pv)
		let g = view.safeAreaLayoutGuide
		NSLayoutConstraint.activate([
			pv.widthAnchor.constraint(equalToConstant: 300.0),
			pv.heightAnchor.constraint(equalToConstant: 600.0),
			pv.centerXAnchor.constraint(equalTo: g.centerXAnchor),
			pv.centerYAnchor.constraint(equalTo: g.centerYAnchor),
		])
		pv.backgroundColor = .systemBlue
		pv.pts = pts
	}
	
	/*
	 
	 */
	func pointOnEllipse2(_ center: CGPoint, radX: CGFloat, radY: CGFloat, angle: CGFloat) -> CGPoint {
		let rad = angle.degreesToRadians
		
//		let rx2 = radX * radX
//		let ry2 = radY * radY
//		let tn = tan(rad)
//		let tn2 = tn * tn
//		var x = (radX * radY) / sqrt(rx2 + ry2 + tn2)
	
//		public PointF GetXYWhenT(float t_rad)
//		{
//			float x = this.Center.X+(this.A*(float)Math.Cos(t_rad));
//			float y = this.Center.Y+(this.B*(float)Math.Sin(t_rad));
//			return new PointF(x, y);
//		}

		let A = radX
		let B = radY
		
		let x = center.x + (A * cos(rad))
		let y = center.y + (B * sin(rad))
		
		return CGPoint(x: x, y: y)
	}
	
	func pointOnEllipse(_ center: CGPoint, radX: CGFloat, radY: CGFloat, angle: CGFloat) -> CGPoint {
		let rad = angle.degreesToRadians
		
		let rx2 = radX * radX
		let ry2 = radY * radY
		let tn = tan(rad)
		let tn2 = tn * tn
		var x = (radX * radY) / sqrt(rx2 + ry2 + tn2)
		if -CGFloat.pi * 0.5 < rad && rad < .pi * 0.5 {
			x = abs(x)
		} else {
			x = -abs(x)
		}
		let y = x * tan(rad)
		return CGPoint(x: x, y: y)
		
//		local rad_angle = math.rad(angle)
//
//		local x = (self.radius_x * self.radius_y) / math.sqrt(
//			(self.radius_y ^ 2) + (self.radius_x ^ 2) * (math.tan(rad_angle) ^ 2)
//		)
//		if (-math.pi * 0.5) < rad_angle and rad_angle < (math.pi * 0.5) then
//			x = math.abs(x)
//			else
//			x = -math.abs(x)
//			end
//
//			local y = x * math.tan(rad_angle)
	}
}


