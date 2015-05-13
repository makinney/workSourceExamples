//
//  Fetcher.swift
//  City Art San Francisco
//
//  Created by Michael Kinney on 12/2/14.
//  Copyright (c) 2014 mkinney. All rights reserved.
//

import Foundation
import CoreData
 
class Fetcher {
	
	let moc:NSManagedObjectContext

	init(managedObjectContext moc:NSManagedObjectContext) {
		self.moc = moc
	}
	
	func fetchAllArt() -> [Art] {
		var art = [Art]()
		let fetchRequest = NSFetchRequest()
		fetchRequest.entity = NSEntityDescription.entityForName(ModelEntity.art, inManagedObjectContext:moc)
		var error:NSError? = nil
		var fetchedObjects = moc.executeFetchRequest(fetchRequest, error:&error)
		if(error == nil) {
			art = fetchedObjects as [Art]
		} else {
			DLog(error!.description)
		}
		return art
	}
	
	func fetchAllArtWithPhotos() -> [Art] {
		var art = [Art]()
		let fetchRequest = NSFetchRequest()
		fetchRequest.entity = NSEntityDescription.entityForName(ModelEntity.art, inManagedObjectContext:moc)
		fetchRequest.predicate = NSPredicate(format:"%K != %@", "thumbFile", "")

		var error:NSError? = nil
		var fetchedObjects = moc.executeFetchRequest(fetchRequest, error:&error)
		if(error == nil) {
			art = fetchedObjects as [Art]
		} else {
			DLog(error!.description)
		}
		return art
	}
	
	func fetchArt(idArt:String) -> (Art?) {
		var art:Art?
		let fetchRequest = NSFetchRequest()
		fetchRequest.entity = NSEntityDescription.entityForName(ModelEntity.art, inManagedObjectContext:moc)
		fetchRequest.predicate = NSPredicate(format:"%K == %@", "idArt", idArt) // TODO: define
		
		var error:NSError? = nil
		var fetchedObjects = moc.executeFetchRequest(fetchRequest, error:&error)
		if(error == nil) {
			if fetchedObjects?.count > 0 {
				art = fetchedObjects?.last as? Art
			}
		} else {
			DLog(error!.description)
		}
		return art
	}
	
	func fetchArtFor(idLocation:String) -> ([Art]?) {
		var art:[Art]?
		let fetchRequest = NSFetchRequest()
		fetchRequest.entity = NSEntityDescription.entityForName(ModelEntity.art, inManagedObjectContext:moc)
		fetchRequest.predicate = NSPredicate(format:"%K == %@", "idLocation", idLocation) // TODO: define
		
		var error:NSError? = nil
		var fetchedObjects = moc.executeFetchRequest(fetchRequest, error:&error)
		if(error == nil) {
			if fetchedObjects?.count > 0 {
				art = fetchedObjects as? [Art]
			}
		} else {
			DLog(error!.description)
		}
		return art
	}
	
	func fetchArtWithPhotosForLocation(idLocation: String, sorted: Bool = true) -> ([Art]?) {
		var art:[Art]?
		let fetchRequest = NSFetchRequest()
		fetchRequest.entity = NSEntityDescription.entityForName(ModelEntity.art, inManagedObjectContext:moc)
		if sorted {
			let sortDescriptor = NSSortDescriptor(key:ModelAttributes.artworkTitle, ascending:true)
			fetchRequest.sortDescriptors = [sortDescriptor]
		}
		
		var locationPredicate = NSPredicate(format:"%K == %@", "idLocation", idLocation)
		var thumbPredicate = NSPredicate(format:"%K != %@", "thumbFile", "")
		var predicateArray = [locationPredicate!, thumbPredicate!]
		var compound = NSCompoundPredicate.andPredicateWithSubpredicates(predicateArray)
		fetchRequest.predicate = compound
		var error:NSError? = nil
		var fetchedObjects = moc.executeFetchRequest(fetchRequest, error:&error)
		if(error == nil) {
			if fetchedObjects?.count > 0 {
				art = fetchedObjects as? [Art]
			}
		} else {
			DLog(error!.description)
		}
		return art
	}
	
