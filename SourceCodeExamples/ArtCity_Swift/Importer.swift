//
//  Importer.swift
//  City Art San Francisco
//
//  Created by Michael Kinney on 11/25/14.
//  Copyright (c) 2014 mkinney. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Importer {

	let coreDataStack:CoreDataStack
	let webService:WebService
	let moc:NSManagedObjectContext
	
	init(webService: WebService, coreDataStack: CoreDataStack) {
		self.webService = webService
		self.coreDataStack = coreDataStack
		self.moc = self.coreDataStack.managedObjectContext!
	}
	
	func getArt(completion: (jsonArt: [JSON]?) -> ()) {
		webService.getJSON(WebServices.EndPoints.art, result: { (json) -> () in
		if let json:AnyObject = json {
				if let jsonArt:[JSON]  = JSON(json)["results"].array {
					completion(jsonArt: jsonArt)
				} else {
					completion(jsonArt: nil)
				}
			} else {
				completion(jsonArt: nil)
			}
		})
	}

	func getNSData(url:String, completion:(data:NSData?) -> ()) {
		webService.getNSData(url, complete: { (data) -> () in
			if let data = data {
				completion(data: data)
			} else {
				completion(data: nil)
			}
		})
	}
	
	func getLocations(completion: (jsonLocation:[JSON]?) -> ()) {
		webService.getJSON(WebServices.EndPoints.locations, result: { (json) -> () in
			if let json:AnyObject = json {
				if let location:[JSON]  = JSON(json)["results"].array {
					completion(jsonLocation:location)
				} else {
					completion(jsonLocation: nil)
				}
			} else {
				completion(jsonLocation: nil)
			}
		})
	}
	
	func getPhotoInfo(completion:(jsonPhotoInfo: [JSON]?) -> ()) {
		webService.getJSON(WebServices.EndPoints.photos, result: { (json) -> () in
			if let json: AnyObject = json {
				if let photoInfo:[JSON]  = JSON(json)["results"].array {
					completion(jsonPhotoInfo:photoInfo)
				} else {
					completion(jsonPhotoInfo: nil)
				}
			} else {
				completion(jsonPhotoInfo: nil)
			}
		})
	}
	
	func getLocationPhotoInfo(completion:(jsonPhotoInfo: [JSON]?) -> ()) {
		webService.getJSON(WebServices.EndPoints.locationPhotos, result: { (json) -> () in
			if let json:AnyObject = json {
				if let photoInfo:[JSON]  = JSON(json)["results"].array {
					completion(jsonPhotoInfo:photoInfo)
				} else {
					completion(jsonPhotoInfo: nil)
				}
			} else {
				completion(jsonPhotoInfo: nil)
			}
		})
	}

	
}