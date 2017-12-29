//
//  ViewController.swift
//  Jeu de Piste
//
//  Created by ORTEGA Pierre on 27/01/2016.
//  Copyright © 2016 ORTEGA Pierre. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, UITableViewDataSource,UITableViewDelegate{

  @IBOutlet weak var TableType: UITableView!
  var strSetTitle:String = ""
  let tabType:[String]=["Divers","Culturel","Sportive","Religieuse","Culinaire"]
  var strNomUtili : String = ""
  var locationManager=CLLocationManager()

  override func viewDidLoad() {
    super.viewDidLoad()
    self.TableType.tableFooterView = UIView(frame: CGRectZero)
    self.TableType.tableFooterView?.hidden = true
    self.TableType.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let aCell : UITableViewCell = TableType.dequeueReusableCellWithIdentifier("CellType")!
    aCell.textLabel!.text=tabType[indexPath.row]
  
    return aCell
  }
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tabType.count
  }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    strSetTitle=(tableView.cellForRowAtIndexPath(indexPath)?.textLabel?.text)!
    self.performSegueWithIdentifier("Map", sender: self)
  }
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
    if segue.identifier == "Map"{
      let navigationController = segue.destinationViewController as! MapViewController
      switch strSetTitle{
        
      case "Sportive":
        let resultat="Sport"
        navigationController.strRecupType = resultat
        break
      case "Culturel":
        let resultat="Culturel"
        print(resultat)
        navigationController.strRecupType = resultat
        break
      case "Religieuse":
        let resultat="Religieux"
        navigationController.strRecupType = resultat
        break
      case "Culinaire":
        let resultat="Culinaire"
        navigationController.strRecupType = resultat
        break
      default:
        let resultat="All"
        navigationController.strRecupType = resultat
        break
        
      }
      navigationController.strGetTitle = strSetTitle
      navigationController.strIdUtili = strNomUtili
      //navigationController.locationManager=self.locationManager
      
    }
  }
}

