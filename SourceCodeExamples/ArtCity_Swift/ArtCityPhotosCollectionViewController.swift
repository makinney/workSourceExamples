//
//  ArtCityPhotosCollectionViewController.swift
//  ArtCity
//
//  Created by Michael Kinney on 2/3/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import UIKit
import CoreData


class ArtCityPhotosCollectionViewController: UICollectionViewController, UINavigationControllerDelegate {

	private let artPhotosByLocation:ArtPhotosByLocation
	private let artPhotoImages = ArtPhotoImages.sharedInstance
	private let artPhotoCache = ArtPhotoCache()
	private var error:NSError?
	private let moc  = CoreDataStack.sharedInstance.managedObjectContext
	private let fetcher: Fetcher
	private var artPhotoCollectionViewFlowLayout: ArtPhotosCollectionViewFlowLayout?
	private var usingArtPhotosFullScreenFlowLayout = false // 
	private var userInterfaceIdion: UIUserInterfaceIdiom = .Phone

	override init(collectionViewLayout: UICollectionViewLayout) {
		fetcher = Fetcher(managedObjectContext: self.moc!)
		artPhotosByLocation = ArtPhotosByLocation(fetcher: fetcher)
		super.init(collectionViewLayout: collectionViewLayout)
		self.useLayoutToLayoutNavigationTransitions = false
	}
	
	required init(coder aDecoder: NSCoder) {
		fetcher = Fetcher(managedObjectContext: self.moc!)
		artPhotosByLocation = ArtPhotosByLocation(fetcher: fetcher)
		super.init(coder:aDecoder)
	}
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.interactivePopGestureRecognizer.enabled = false
		navigationController?.delegate = self
	
