//
//  PhotoExtension.swift
//  ArtCity
//
//  Created by Michael Kinney on 1/21/15.
//  Copyright (c) 2015 mkinney. All rights reserved.
//

import Foundation

import CoreData

extension Photo {
	
	class func fromJSON(json:JSON) -> (Photo)? {
		//	println("\(__FUNCTION__) \(json)")
		let moc = CoreDataStack.sharedInstance.managedObjectContext!
		
		if let photo = NSEntityDescription.insertNewObjectForEntityForName(ModelEntity.photo, inManagedObjectContext:moc) as? Photo {
			photo.createdAt = json["createdAt"].stringValue
			photo.idArt = json["idArt"].stringValue
			photo.imageFileName = extractImageFileName(json["imageFile"]["name"].stringValue)
			photo.imageFileURL = json["imageFile"]["url"].stringValue
			photo.objectId = json["objectId"].stringValue
			photo.updatedAt = json["updatedAt"].stringValue
			return photo
		}
		return nil
	}
	
	class private func extractImageFileName(source: String) -> String {
		var imageFileName = ""
		let delimiter = "-"
		if let lastDelimiter = source.rangeOfString(delimiter, options: NSStringCompareOptions.BackwardsSearch) {
			imageFileName = source[lastDelimiter.endIndex..<source.endIndex]
		}
		return imageFileName
	}
}