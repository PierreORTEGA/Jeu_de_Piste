//
//  AuthentificationViewController.swift
//  Jeu de Piste
//
//  Created by ORTEGA Pierre on 09/02/2016.
//  Copyright © 2016 ORTEGA Pierre. All rights reserved.
//

import UIKit
import Parse
import CoreLocation

class AuthentificationViewController: UIViewController {

  @IBOutlet weak var IdentificationTF: UITextField!
  @IBOutlet weak var PassWordTF: UITextField!
  var query : PFQuery?
  var Login : Bool=false
  let locationManager=CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
      IdentificationTF.text = ""
      PassWordTF.text = ""
      locationManager.requestAlwaysAuthorization()
      query = PFQuery(className:"User")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    self.view.endEditing(false)
  }
  @IBAction func Login(sender: AnyObject) {
    if IdentificationTF.text != "" && PassWordTF.text != "" {
      self.ConnetionBdd(IdentificationTF.text!, strMDP: PassWordTF.text!)
      
    }
  }
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "Type" {
      let vc=segue.destinationViewController as! ViewController
      vc.strNomUtili=IdentificationTF.text!
      vc.locationManager=self.locationManager
    }
  }
  func ConnetionBdd(strId:String,strMDP:String) {
    let loginData: NSData = strMDP.dataUsingEncoding(NSUTF8StringEncoding)!;
    let base64LoginString = loginData.base64EncodedStringWithOptions([])

    query!.whereKey("username", equalTo:strId)
    query!.findObjectsInBackgroundWithBlock {
      (objects: [PFObject]?, error: NSError?) -> Void in
      
      
      if error == nil {
        // The find succeeded.
        print("Successfully retrieved \(objects!.count) scores.")
        // Do something with the found objects
        if let objects = objects {
          for object in objects {
            if object["password"] as! String == base64LoginString {
              print(object["password"])
              self.Login=true
              if (self.Login != false) {
                self.performSegueWithIdentifier("Type", sender: self)
                self.Login=false
                }
            }else {
              self.Login=false
              print("Erreur Mot de passe")
            }
          }
        }
      }else {
        print("Erreur identifiant")
      }
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
