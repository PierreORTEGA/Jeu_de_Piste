//
//  NoteViewController.swift
//  Jeu de Piste
//
//  Created by ORTEGA Pierre on 08/02/2016.
//  Copyright © 2016 ORTEGA Pierre. All rights reserved.
//

import UIKit
import Parse
class NoteViewController: UIViewController {
  
  @IBOutlet weak var ratingController: RatingControl!
  var strNomUtili:String=""
  var strIdMonu:String=""
  var floatNote:Float?
  var nbNote:Float?
  var query:PFQuery?
  var object:PFObject?
  let objetCommentaireView = CommentaireView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.connectionANoter(strIdMonu)
        object=PFObject(className: "Notation")
      self.connectionRecupNote(strIdMonu)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  func connectionNoterMonu(pNbNote:Float,pNoteMoyenne:Float,pIDMonument:String){
    query = PFQuery(className: "Monuments")
    query!.getObjectInBackgroundWithId(pIDMonument) {
      (gameScore: PFObject?, error: NSError?) -> Void in
      if error != nil {
        print(error)
      } else if let gameScore = gameScore {
        gameScore["MoyenneNote"] = pNoteMoyenne
        gameScore["NombreNote"] = pNbNote
        gameScore.saveInBackground()
      }
    }
  }
  func connectionRecupNote(pIDMonument:String) {
    query = PFQuery(className: "Monuments")
    query!.getObjectInBackgroundWithId(pIDMonument) {
      (objects: PFObject?, error: NSError?) -> Void in
      
      if error == nil {
        // The find succeeded.
        print("Successfully retrieved \(objects) scores.")
        // Do something with the found objects
        self.floatNote = objects!["MoyenneNote"] as! Float
        self.nbNote = objects!["NombreNote"] as! Float
        self.floatNote = self.floatNote! * self.nbNote!
      } else {
        // Log details of the failure
        print("Error: \(error!) \(error!.userInfo)")
      }
    }
  }
  func connectionWriteANote(pIdentifiant:String,pIDMonument:String){
    
    object!.setObject(pIdentifiant, forKey: "Utilisateur")
    object!.setObject(pIDMonument, forKey: "IDMonument")
    object!.saveInBackgroundWithBlock {
      (success: Bool, error: NSError?) -> Void in
      if (success) {
        print("The object has been saved.")

        
      } else {
        // There was a problem, check error.description
      }
    }
  }
  func connectionANoter(pIDMonument:String) {
    query = PFQuery(className: "Notation")
    query!.whereKey("IDMonument", equalTo:pIDMonument)
    query!.findObjectsInBackgroundWithBlock {
      (objects: [PFObject]?, error: NSError?) -> Void in
      
      if error == nil {
        // The find succeeded.
        print("Successfully retrieved \(objects!.count) scores.")
        // Do something with the found objects
        if let objects = objects {
          for object in objects {
            if object["Utilisateur"] as! String == self.strNomUtili {
              let alertController = UIAlertController(title: "Attention", message:
                "Vous avez déjà noté ce monument", preferredStyle: UIAlertControllerStyle.Alert)
              alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
                self.dismissViewControllerAnimated(true, completion: nil)
              }))
              self.presentViewController(alertController, animated: true, completion: nil)
            }
          }
        }
        
      } else {
        // Log details of the failure
        print("Error: \(error!) \(error!.userInfo)")
      }
    }
  }

  @IBAction func Note(sender: AnyObject) {
    
    floatNote!+=Float(self.ratingController.rating)
    nbNote!+=1
    floatNote = floatNote! / nbNote!
    self.connectionNoterMonu(nbNote!, pNoteMoyenne: floatNote!, pIDMonument: strIdMonu)
    self.connectionWriteANote(strNomUtili, pIDMonument: strIdMonu)
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  @IBAction func Retour(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
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
