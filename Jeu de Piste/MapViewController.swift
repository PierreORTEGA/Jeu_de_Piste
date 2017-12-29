//
//  MapViewController.swift
//  Jeu de Piste
//
//  Created by ORTEGA Pierre on 28/01/2016.
//  Copyright © 2016 ORTEGA Pierre. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Parse
class MapViewController: UIViewController, CLLocationManagerDelegate {
  var strGetTitle:String=""
  var strIdUtili:String=""
  var strIdMonu:String?
  var tabRecupData:[NSObject]?
  var  strRecupType:String?
  var query : PFQuery?
  var tabMonu : Array<[NSObject]>?
  var strAddress:String?
  var strTitle, strDescription:String?
  var strImg:String?
  var dicDescription:[String:String]=[:]
  var dicIDMonu:[String:String]=[:]
  var dicImage:[String:String]=[:]
  
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var NavItem: UINavigationItem!
  @IBOutlet weak var LabelNom: UILabel!
  @IBOutlet weak var LabelCoor: UILabel!
  @IBOutlet weak var LabelNote: UILabel!
  @IBOutlet weak var ButtonInfo: UIButton!
  @IBOutlet weak var imgMonu: UIImageView!
  
  var locationManager=CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
      
      NavItem.title="Map: \(strGetTitle)"
      mapView.delegate=self
      print(strRecupType)
      query = PFQuery(className:"Monuments")
      
      self.connectionReadMonuments(strRecupType!)
      locationManager.delegate = self
      locationManager.requestAlwaysAuthorization()

      
        // 2
        // set initial location in Saint-dié
        let initialLocation = CLLocation(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
        self.centerMapOnLocation(initialLocation)
      
      ButtonInfo.enabled=false
      

    }
   func connectionReadMonuments(pStrConnect:String){
    if pStrConnect != "All"{
      //séléction des données consernées
      query!.whereKey("Categorie", equalTo:pStrConnect)
      query!.findObjectsInBackgroundWithBlock {
        (objects: [PFObject]?, error: NSError?) -> Void in
      
        if error == nil {
          // The find succeeded.
          print("Successfully retrieved \(objects!.count) scores.")
          // Do something with the found objects
          if let objects = objects {
            for object in objects {
              //récupération des données stockées dans la table
              self.dicDescription[object["Nom"] as! String]=object["Description"] as? String
              self.dicImage[object["Nom"] as! String]=object["IDImage"] as? String
              self.dicIDMonu[object["Nom"] as! String]=object.objectId
              //appel constructeur artwork
              let artwork = Artwork(title: self.strGetTitle,
                nom:object["Nom"] as! String,
                description: object["Description"] as! String ,
                coordinate: CLLocationCoordinate2D(latitude: object["Latitude"] as! CLLocationDegrees,
                longitude: object["Longitude"] as! CLLocationDegrees))
              //affichage des points sur la carte
              self.mapView.addAnnotation(artwork)
            }
          }
        
        } else {
          // Log details of the failure
          print("Error: \(error!) \(error!.userInfo)")
        }
      }
    }else{
      query!.findObjectsInBackgroundWithBlock {
        (objects: [PFObject]?, error: NSError?) -> Void in
        if error == nil {
          // The find succeeded.
          print("Successfully retrieved \(objects!.count) scores.")
          // Do something with the found objects
          if let objects = objects {
            for object in objects {
              self.dicDescription[object["Nom"] as! String]=object["Description"] as! String
              self.dicIDMonu[object["Nom"] as! String]=object.objectId
              let artwork = Artwork(title: self.strGetTitle,
                nom:object["Nom"] as! String,
                description: object["Description"] as! String ,
                coordinate: CLLocationCoordinate2D(latitude: object["Latitude"] as! CLLocationDegrees, longitude: object["Longitude"] as! CLLocationDegrees))
              self.mapView.addAnnotation(artwork)
            }
          }
          
        }
      }
    }
  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  let regionRadius: CLLocationDistance = 1000
  func centerMapOnLocation(location: CLLocation) {
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
      regionRadius * 2.0, regionRadius * 2.0)
    mapView.setRegion(coordinateRegion, animated: true)
  }

  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    mapView.showsUserLocation = (status == .AuthorizedAlways)
  }
  
 
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
  {
    
    let location = locations.last! as CLLocation
    
    let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    
    self.mapView.setRegion(region, animated: true)
  }
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
    if segue.identifier == "Avis"{
      let navigationController = segue.destinationViewController as! CommentaireView
      navigationController.strTitre=self.strTitle!
      navigationController.strCoor=self.strAddress!
      navigationController.strDescription=self.strDescription!
      navigationController.strNomUtili=self.strIdUtili
      navigationController.strIdMonu=self.strIdMonu!
      navigationController.strImg=self.strImg!
    }
  }
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
  
}
