//
//  MapPreviewViewController.swift
//  MoreScratch
//
//  Created by Don Mag on 4/13/22.
//

import UIKit

class MapPreviewViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
/*
	func initMapDataUserView() {
		guard let mapInfoJson = decodeMapInfo(with: "MapBoxUrl") else {
			return
		}
		
		let position = CGPoint.init(x: mapInfoJson.rasterXYsize.first!, y: mapInfoJson.rasterXYsize.last!)
		let pointerVal: UnsafePointer<Int8>? = NSString(string: mapInfoJson.projection).utf8String
		let decoder = GeoDecode()
		decoder.fetchPdfCoordinateBounds(with: position, projection: pointerVal, initialTransform: mapInfoJson.geotransform) { coordinate, error in
			if let error = error {
				debugPrint(error)
			} else {
				guard let coordinate = coordinate else {
					return
				}
				self.coordinatesUserCurrentLocation = coordinate
				self.initCurrentLocation()
			}
		}
	}
	
	func initPdfView() {
		do {
			let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
			if let path = paths.first {
				let fileURL = URL(fileURLWithPath: path).appendingPathComponent("MapBoxUrl")
				let document = try PDFDocument.init(at: fileURL)
				viewPDFController?.page = try document.page(0)
				viewPDFController?.scrollDelegates = self
				viewPDFController?.scrollView.layoutSubviews()
			}
		} catch {
			print(error.localizedDescription)
		}
	}
	
	
	func decodeMapInfo(with value: String) -> MapInfoJson? {
		do {
			guard let valueData = value.data(using: .utf8) else {
				return nil
			}
			let decodedResult = try JSONDecoder().decode(MapInfoJson.self, from: valueData)
			return decodedResult
		} catch {
			print("error: ", error)
		}
		return nil
	}
*/
}

/*
extension MapPreviewViewController: scrollViewActions {
	
	func scrollViewScroll(_ sender: UIScrollView) {
		let visibleRect = CGRect.init(x: sender.contentOffset.x, y: sender.contentOffset.y, width: sender.contentSize.width*sender.zoomScale, height: sender.contentSize.height*sender.zoomScale)
		self.visibleScrollViewRectUserScreen = visibleRect
		self.zooomLevelScrollView = sender.zoomScale
		if coordinatesUserCurrentLocation != nil {
			updateMarkerVisiblityOnPdfView()
		}
	}
}


extension MapPreviewViewController: CLLocationManagerDelegate {
	
	func initCurrentLocation() {
		locationManagerUserTest.delegate = self
		locationManagerUserTest.desiredAccuracy = kCLLocationAccuracyBest
		locationManagerUserTest.requestAlwaysAuthorization()
		
		if CLLocationManager.locationServicesEnabled() {
			locationManagerUserTest.desiredAccuracy = kCLLocationAccuracyBest
			locationManagerUserTest.startUpdatingLocation()
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
		self.currentLocationUser = locValue
		updateMarkerVisiblityOnPdfView()
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		
	}
	
	func updateMarkerVisiblityOnPdfView() {
		guard let locValue: CLLocationCoordinate2D = self.currentLocationUser else { return }
		guard let coordinates = coordinatesUserCurrentLocation else { return }
		
		let yFactor = (locValue.longitude - coordinates.minY) / (coordinates.maxY - coordinates.minY)
		let xFactor = (coordinates.maxX - locValue.latitude) / (coordinates.maxX - coordinates.minX)
		
		var positionX: Double = 0.0
		var positionY: Double = 0.0
		
		positionX = (yFactor*Double(visibleScrollViewRectUserScreen!.size.width))/Double(self.zooomLevelScrollView!)
		positionY = (xFactor*Double(visibleScrollViewRectUserScreen!.size.height))/Double(self.zooomLevelScrollView!)
		
		if visibleScrollViewRectUserScreen!.size.width < 1.0 {
			positionX = (yFactor*Double(18))*Double(self.zooomLevelScrollView!)
			positionY = (xFactor*Double(18))*Double(self.zooomLevelScrollView!)
		}
		
		var indexOfExistingImageView: Int?
		
		for index in 0..<viewPDFController!.scrollView.subviews.count {
			if let imageview = viewPDFController!.scrollView.subviews[index] as? UIImageView {
				if imageview.image == currentmarkerImagView.image {
					indexOfExistingImageView = index
				}
			}
		}
		
		self.currentmarkerImagView.center = .init(x: positionX, y: positionY)
		self.viewPDFController!.scrollView.addSubview(currentmarkerImagView)
		self.viewPDFController!.scrollView.bringSubviewToFront(currentmarkerImagView)
		
	}
}


public protocol scrollViewActions {
	func scrollViewScroll(_ sender: UIScrollView)
}

public class PdfViewViewController: UIViewController {
	public var scrollView: UIScrollView!
	public var overlayView: UIView!
	public var contentView: UIView!
	public var scrollDelegates: scrollViewActions?
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		
		scrollView.delegate = self
		scrollView.contentInsetAdjustmentBehavior = .never
	}
}

extension PdfViewViewController: UIScrollViewDelegate {
	public func scrollViewDidScroll(_ scrollView: UIScrollView) {
		scrollDelegates?.scrollViewScroll(scrollView)
	}
	
	public func scrollViewDidZoom(_ scrollView: UIScrollView) {
		scrollDelegates?.scrollViewScroll(scrollView)
	}
	
	public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		scrollDelegates?.scrollViewScroll(scrollView)
	}
	
	public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
	}
	
	public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
	}
	
	public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
	}
}
*/