		var nibName = UINib(nibName: "ArtworkCollectionViewCell", bundle: nil) // TODO:
		self.collectionView?.registerNib(nibName, forCellWithReuseIdentifier: "ArtworkCollectionViewCell")
		var subNibName = UINib(nibName: "ArtCitySupplementaryView", bundle: nil) // TODO:
		self.collectionView?.registerNib(subNibName, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ArtCitySupplementaryView")
		
		setupArtCityPhotosFlowLayout()
		
		NSNotificationCenter.defaultCenter().addObserver(self,
														selector:"newArtCityDatabase:",
															name: ArtAppNotifications.NewArtCityDatabase.rawValue,
														  object: nil)

		
		NSNotificationCenter.defaultCenter().addObserver(self,
														selector: "contentSizeCategoryDidChange",
															name: UIContentSizeCategoryDidChangeNotification,
														  object: nil)
		
		collectionView?.reloadData()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		collectionView?.backgroundColor = UIColor.whiteColor()
		self.navigationController?.navigationBar.topItem?.title = "Photos"
		usingArtPhotosFullScreenFlowLayout = false
		collectionView?.pagingEnabled = false
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		collectionView?.reloadData()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func setupArtCityPhotosFlowLayout() {
		if let collectionViewFlowLayout: UICollectionViewFlowLayout = collectionViewLayout? as? UICollectionViewFlowLayout {
			collectionViewFlowLayout.scrollDirection = .Vertical
			let screenWidth = UIScreen.mainScreen().coordinateSpace.bounds.width ?? 320 // TODO:
			collectionViewFlowLayout.headerReferenceSize = CGSize(width: screenWidth, height: 30)

			collectionViewFlowLayout.minimumLineSpacing = 5.0
			let itemSpacing: CGFloat = 2.0
			collectionViewFlowLayout.minimumInteritemSpacing = itemSpacing
			var minimumPhotosPerLine = 0 // ultimately up to flow layout
			
			userInterfaceIdion = traitCollection.userInterfaceIdiom
			if userInterfaceIdion == .Phone || userInterfaceIdion == .Unspecified {
				minimumPhotosPerLine = 4
				var photoWidth = calculatePhotoWidth(screenWidth, photosPerLine: minimumPhotosPerLine, itemSpacing: itemSpacing, flowLayout: collectionViewFlowLayout)
				collectionViewFlowLayout.itemSize = CGSize(width: photoWidth, height: photoWidth)
			} else {
				minimumPhotosPerLine = 6
				var photoWidth = calculatePhotoWidth(screenWidth, photosPerLine: minimumPhotosPerLine, itemSpacing: itemSpacing, flowLayout: collectionViewFlowLayout)
				collectionViewFlowLayout.itemSize = CGSize(width: photoWidth, height: photoWidth)
			}
		}
	}
	
	func calculatePhotoWidth(screenWidth: CGFloat, photosPerLine: Int, itemSpacing: CGFloat, flowLayout:UICollectionViewFlowLayout ) -> CGFloat {
		let numPhotos: CGFloat = CGFloat(photosPerLine)
		var totalInterItemSpacing: CGFloat = 0.0
		var totalInsetSpacing: CGFloat = 0.0
		var totalSpacing: CGFloat = 0.0
		var spaceLeftForPhotos: CGFloat = 0.0
		var photoWidth: CGFloat = 0.0
		
		totalInterItemSpacing = numPhotos * itemSpacing
		totalInsetSpacing = flowLayout.sectionInset.left + flowLayout.sectionInset.right
		totalSpacing = totalInterItemSpacing + totalInsetSpacing
		spaceLeftForPhotos = screenWidth - totalSpacing
		photoWidth = spaceLeftForPhotos / numPhotos
		return photoWidth
	}

	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier.ArtworkCollectionViewCell.rawValue, forIndexPath: indexPath) as ArtworkCollectionViewCell
		cell.title.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody) // TODO: has to be a better way
		// TODO: need weakself all through the code !!!
		let afileName = self.artPhotosByLocation.photoFileName(indexPath.section, photoIndex: indexPath.row)!
		if let image = artPhotoCache.getImageFor(afileName) {
			cell.imageView.image = image
			cell.title.alpha = 0.0
			cell.title.text = ""
			if self.usingArtPhotosFullScreenFlowLayout && self.traitCollection.verticalSizeClass == .Regular {
				cell.title.alpha = 1.0
				cell.title.text = " " + self.artPhotosByLocation.photoTitle(indexPath.section, photoIndex: indexPath.row) +  " at " + self.artPhotosByLocation.locationName(indexPath.section) + " "
			}
		} else {
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
				let bfileName = self.artPhotosByLocation.photoFileName(indexPath.section, photoIndex: indexPath.row)
				let image = self.artPhotosByLocation.photoImage(indexPath.section, photoIndex: indexPath.row)
				dispatch_async(dispatch_get_main_queue(), {
					self.artPhotoCache.addImage(image!, name: bfileName!) // TODO: might be nil
					cell.imageView.image = image
					cell.title.alpha = 0.0
					cell.title.text = ""
					if self.usingArtPhotosFullScreenFlowLayout && self.traitCollection.verticalSizeClass == .Regular {
						cell.title.alpha = 1.0
						cell.title.text = " " + self.artPhotosByLocation.photoTitle(indexPath.section, photoIndex: indexPath.row) +  " at " + self.artPhotosByLocation.locationName(indexPath.section) + " "
					}
				})
			
			})
		
		}
		return cell
	}
	
	override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
		var supplementaryView: UICollectionReusableView = UICollectionReusableView()
		if kind == UICollectionElementKindSectionHeader {
			supplementaryView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "ArtCitySupplementaryView", forIndexPath: indexPath) as UICollectionReusableView // TODO:
			if let supplementaryView = supplementaryView as? ArtCitySupplementaryView {
				supplementaryView.label.text = artPhotosByLocation.locationName(indexPath.section)
				supplementaryView.label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody) // TODO: has to be a better way
				supplementaryView.label.textColor = UIColor.blackColor()
			}
		}
		return supplementaryView
	}
	
	override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return artPhotosByLocation.locationsCount
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return artPhotosByLocation.photosCount(section)
	}
	
	// MARK: ArtPhotos Navigation
	
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		navigationController?.pushViewController(newArtPhotosFullScreenCollectionViewController(indexPath), animated: true)
	}
	

	func newArtPhotosFullScreenCollectionViewController(indexPath: NSIndexPath) -> UICollectionViewController {
		artPhotoCollectionViewFlowLayout = ArtPhotosCollectionViewFlowLayout()
		collectionView?.pagingEnabled = true
		artPhotoCollectionViewFlowLayout!.scrollDirection = .Horizontal
		artPhotoCollectionViewFlowLayout!.minimumLineSpacing = 0.0 // critical for correct horizontal paging
		setupArtPhotosFullScreenItemSize(artPhotoCollectionViewFlowLayout!)
		
		var artPhotosCollectionViewController = ArtPhotosCollectionViewController(collectionViewLayout: artPhotoCollectionViewFlowLayout)
		artPhotosCollectionViewController.selectedIndexPath = indexPath
		artPhotosCollectionViewController.useLayoutToLayoutNavigationTransitions = true
		usingArtPhotosFullScreenFlowLayout = true
		return artPhotosCollectionViewController
	}
	
	func setupArtPhotosFullScreenItemSize(flowLayout: UICollectionViewFlowLayout) {
		artPhotoCollectionViewFlowLayout!.sectionInset.left = 0
		artPhotoCollectionViewFlowLayout!.sectionInset.right =  0

		var navBarHeight = navigationController?.navigationBar.frame.size.height ?? 0
		var tabBarHeight = tabBarController?.tabBar.frame.size.height ?? 0
		var statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height ?? 0
		var collectionViewHeight = collectionView?.frame.height ?? 0
		var collectionViewWidth = collectionView?.frame.width ?? 0
		
		var height = collectionViewHeight - navBarHeight - tabBarHeight - statusBarHeight - flowLayout.sectionInset.top - flowLayout.sectionInset.bottom
		var width = UIScreen.mainScreen().coordinateSpace.bounds.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right
		flowLayout.itemSize = CGSize(width: width, height: height)
		
	}
	
	override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
		
		if let artPhotoCollectionViewFlowLayout = self.artPhotoCollectionViewFlowLayout {
				artPhotoCollectionViewFlowLayout.currentPage = collectionView!.contentOffset.x / collectionView!.bounds.width
		}

		coordinator.animateAlongsideTransitionInView(view, animation: { (context) -> Void in
			if let artPhotoCollectionViewFlowLayout = self.artPhotoCollectionViewFlowLayout {
				self.setupArtPhotosFullScreenItemSize(artPhotoCollectionViewFlowLayout)
			}
	
		}) { (context) -> Void in
			var i = 0.0
		}
	}
	
	// MARK: Notification handlers
	
	func contentSizeCategoryDidChange() {
		collectionView?.reloadData()
	}
	
	func newArtCityDatabase(notification: NSNotification) {
		collectionView?.reloadData()
	}
	
	// MARK: Misc
	func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
//		self.collectionView?.alpha = 0.0
	}
	
	func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
//		self.collectionView?.alpha = 1.0
	}
	
}

