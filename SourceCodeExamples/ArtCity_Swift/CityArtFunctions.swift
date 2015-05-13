//
//  CityArtFunctions.swift
//  City Art San Francisco
//
//  Created by Michael Kinney on 11/25/14.
//  Copyright (c) 2014 mkinney. All rights reserved.
//

import Foundation


func ascending(s1: String, s2: String) -> Bool {
	return s1 < s2
}

func outsideArtCityMapBoundaries(#latitude: Double, #longitude: Double) -> Bool {
	var withInBoundaries = false
	if latitude < ArtCityMap.minlatitude || latitude > ArtCityMap.maxlatitude {
		return true
	}
	if longitude < ArtCityMap.minlongitude || longitude > ArtCityMap.maxlongitude {
		return true
	}
	return withInBoundaries
}

func mapCoordinates(latitude lat: String, longitude lng: String) -> (latitude: Double, longitude: Double, coordinatesGood: Bool) {
	var latitude = (lat as NSString).doubleValue
	var longitude = (lng as NSString).doubleValue
	var coordinatesGood = true
	if latitude == 0 || longitude == 0 {
		coordinatesGood = false
		latitude = ArtCityMap.NotOnEarthSphereLatitude
		longitude = ArtCityMap.NotOnEarthSphereLongitude
	} else {
		if latitude < 0 { // protect against db sign errors
			latitude = 0 - latitude
		}
		if longitude > 0 { // protect against db sign errors
			longitude = 0 - longitude
		}
		if outsideArtCityMapBoundaries(latitude: latitude, longitude: longitude) {
			coordinatesGood = false
			latitude = ArtCityMap.NotOnEarthSphereLatitude
			longitude = ArtCityMap.NotOnEarthSphereLongitude
		}
	}
	
	return (latitude, longitude, coordinatesGood)
}


func DLog(message: String, function: String = __FUNCTION__){
	#if DEBUG
		println("\(function): \(message)")
	#endif
}


	