//
//  InscriptionViewController.swift
//  Jeu de Piste
//
//  Created by ORTEGA Pierre on 09/02/2016.
//  Copyright © 2016 ORTEGA Pierre. All rights reserved.
//

import UIKit
import Parse
class InscriptionViewController: UIViewController,UITextFieldDelegate {

  @IBOutlet weak var IdentifiantTF: UITextField!
  @IBOutlet weak var PassWordTF: UITextField!
  @IBOutlet weak var PassWordConfirmTF: UITextField!
  @IBOutlet weak var EmailTF: UITextField!
  
  var object : PFObject?
  var strId : String?
  var strPW : String?
  var strPWC : String?
  var strEmail : String?
  var query : PFQuery?
  var login : Bool?
  var boolEmail : Bool?
    override func viewDidLoad() {
      super.viewDidLoad()
      object = PFObject(className:"User")
      query = PFQuery(className: "User")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  @IBAction func ActionInscription(sender: AnyObject) {
    if IdentifiantTF.text != "" && PassWordTF.text != "" && PassWordConfirmTF.text != "" && EmailTF.text != "" {
      strId=IdentifiantTF.text
      strPW=PassWordTF.text
      strPWC=PassWordConfirmTF.text
      self.connectionVerif("username", pVerif: IdentifiantTF.text!,pEmail:EmailTF.text! )
      
    }
  }
  
  @IBAction func Retour(sender: AnyObject) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  func connectionVerif(pParam:String,pVerif:String,pEmail:String){
    query!.whereKey(pParam, equalTo:pVerif)
    
    query!.findObjectsInBackgroundWithBlock {
      (objects: [PFObject]?, error: NSError?) -> Void in
      
      if error == nil && objects != nil {
        if let objects = objects {
          for object in objects {
            if object[pParam] as! String == pVerif {
              self.login=false
              if object["email"] as! String == pEmail {
                self.boolEmail=false
              }
            }
          }
        }
      } else {
        self.login = true
        self.boolEmail = true
      }
      let boolValidEmail=self.isValidEmail(self.EmailTF.text!)
      if (boolValidEmail){
        self.strEmail=self.EmailTF.text
      }else {
        print("erreur adresse email")
      }
      if self.login != false {
        if self.boolEmail != false{
          if self.strPW?.characters.count>7  {
            if self.strPW == self.strPWC{
              self.connectionWriteUser(self.strId!, pPassword: self.strPW!, pEmail: self.strEmail!)
            }else {
              print("erreur mot de passe")
            }
          }else {
            print("Votre mot de passe doit comporter 7 Charactère")
          }
        }else{
          print("Changer votre adresse email")
          self.viewDidLoad()
        }
      }else {
        print("Changer votre Identifiant ")
        self.viewDidLoad()
      }
    }
  }
  func connectionWriteUser(pIdentifiant:String,pPassword:String,pEmail:String){

    object!.setObject(pIdentifiant, forKey: "username")
    let loginData: NSData = pPassword.dataUsingEncoding(NSUTF8StringEncoding)!;
    let base64LoginString = loginData.base64EncodedStringWithOptions([])
    object!.setObject(base64LoginString, forKey: "password")
    
    object!.setObject(pEmail, forKey: "email")
    object!.saveInBackgroundWithBlock {
      (success: Bool, error: NSError?) -> Void in
      if (success) {
        print("The object has been saved.")
        let alertController = UIAlertController(title: "Compte", message:
          "Votre compte est validé", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
          self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
      } else {
        // There was a problem, check error.description
      }
    }
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  
  /**
   * Called when the user click on the view (outside the UITextField).
   */
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    self.view.endEditing(false)
  }
  func isValidEmail(testStr:String) -> Bool {
    // println("validate calendar: \(testStr)")
    let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluateWithObject(testStr)
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
