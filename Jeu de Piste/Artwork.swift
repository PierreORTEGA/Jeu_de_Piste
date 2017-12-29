//
//  Artwork.swift
//  Jeu de Piste
//
//  Created by ORTEGA Pierre on 28/01/2016.
//  Copyright © 2016 ORTEGA Pierre. All rights reserved.
//

import Foundation
import MapKit
import AddressBook

class Artwork: NSObject, MKAnnotation {
  let title: String?
  let subtitle: String?
  let Description: String
  let coordinate: CLLocationCoordinate2D

  init(title: String,nom:String , description: String, coordinate: CLLocationCoordinate2D) {
    self.title = title
    self.subtitle = nom
    self.Description = description
    self.coordinate = coordinate

    super.init() 
  }
  var Subtitle: String {
    return subtitle!
  }
  var Title: String {
    return title!
  }
  var getDescription: String {
      return Description
  }
  // annotation callout info button opens this mapItem in Maps app
  func mapItem() -> MKMapItem {
    let addressDictionary = [String(kABPersonAddressStreetKey): subtitle!]
    let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
    let mapItem = MKMapItem(placemark: placemark)
    mapItem.name = self.Title
    
    return mapItem
  }
  
}