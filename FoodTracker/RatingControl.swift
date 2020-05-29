//
//  RatingControl.swift
//  FoodTracker
//
//  Created by admin on 3/11/20.
//  Copyright © 2020 Long. All rights reserved.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {
    // MARK: Properties
    private var ratingButton = [UIButton]()
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setUpButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setUpButtons()
        }
    }
    
    // MARK: Initiazilation
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setUpButtons()
    }
    
    // MARK: Private Methods
    private func setUpButtons() {
        // Clear any exitting buttons
        for button in ratingButton {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButton.removeAll()
        
        // Load button images
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        for index in 0..<starCount {
            // Cread the button
            let button = UIButton()
            
            // set the button in image
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            // Add the contraints
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            // set the accessilibiti label
            button.accessibilityLabel = "set \(index + 1) star rating"
            
            // Set up the button action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            //Add the button form the stack
            addArrangedSubview(button)
            
            // Add the new button to the rating array
            ratingButton.append(button)
        }
        updateButtonSelectionStates()
    }
    
    // MARK: Button Action
    @objc func ratingButtonTapped(button: UIButton) {
        guard let index = ratingButton.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButton)")
        }
        
        //Calculate the rating of the selected button
        let selectedRating = index + 1
        if selectedRating == rating {
            // If selected star represent the current rating, reset the rating to 0
            rating = 0
        } else {
            // Otherwise set the star to the selected star
            rating = selectedRating
        }
    }
    
    private func updateButtonSelectionStates() {
        for (index, button) in ratingButton.enumerated() {
            // If the index for a button is less the rating, this button should selected
            button.isSelected = index < rating
            
            // Set the hind string for the currently selected star
            let hintString: String?
            if rating == index + 1 {
                hintString = "Tap to reset the rating zezo"
            } else {
                hintString = nil
            }
            // Calculate the value string
            let valueString: String
            switch (rating) {
            case 0:
                valueString = "No rating set"
            case 1:
                valueString = "1 star set"
            default:
                valueString = "\(rating) stars set"
            }
            
            // Assign the hint string and value string
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }
}
