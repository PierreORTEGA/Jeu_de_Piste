//
//  VCMapView.swift
//  Jeu de Piste
//
//  Created by ORTEGA Pierre on 01/02/2016.
//  Copyright © 2016 ORTEGA Pierre. All rights reserved.
//

import MapKit

extension MapViewController: MKMapViewDelegate {
  
  // 1
  func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
    if let annotation = annotation as? Artwork {
      let identifier = "pin"
      var view: MKPinAnnotationView
      if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView { // 2
          dequeuedView.annotation = annotation
          view = dequeuedView
      } else {
        // 3
        view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        view.canShowCallout = true
        view.calloutOffset = CGPoint(x: -5, y: 5)
        view.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
      }
      return view
    }
    return nil
  }
  func mapView(mapView: MKMapView, annotationView view: MKAnnotationView,calloutAccessoryControlTapped control: UIControl) {
      let location = view.annotation as! Artwork
      let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
      print(location)
      location.mapItem().openInMapsWithLaunchOptions(launchOptions)
  }
  func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
    self.strTitle=(view.annotation?.subtitle)!
    self.strDescription=self.dicDescription[strTitle!]
    self.strIdMonu=self.dicIDMonu[strTitle!]
    self.strImg=self.dicImage[strTitle!]
    let nameImg="\(self.strImg!).jpg"
    imgMonu.image=UIImage(named: nameImg)
    self.view.addSubview(imgMonu!)
    LabelNom.text=strTitle
    print(self.strDescription,strTitle)
    let geocoder = CLGeocoder()
    let center=view.annotation?.coordinate
    let getLat: CLLocationDegrees = center!.latitude
    let getLon: CLLocationDegrees = center!.longitude
    geocoder.reverseGeocodeLocation(CLLocation(latitude: getLat, longitude: getLon)) {
      (placemarks, error) -> Void in
      let placemark = placemarks![0]
      self.strAddress="\(placemark.addressDictionary!["Name"] as! String),\(placemark.addressDictionary!["City"] as! String)"
      print(self.strAddress)
      self.LabelCoor?.text=self.strAddress
      self.ButtonInfo.enabled=true
    }
  }
}
