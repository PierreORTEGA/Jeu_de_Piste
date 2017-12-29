//
//  CommentaireView.swift
//  Jeu de Piste
//
//  Created by ORTEGA Pierre on 03/02/2016.
//  Copyright © 2016 ORTEGA Pierre. All rights reserved.
//

import UIKit
import Parse
class CommentaireView: UIViewController,UIPopoverPresentationControllerDelegate,UITableViewDataSource,UITableViewDelegate {
  
  @IBOutlet weak var LabelTitre: UILabel!
  @IBOutlet weak var LabelCoordo: UILabel!
  @IBOutlet weak var LabelDescription: UILabel!
  @IBOutlet weak var ratingControl: RatingGeneral!
  @IBOutlet weak var AvisTableView: UITableView!
  
  @IBOutlet weak var ImgMonu: UIImageView!
  @IBOutlet weak var LabelDate: UILabel!
  @IBOutlet weak var LabelCommentaire: UILabel!
  @IBOutlet weak var LabelNom: UILabel!
  @IBOutlet weak var TextfieldCommentaire: UITextField!
  @IBOutlet weak var ScrollBar: UIScrollView!
  var strTitre,strCoor,strDescription:String?
  var strNomUtili:String=""
  var strIdMonu:String=""
  var object : PFObject?
  var query : PFQuery?
  var tabAvis : [String]=[]
  var tabUtili : [String]=[]
  var tabDate : [String]=[]
  var strImg : String=""

  override func viewDidLoad() {
    super.viewDidLoad()
    self.connectionReadCommentaire(strIdMonu)
    self.connectionNote(strIdMonu)
    AvisTableView.delegate=self
    self.TextfieldCommentaire.placeholder="Commentaire"
    if strTitre != nil && strCoor != nil && strDescription != nil {
      LabelTitre?.text=strTitre!
      LabelCoordo?.text=strCoor!
      LabelDescription.text=strDescription
      object = PFObject(className:"Avis")
      let nameImg="\(self.strImg).jpg"
      ImgMonu.image=UIImage(named: nameImg)
      self.view.addSubview(ImgMonu!)
    }
    self.AvisTableView.tableFooterView = UIView(frame: CGRectZero)
    self.AvisTableView.tableFooterView?.hidden = true
    self.AvisTableView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    
  }

    override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    self.viewDidLoad()
  }
  @IBAction func Popover(sender: AnyObject) {
    self.performSegueWithIdentifier("showPop", sender: self)
  }

  func connectionWriteCommentaire(pIdentifiant:String,pCommentaire:String,pIDMonument:String){
    //ajoute les données dans l'objet
    object!.setObject(pIdentifiant, forKey: "Utilisateur")
    object!.setObject(pCommentaire, forKey: "Commentaire")
    
    object!.setObject(pIDMonument, forKey: "IDMonument")
    //Sauvegarde dans la Table
    object!.saveInBackgroundWithBlock {
      (success: Bool, error: NSError?) -> Void in
      if (success) {
        print("The object has been saved.")
        self.viewDidLoad()
        
      } else {
        // There was a problem, check error.description
      }
    }
  }
  
  func connectionReadCommentaire(pIDMonument:String) {
    self.tabAvis=[]
    self.tabDate=[]
    self.tabUtili=[]
    query = PFQuery(className: "Avis")
    query!.whereKey("IDMonument", equalTo:pIDMonument)
    query!.findObjectsInBackgroundWithBlock {
      (objects: [PFObject]?, error: NSError?) -> Void in
      
      if error == nil {
        // The find succeeded.
        print("Successfully retrieved \(objects!.count) scores.")
        // Do something with the found objects
        if let objects = objects {
          for object in objects {
            self.tabAvis.append(object["Commentaire"] as! String)
            let date = object.createdAt
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy" //format style. Browse online to get a format that fits your needs.
            let lStrDate = dateFormatter.stringFromDate(date!)
            self.tabDate.append(lStrDate)
            self.tabUtili.append(object["Utilisateur"] as! String)
            print(dateFormatter.stringFromDate(date!))
          }
          self.AvisTableView.reloadData()

        }
        
      } else {
        // Log details of the failure
        print("Error: \(error!) \(error!.userInfo)")
      }
    }
  }
  func connectionNote(pIDMonument:String) {
    query = PFQuery(className: "Monuments")
    query!.getObjectInBackgroundWithId(pIDMonument) {
      (objects: PFObject?, error: NSError?) -> Void in
      
      if error == nil {
        // The find succeeded.
        print("Successfully retrieved \(objects) scores.")
        // Do something with the found objects
        
          self.ratingControl.rating=objects!["MoyenneNote"] as! Int
        
      } else {
        // Log details of the failure
        print("Error: \(error!) \(error!.userInfo)")
      }
    }
  }

  @IBAction func SendCom(sender: AnyObject) {
    if TextfieldCommentaire.text != "" {
      self.connectionWriteCommentaire(strNomUtili, pCommentaire: TextfieldCommentaire.text!, pIDMonument: strIdMonu)
      TextfieldCommentaire.text = ""
    }
  }
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "showPop" {
      let vc = segue.destinationViewController as! NoteViewController
      vc.strIdMonu=self.strIdMonu
      vc.strNomUtili=self.strNomUtili
      vc.preferredContentSize = CGSize(width: 220, height: 220)
      let controller = vc.popoverPresentationController
      controller?.delegate=self

    }
  }
  func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
    return .None
  }
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    self.view.endEditing(false)
  }
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {

    return 1
  }
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let aCell = AvisTableView.dequeueReusableCellWithIdentifier("CellAvis", forIndexPath: indexPath) as! AvisCustomCell
    aCell.LabelNom!.text = tabUtili[indexPath.row]
    aCell.LabelCom!.text=tabAvis[indexPath.row]
    aCell.LabelDate!.text=tabDate[indexPath.row]
    print("les avis\(tabAvis)")
    return aCell
  }
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return tabAvis.count
  }

}
