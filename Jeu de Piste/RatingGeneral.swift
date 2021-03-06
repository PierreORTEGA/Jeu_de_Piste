//
//  RatingGeneral.swift
//  Jeu de Piste
//
//  Created by ORTEGA Pierre on 08/02/2016.
//  Copyright © 2016 ORTEGA Pierre. All rights reserved.
//

import UIKit
import Parse
class RatingGeneral: UIView {
  // MARK: Properties
  
  var rating = 0 {
    didSet {
      setNeedsLayout()
    }
  }
  var ratingButtons = [UIButton]()
  var spacing = 5
  var stars = 5
  var Intindex=0  // MARK: Initialization
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    let filledStarImage = UIImage(named: "filledStar")
    let emptyStarImage = UIImage(named: "emptyStar")
    
    for _ in 0..<5 {
      let button = UIButton()
      
      button.setImage(emptyStarImage, forState: .Normal)
      button.setImage(filledStarImage, forState: .Selected)
      button.setImage(filledStarImage, forState: [.Highlighted, .Selected])
      
      button.adjustsImageWhenHighlighted = false
      
      ratingButtons += [button]
      addSubview(button)
    }
  }
  
  override func layoutSubviews() {
    // Set the button's width and height to a square the size of the frame's height.
    let buttonSize = Int(frame.size.height)
    var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
    
    // Offset each button's origin by the length of the button plus spacing.
    for (index, button) in ratingButtons.enumerate() {
      buttonFrame.origin.x = CGFloat(index * (buttonSize + spacing))
      button.frame = buttonFrame
    }
    updateButtonSelectionStates()
  }
  
  override func intrinsicContentSize() -> CGSize {
    let buttonSize = Int(frame.size.height)
    let width = (buttonSize + spacing) * stars
    
    return CGSize(width: width, height: buttonSize)
  }
  
  
  
  func updateButtonSelectionStates() {
    for (index, button) in ratingButtons.enumerate() {
      // If the index of a button is less than the rating, that button should be selected.
      button.selected = index < rating
    }
  }
}

