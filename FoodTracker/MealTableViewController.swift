//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by admin on 3/19/20.
//  Copyright © 2020 Long. All rights reserved.
//

import UIKit
import os.log

class MealTableViewController: UITableViewController {
    // MARK: Properties
    var meals = [Meal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved meals, otherwise load sample data.
        if let savedMeals = loadMeals() {
            meals += savedMeals
            
        } else {
            // Load the sample data.
            loadSampleMeals()
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MealTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MealTableViewCell else {
            fatalError("ccccccccccc")
        }
        
        let meal = meals[indexPath.row]
        cell.nameLabel.text = meal.name
        cell.ratingControl.rating = meal.rating
        cell.photoImageView.image = meal.photo
        return cell
    }
    
    // Load sample data in app
    private func loadSampleMeals() {
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        let photo3 = UIImage(named: "meal3")
        
        guard let meal1 = Meal(name: "mot con ga", photo: photo1, rating: 4) else {
            fatalError("")
        }
        guard let meal2 = Meal(name: "mot con vit ", photo: photo2, rating: 1) else {
            fatalError("")
        }
        guard let meal3 = Meal(name: "not Ok con  ", photo: photo3, rating: 2) else {
            fatalError("")
        }
        meals += [meal1, meal2, meal3]
    }
    
    // MARK: Actions
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? MealViewController,
            let meal = sourceViewController.meal {
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                meals[selectedIndexPath.row] = meal
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // luu cac bua an
                saveMeals()
                let newIndexPath = IndexPath(row: meals.count, section: 0)
                // Add a new meal.
                meals.append(meal)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch(segue.identifier ?? "") {
            case "AddItem":
            os_log("Adding a new meal.", log: OSLog.default, type: .debug)
            
            case "ShowDetail":
            guard let mealDetailViewController = segue.destination as? MealViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
             
            guard let selectedMealCell = sender as? MealTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
             
            guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
             
            let selectedMeal = meals[indexPath.row]
            mealDetailViewController.meal = selectedMeal
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            meals.remove(at: indexPath.row)
            // This code saves the meals array whenever a meal is deleted.
            saveMeals()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
    }
    
    // This method attempts to archive the meals array to a specific location, and returns true if it’s successful.
    private func saveMeals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("Meals successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save meals...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadMeals() -> [Meal]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meal.ArchiveURL.path) as? [Meal]
        
    }
}