	func fetchLocation(idLocation:String) -> (Location?) {
		var location:Location?
		let fetchRequest = NSFetchRequest()
		fetchRequest.entity = NSEntityDescription.entityForName(ModelEntity.location, inManagedObjectContext:moc)
		fetchRequest.predicate = NSPredicate(format:"%K == %@", "idLocation", idLocation) // TODO: define
		
		var error:NSError? = nil
		var fetchedObjects = moc.executeFetchRequest(fetchRequest, error:&error)
		if(error == nil) {
			if fetchedObjects?.count > 0 {
				location = fetchedObjects?.last as? Location
			}
		} else {
			DLog(error!.description)
		}
		return location
	}
	
	func fetchAllLocations(sorted: Bool = true) -> ([Location]?) {
		var locations:[Location]?
		let fetchRequest = NSFetchRequest()
		fetchRequest.entity = NSEntityDescription.entityForName(ModelEntity.location, inManagedObjectContext:moc)
		if sorted {
			let sortDescriptor = NSSortDescriptor(key:ModelAttributes.locationName, ascending:true)
			fetchRequest.sortDescriptors = [sortDescriptor]
		}		
		var error:NSError? = nil
		var fetchedObjects = moc.executeFetchRequest(fetchRequest, error:&error)
		if(error == nil) {
			locations = fetchedObjects as? [Location]
		} else {
			DLog(error!.description)
		}
		return locations
	}
	
	func fetchAllLocationsHavingArtWithPhotos(sorted: Bool = true) -> ([Location]?) {
		var locationsWithArtPhotos: [Location] = []
		if let locations = fetchAllLocations() {
			for location in locations {
				if let art = fetchArtWithPhotosForLocation(location.idLocation) {
					locationsWithArtPhotos.append(location)
				}
			}
		}
		return locationsWithArtPhotos
	}


	func fetchLocationPhotosFor(idLocation:String) -> ([LocationPhoto]?) {
		var locationPhotos:[LocationPhoto]?
		let fetchRequest = NSFetchRequest()
		fetchRequest.entity = NSEntityDescription.entityForName(ModelEntity.locationPhoto, inManagedObjectContext:moc)
		fetchRequest.predicate = NSPredicate(format:"%K == %@", "idLocation", idLocation) // TODO: define
		
		var error:NSError? = nil
		var fetchedObjects = moc.executeFetchRequest(fetchRequest, error:&error)
		if(error == nil) {
			locationPhotos = fetchedObjects as? [LocationPhoto]
		} else {
			DLog(error!.description)
		}
		return locationPhotos
	}
	

	func fetchPhotosFor(idArt:String) -> ([Photo]?) {
		var photos:[Photo]?
		let fetchRequest = NSFetchRequest()
		fetchRequest.entity = NSEntityDescription.entityForName(ModelEntity.photo, inManagedObjectContext:moc)
		fetchRequest.predicate = NSPredicate(format:"%K == %@", "idArt", idArt) // TODO: define
		
		var error:NSError? = nil
		var fetchedObjects = moc.executeFetchRequest(fetchRequest, error:&error)
		if(error == nil) {
			photos = fetchedObjects as? [Photo]
		} else {
			DLog(error!.description)
		}
		return photos
	}
	
	
	func fetchManagedObjsWithIdsMatching(jsonIds: [String], inEntityNamed:String, moc: NSManagedObjectContext) -> [String]? {
		var objectIds = [String]()
		let fetchRequest = NSFetchRequest()
		fetchRequest.entity = NSEntityDescription.entityForName(inEntityNamed, inManagedObjectContext:moc)
		fetchRequest.predicate = NSPredicate(format:"%K IN %@", ModelEntity.objectId, jsonIds)
		
		var error:NSError? = nil
		var fetchedObjects:[AnyObject] = moc.executeFetchRequest(fetchRequest, error:&error)!
		if(error == nil) {
			for obj in fetchedObjects {
				var id = obj.valueForKey(ModelEntity.objectId) as String!
				objectIds += [id]
			}
		} else {
			DLog(error!.description)
		}
		
		if objectIds.count == 0 {
			return nil
		}
		return objectIds
	}
	

	
}
