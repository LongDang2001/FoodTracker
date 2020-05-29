//
//  ViewController.swift
//  FoodTracker
//
//  Created by admin on 3/10/20.
//  Copyright © 2020 Long. All rights reserved.
//

import UIKit
// unified logging system
import os.log

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControll: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    var meal: Meal?
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        
        // Set up views if editing an existing Meal.
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text   = meal.name
            photoImageView.image = meal.photo
            ratingControll.rating = meal.rating
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
 //       updateSaveButtonState()
    }
    
    // MARK: UItextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hire the keyboard
        textField.resignFirstResponder()
        return true
    }
    //MARK: UITextFieldDelegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //The first line calls updateSaveButtonState() to check if the text field has text in it, which enables the Save button if it does. The second line sets the title of the scene to that text.
        updateSaveButtonState()
        navigationItem.title = nameTextField.text
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    @IBAction func selecPhotoImageLibary(_ sender: UIGestureRecognizer) {
        // Hire the keyboard
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a viewController that lets user picker from the photo library
        let imagePickerController = UIImagePickerController()
        
        // only allow image to be picker, not taken
        imagePickerController.sourceType = .photoLibrary
        
        //
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("cái này đã không có giá trị, cái thằng này có khả năng nil")
        }
        
        // Set photoImageView to display to selected image
        photoImageView.image = selectedImage
        // dismiss picker
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancal() {
        dismiss(animated: true, completion: nil)
        
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        
        let isPresentingInAddMealMode = presentingViewController is UINavigationController

        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)

        } else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
//        navigationController?.popViewController(animated: true)
    }
    
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControll.rating
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        meal = Meal(name: name, photo: photo, rating: rating)
    }
    
    //MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}
